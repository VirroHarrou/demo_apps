class PasswordEntry {
  final String serviceName;
  final String password;

  PasswordEntry({required this.serviceName, required this.password});

  // Преобразование в JSON для хранения
  Map<String, dynamic> toJson() => {
    'serviceName': serviceName,
    'password': password,
  };

  factory PasswordEntry.fromJson(Map<String, dynamic> json) => PasswordEntry(
    serviceName: json['serviceName'],
    password: json['password'],
  );
}
