import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const FormulaApp());
}

class FormulaApp extends StatelessWidget {
  const FormulaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Научный справочник',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: HomePage(),
    );
  }
}
