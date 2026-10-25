// lib/core/network/api_client.dart
import 'package:dio/dio.dart';

import '../auth/token_storage.dart';
import 'auth_interceptor.dart';

class ApiClient {
  // Emulador Android: 10.0.2.2 | Dispositivo físico: IP de tu PC en la red local
  static const baseUrl = 'http://192.168.1.108:8080/api-prestacash';

  final TokenStorage storage;
  late final Dio dio;

  ApiClient({required this.storage, void Function()? onSessionExpired}) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    dio.interceptors.add(
      AuthInterceptor(
        dio: dio,
        storage: storage,
        baseUrl: baseUrl,
        onSessionExpired: onSessionExpired,
      ),
    );
  }
}
