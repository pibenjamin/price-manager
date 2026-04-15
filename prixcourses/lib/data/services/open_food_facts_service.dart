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
        '${AppConstants.openFoodFactsProductEndpoint}/$barcode.json',
      );

      if (response.statusCode == 200 && response.data['status'] == 1) {
        return Product.fromOpenFoodFacts(barcode, response.data);
      }

      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw Exception('Failed to fetch product: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch product: $e');
    }
  }
}
