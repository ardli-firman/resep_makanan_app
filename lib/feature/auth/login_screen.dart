import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading di set false untuk menghilangkan tombol back
        automaticallyImplyLeading: false,
        title: const Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // custom text field widget terdapat pada core/widgets/custom_text_field_widget.dart
              CustomTextFieldWidget(
                controller: emailController,
                label: "Email",
                hintText: "Masukkan Email",
                prefixIcon: const Icon(Icons.email),
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextFieldWidget(
                controller: passwordController,
                label: "Password",
                obscureText: true,
                hintText: "Masukkan Password",
                prefixIcon: const Icon(Icons.key),
              ),
              const SizedBox(
                height: 32,
              ),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () {
                    // navigator pushnamed digunakan untuk pindah halaman berdasarkan route yang sudah didefinisi diwal
                    Navigator.pushNamed(context, "/");
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/register");
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Daftar akun disini'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
