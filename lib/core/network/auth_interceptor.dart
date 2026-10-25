// lib/core/network/auth_interceptor.dart
import 'package:dio/dio.dart';
import '../auth/token_storage.dart';

class AuthInterceptor extends QueuedInterceptor {
  final Dio dio;               // el Dio principal (para reintentar)
  final TokenStorage storage;
  final Dio _refreshDio;       // Dio "limpio", sin interceptores
  final void Function()? onSessionExpired;

  AuthInterceptor({
    required this.dio,
    required this.storage,
    required String baseUrl,
    this.onSessionExpired,
  }) : _refreshDio = Dio(BaseOptions(baseUrl: baseUrl));

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.extra['skipAuth'] != true) {
      final token = await storage.accessToken;
      if (token != null) options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final req = err.requestOptions;
    final is401 = err.response?.statusCode == 401;

    if (!is401 || req.extra['skipAuth'] == true || req.extra['retried'] == true) {
      return handler.next(err);
    }

    // Si otra petición ya renovó el token mientras esta esperaba en la cola,
    // basta con reintentar con el token nuevo.
    final usedToken = (req.headers['Authorization'] as String?)?.replaceFirst('Bearer ', '');
    final current = await storage.accessToken;
    if (current != null && current != usedToken) {
      return _retry(req, current, handler, err);
    }

    final refresh = await storage.refreshToken;
    if (refresh == null) return _expire(handler, err);

    try {
      // ⚠️ Ajusta la ruta y el body a lo que exponga tu backend
      final res = await _refreshDio.post('/auth/refresh', data: {'refreshToken': refresh});
      final newAccess = res.data['accessToken'] as String;
      final newRefresh = (res.data['refreshToken'] as String?) ?? refresh;
      await storage.save(accessToken: newAccess, refreshToken: newRefresh);
      return _retry(req, newAccess, handler, err);
    } catch (_) {
      return _expire(handler, err);
    }
  }

  Future<void> _retry(RequestOptions req, String token,
      ErrorInterceptorHandler handler, DioException original) async {
    try {
      req.headers['Authorization'] = 'Bearer $token';
      req.extra['retried'] = true;
      handler.resolve(await dio.fetch(req));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  Future<void> _expire(ErrorInterceptorHandler handler, DioException err) async {
    await storage.clear();
    onSessionExpired?.call(); // p. ej. navegar al login
    handler.next(err);
  }
}