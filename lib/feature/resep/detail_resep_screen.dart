import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../core/models/recipe_model.dart';
import '../../core/providers/recipe_provider.dart';
import '../../core/utils/dialog_utils.dart';

class DetailResepScreen extends StatefulWidget {
  final argument;
  const DetailResepScreen({super.key, this.argument});

  @override
  State<DetailResepScreen> createState() => DetailResepScreenState();
}

class DetailResepScreenState extends State<DetailResepScreen> {
  late Recipe recipe;

  @override
  void initState() {
    super.initState();
    recipe = widget.argument as Recipe;
  }

  Future<void> _deleteRecipe(BuildContext context) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin menghapus resep ini?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text('Hapus'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      final provider = Provider.of<RecipeProvider>(context, listen: false);
      try {
        await provider.deleteRecipe(recipe.id ?? 0);
        // Navigasi ke home screen dengan menghapus semua halaman di stack
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } catch (e) {
        if (mounted) {
          DialogUtils.showErrorDialog("Gagal menghapus resep");
        }
      }
    }
  }

  Widget _buildIngredientItem(String ingredient) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(Icons.circle, size: 8),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              ingredient,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Detail Resep',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            color: Colors.white,
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/tambah-resep',
                arguments: recipe,
              ).then((_) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  context
                      .read<RecipeProvider>()
                      .getRecipeDetail(recipe.id ?? 0);
                });
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.white,
            onPressed: () => _deleteRecipe(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        child: Consumer<RecipeProvider>(builder: (context, recipeProvider, _) {
          if (recipeProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          Recipe _recipe = widget.argument as Recipe;

          if (recipeProvider.recipe != null) {
            _recipe = recipeProvider.recipe!;
            recipe = _recipe;
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Hero(
                  tag: _recipe.id ?? "",
                  child: CachedNetworkImage(
                    height: 200,
                    width: double.infinity,
                    imageUrl: _recipe.photoUrl ?? "",
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.error),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    Text(
                      _recipe.title ?? "",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Badge(
                      backgroundColor: Colors.green[600],
                      label: Text(
                        "Oleh : ${_recipe.user?.name}",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Deskripsi",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _recipe.description ?? "",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Bahan - bahan",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          ...(_recipe.ingredients ?? "")
                              .split('\n')
                              .map(_buildIngredientItem),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Cara Membuat",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          ...(_recipe.cookingMethod ?? "").split('\n').map(
                                (step) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          '${(_recipe.cookingMethod ?? "").split('\n').indexOf(step) + 1}.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          step,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
