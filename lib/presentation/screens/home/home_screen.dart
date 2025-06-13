import 'package:flutter/material.dart';
import 'package:voz_popular/data/models/occurrence_model.dart';
import 'package:voz_popular/data/services/occurrence_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Occurrence>> _occurrencesFuture;
  @override
  void initState() {
    super.initState();
    //busca de ocorrencias
    _occurrencesFuture = OccurrenceService().getOccurrences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bem vindo!')),
      //FutureBuilder para dados que demoram a chegar
      body: FutureBuilder<List<Occurrence>>(
        future: _occurrencesFuture,
        builder: (context, snapshot) {
          //c1: dados carregando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          //c2: erro na busca
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar ocorrências: ${snapshot.error}'),
            );
          }
          // c3:dados chegaram, mas a lista vazia
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma ocorrência encontrada.'));
          }
          // c4: sucesso
          final occurrences = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: occurrences.length,
            itemBuilder: (context, index) {
              final occurrence = occurrences[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 3,
                clipBehavior:
                    Clip.antiAlias, //corta bordas
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //widget para imagens da net
                    Image.network(
                      occurrence.imageUrl,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      // loading imagem
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 180,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            value:
                                loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                          ),
                        );
                      },
                      //icone erro se imagem não carregar
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 180,
                          color: Colors.grey[200],
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.grey[400],
                            size: 48,
                          ),
                        );
                      },
                    ),

                    //texto
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            occurrence.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            occurrence.address,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 12),
                          Chip(
                            label: Text(
                              occurrence.status.name.replaceFirst(
                                occurrence.status.name[0],
                                occurrence.status.name[0].toUpperCase(),
                              ),
                            ),
                            backgroundColor: _getStatusColor(occurrence.status),
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // função def cor status
  Color _getStatusColor(OccurrenceStatus status) {
    switch (status) {
      case OccurrenceStatus.resolvido:
        return Colors.green.shade100;
      case OccurrenceStatus.emAndamento:
        return Colors.orange.shade100;
      case OccurrenceStatus.recebido:
      default:
        return Colors.blue.shade100;
    }
  }
}
