import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/vault_service.dart';

class PasswordGeneratorCard extends StatefulWidget {
  final Function() onSaved;

  const PasswordGeneratorCard({super.key, required this.onSaved});

  @override
  State<PasswordGeneratorCard> createState() => _PasswordGeneratorCardState();
}

class _PasswordGeneratorCardState extends State<PasswordGeneratorCard> {
  final VaultService _vault = VaultService();
  final TextEditingController _serviceController = TextEditingController();
  String _currentPassword = "";

  @override
  void initState() {
    super.initState();
    _currentPassword = _vault.generateMemorablePassword();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey.withAlpha(80), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const Text(
              "Генератор фраз-паролей",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SelectableText(
                    _currentPassword,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Spacer(),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 20),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _currentPassword));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _serviceController,
              decoration: const InputDecoration(
                labelText: "Название сервиса",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Colors.blue, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Colors.blueGrey, width: 1),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () => setState(
                    () => _currentPassword = _vault.generateMemorablePassword(),
                  ),
                  icon: const Icon(Icons.refresh),
                  label: const Text("Новый"),
                ),
                TextButton(
                  onPressed: () async {
                    if (_serviceController.text.isNotEmpty) {
                      await _vault.savePassword(
                        _serviceController.text,
                        _currentPassword,
                      );
                      _serviceController.clear();
                      widget.onSaved();
                    }
                  },
                  child: const Text("Сохранить"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
