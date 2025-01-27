import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resep_makanan_app/core/models/recipe_model.dart';
import 'package:resep_makanan_app/core/services/recipe_service.dart';

class RecipeProvider with ChangeNotifier {
  final RecipeService _recipeService;

  List<Recipe> _recipes = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _currentPage = 1;
  int? _lastPage;
  bool _hasMore = true;

  RecipeProvider({required RecipeService recipeService})
      : _recipeService = recipeService;

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;

  Future<void> loadRecipes([bool loadMore = false]) async {
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
        _clearError();
      }
    } catch (e) {
      if (loadMore) _currentPage--;
      _setError(e.toString());
    } finally {
      _stopLoading();
    }
  }

  Future<void> createRecipe({
    required String title,
    required String description,
    required String cookingMethod,
    required String ingredients,
    required XFile photo,
  }) async {
    _startLoading();
    try {
      await _recipeService.createRecipe(
        title: title,
        description: description,
        cookingMethod: cookingMethod,
        ingredients: ingredients,
        photo: photo,
      );
      _clearError();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _stopLoading();
    }
  }

  // update recipe
  Future<void> updateRecipe({
    required int id,
    required String title,
    required String description,
    required String cookingMethod,
    required String ingredients,
  }) async {
    _startLoading();
    try {
      await _recipeService.updateRecipe(
        id: id,
        title: title,
        description: description,
        cookingMethod: cookingMethod,
        ingredients: ingredients,
      );
      _clearError();
    } catch (e) {
      _setError(e.toString());
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

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
