class LocationModel {
  final int id;
  final String code;
  final String name;
  final double? latitude;
  final double? longitude;

  LocationModel({
    required this.id,
    required this.code,
    required this.name,
    this.latitude,
    this.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class LocationResponse {
  final List<LocationModel> data;

  LocationResponse({required this.data});

  factory LocationResponse.fromJson(Map<String, dynamic> json) {
    return LocationResponse(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => LocationModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}
