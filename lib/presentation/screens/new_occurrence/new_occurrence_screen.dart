import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voz_popular/data/services/occurrence_service.dart';

class NewOccurrenceScreen extends StatefulWidget {
  const NewOccurrenceScreen({super.key});

  @override
  State<NewOccurrenceScreen> createState() => _NewOccurrenceScreenState();
}

class _NewOccurrenceScreenState extends State<NewOccurrenceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _picker = ImagePicker();

  String? _selectedCategory;
  File? _mobileImageFile;
  Uint8List? _webImageBytes;
  Position? _currentPosition;
  bool _isSubmitting = false;

  final Map<String, String> _categoryMap = {
    'Iluminação Pública': '1',
    'Buracos na Rua': '2',
    'Lixo Acumulado': '3',
    'Sinalização': '4',
    'Outros': '5',
  };

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      _currentPosition = await Geolocator.getCurrentPosition();
    } catch (e) {
      print('Erro ao obter localização: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _mobileImageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitOccurrence() async {
    if (!_formKey.currentState!.validate() || _selectedCategory == null || _currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos corretamente.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await OccurrenceService().submitOccurrence(
        title: _titleController.text,
        description: _descriptionController.text,
        address: _addressController.text,
        category: _categoryMap[_selectedCategory]!,
        mobileImageFile: _mobileImageFile,
        webImageBytes: _webImageBytes,
        position: _currentPosition!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ocorrência enviada com sucesso!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar ocorrência: $e')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Ocorrência'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) => value!.isEmpty ? 'Informe o título' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) => value!.isEmpty ? 'Informe a descrição' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Endereço'),
                validator: (value) => value!.isEmpty ? 'Informe o endereço' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
                items: _categoryMap.keys
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: _isSubmitting ? null : (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              _mobileImageFile != null
                  ? Image.file(_mobileImageFile!, height: 150)
                  : ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Selecionar Imagem'),
                    ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitOccurrence,
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text('Enviar Ocorrência'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}