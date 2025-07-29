import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/utils/svg_icons.dart';

class SvgIconWidget extends StatelessWidget {
  final String iconPath;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;
  final VoidCallback? onTap;

  const SvgIconWidget({
    super.key,
    required this.iconPath,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget svgIcon = SvgPicture.asset(
      iconPath,
      width: width,
      height: height,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      fit: fit,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: svgIcon);
    }

    return svgIcon;
  }
}

// Predefined icon widgets for common use cases
class BankingIcons {
  static Widget logo({double? width, double? height, Color? color}) {
    return SvgIconWidget(
      iconPath: SvgIcons.logo,
      width: width,
      height: height,
      color: color,
    );
  }

  static Widget faceId({
    double? width,
    double? height,
    Color? color,
    VoidCallback? onTap,
  }) {
    return SvgIconWidget(
      iconPath: SvgIcons.faceId,
      width: width,
      height: height,
      color: color,
      onTap: onTap,
    );
  }

  static Widget finger({
    double? width,
    double? height,
    Color? color,
    VoidCallback? onTap,
  }) {
    return SvgIconWidget(
      iconPath: SvgIcons.finger,
      width: width,
      height: height,
      color: color,
      onTap: onTap,
    );
  }

  static Widget scan({
    double? width,
    double? height,
    Color? color,
    VoidCallback? onTap,
  }) {
    return SvgIconWidget(
      iconPath: SvgIcons.scan,
      width: width,
      height: height,
      color: color,
      onTap: onTap,
    );
  }

  static Widget qr({
    double? width,
    double? height,
    Color? color,
    VoidCallback? onTap,
  }) {
    return SvgIconWidget(
      iconPath: 'assets/images/qr.svg',
      width: width,
      height: height,
      color: color,
      onTap: onTap,
    );
  }

  static Widget profile({
    double? width,
    double? height,
    Color? color,
    VoidCallback? onTap,
  }) {
    return SvgIconWidget(
      iconPath: SvgIcons.profile,
      width: width,
      height: height,
      color: color,
      onTap: onTap,
    );
  }

  static Widget notification({
    double? width,
    double? height,
    Color? color,
    VoidCallback? onTap,
  }) {
    return SvgIconWidget(
      iconPath: SvgIcons.noti,
      width: width,
      height: height,
      color: color,
      onTap: onTap,
    );
  }

  static Widget transaction({
    double? width,
    double? height,
    Color? color,
    VoidCallback? onTap,
  }) {
    return SvgIconWidget(
      iconPath: SvgIcons.transection,
      width: width,
      height: height,
      color: color,
      onTap: onTap,
    );
  }

  static Widget services({
    double? width,
    double? height,
    Color? color,
    VoidCallback? onTap,
  }) {
    return SvgIconWidget(
      iconPath: SvgIcons.services,
      width: width,
      height: height,
      color: color,
      onTap: onTap,
    );
  }
}
