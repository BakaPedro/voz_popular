import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voz_popular/data/models/occurrence_model.dart';
import 'package:voz_popular/routes/app_routes.dart';

class OccurrenceCard extends StatelessWidget {
  final Occurrence occurrence;

  const OccurrenceCard({super.key, required this.occurrence});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.occurrenceDetails,
          arguments: occurrence.id,
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        elevation: 8,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: SizedBox(
          height: 250,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  occurrence.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                      child: Icon(Icons.broken_image, color: Colors.grey[600], size: 60),
                    );
                  },
                ),
              ),

              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: const [0.6, 1.0],
                    ),
                  ),
                ),
              ),

              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        occurrence.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'SpoofTrial',
                              shadows: [
                                const Shadow(blurRadius: 2, color: Colors.black54)
                              ],
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on_outlined, size: 16, color: Colors.white70),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              occurrence.formattedAddress,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.share_outlined, color: Colors.white),
                            onPressed: () {
                              print('Compartilhar clicado');
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite_border, color: Colors.white),
                            onPressed: () {
                              print('Curtir clicado');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 12,
                left: 12,
                child: Chip(
                  label: Text(
                    occurrence.status.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: _getStatusColor(occurrence.status),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),

              Positioned(
                top: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                     Text(
                        DateFormat('dd/MM/yyyy').format(occurrence.date),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white, shadows: [const Shadow(blurRadius: 1, color: Colors.black87)]),
                      ),
                     const SizedBox(height: 8),
                     _buildInfoChip(Icons.category_outlined, occurrence.categoryName),
                     const SizedBox(height: 4),
                     _buildInfoChip(Icons.lightbulb_outline, occurrence.themeName),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 14, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
      backgroundColor: Colors.black.withOpacity(0.4),
      side: BorderSide(color: Colors.white.withOpacity(0.3)),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Color _getStatusColor(OccurrenceStatus status) {
    switch (status) {
      case OccurrenceStatus.atrasado:
        return Colors.red.shade600;
      case OccurrenceStatus.em_analise:
        return Colors.yellow.shade600;  
      case OccurrenceStatus.concluido:
        return Colors.green.shade600;
      case OccurrenceStatus.em_andamento:
        return Colors.orange.shade700;
      case OccurrenceStatus.recebido:
      default:
        return Colors.blue.shade600;
    }
  }
}
