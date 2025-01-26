import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resep_makanan_app/core/providers/auth_provider.dart';
import 'package:resep_makanan_app/core/providers/recipe_provider.dart';
import 'package:resep_makanan_app/feature/home/widgets/item_resep_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecipeProvider>().loadRecipes();
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMore();
    }
  }

  void _loadMore() {
    final provider = context.read<RecipeProvider>();
    if (provider.hasMore && !provider.isLoading) {
      provider.loadRecipes(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                Navigator.popAndPushNamed(context, '/login');
              }
            },
          )
        ],
      ),
      body: Consumer<RecipeProvider>(
        builder: (context, recipeProvider, _) {
          if (recipeProvider.isLoading && recipeProvider.recipes.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (recipeProvider.errorMessage != null) {
            return Center(
              child: Text(
                recipeProvider.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification &&
                  _scrollController.position.extentAfter == 0) {
                _loadMore();
              }
              return false;
            },
            child: GridView.builder(
              controller: _scrollController,
              itemCount: recipeProvider.recipes.length +
                  (recipeProvider.hasMore ? 1 : 0),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                mainAxisExtent: 250,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                if (index >= recipeProvider.recipes.length) {
                  return Center(
                    child: recipeProvider.isLoading
                        ? const CircularProgressIndicator()
                        : const Text('No more recipes'),
                  );
                }

                final recipe = recipeProvider.recipes[index];
                return ItemResepWidget(
                  recipe: recipe,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/detail-resep',
                      arguments: recipe,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/tambah-resep');
        },
        label: const Text("Tambah Resep"),
      ),
    );
  }
}
