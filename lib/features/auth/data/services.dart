import 'package:flutter/material.dart';

import '../../../core/auth/token_storage.dart';
import '../../../core/network/api_client.dart';
import '../../../screens/login_screen.dart';
import 'auth_service.dart';
import 'customer_service.dart';

final navigatorKey = GlobalKey<NavigatorState>();

late final ApiClient apiClient;
late final AuthService authService;
late final CustomerService customerService;

void setupServices() {
  apiClient = ApiClient(
    storage: TokenStorage(),
    onSessionExpired: () => navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (_) => false,
    ),
  );

  authService = AuthService(apiClient);
  customerService = CustomerService(apiClient);
  // loanService = LoanService(apiClient);
}