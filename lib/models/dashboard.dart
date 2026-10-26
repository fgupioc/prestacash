import 'package:prestacash/models/loan.dart';

class Dashboard {
  final double totalPrestado;
  final double totalPorCobrar;
  final int cantidadPrestamos;
  final int cantidadVencidos;
  final List<Loan> ultimosPrestamos;

  Dashboard({
    required this.totalPrestado,
    required this.totalPorCobrar,
    required this.cantidadPrestamos,
    required this.cantidadVencidos,
    required this.ultimosPrestamos,
  });

  static Dashboard fromJson(data) {
    return Dashboard(
      totalPrestado: data['totalPrestado']?.toDouble() ?? 0.0,
      totalPorCobrar: data['totalPorCobrar']?.toDouble() ?? 0.0,
      cantidadPrestamos: data['cantidadPrestamos'] ?? 0,
      cantidadVencidos: data['cantidadVencidos'] ?? 0,
      ultimosPrestamos:
          (data['ultimosPrestamos'] as List<dynamic>?)
              ?.map((e) => Loan.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPrestado': totalPrestado,
      'totalPorCobrar': totalPorCobrar,
      'cantidadPrestamos': cantidadPrestamos,
      'cantidadVencidos': cantidadVencidos,
      'ultimosPrestamos': ultimosPrestamos.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Dashboard(totalPrestado: $totalPrestado, totalPorCobrar: $totalPorCobrar, cantidadPrestamos: $cantidadPrestamos, cantidadVencidos: $cantidadVencidos, ultimosPrestamos: $ultimosPrestamos)';
  }
}
