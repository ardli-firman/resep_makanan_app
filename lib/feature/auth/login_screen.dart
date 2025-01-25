import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resep_makanan_app/core/providers/auth_provider.dart';
import 'package:resep_makanan_app/core/widgets/custom_text_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // untuk text controller pada tiap field
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: authProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      if (authProvider.errorMessage != null)
                        Text(
                          authProvider.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      CustomTextFieldWidget(
                        controller: emailController,
                        label: 'Email',
                        hintText: 'Masukkan email anda',
                      ),
                      const SizedBox(height: 16),
                      CustomTextFieldWidget(
                        controller: passwordController,
                        label: 'Password',
                        hintText: 'Masukkan password anda',
                        obscureText: true,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          if (emailController.text.isNotEmpty &&
                              passwordController.text.isNotEmpty) {
                            authProvider
                                .login(emailController.text,
                                    passwordController.text)
                                .then((_) {
                              if (authProvider.isAuthenticated) {
                                Navigator.pushReplacementNamed(
                                    context, '/home');
                              }
                            });
                          }
                        },
                        child: const Text('Login'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text('Belum punya akun? Daftar disini'),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
