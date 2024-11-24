import 'package:flutter/material.dart';
import 'package:resep_makanan_app/core/widgets/custom_text_field_widget.dart';

class TambahResepScreen extends StatefulWidget {
  const TambahResepScreen({super.key});

  @override
  State<TambahResepScreen> createState() => _TambahResepScreenState();
}

class _TambahResepScreenState extends State<TambahResepScreen> {
  final judulController = TextEditingController();
  final deskripsiController = TextEditingController();
  final ingridientsController = TextEditingController();

  @override
  void dispose() {
    judulController.dispose();
    deskripsiController.dispose();
    ingridientsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Tambah Resep',
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
                controller: judulController,
                label: "Judul",
                hintText: "Masukkan Judul",
                prefixIcon: const Icon(Icons.title),
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextFieldWidget(
                controller: deskripsiController,
                label: "Deskripsi",
                lines: 5,
                hintText: "Masukkan Deskripsi",
                prefixIcon: const Icon(Icons.description),
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextFieldWidget(
                controller: ingridientsController,
                label: "Bahan-bahan",
                lines: 5,
                hintText: "Masukkan Bahan - bahan",
                prefixIcon: const Icon(Icons.receipt),
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
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
