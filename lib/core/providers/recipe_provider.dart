import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resep_makanan_app/core/services/recipe_service.dart';

class RecipeProvider with ChangeNotifier {
  final RecipeService _recipeService;

  List<dynamic> _recipes = [];
  bool _isLoading = false;
  String? _errorMessage;

  RecipeProvider({required RecipeService recipeService})
      : _recipeService = recipeService;

  List<dynamic> get recipes => _recipes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadRecipes(int page) async {
    _startLoading();
    try {
      final response = await _recipeService.getRecipes(page);
      _recipes = response['data'];
      _clearError();
    } catch (e) {
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
