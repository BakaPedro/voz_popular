import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb; //verifica se é web
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:voz_popular/data/services/occurrence_service.dart';

class NewOccurrenceScreen extends StatefulWidget {
  const NewOccurrenceScreen({super.key});

  @override
  State<NewOccurrenceScreen> createState() => _NewOccurrenceScreenState();
}

class _NewOccurrenceScreenState extends State<NewOccurrenceScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  String? _selectedCategory;

  //var imagem localização
  //File? _imageFile;

  File? _mobileImageFile;
  Uint8List? _webImageBytes;

  Position? _currentPosition;
  bool _isLocating = false;
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

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

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLocating = true;
    });

    try {
      //verifica permissão
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permissão de localização negada.')),
          );
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      ScaffoldMessenger.of(context,
      ).showSnackBar(SnackBar(content: Text('Erro ao buscar localização: $e')));
    } finally {
      setState(() {
        _isLocating = false;
      });
    }
  }

  Future<void> _submitOccurrence() async {
    final bool isImageSelected =
        kIsWeb ? _webImageBytes != null : _mobileImageFile != null;

    //validação
    /*if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedCategory == null ||
        _imageFile == null ||
        _currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, preencha todos os campos, adicione uma imagem e a localização.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }*/
     if (_titleController.text.isEmpty || 
     _descriptionController.text.isEmpty || 
     _addressController.text.isEmpty || _selectedCategory == null ||
      !isImageSelected || _currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos e anexe imagem e localização.'), 
        backgroundColor: Colors.orange));
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final occurrenceService = OccurrenceService();
      await occurrenceService.submitOccurrence(
        title: _titleController.text,
        description: _descriptionController.text,
        address: _addressController.text,
        category: _selectedCategory!,
        mobileImageFile: _mobileImageFile,
        webImageBytes: _webImageBytes,
        //imageFile: _imageFile!,
        position: _currentPosition!,
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
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
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
            // titulo desc
            TextFormField(
              controller: _titleController,
              enabled: !_isSubmitting,
              decoration: const InputDecoration(
                labelText: 'Título da Ocorrência',
                hintText: 'Ex: Poste de luz queimado',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              enabled: !_isSubmitting,
              decoration: const InputDecoration(
                labelText: 'Descrição Detalhada',
                hintText:
                    'Descreva o problema com o máximo de detalhes possível...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5, //linhas multiplas
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              enabled: !_isSubmitting,
              decoration: const InputDecoration(
                labelText: 'Endereço da Ocorrência',
                hintText: 'Ex: Rua Principal, em frente ao nº 123',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Categoria',
                border: OutlineInputBorder(),
              ),
              hint: const Text('Selecione uma categoria'),
              items:
                  [
                        'Iluminação Pública',
                        'Buracos na Rua',
                        'Lixo Acumulado',
                        'Sinalização',
                        'Outros',
                      ]
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
              //atualiza a categoria
              onChanged:
                  _isSubmitting
                      ? null
                      : (value) {
                        if (value != null) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        }
                      },
              //validação
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, selecione uma categoria.';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // imagem
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
            const SizedBox(height: 24),

            //localização
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.my_location),
                  onPressed: _getCurrentLocation,
                ),
                Expanded(
                  child: Text(
                    _currentPosition == null
                        ? 'Clique para obter a localização'
                        : 'Lat: ${_currentPosition!.latitude.toStringAsFixed(5)}, Lon: ${_currentPosition!.longitude.toStringAsFixed(5)}',
                  ),
                ),
                if (_isLocating)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
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
