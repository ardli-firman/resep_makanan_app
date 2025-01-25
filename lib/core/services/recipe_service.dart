import 'package:image_picker/image_picker.dart';
import 'package:resep_makanan_app/core/services/api_service.dart';

class RecipeService {
  final ApiService _apiService;
  final ImagePicker _picker = ImagePicker();

  RecipeService({required ApiService apiService}) : _apiService = apiService;

  Future<Map<String, dynamic>> getRecipes(int page) async {
    return await _apiService.get('api/recipes?page=$page');
  }

  Future<Map<String, dynamic>> getRecipeDetail(int id) async {
    return await _apiService.get('api/recipes/$id');
  }

  Future<Map<String, dynamic>> createRecipe({
    required String title,
    required String description,
    required String cookingMethod,
    required String ingredients,
    required XFile photo,
  }) async {
    final request = await _apiService.createMultipartRequest(
      'POST',
      'api/recipes',
      {
        'title': title,
        'description': description,
        'cooking_method': cookingMethod,
        'ingredients': ingredients,
      },
      photo,
    );

    return await _apiService.handleMultipartRequest(request);
  }

  Future<Map<String, dynamic>> updateRecipe({
    required int id,
    required String title,
    required String description,
    required String cookingMethod,
    required String ingredients,
  }) async {
    return await _apiService.put('api/recipes/$id', {
      'title': title,
      'description': description,
      'cooking_method': cookingMethod,
      'ingredients': ingredients,
    });
  }

  Future<void> deleteRecipe(int id) async {
    await _apiService.delete('api/recipes/$id');
  }
}
