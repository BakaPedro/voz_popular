import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:voz_popular/data/models/occurrence_model.dart';
import 'package:voz_popular/data/repositories/auth_repository.dart';
import 'package:voz_popular/locator.dart';
import 'package:voz_popular/presentation/widgets/occurrence_card.dart';

class OccurrenceListView extends StatefulWidget {
  const OccurrenceListView({super.key});

  @override
  State<OccurrenceListView> createState() => _OccurrenceListViewState();
}

class _OccurrenceListViewState extends State<OccurrenceListView> {
  late Future<List<Occurrence>> _occurrencesFuture;
  OccurrenceStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _loadOccurrences();
  }

  void _loadOccurrences() {
    setState(() {
      _occurrencesFuture = locator<OccurrenceRepository>().getOccurrences(status: _selectedStatus);
    });
  }

  void _onFilterSelected(OccurrenceStatus? status) {
    setState(() {
      _selectedStatus = status;
    });
    _loadOccurrences();
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('EEEE, d MMMM', 'pt_BR').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          formattedDate,
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: _buildFilterChips(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadOccurrences();
        },
        child: FutureBuilder<List<Occurrence>>(
          future: _occurrencesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerList();
            }
            if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhuma ocorrência encontrada.'));
            }
            final occurrences = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8),
              itemCount: occurrences.length,
              itemBuilder: (context, index) {
                return OccurrenceCard(occurrence: occurrences[index]);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildChip('Todos', null),
          _buildChip('Em Andamento', OccurrenceStatus.em_andamento),
          _buildChip('Concluído', OccurrenceStatus.concluido),
        ],
      ),
    );
  }

  Widget _buildChip(String label, OccurrenceStatus? status) {
    final bool isSelected = _selectedStatus == status;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) => _onFilterSelected(status),
        selectedColor: Theme.of(context).primaryColor,
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
        backgroundColor: Colors.grey[200],
        shape: StadiumBorder(side: BorderSide(color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!)),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 200, color: Colors.white),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: double.infinity, height: 24, color: Colors.white),
                    const SizedBox(height: 8),
                    Container(width: 150, height: 16, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
