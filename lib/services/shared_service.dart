import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

Future<void> saveSecureToken(String token) async {
  await storage.write(key: 'userToken', value: token);
}

Future<String?> getSecureToken() async {
  return await storage.read(key: 'userToken');
}

Future<void> removeSecureToken() async {
  await storage.delete(key: 'userToken');
}
