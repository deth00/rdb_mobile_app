import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/core/services/api_service.dart';
import 'package:moblie_banking/core/models/location_model.dart';
import 'package:moblie_banking/features/location/logic/location_state.dart';

class LocationNotifier extends StateNotifier<LocationState> {
  final DioClient _apiService;

  LocationNotifier(this._apiService) : super(LocationState());

  Future<void> fetchLocations() async {
    try {
      print('Fetching locations...');
      state = state.copyWith(status: LocationStatus.loading);

      final response = await _apiService.getLocations();
      print(
        'API response received. Number of locations: ${response.data.length}',
      );

      // Check if we got any locations from the API
      // if (response.data.isEmpty) {
      //   print('No locations received from API, using sample data');
      //   // Use sample data for testing
      //   final sampleLocations = [
      //     LocationModel(
      //       id: 1,
      //       code: 'VTE001',
      //       name: 'ສະຫະພັນການເງິນແຫ່ງສປປລາວ - ສູນກາງ',
      //       latitude: 17.9757,
      //       longitude: 102.6331,
      //     ),
      //     LocationModel(
      //       id: 2,
      //       code: 'VTE002',
      //       name: 'ສະຫະພັນການເງິນແຫ່ງສປປລາວ - ສະຫວັນນະເຂດ',
      //       latitude: 16.5560,
      //       longitude: 104.7500,
      //     ),
      //     LocationModel(
      //       id: 3,
      //       code: 'VTE003',
      //       name: 'ສະຫະພັນການເງິນແຫ່ງສປປລາວ - ຫຼວງພະບາງ',
      //       latitude: 19.8834,
      //       longitude: 102.1347,
      //     ),
      //   ];

      //   state = state.copyWith(
      //     status: LocationStatus.success,
      //     locations: sampleLocations,
      //   );
      // } else {
      // Add default coordinates for locations with null coordinates
      final locationsWithDefaults = response.data.map((location) {
        if (location.latitude == null || location.longitude == null) {
          // Provide default coordinates based on location name
          double? defaultLat, defaultLng;

          // if (location.name.contains('ຊຽງຂວາງ')) {
          //   defaultLat = 19.3333;
          //   defaultLng = 103.3667;
          // } else if (location.name.contains('ຫຼວງພະບາງ')) {
          //   defaultLat = 19.8834;
          //   defaultLng = 102.1347;
          // } else if (location.name.contains('ຈໍາປາສັກ')) {
          //   defaultLat = 14.8167;
          //   defaultLng = 106.8167;
          // } else if (location.name.contains('ຫົວພັນ')) {
          //   defaultLat = 20.4167;
          //   defaultLng = 103.6667;
          // } else {
          //   // Default to Vientiane if no specific location found
          //   defaultLat = 17.9757;
          //   defaultLng = 102.6331;
          // }

          return LocationModel(
            id: location.id,
            code: location.code,
            name: location.name,
            latitude: defaultLat,
            longitude: defaultLng,
          );
        }
        return location;
      }).toList();

      state = state.copyWith(
        status: LocationStatus.success,
        locations: locationsWithDefaults,
      );
      // }
      print('Location state updated successfully');
    } catch (e) {
      print('Error fetching locations: $e');
      String errorMessage = 'ເກີດຂໍ້ຜິດພາດໃນການໂຫຼດຂໍ້ມູນ';

      if (e.toString().contains('404')) {
        errorMessage = 'ບໍ່ພົບ API endpoint ສຳລັບສະຖານທີ່ບໍລິການ';
      } else if (e.toString().contains('401')) {
        errorMessage = 'ການອະນຸຍາດບໍ່ຖືກຕ້ອງ';
      } else if (e.toString().contains('timeout')) {
        errorMessage = 'ເຊື່ອມຕໍ່ຊ້າເກີນໄປ';
      } else if (e.toString().contains('network')) {
        errorMessage = 'ບໍ່ສາມາດເຊື່ອມຕໍ່ເຄືອຂ່າຍໄດ້';
      }

      state = state.copyWith(
        status: LocationStatus.error,
        errorMessage: errorMessage,
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void setSelectedLocation(LocationModel location) {
    state = state.copyWith(selectedLocation: location);
  }

  void clearSelectedLocation() {
    state = state.copyWith(selectedLocation: null);
  }
}
