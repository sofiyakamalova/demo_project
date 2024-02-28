import 'package:demo_project/src/features/events_page/events_page.dart';
import 'package:demo_project/src/features/tickets_page/tickets_page.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  List pages = [
    const EventsPage(),
    const TicketsPage(),
    Container(
      color: Colors.red,
    ),
    // const ToDoPage(),
    // const UsersPage(),
  ];
  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xFF5777A2),
        unselectedItemColor: Colors.black.withOpacity(0.4),
        showSelectedLabels: true,
        showUnselectedLabels: false,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
              label: "Events", icon: Icon(Icons.home_outlined)),
          BottomNavigationBarItem(label: "Tickets", icon: Icon(Icons.add)),
          BottomNavigationBarItem(label: "just", icon: Icon(Icons.add)),
        ],
      ),
    );
  }
}
