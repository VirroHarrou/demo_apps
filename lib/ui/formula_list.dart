import 'package:demo_apps/services/formula_service.dart';
import 'package:demo_apps/ui/animated_formula_card.dart';
import 'package:flutter/material.dart';

class FormulaList extends StatefulWidget {
  final Subject subject;
  const FormulaList({required this.subject, super.key});

  @override
  State<FormulaList> createState() => _FormulaListState();
}

class _FormulaListState extends State<FormulaList> {
  int _expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final formulas = FormulaService.getFormulas(widget.subject);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: formulas.length,
      itemBuilder: (context, index) {
        return AnimatedFormulaCard(
          formula: formulas[index],
          isExpanded: index == _expandedIndex,
          onTap: () {
            setState(() {
              _expandedIndex = (_expandedIndex == index) ? -1 : index;
            });
          },
        );
      },
    );
  }
}
