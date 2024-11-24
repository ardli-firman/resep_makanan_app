import 'package:flutter/material.dart';
import 'package:resep_makanan_app/core/widgets/custom_text_field_widget.dart';

class RegistrasiScreen extends StatefulWidget {
  const RegistrasiScreen({super.key});

  @override
  State<RegistrasiScreen> createState() => _RegistrasiScreenState();
}

class _RegistrasiScreenState extends State<RegistrasiScreen> {
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Registrasi',
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
              CustomTextFieldWidget(
                controller: namaController,
                label: "Nama",
                hintText: "Masukkan Nama",
                prefixIcon: const Icon(Icons.person),
              ),
              const SizedBox(
                height: 16,
              ),
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
                    Navigator.pushNamed(context, "/");
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
