import 'package:dio/dio.dart';
import 'package:prestacash/core/network/api_client.dart';
import 'package:prestacash/models/dashboard.dart';

import '../../../models/api_response.dart';

class DashboardService {
  final Dio _dio;

  DashboardService(ApiClient apiClient) : _dio = apiClient.dio;

  Future<Dashboard> getDashboard() async {
    try {
      final res = await _dio.get('/api/v1/dashboard');
      final api = ApiResponse<Dashboard>.fromJson(
        res.data,
        (data) => Dashboard.fromJson(data),
      );

      if (!api.success) {
        throw Exception(api.message ?? 'Error al obtener el dashboard');
      }
      return api.data!;
    } on DioException catch (e) {
      final body = e.response?.data;
      final msg = body is Map ? body['message'] : null;
      throw Exception(msg ?? 'Error de conexión: ${e.message}');
    }
  }
}