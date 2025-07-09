import 'package:flutter/material.dart';
import 'package:voz_popular/presentation/screens/my_occurrences/my_occurrences_screen.dart';
import 'package:voz_popular/presentation/screens/profile/profile_screen.dart';
import 'package:voz_popular/presentation/screens/updates/updates_screen.dart';
import 'package:voz_popular/presentation/widgets/occurrence_list_view.dart';
import 'package:voz_popular/routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    OccurrenceListView(),
    UpdatesScreen(),
    SizedBox.shrink(),
    MyOccurrencesScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.pushNamed(context, AppRoutes.newOccurrence);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onItemTapped(2),
        backgroundColor: Colors.grey[850],
        child: const Icon(Icons.add, color: Colors.white),
        elevation: 2.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              tooltip: 'Início',
              icon: Icon(Icons.home, color: _selectedIndex == 0 ? Theme.of(context).primaryColor : Colors.grey),
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              tooltip: 'Atualizações',
              icon: Icon(Icons.notifications, color: _selectedIndex == 1 ? Theme.of(context).primaryColor : Colors.grey),
              onPressed: () => _onItemTapped(1),
            ),
            const SizedBox(width: 40),
            IconButton(
              tooltip: 'Minhas Ocorrências',
              icon: Icon(Icons.folder, color: _selectedIndex == 3 ? Theme.of(context).primaryColor : Colors.grey),
              onPressed: () => _onItemTapped(3),
            ),
            IconButton(
              tooltip: 'Perfil',
              icon: Icon(Icons.person, color: _selectedIndex == 4 ? Theme.of(context).primaryColor : Colors.grey),
              onPressed: () => _onItemTapped(4),
            ),
          ],
        ),
      ),
    );
  }
}
