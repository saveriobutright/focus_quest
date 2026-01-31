import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../views/history_page.dart';
import '../views/profile_page.dart';
import '../views/dashboard_view.dart';

//Home page (ConsumerWidget can read Riverpod data)
class HomePage extends ConsumerStatefulWidget{
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>{
  //navigation index
  int _currentIndex = 0;

  //views
  final List<Widget> _pages = [
    const DashboardView(),
    const HistoryPage(),
    const ProfilePage(),
  ];

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('FocusQuest'),
        centerTitle: true,
      ),
      //change view based on index
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Storico'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profilo'),
        ],
      ),
    );
  }
} 
