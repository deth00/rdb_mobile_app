import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/features/location/logic/location_provider.dart';
import 'package:moblie_banking/features/location/logic/location_state.dart';
import 'package:moblie_banking/widgets/appbar.dart';

class LocationScreen extends ConsumerStatefulWidget {
  const LocationScreen({super.key});

  @override
  ConsumerState<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends ConsumerState<LocationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(locationProvider.notifier).fetchLocations();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;
    final locationState = ref.watch(locationProvider);

    return Scaffold(
      appBar: GradientAppBar(
        title: 'ສະຖານທີ່ບໍລິການ',
        icon: Icons.arrow_back,
        onIconPressed: () => context.pop(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(fixedSize * 0.01),
          child: _buildContent(locationState, fixedSize),
        ),
      ),
    );
  }

  Widget _buildContent(LocationState state, double fixedSize) {
    switch (state.status) {
      case LocationStatus.initial:
      case LocationStatus.loading:
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.color1),
          ),
        );

      case LocationStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 60),
              SizedBox(height: 16),
              Text(
                'ເກີດຂໍ້ຜິດພາດໃນການໂຫຼດຂໍ້ມູນ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 8),
              Text(
                state.errorMessage ?? 'ບໍ່ສາມາດໂຫຼດຂໍ້ມູນສະຖານທີ່ບໍລິການໄດ້',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(locationProvider.notifier).fetchLocations();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.color1,
                  foregroundColor: Colors.white,
                ),
                child: Text('ລອງໃໝ່'),
              ),
            ],
          ),
        );

      case LocationStatus.success:
        if (state.locations.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_off, color: Colors.grey, size: 60),
                SizedBox(height: 16),
                Text(
                  'ບໍ່ມີຂໍ້ມູນສະຖານທີ່ບໍລິການ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: state.locations.length,
          itemBuilder: (context, index) {
            final location = state.locations[index];
            return _buildLocationCard(location, fixedSize);
          },
        );
    }
  }

  Widget _buildLocationCard(location, double fixedSize) {
    final selectedLocation = ref.watch(locationProvider).selectedLocation;
    final isSelected =
        selectedLocation != null && selectedLocation.id == location.id;
    final hasCoordinates =
        location.latitude != null && location.longitude != null;

    return Container(
      margin: EdgeInsets.only(bottom: fixedSize * 0.01),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.color1.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? AppColors.color1
              : AppColors.color1.withOpacity(0.3),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(fixedSize * 0.015),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: hasCoordinates
                ? AppColors.color1.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(
            hasCoordinates ? Icons.location_on : Icons.location_off,
            color: hasCoordinates ? AppColors.color1 : Colors.grey,
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                location.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.color1 : Colors.black87,
                ),
              ),
            ),
            if (hasCoordinates) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.color1.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'ມີພິກັດ',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.color1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ] else ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'ບໍ່ມີພິກັດ',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              'ລະຫັດ: ${location.code}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            if (hasCoordinates) ...[
              SizedBox(height: 4),
              Text(
                'ພິກັດ: ${location.latitude!.toStringAsFixed(6)}, ${location.longitude!.toStringAsFixed(6)}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.color1,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ] else ...[
              SizedBox(height: 4),
              Text(
                'ບໍ່ມີຂໍ້ມູນພິກັດ',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Icon(Icons.check_circle, color: AppColors.color1, size: 20),
              SizedBox(width: 8),
            ],
            IconButton(
              onPressed: () {
                // Set selected location and navigate to map
                ref
                    .read(locationProvider.notifier)
                    .setSelectedLocation(location);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ເລືອກສະຖານທີ່: ${location.name}'),
                    backgroundColor: AppColors.color1,
                    duration: Duration(seconds: 1),
                  ),
                );
                context.push('/location/map');
              },
              icon: Icon(
                hasCoordinates ? Icons.info_outline : Icons.info_outline,
                color: hasCoordinates ? AppColors.color1 : Colors.grey,
                size: 20,
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppColors.color1, size: 16),
          ],
        ),
        onTap: () {
          // Set selected location and navigate to map screen
          ref.read(locationProvider.notifier).setSelectedLocation(location);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('ເລືອກສະຖານທີ່: ${location.name}'),
              backgroundColor: AppColors.color1,
              duration: Duration(seconds: 1),
            ),
          );
          context.push('/location/map');
        },
      ),
    );
  }
}
