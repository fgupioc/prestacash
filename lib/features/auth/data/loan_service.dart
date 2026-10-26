
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:prestacash/loan_req_dto.dart';
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

  Future<Loan> create(LoanReqDto loan) async {
    try {
      final res = await _dio.post('/api/v1/loans',
        data: {
          "amount": loan.amount,
          "interest": loan.interest,
          "interestApplications": loan.aplicacionInterest,
          "loanDate": loan.initDate,
          "loanStatus": "PENDING",
          "plazo": loan.plazo,
          "customerId": loan.customerId,
        },
      );

      final api = ApiResponse<Loan>.fromJson(
        res.data, (data) => Loan.fromJson(data),
      );

      if (!api.success || api.data == null) {
        throw Exception(api.message ?? 'No se pudo registrar el préstamo');
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

  Future<Loan> update(int loanId, LoanReqDto loan) async {
    try {
      final res = await _dio.put('/api/v1/loans/$loanId',
        data: {
          "amount": loan.amount,
          "interest": loan.interest,
          "interestApplications": loan.aplicacionInterest,
          "loanDate": loan.initDate,
          "loanStatus": "PENDING",
          "plazo": loan.plazo,
          "customerId": loan.customerId,
        },
      );

      final api = ApiResponse<Loan>.fromJson(
        res.data, (data) => Loan.fromJson(data),
      );

      if (!api.success || api.data == null) {
        throw Exception(api.message ?? 'No se pudo actualizar el préstamo');
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