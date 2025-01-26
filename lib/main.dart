import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resep_makanan_app/core/providers/auth_provider.dart';
import 'package:resep_makanan_app/core/providers/recipe_provider.dart';
import 'package:resep_makanan_app/core/services/auth_service.dart';
import 'package:resep_makanan_app/core/services/api_service.dart';
import 'package:resep_makanan_app/core/services/recipe_service.dart';
import 'package:resep_makanan_app/core/utils/token_manager.dart';
import 'package:resep_makanan_app/core/utils/dialog_utils.dart';
import 'package:resep_makanan_app/feature/app.dart';

void main() {
  // Initialize services
  final tokenManager = TokenManager();
  final apiService = ApiService(tokenManager: tokenManager);
  final authService =
      AuthService(apiService: apiService, tokenManager: tokenManager);
  final recipeService = RecipeService(apiService: apiService);

  // Set up global error handling
  // FlutterError.onError = (details) {
  //   FlutterError.presentError(details);
  //   DialogUtils.showErrorDialog(details.exceptionAsString());
  // };

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            authService: authService,
            tokenManager: tokenManager,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => RecipeProvider(
            recipeService: recipeService,
          ),
        ),
      ],
      child: MaterialApp(
        navigatorKey: DialogUtils.navigatorKey,
        builder: (context, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // _setupErrorHandler(context);
          });
          return child!;
        },
        home: const App(),
      ),
    ),
  );
}

// void _setupErrorHandler(BuildContext context) {
//   // Handle async errors
//   PlatformDispatcher.instance.onError = (error, stack) {
//     DialogUtils.showErrorDialog(error.toString());
//     return true;
//   };
// }
