import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';

class ApiService {
  late final Dio _dio;
  String? _token;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_token != null) {
          options.headers['Authorization'] = 'Bearer $_token';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        return handler.next(error);
      },
    ));
  }

  void setToken(String? token) {
    _token = token;
  }

  String? getToken() => _token;

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '${AppConstants.apiAuthEndpoint}/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '${AppConstants.apiAuthEndpoint}/login',
      data: {
        'email': email,
        'password': password,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> logout() async {
    final response = await _dio.post('${AppConstants.apiAuthEndpoint}/logout');
    _token = null;
    return response.data;
  }

  Future<Map<String, dynamic>> getMe() async {
    final response = await _dio.get('${AppConstants.apiAuthEndpoint}/me');
    return response.data;
  }

  Future<List<dynamic>> getPurchases() async {
    final response = await _dio.get(AppConstants.apiPurchasesEndpoint);
    return response.data['purchases'];
  }

  Future<Map<String, dynamic>> createPurchase({
    required String productBarcode,
    required double price,
    required String store,
    required String purchaseDate,
  }) async {
    final response = await _dio.post(
      AppConstants.apiPurchasesEndpoint,
      data: {
        'product_barcode': productBarcode,
        'price': price,
        'store': store,
        'purchase_date': purchaseDate,
      },
    );
    return response.data['purchase'];
  }

  Future<Map<String, dynamic>> updatePurchase({
    required int id,
    String? productBarcode,
    double? price,
    String? store,
    String? purchaseDate,
  }) async {
    final response = await _dio.put(
      '${AppConstants.apiPurchasesEndpoint}/$id',
      data: {
        if (productBarcode != null) 'product_barcode': productBarcode,
        if (price != null) 'price': price,
        if (store != null) 'store': store,
        if (purchaseDate != null) 'purchase_date': purchaseDate,
      },
    );
    return response.data['purchase'];
  }

  Future<void> deletePurchase(int id) async {
    await _dio.delete('${AppConstants.apiPurchasesEndpoint}/$id');
  }
}
