import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:voz_popular/data/models/occurrence_model.dart';
import 'package:voz_popular/data/repositories/auth_repository.dart';
import 'package:voz_popular/locator.dart';
import 'package:voz_popular/presentation/widgets/comment_section.dart';

class OccurrenceDetailsScreen extends StatefulWidget {
  final String occurrenceId;

  const OccurrenceDetailsScreen({super.key, required this.occurrenceId});

  @override
  State<OccurrenceDetailsScreen> createState() => _OccurrenceDetailsScreenState();
}

class _OccurrenceDetailsScreenState extends State<OccurrenceDetailsScreen> {
  late Future<Occurrence> _occurrenceFuture;

  @override
  void initState() {
    super.initState();
    _occurrenceFuture = locator<OccurrenceRepository>().getOccurrenceDetails(widget.occurrenceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Occurrence>(
        future: _occurrenceFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar detalhes: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            final occurrence = snapshot.data!;
            return _buildDetailsPage(context, occurrence);
          }
          return const Center(child: Text('Nenhuma informação encontrada.'));
        },
      ),
    );
  }

  Widget _buildDetailsPage(BuildContext context, Occurrence occurrence) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 280.0,
          pinned: true,
          stretch: true,
          backgroundColor: Colors.grey[800],
          iconTheme: const IconThemeData(color: Colors.white),
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              occurrence.title,
              style: const TextStyle(
                shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                fontFamily: 'SpoofTrial',
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            centerTitle: true,
            background: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  occurrence.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: Colors.grey, child: const Icon(Icons.broken_image, size: 50));
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detalhes da Ocorrência',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(Icons.calendar_today, 'Data', DateFormat('dd/MM/yyyy').format(occurrence.date)),
                    _buildInfoRow(Icons.person_outline, 'Reportado por', occurrence.userName),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.category_outlined, 'Categoria', occurrence.categoryName),
                    _buildInfoRow(Icons.lightbulb_outline, 'Tema', occurrence.themeName),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.description_outlined, 'Descrição', occurrence.description, isMultiline: true),
                    const SizedBox(height: 24),
                    Text(
                      'Localização',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(Icons.location_on_outlined, 'Endereço', occurrence.formattedAddress),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(occurrence.latitude, occurrence.longitude),
                            initialZoom: 16.0,
                          ),
                          children: [
                            TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                            MarkerLayer(markers: [
                              Marker(
                                point: LatLng(occurrence.latitude, occurrence.longitude),
                                child: Icon(Icons.location_pin, color: Colors.red.shade700, size: 50.0),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ),
                     if (occurrence.isOwner) ...[
                      const SizedBox(height: 24),
                      _buildSectionTitle('Status e Comentários'),
                      _buildInfoRow(Icons.hourglass_empty, 'Status Atual', occurrence.status.name.toUpperCase()),
                      const SizedBox(height: 16),
                      CommentSection(occurrenceId: occurrence.id),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'SpoofTrial'),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(value, style: TextStyle(color: Colors.grey[800], fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
