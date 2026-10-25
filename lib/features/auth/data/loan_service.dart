
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:prestacash/models/cuota.dart';
import 'package:prestacash/models/loan.dart';

import '../../../core/network/api_client.dart';
import '../../../models/api_response.dart';

class LoanService {
  final Dio _dio;

  LoanService(ApiClient client) : _dio = client.dio;

  Future<List<Loan>> getLoans() async {
    try {
      final res = await _dio.get('/api/v1/loans');
      final api = ApiResponse<List<Loan>>.fromJson(
        res.data,
        (data) => (data as List).map((e) => Loan.fromJson(e)).toList(),
      );

      if (!api.success) {
        throw Exception(api.message ?? 'Error al obtener préstamos');
      }
      return api.data ?? [];
    } on DioException catch (e) {
      final body = e.response?.data;
      final msg = body is Map ? body['message'] : null;
      throw Exception(msg ?? 'Error de conexión: ${e.message}');
    }
  }

  Future<List<Cuota>> getCuotas(int loanId) async {
    try {
      final res = await _dio.get('/api/v1/loans/$loanId/cuotas');
      final api = ApiResponse<List<Cuota>>.fromJson(
        res.data,
        (data) => (data as List).map((e) => Cuota.fromJson(e)).toList(),
      );

      if (!api.success) {
        throw Exception(api.message ?? 'Error al obtener cuotas');
      }
      return api.data ?? [];
    } on DioException catch (e) {
      final body = e.response?.data;
      final msg = body is Map ? body['message'] : null;
      throw Exception(msg ?? 'Error de conexión: ${e.message}');
    }
  }
}