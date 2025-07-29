import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/svg_icon_widget.dart';
import '../core/utils/svg_icons.dart';

class SvgUsageExample extends StatelessWidget {
  const SvgUsageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SVG Icons Usage Examples'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Example 1: Using predefined BankingIcons
            _buildSection(
              '1. Using Predefined BankingIcons',
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BankingIcons.logo(width: 50, height: 50),
                      BankingIcons.faceId(
                        width: 40,
                        height: 40,
                        color: Colors.blue,
                      ),
                      BankingIcons.finger(
                        width: 40,
                        height: 40,
                        color: Colors.green,
                      ),
                      BankingIcons.scan(
                        width: 40,
                        height: 40,
                        color: Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BankingIcons.profile(
                        width: 40,
                        height: 40,
                        color: Colors.purple,
                      ),
                      BankingIcons.notification(
                        width: 40,
                        height: 40,
                        color: Colors.red,
                      ),
                      BankingIcons.transaction(
                        width: 40,
                        height: 40,
                        color: Colors.teal,
                      ),
                      BankingIcons.services(
                        width: 40,
                        height: 40,
                        color: Colors.indigo,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Example 2: Using SvgIconWidget directly
            _buildSection(
              '2. Using SvgIconWidget Directly',
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SvgIconWidget(
                    iconPath: SvgIcons.calendar,
                    width: 40,
                    height: 40,
                    color: Colors.blue,
                  ),
                  SvgIconWidget(
                    iconPath: SvgIcons.location,
                    width: 40,
                    height: 40,
                    color: Colors.red,
                  ),
                  SvgIconWidget(
                    iconPath: SvgIcons.news,
                    width: 40,
                    height: 40,
                    color: Colors.green,
                  ),
                  SvgIconWidget(
                    iconPath: SvgIcons.feedback,
                    width: 40,
                    height: 40,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),

            // Example 3: Using SvgPicture.asset directly
            _buildSection(
              '3. Using SvgPicture.asset Directly',
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SvgPicture.asset(
                    SvgIcons.aon,
                    width: 40,
                    height: 40,
                    colorFilter: const ColorFilter.mode(
                      Colors.blue,
                      BlendMode.srcIn,
                    ),
                  ),
                  SvgPicture.asset(
                    SvgIcons.bunc,
                    width: 40,
                    height: 40,
                    colorFilter: const ColorFilter.mode(
                      Colors.green,
                      BlendMode.srcIn,
                    ),
                  ),
                  SvgPicture.asset(
                    SvgIcons.cop,
                    width: 40,
                    height: 40,
                    colorFilter: const ColorFilter.mode(
                      Colors.red,
                      BlendMode.srcIn,
                    ),
                  ),
                  SvgPicture.asset(
                    SvgIcons.faifar,
                    width: 40,
                    height: 40,
                    colorFilter: const ColorFilter.mode(
                      Colors.purple,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),

            // Example 4: Icons with tap functionality
            _buildSection(
              '4. Icons with Tap Functionality',
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  BankingIcons.faceId(
                    width: 50,
                    height: 50,
                    color: Colors.blue,
                    onTap: () => _showSnackBar(context, 'Face ID tapped!'),
                  ),
                  BankingIcons.finger(
                    width: 50,
                    height: 50,
                    color: Colors.green,
                    onTap: () => _showSnackBar(context, 'Fingerprint tapped!'),
                  ),
                  BankingIcons.scan(
                    width: 50,
                    height: 50,
                    color: Colors.orange,
                    onTap: () => _showSnackBar(context, 'Scan QR tapped!'),
                  ),
                  BankingIcons.qr(
                    width: 50,
                    height: 50,
                    color: Colors.purple,
                    onTap: () => _showSnackBar(context, 'QR Code tapped!'),
                  ),
                ],
              ),
            ),

            // Example 5: Different sizes
            _buildSection(
              '5. Different Icon Sizes',
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BankingIcons.logo(width: 30, height: 30),
                      BankingIcons.logo(width: 50, height: 50),
                      BankingIcons.logo(width: 80, height: 80),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SvgIconWidget(
                        iconPath: SvgIcons.profile,
                        width: 30,
                        height: 30,
                        color: Colors.blue,
                      ),
                      SvgIconWidget(
                        iconPath: SvgIcons.profile,
                        width: 50,
                        height: 50,
                        color: Colors.blue,
                      ),
                      SvgIconWidget(
                        iconPath: SvgIcons.profile,
                        width: 80,
                        height: 80,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Example 6: Banking service icons
            _buildSection(
              '6. Banking Service Icons',
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SvgIconWidget(
                    iconPath: SvgIcons.jutkan,
                    width: 40,
                    height: 40,
                    color: Colors.blue,
                  ),
                  SvgIconWidget(
                    iconPath: SvgIcons.nam,
                    width: 40,
                    height: 40,
                    color: Colors.green,
                  ),
                  SvgIconWidget(
                    iconPath: SvgIcons.pakun,
                    width: 40,
                    height: 40,
                    color: Colors.orange,
                  ),
                  SvgIconWidget(
                    iconPath: SvgIcons.phouk,
                    width: 40,
                    height: 40,
                    color: Colors.purple,
                  ),
                  SvgIconWidget(
                    iconPath: SvgIcons.sinseua,
                    width: 40,
                    height: 40,
                    color: Colors.teal,
                  ),
                  SvgIconWidget(
                    iconPath: SvgIcons.other,
                    width: 40,
                    height: 40,
                    color: Colors.indigo,
                  ),
                ],
              ),
            ),

            // Example 7: Navigation icons
            _buildSection(
              '7. Navigation Icons',
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SvgIconWidget(
                    iconPath: SvgIcons.home,
                    width: 40,
                    height: 40,
                    color: Colors.blue,
                  ),
                  SvgIconWidget(
                    iconPath: SvgIcons.profile,
                    width: 40,
                    height: 40,
                    color: Colors.green,
                  ),
                  SvgIconWidget(
                    iconPath: SvgIcons.transection,
                    width: 40,
                    height: 40,
                    color: Colors.orange,
                  ),
                  SvgIconWidget(
                    iconPath: SvgIcons.services,
                    width: 40,
                    height: 40,
                    color: Colors.purple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: content,
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }
}
