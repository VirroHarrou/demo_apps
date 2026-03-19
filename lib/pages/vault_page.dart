import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/vault_service.dart';
import '../widgets/password_generator_card.dart';

class VaultPage extends StatefulWidget {
  const VaultPage({super.key});

  @override
  State<VaultPage> createState() => _VaultPageState();
}

class _VaultPageState extends State<VaultPage> {
  final _storage = const FlutterSecureStorage();
  final VaultService _vault = VaultService();

  bool _isAuthenticated = false;
  bool _pinExists = false;
  final TextEditingController _pinController = TextEditingController();
  List<dynamic> _savedPasswords = [];

  @override
  void initState() {
    super.initState();
    _checkPinStatus();
  }

  Future<void> _checkPinStatus() async {
    String? pin = await _storage.read(key: 'user_pin');
    setState(() {
      _pinExists = pin != null;
    });
  }

  Future<void> _loadPasswords() async {
    final data = await _vault.getAllPasswords();
    setState(() {
      _savedPasswords = data;
    });
  }

  void _handlePinSubmit() async {
    if (!_pinExists) {
      await _storage.write(key: 'user_pin', value: _pinController.text);
      setState(() => _pinExists = true);
      _pinController.clear();
    } else {
      String? savedPin = await _storage.read(key: 'user_pin');
      if (savedPin == _pinController.text) {
        setState(() => _isAuthenticated = true);
        _loadPasswords();
      } else if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Неверный PIN")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) return _buildAuth();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Менеджер паролей",
          style: TextStyle(
            fontSize: 22,
            letterSpacing: 2,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => setState(() => _isAuthenticated = false),
          ),
        ],
      ),
      body: Column(
        children: [
          PasswordGeneratorCard(onSaved: _loadPasswords),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "Сохраненные доступы",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _savedPasswords.length,
              itemBuilder: (context, index) {
                final entry = _savedPasswords[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.blueGrey.withAlpha(80),
                        width: 2,
                      ),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.vpn_key),
                      title: Text(
                        entry['serviceName'],
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(entry['password']),
                      trailing: IconButton(
                        icon: const Icon(Icons.copy, size: 20),
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: entry['password']),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuth() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 64, color: Colors.blueGrey),
              const SizedBox(height: 20),
              Text(
                _pinExists ? "Введите PIN для входа" : "Создайте PIN-код",
                style: TextStyle(fontSize: 16, letterSpacing: 1.5),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: "* * * *",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Colors.blueGrey, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Colors.blueGrey, width: 1),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Colors.blueGrey, width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handlePinSubmit,
                child: Text(_pinExists ? "Войти" : "Сохранить PIN"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
