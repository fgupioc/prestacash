enum LoanStatus {
  pending('PENDING', 'Pendiente'),
  paid('PAID', 'Pagado'),
  cancelled('CANCELLED', 'Cancelado'),
  expired('EXPIRED', 'Expirado');

  const LoanStatus(this.apiValue, this.label);

  /// Valor tal como lo envía/espera el backend (Java enum name)
  final String apiValue;

  /// Etiqueta legible para mostrar en la UI
  final String label;

  /// Convierte un String del backend a LoanStatus.
  /// Devuelve [LoanStatus.pending] por defecto si no coincide (o lanza excepción si prefieres).
  static LoanStatus fromApi(String? value) {
    return LoanStatus.values.firstWhere(
          (status) => status.apiValue == value,
      orElse: () => LoanStatus.pending,
    );
  }

  /// Convierte un String en cualquier formato (PENDING, pending, Pending) a LoanStatus.
  static LoanStatus? tryParse(String? value) {
    if (value == null) return null;
    final normalized = value.toUpperCase();
    for (final status in LoanStatus.values) {
      if (status.apiValue == normalized) return status;
    }
    return null;
  }

  /// Representación JSON-friendly
  String toJson() => apiValue;

  /// Útil para JsonSerializable / fromJson
  static LoanStatus fromJson(dynamic json) =>
      fromApi(json is String ? json : null);
}