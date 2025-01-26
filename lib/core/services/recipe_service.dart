import 'package:image_picker/image_picker.dart';
import 'package:resep_makanan_app/core/models/recipe_model.dart';
import 'package:resep_makanan_app/core/services/api_service.dart';
import 'package:resep_makanan_app/core/models/api_response.dart';

class RecipeService {
  final ApiService _apiService;
  final ImagePicker _picker = ImagePicker();

  RecipeService({required ApiService apiService}) : _apiService = apiService;

  Future<ApiResponse<PaginatedResponse<Recipe>>> getRecipes(int page) async {
    return await _apiService.get<PaginatedResponse<Recipe>>(
      'api/recipes?page=$page',
      fromJson: (json) => PaginatedResponse<Recipe>.fromJson(
        json,
        (itemJson) => Recipe.fromJson(itemJson),
      ),
    );
  }

  Future<ApiResponse<Recipe>> getRecipeDetail(int id) async {
    return await _apiService.get<Recipe>(
      'api/recipes/$id',
      fromJson: (json) => Recipe.fromJson(json),
    );
  }

  Future<ApiResponse<Recipe>> createRecipe({
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

    final response = await _apiService.handleMultipartRequest(request);
    return ApiResponse<Recipe>.fromJson(
      response,
      (data) => Recipe.fromJson(data),
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> updateRecipe({
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
