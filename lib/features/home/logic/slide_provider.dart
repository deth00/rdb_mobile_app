import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:moblie_banking/features/auth/logic/auth_provider.dart';

class Slide {
  final int id;
  final String name;
  final String img;

  Slide({required this.id, required this.name, required this.img});

  factory Slide.fromJson(Map<String, dynamic> json) {
    return Slide(
      id: json['id'] as int,
      name: json['name'] as String,
      img: json['img'] as String,
    );
  }
}

final slideProvider = FutureProvider<List<Slide>>((ref) async {
  // final dio = ref.read(dioClientProvider);

  try {
    print('Fetching slides from API...');
    // final response = await dio.client.get('https://web.nbb.com.la/api/slide');
    final response = await Dio().get('https://web.nbb.com.la/api/slide');

    print('Slide API response status: ${response.statusCode}');
    print('Slide API response data: ${response.data['data']}');

    if (response.statusCode == 200) {
      final data = response.data['data'] as List;
      final slides = data.map((json) => Slide.fromJson(json)).toList();
      return slides;
    } else {
      throw Exception('Failed to load slides: HTTP ${response.statusCode}');
    }
  } on DioError catch (e) {
    print('DioError fetching slides: ${e.message}');
    if (e.response != null) {
      print('Response status: ${e.response!.statusCode}');
      print('Response data: ${e.response!.data}');
    }
    throw Exception('Network error: ${e.message}');
  } catch (e) {
    print('Unexpected error fetching slides: $e');
    throw Exception('Error fetching slides: $e');
  }
});
