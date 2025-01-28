import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../models/recipe_model.dart';
import '../services/recipe_service.dart';
import '../utils/dialog_utils.dart';

class RecipeProvider with ChangeNotifier {
  final RecipeService _recipeService;

  List<Recipe> _recipes = [];
  Recipe? _recipe;
  bool _isLoading = false;
  int _currentPage = 1;
  int? _lastPage;
  bool _hasMore = true;

  RecipeProvider({required RecipeService recipeService})
      : _recipeService = recipeService;

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;
  Recipe? get recipe => _recipe;

  Future<void> getRecipeDetail(int id) async {
    _startLoading();
    try {
      final response = await _recipeService.getRecipeDetail(id);
      if (response.isSuccess) _recipe = response.data!;
    } catch (e) {
      rethrow;
    } finally {
      _stopLoading();
    }
  }

  Future<void> loadRecipes([bool loadMore = false]) async {
    _recipe = null;
    if (loadMore) {
      if (!_hasMore || _isLoading) return;
      _currentPage++;
    } else {
      _currentPage = 1;
      _hasMore = true;
    }

    _startLoading();
    try {
      final response = await _recipeService.getRecipes(_currentPage);
      if (response.isSuccess) {
        final paginatedData = response.data!;

        if (loadMore) {
          _recipes.addAll(paginatedData.data);
        } else {
          _recipes = paginatedData.data;
        }

        _lastPage = paginatedData.currentPage;
        _hasMore = paginatedData.nextPageUrl != null;
      }
    } catch (e) {
      if (loadMore) _currentPage--;
      rethrow;
    } finally {
      _stopLoading();
    }
  }

  Future<bool> createRecipe({
    required String title,
    required String description,
    required String cookingMethod,
    required String ingredients,
    required XFile photo,
  }) async {
    _startLoading();
    try {
      final response = await _recipeService.createRecipe(
        title: title,
        description: description,
        cookingMethod: cookingMethod,
        ingredients: ingredients,
        photo: photo,
      );
      if (response.isSuccess) {
        DialogUtils.showInfoDialog('Resep berhasil ditambahkan');
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    } finally {
      _stopLoading();
    }
  }

  // update recipe
  Future<bool> updateRecipe({
    required int id,
    required String title,
    required String description,
    required String cookingMethod,
    required String ingredients,
  }) async {
    _startLoading();
    try {
      final response = await _recipeService.updateRecipe(
        id: id,
        title: title,
        description: description,
        cookingMethod: cookingMethod,
        ingredients: ingredients,
      );
      if (response.isSuccess) {
        DialogUtils.showInfoDialog('Resep berhasil diupdate');
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    } finally {
      _stopLoading();
    }
  }

  Future<void> deleteRecipe(int id) async {
    _startLoading();
    try {
      await _recipeService.deleteRecipe(id);
      // Hapus resep dari list
      _recipes.removeWhere((recipe) => recipe.id == id);
      notifyListeners();
      DialogUtils.showInfoDialog('Resep berhasil dihapus');
    } catch (e) {
      rethrow;
    } finally {
      _stopLoading();
    }
  }

  void _startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void _stopLoading() {
    _isLoading = false;
    notifyListeners();
  }
}
