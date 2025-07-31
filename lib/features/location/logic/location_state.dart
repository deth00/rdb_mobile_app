import 'package:moblie_banking/core/models/location_model.dart';

enum LocationStatus { initial, loading, success, error }

class LocationState {
  final LocationStatus status;
  final List<LocationModel> locations;
  final String? errorMessage;
  final LocationModel? selectedLocation;

  LocationState({
    this.status = LocationStatus.initial,
    this.locations = const [],
    this.errorMessage,
    this.selectedLocation,
  });

  LocationState copyWith({
    LocationStatus? status,
    List<LocationModel>? locations,
    String? errorMessage,
    LocationModel? selectedLocation,
  }) {
    return LocationState(
      status: status ?? this.status,
      locations: locations ?? this.locations,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedLocation: selectedLocation ?? this.selectedLocation,
    );
  }
}
