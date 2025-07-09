import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:voz_popular/data/models/occurrence_model.dart';
import 'package:voz_popular/data/repositories/auth_repository.dart';
import 'package:voz_popular/locator.dart';
import 'package:voz_popular/presentation/widgets/occurrence_card.dart';

class MyOccurrencesScreen extends StatefulWidget {
  const MyOccurrencesScreen({super.key});

  @override
  State<MyOccurrencesScreen> createState() => _MyOccurrencesScreenState();
}

class _MyOccurrencesScreenState extends State<MyOccurrencesScreen> {
  late Future<List<Occurrence>> _myOccurrencesFuture;

  @override
  void initState() {
    super.initState();
    _loadMyOccurrences();
  }

  void _loadMyOccurrences() {
    setState(() {
      _myOccurrencesFuture = locator<OccurrenceRepository>().getMyOccurrences();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Ocorrências'),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.grey[800],
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'SpoofTrial',
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadMyOccurrences();
        },
        child: FutureBuilder<List<Occurrence>>(
          future: _myOccurrencesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerList();
            }
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Erro ao carregar suas ocorrências:\n${snapshot.error}', textAlign: TextAlign.center),
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Você ainda não registou nenhuma ocorrência.'));
            }
            final occurrences = snapshot.data!;
            return ListView.builder(
              itemCount: occurrences.length,
              itemBuilder: (context, index) {
                final occurrence = occurrences[index];
                return OccurrenceCard(occurrence: occurrence);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(height: 250, color: Colors.white),
        ),
      ),
    );
  }
}