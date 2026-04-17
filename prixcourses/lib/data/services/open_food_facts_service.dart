import 'package:dio/dio.dart';
import '../models/product.dart';
import '../../core/constants/app_constants.dart';

class OpenFoodFactsService {
  final Dio _dio;

  OpenFoodFactsService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: AppConstants.openFoodFactsBaseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ));

  Future<Product?> getProductByBarcode(String barcode) async {
    try {
      final response = await _dio.get(
        '/api/v2/product/$barcode',
        queryParameters: {
          'fields':
              'product_name,product_name_fr,brands,image_url,image_front_url,image_small_url,categories,nutriscore_grade,nutriments,origins'
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 1) {
        return Product.fromOpenFoodFacts(barcode, response.data);
      }

      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw Exception('Échec de récupération du produit: ${e.message}');
    } catch (e) {
      throw Exception('Échec de récupération du produit: $e');
    }
  }
}
