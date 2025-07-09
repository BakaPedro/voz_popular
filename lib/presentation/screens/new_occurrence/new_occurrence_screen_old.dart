import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb; //verifica se é web
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:voz_popular/data/repositories/auth_repository.dart';
import 'package:latlong2/latlong.dart';
import 'package:voz_popular/data/models/category_model.dart';
import 'package:voz_popular/data/models/theme_model.dart';
import 'package:voz_popular/data/repositories/data_repository.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:voz_popular/locator.dart';

class NewOccurrenceScreen extends StatefulWidget {
  const NewOccurrenceScreen({super.key});

  @override
  State<NewOccurrenceScreen> createState() => _NewOccurrenceScreenState();
}

class _NewOccurrenceScreenState extends State<NewOccurrenceScreen> {
  final _descriptionController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _referenceController = TextEditingController();
  String? _selectedCategoryId;
  String? _selectedThemeId;

  List<Category> _categories = [];
  List<ThemeModel> _themes = [];

  File? _mobileImageFile;
  Uint8List? _webImageBytes;
  LatLng? _selectedLocation;
  bool _isLoadingLocation = true;
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;
  bool _isLoadingInitialData = true;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    setState(() => _isLoadingInitialData = true);
    try {
      await Future.wait([
        _fetchInitialLocationAndAddress(),
        _fetchDropdownData(),
      ]);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingInitialData = false);
      }
    }
  }

  Future<void> _fetchDropdownData() async {
    final dataRepository = locator<DataRepository>();
    final categories = await dataRepository.getCategories();
    final themes = await dataRepository.getThemes();
    setState(() {
      _categories = categories;
      _themes = themes;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImageBytes = bytes;
          _mobileImageFile = null;
          //_imageFile = File(pickedFile.path);
        });
      } else {
        setState(() {
          _mobileImageFile = File(pickedFile.path);
          _webImageBytes = null;
        });
      }
    }
  }

  Future<void> _fetchInitialLocationAndAddress() async {
    setState(() => _isLoadingLocation = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Permissão de localização negada.');
        }
      }
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final initialLatLng = LatLng(position.latitude, position.longitude);
      setState(() => _selectedLocation = initialLatLng);
      await _getAddressFromCoordinates(initialLatLng);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao buscar localização: ${e.toString()}')));
      }
      final fallbackLatLng = LatLng(-19.0094, -57.6533);
      setState(() => _selectedLocation = fallbackLatLng);
      await _getAddressFromCoordinates(fallbackLatLng);
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  Future<void> _getAddressFromCoordinates(LatLng point) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(point.latitude, point.longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _streetController.text = place.street ?? '';
          _neighborhoodController.text = place.subLocality ?? '';
        });
      }
    } catch (e) {
      print("Erro na geocodificação reversa: $e");
    }
  }

  Future<void> _submitOccurrence() async {
    final bool isImageSelected =
        kIsWeb ? _webImageBytes != null : _mobileImageFile != null;
    if (_descriptionController.text.isEmpty ||
        _streetController.text.isEmpty ||
        _numberController.text.isEmpty ||
        _neighborhoodController.text.isEmpty ||
        _referenceController.text.isEmpty ||
        _selectedCategoryId == null ||
        _selectedThemeId == null ||
        !isImageSelected ||
        _selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, preencha todos os campos e anexe imagem e localização.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await locator<OccurrenceRepository>().submitOccurrence(
        description: _descriptionController.text,
        street: _streetController.text,
        number: _numberController.text,
        neighborhood: _neighborhoodController.text,
        reference: _referenceController.text,
        categoryId: _selectedCategoryId!,
        themeId: _selectedThemeId!,
        mobileImageFile: _mobileImageFile,
        webImageBytes: _webImageBytes,
        position: _selectedLocation!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ocorrência registrada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(); //volta para o home
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao registrar ocorrência: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _neighborhoodController.dispose();
    _referenceController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Widget imagePreview;
    if (kIsWeb && _webImageBytes != null) {
      imagePreview = Image.memory(_webImageBytes!, fit: BoxFit.cover);
    } else if (!kIsWeb && _mobileImageFile != null) {
      imagePreview = Image.file(_mobileImageFile!, fit: BoxFit.cover);
    } else {
      imagePreview = const Center(child: Text('Nenhuma imagem selecionada.'));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Nova Ocorrência')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //desc
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategoryId,
                    hint: const Text('Categoria'),
                    isExpanded: true,
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category.id.toString(),
                        child: Text(category.name, overflow: TextOverflow.ellipsis),);}).toList(),
                    onChanged: (value) => setState(() => _selectedCategoryId = value),
                    validator: (value) => value == null ? 'Obrigatório' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedThemeId,
                    hint: const Text('Tema'),
                    isExpanded: true,
                    items: _themes.map((theme) {
                      return DropdownMenuItem(
                        value: theme.id.toString(),
                        child: Text(theme.name, overflow: TextOverflow.ellipsis),);}).toList(),
                    onChanged: (value) => setState(() => _selectedThemeId = value),
                    validator: (value) => value == null ? 'Obrigatório' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Descrição'), maxLines: 4),
            const SizedBox(height: 24),
            
            //mapa
            Text('Ajuste a Localização no Mapa', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _isLoadingLocation
                    ? const Center(child: CircularProgressIndicator())
                    : FlutterMap(
                        options: MapOptions(
                          initialCenter: _selectedLocation!,
                          initialZoom: 17.0,
                          onTap: (tapPosition, point) async {
                            setState(() => _selectedLocation = point);
                            await _getAddressFromCoordinates(point);
                          },
                        ),
                        children: [
                          TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                          MarkerLayer(markers: [
                            Marker(
                              point: _selectedLocation!,
                              child: Icon(Icons.location_pin, color: Colors.red.shade700, size: 50.0),
                            ),
                          ]),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
            
            //endereço
            TextFormField(controller: _streetController, decoration: const InputDecoration(labelText: 'Rua')),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: TextFormField(controller: _numberController, decoration: const InputDecoration(labelText: 'Número'))),
                const SizedBox(width: 16),
                Expanded(child: TextFormField(controller: _neighborhoodController, decoration: const InputDecoration(labelText: 'Bairro'))),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(controller: _referenceController, decoration: const InputDecoration(labelText: 'Ponto de Referência (Opcional)')),
           
            const SizedBox(height: 24),

            //imagem
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: imagePreview,
              /*_imageFile != null
                      ? Image.file(_imageFile!, fit: BoxFit.cover)
                      : const Center(
                        child: Text('Nenhuma imagem selecionada.'),
                      ),*/
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Câmera'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Galeria'),
                ),
              ],
            ),
            const SizedBox(height: 16), 
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _isSubmitting ? null : _submitOccurrence,
              child:
                  _isSubmitting
                      ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                      : const Text(
                        'Registrar Ocorrência',
                        style: TextStyle(fontSize: 16),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
