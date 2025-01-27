import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/widgets/custom_text_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // untuk text controller pada tiap field
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late final AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();

    authProvider.addListener(_isAuthenticated);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    authProvider.removeListener(_isAuthenticated);
    super.dispose();
  }

  void _isAuthenticated() async {
    if (authProvider.isAuthenticated && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
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
