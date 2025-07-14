import 'package:dio/dio.dart';
import 'package:moblie_banking/core/utils/secure_storage.dart';

class DioClient {
  final Dio _dio = Dio();
  final SecureStorage _storage = SecureStorage();

  DioClient() {
    _dio.options.baseUrl = 'https://fund.nbb.com.la/api/';
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
  }

  Dio get client => _dio;
}
