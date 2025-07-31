import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/features/location/logic/location_provider.dart';
import 'package:moblie_banking/features/location/logic/location_state.dart';
import 'package:moblie_banking/core/models/location_model.dart';
import 'package:moblie_banking/widgets/appbar.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  Position? _currentPosition;
  bool _isLoading = true;
  bool _locationPermissionDenied = false;
  String? _locationError;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  bool _mapLoadError = false;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure locations are loaded when the screen becomes visible
    final locationState = ref.read(locationProvider);
    if (locationState.status == LocationStatus.initial) {
      _loadLocations();
    }
  }

  @override
  void dispose() {
    // Clear selected location when leaving map screen
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    try {
      setState(() {
        _isLoading = true;
        _locationError = null;
        _locationPermissionDenied = false;
        _mapLoadError = false;
      });

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationError = 'ບໍ່ສາມາດເປີດບໍລິການສະຖານທີ່ໄດ້';
          _isLoading = false;
        });
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationPermissionDenied = true;
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError = 'ການອະນຸຍາດສະຖານທີ່ຖືກປະຕິເສດຖາວອນ';
          _isLoading = false;
        });
        return;
      }

      // Get current position
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Load locations
      await _loadLocations();
    } catch (e) {
      setState(() {
        _locationError = 'ເກີດຂໍ້ຜິດພາດໃນການດຶງຂໍ້ມູນສະຖານທີ່: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadLocations() async {
    try {
      await ref.read(locationProvider.notifier).fetchLocations();
    } catch (e) {
      // Handle error loading locations
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _createMarkers(LocationState state) {
    _markers.clear();

    // Add current location marker
    if (_currentPosition != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          infoWindow: const InfoWindow(
            title: 'ສະຖານທີ່ປັດຈຸບັນ',
            snippet: 'ທ່ານຢູ່ທີ່ນີ້',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    // Add location markers
    for (final location in state.locations) {
      if (location.latitude != null && location.longitude != null) {
        _markers.add(
          Marker(
            markerId: MarkerId('location_${location.id}'),
            position: LatLng(location.latitude!, location.longitude!),
            infoWindow: InfoWindow(
              title: location.name,
              snippet: 'ລະຫັດ: ${location.code}',
              onTap: () {
                ref
                    .read(locationProvider.notifier)
                    .setSelectedLocation(location);
                _showLocationDetails(location);
              },
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
            onTap: () {
              ref.read(locationProvider.notifier).setSelectedLocation(location);
              _showLocationDetails(location);
            },
          ),
        );
      }
    }
  }

  void _centerOnSelectedLocation(LocationModel location) {
    if (_mapController != null &&
        location.latitude != null &&
        location.longitude != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(location.latitude!, location.longitude!),
          15.0,
        ),
      );
    }
  }

  CameraPosition _getInitialCameraPosition() {
    if (_currentPosition != null) {
      return CameraPosition(
        target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        zoom: 10.0,
      );
    }

    // Default to Vientiane, Laos if no current position
    return const CameraPosition(
      target: LatLng(20.695834, 101.989132), // Vientiane coordinates
      zoom: 6.0,
    );
  }

  void _showLocationDetails(LocationModel location) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildLocationDetailsSheet(location),
    );
  }

  Widget _buildLocationDetailsSheet(LocationModel location) {
    final hasCoordinates =
        location.latitude != null && location.longitude != null;

    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.color1.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: AppColors.color1,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              location.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'ລະຫັດ: ${location.code}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (location.latitude != null &&
                      location.longitude != null) ...[
                    _buildDetailRow(
                      Icons.my_location,
                      'ພິກັດ',
                      '${location.latitude?.toStringAsFixed(6) ?? 'N/A'}, ${location.longitude?.toStringAsFixed(6) ?? 'N/A'}',
                    ),
                    const SizedBox(height: 12),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning, color: Colors.orange, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'ສະຖານທີ່ນີ້ບໍ່ມີຂໍ້ມູນພິກັດ',
                              style: TextStyle(
                                color: Colors.orange[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (_currentPosition != null &&
                      location.latitude != null &&
                      location.longitude != null) ...[
                    _buildDetailRow(
                      Icons.straighten,
                      'ໄລຍະທາງ',
                      '${_calculateDistance(location).toStringAsFixed(2)} km',
                    ),
                    const SizedBox(height: 12),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: hasCoordinates
                              ? () => _getDirections(location)
                              : null,
                          icon: const Icon(Icons.directions),
                          label: const Text('ທາງໄປ'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: hasCoordinates
                                ? AppColors.color1
                                : Colors.grey,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _callLocation(location),
                          icon: const Icon(Icons.phone),
                          label: const Text('ໂທຫາ'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.color1, size: 20),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }

  double _calculateDistance(LocationModel location) {
    if (_currentPosition == null ||
        location.latitude == null ||
        location.longitude == null) {
      return 0.0;
    }

    return Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          location.latitude!,
          location.longitude!,
        ) /
        1000; // Convert to kilometers
  }

  void _getDirections(LocationModel location) {
    if (location.latitude != null && location.longitude != null) {
      // Open external maps app with directions
      // This would typically use url_launcher to open external maps app
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ກຳລັງເປີດແຜນທີ່ສຳລັບທາງໄປ ${location.name}'),
          backgroundColor: AppColors.color1,
        ),
      );
    }
  }

  void _callLocation(LocationModel location) {
    // This would typically use url_launcher to make a phone call
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ກຳລັງໂທຫາສະຖານທີ່ ${location.name}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildCurrentLocationInfo() {
    if (_currentPosition == null) return SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.my_location, color: AppColors.color1, size: 20),
              const SizedBox(width: 8),
              Text(
                'ສະຖານທີ່ປັດຈຸບັນ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.color1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'ພິກັດ: ${_currentPosition!.latitude.toStringAsFixed(6)}, ${_currentPosition!.longitude.toStringAsFixed(6)}',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          Text(
            'ຄວາມແມ່ຍາ: ${_currentPosition!.accuracy?.toStringAsFixed(1) ?? 'N/A'} m',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, color: Colors.red, size: 80),
            const SizedBox(height: 20),
            Text(
              'ບໍ່ສາມາດດຶງຂໍ້ມູນສະຖານທີ່ໄດ້',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _locationError ?? 'ເກີດຂໍ້ຜິດພາດໃນການດຶງຂໍ້ມູນສະຖານທີ່',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _initializeLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.color1,
                foregroundColor: Colors.white,
              ),
              child: const Text('ລອງໃໝ່'),
            ),
            if (_locationPermissionDenied) ...[
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Geolocator.openAppSettings(),
                child: Text(
                  'ເປີດການຕັ້ງຄ່າແອັບ',
                  style: TextStyle(color: AppColors.color1),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationProvider);

    return Scaffold(
      appBar: GradientAppBar(
        title: 'ສະຖານທີ່ບໍລິການ',
        icon: Icons.arrow_back,
        onIconPressed: () => context.pop(),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.color1),
              ),
            )
          : _locationError != null
          ? _buildErrorWidget()
          : _buildFullScreenMap(locationState),
      floatingActionButton: _currentPosition != null
          ? FloatingActionButton(
              onPressed: () {
                if (_mapController != null) {
                  _mapController!.animateCamera(
                    CameraUpdate.newLatLngZoom(
                      LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                      15.0,
                    ),
                  );
                }
              },
              backgroundColor: AppColors.color1,
              child: const Icon(Icons.my_location, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildFullScreenMap(LocationState state) {
    // Create markers when building the map
    _createMarkers(state);

    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
      initialCameraPosition: _getInitialCameraPosition(),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: false, // We have our own FAB
      zoomControlsEnabled: true,
      mapToolbarEnabled: false,
      onCameraMove: (CameraPosition position) {
        // Handle camera movement if needed
      },
      onTap: (LatLng position) {
        // Handle map tap if needed
      },
    );
  }

  Widget _buildMapErrorWidget() {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 8),
            Text(
              'ບໍ່ສາມາດໂຫຼດແຜນທີ່ໄດ້',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _mapLoadError = false;
                });
              },
              child: const Text('ລອງໃໝ່'),
            ),
          ],
        ),
      ),
    );
  }
}
