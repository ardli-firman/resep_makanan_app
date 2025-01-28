import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/models/recipe_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/providers/recipe_provider.dart';
import '../../core/widgets/custom_text_field_widget.dart';

class TambahResepScreen extends StatefulWidget {
  const TambahResepScreen({super.key});

  @override
  State<TambahResepScreen> createState() => _TambahResepScreenState();
}

class _TambahResepScreenState extends State<TambahResepScreen> {
  final _formKey = GlobalKey<FormState>();
  final judulController = TextEditingController();
  final deskripsiController = TextEditingController();
  final ingredientsController = TextEditingController();
  final methodController = TextEditingController();
  XFile? _imageFile;
  Recipe? recipe;
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments is Recipe) recipe = arguments;
    if (recipe != null) {
      setState(() {
        _isEdit = true;
      });
      judulController.text = recipe?.title ?? "";
      deskripsiController.text = recipe?.description ?? "";
      ingredientsController.text = recipe?.ingredients ?? "";
      methodController.text = recipe?.cookingMethod ?? "";
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Future<void> _submitForm(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null && !_isEdit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih foto resep')),
      );
      return;
    }

    final recipeProvider = context.read<RecipeProvider>();
    if (_isEdit) {
      final res = await recipeProvider.updateRecipe(
        id: recipe!.id,
        title: judulController.text,
        description: deskripsiController.text,
        ingredients: ingredientsController.text,
        cookingMethod: methodController.text,
      );
      if (res) Navigator.pop(context);
    } else {
      final res = await recipeProvider.createRecipe(
        title: judulController.text,
        description: deskripsiController.text,
        ingredients: ingredientsController.text,
        cookingMethod: methodController.text,
        photo: _imageFile!,
      );
      if (res) Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    judulController.dispose();
    deskripsiController.dispose();
    ingredientsController.dispose();
    methodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          _isEdit ? 'Edit Resep' : 'Tambah Resep',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<RecipeProvider>(
        builder: (context, recipeProvider, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    !_isEdit
                        ? GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: _imageFile == null
                                  ? const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_a_photo, size: 48),
                                        SizedBox(height: 8),
                                        Text('Tambahkan Foto Resep'),
                                      ],
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.file(
                                        File(_imageFile!.path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(height: 16),
                    CustomTextFieldWidget(
                      controller: judulController,
                      label: "Judul",
                      enabled: recipeProvider.isLoading ? false : true,
                      hintText: "Masukkan Judul",
                      prefixIcon: const Icon(Icons.title),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Judul tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextFieldWidget(
                      controller: deskripsiController,
                      label: "Deskripsi",
                      enabled: recipeProvider.isLoading ? false : true,
                      lines: 5,
                      hintText: "Masukkan Deskripsi",
                      prefixIcon: const Icon(Icons.description),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Deskripsi tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextFieldWidget(
                      controller: ingredientsController,
                      label: "Bahan-bahan",
                      enabled: recipeProvider.isLoading ? false : true,
                      lines: 5,
                      hintText: "Masukkan Bahan - bahan",
                      prefixIcon: const Icon(Icons.receipt),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bahan-bahan tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextFieldWidget(
                      controller: methodController,
                      label: "Cara Membuat",
                      enabled: recipeProvider.isLoading ? false : true,
                      lines: 5,
                      hintText: "Masukkan Cara Membuat",
                      prefixIcon: const Icon(Icons.article),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Cara membuat tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: recipeProvider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : FilledButton(
                              onPressed: () => _submitForm(context),
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
        },
      ),
    );
  }
}
