// lib/features/customers/data/customer_service.dart
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/network/api_client.dart';
import '../../../models/api_response.dart';
import '../../../models/customer.dart';

class CustomerService {
  final Dio _dio;
  CustomerService(ApiClient client) : _dio = client.dio;

  Future<List<Customer>> getCustomers() async {
    try {
      final res = await _dio.get('/api/v1/customers');
      /*
      debugPrint('STATUS: ${res.statusCode}');
      debugPrint(const JsonEncoder.withIndent('  ').convert(res.data));
      */
      final api = ApiResponse<List<Customer>>.fromJson(
        res.data,
            (data) => (data as List).map((e) => Customer.fromJson(e)).toList(),
      );

      if (!api.success) {
        throw Exception(api.message ?? 'Error al obtener clientes');
      }
      return api.data ?? [];
    } on DioException catch (e) {
      // Tu backend también responde con la envoltura en errores (400, 401, 500...)
      final body = e.response?.data;
      final msg = body is Map ? body['message'] : null;
      throw Exception(msg ?? 'Error de conexión: ${e.message}');
    }
  }

  Future<Customer> createCustomer({
    required String documentType,
    required String documentNumber,
    required String name,
    required String lastName,
    String? phone,
    String? address,
  }) async {
    try {
      final res = await _dio.post('/api/v1/customers', data: {
        'documentType': documentType,
        'documentNumber': documentNumber,
        'name': name,
        'lastName': lastName,
        'phone': phone,
        'address': address,
      });

      final api = ApiResponse<Customer>.fromJson(
        res.data,
            (data) => Customer.fromJson(data),
      );

      if (!api.success || api.data == null) {
        throw Exception(api.message ?? 'No se pudo registrar el cliente');
      }
      return api.data!;
    } on DioException catch (e) {
      final body = e.response?.data;
      if (body is Map) {
        // Errores de validación del backend: { "documentNumber": "ya existe", ... }
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