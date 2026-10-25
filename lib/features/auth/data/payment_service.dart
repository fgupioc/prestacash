import 'package:dio/dio.dart';
import 'package:prestacash/core/network/api_client.dart';
import 'package:prestacash/models/payment.dart';
import '../../../models/api_response.dart';

class PaymentService {
  final Dio _dio;

  PaymentService(ApiClient apiClient) : _dio = apiClient.dio;

  Future<Payment> create(Payment payment) async {
    try {
      final res = await _dio.post('/api/v1/payments',
        data: {
          "loanId": payment.loanId,
          "amount": payment.amount,
          "paymentDate": payment.paymentDate,
          "paymentType": payment.paymentType,
          "observations": payment.observations
        },
      );

      final api = ApiResponse<Payment>.fromJson(
        res.data, (data) => Payment.fromJson(data),
      );

      if (!api.success || api.data == null) {
        throw Exception(api.message ?? 'No se pudo registrar el cliente');
      }
      return api.data!;
    } on DioException catch (e) {
      final body = e.response?.data;
      if (body is Map) {
        final errors = body['errors'];
        if (errors is Map && errors.isNotEmpty) {
          throw Exception(errors.values.join('\n'));
        }
        if (body['message'] != null) throw Exception(body['message']);
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }
}