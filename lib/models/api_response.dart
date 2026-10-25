class ApiResponse<T> {
  final bool success;
  final int status;
  final String? message;
  final T? data;
  final Map<String, String>? errors;
  final String? path;
  final DateTime? timestamp;

  ApiResponse({
    required this.success,
    required this.status,
    this.message,
    this.data,
    this.errors,
    this.path,
    this.timestamp,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic json) fromJsonT,
      ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      message: json['message'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      errors: (json['errors'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v.toString())),
      path: json['path'],
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'])
          : null,
    );
  }
}