import 'package:dio/dio.dart';
import 'package:moblie_banking/core/utils/secure_storage.dart';
import 'package:moblie_banking/core/models/location_model.dart';

class DioClient {
  final Dio _dio = Dio();
  final Dio _dioV2 = Dio();
  final SecureStorage _storage = SecureStorage();

  DioClient() {
    _dio.options.baseUrl = 'https://fund.nbb.com.la/api/';
    _dioV2.options.baseUrl = 'https://fund.nbb.com.la/api/v2/';

    // Add timeout configurations
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.sendTimeout = const Duration(seconds: 30);

    _dioV2.options.connectTimeout = const Duration(seconds: 30);
    _dioV2.options.receiveTimeout = const Duration(seconds: 30);
    _dioV2.options.sendTimeout = const Duration(seconds: 30);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await _storage.getAccessToken();
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshToken = await _storage.getRefreshToken();
            if (refreshToken != null) {
              try {
                final refreshResponse = await _dio.post(
                  'v1/refreshToken',
                  data: {'refreshToken': refreshToken},
                );

                final newAccessToken = refreshResponse.data['accessToken'];
                final newRefreshToken = refreshResponse.data['refreshToken'];

                await _storage.saveAccessToken(newAccessToken);
                await _storage.saveRefreshToken(newRefreshToken);

                final options = error.requestOptions;
                options.headers['Authorization'] = 'Bearer $newAccessToken';
                final retryResponse = await _dio.fetch(options);
                return handler.resolve(retryResponse);
              } catch (e) {
                await _storage.clearAll();
              }
            }
          }
          return handler.next(error);
        },
      ),
    );

    _dioV2.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await _storage.getAccessToken();
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshToken = await _storage.getRefreshToken();
            if (refreshToken != null) {
              try {
                final refreshResponse = await _dio.post(
                  'v1/refreshToken',
                  data: {'refreshToken': refreshToken},
                );

                final newAccessToken = refreshResponse.data['accessToken'];
                final newRefreshToken = refreshResponse.data['refreshToken'];

                await _storage.saveAccessToken(newAccessToken);
                await _storage.saveRefreshToken(newRefreshToken);

                final options = error.requestOptions;
                options.headers['Authorization'] = 'Bearer $newAccessToken';
                final retryResponse = await _dioV2.fetch(options);
                return handler.resolve(retryResponse);
              } catch (e) {
                await _storage.clearAll();
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Dio get client => _dio;
  Dio get clientV2 => _dioV2;

  // Location API methods
  Future<LocationResponse> getLocations() async {
    try {
      print('Making API call to get locations...');
      // Create a temporary Dio instance for the web.nbb.com.la domain
      final webDio = Dio();
      webDio.options.baseUrl = 'https://web.nbb.com.la/api/';
      webDio.options.connectTimeout = const Duration(seconds: 30);
      webDio.options.receiveTimeout = const Duration(seconds: 30);
      webDio.options.sendTimeout = const Duration(seconds: 30);

      // Add authorization header if available
      final accessToken = await _storage.getAccessToken();
      if (accessToken != null) {
        webDio.options.headers['Authorization'] = 'Bearer $accessToken';
        print('Using access token for authentication');
      } else {
        print('No access token available');
      }

      print('Calling API endpoint: ${webDio.options.baseUrl}getlocal');
      final response = await webDio.get('getlocal');
      print('API response status: ${response.statusCode}');
      print('API response data: ${response.data}');

      return LocationResponse.fromJson(response.data);
    } catch (e) {
      print('API call failed: $e');
      throw Exception('Failed to fetch locations: $e');
    }
  }
}
