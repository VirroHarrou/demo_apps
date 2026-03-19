import 'package:demo_apps/ui/formula_list.dart';
import 'package:flutter/material.dart';
import '../services/formula_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Научный справочник',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.calculate), text: 'Математика'),
              Tab(icon: Icon(Icons.bolt), text: 'Физика'),
              Tab(icon: Icon(Icons.science), text: 'Химия'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            FormulaList(subject: Subject.math),
            FormulaList(subject: Subject.physics),
            FormulaList(subject: Subject.chemistry),
          ],
        ),
      ),
    );
  }
}
