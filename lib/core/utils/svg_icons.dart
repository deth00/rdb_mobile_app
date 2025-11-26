import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcons {
  // Authentication icons
  static const String faceId = 'assets/icons/faceID.svg';
  static const String finger = 'assets/icons/finger.svg';
  static const String key = 'assets/icons/key.svg';
  static const String show = 'assets/icons/show.svg';
  static const String sms = 'assets/icons/sms.svg';

  // Navigation icons
  static const String home = 'assets/icons/home.svg';
  static const String services = 'assets/icons/services.svg';
  static const String profile = 'assets/icons/profile.svg';
  static const String transection = 'assets/icons/transection.svg';

  // Banking icons
  static const String aon = 'assets/icons/aon.svg';
  static const String bunc = 'assets/icons/bunc.svg';
  static const String cop = 'assets/icons/cop.svg';
  static const String faifar = 'assets/icons/faifar.svg';
  static const String jutkan = 'assets/icons/jutkan.svg';
  static const String nam = 'assets/icons/nam.svg';
  static const String other = 'assets/icons/other.svg';
  static const String pakun = 'assets/icons/pakun.svg';
  static const String phouk = 'assets/icons/phouk.svg';
  static const String sinseua = 'assets/icons/sinseua.svg';

  // Feature icons
  static const String calendar = 'assets/icons/calendar.svg';
  static const String contact = 'assets/icons/contect.svg';
  static const String feedback = 'assets/icons/feedback.svg';
  static const String fees = 'assets/icons/fees.svg';
  static const String iconWeb = 'assets/icons/icon_web.svg';
  static const String inp = 'assets/icons/inp.svg';
  static const String kuad = 'assets/icons/kuad.svg';
  static const String location = 'assets/icons/location.svg';
  static const String news = 'assets/icons/news.svg';
  static const String noti = 'assets/icons/noti.svg';
  static const String photo = 'assets/icons/photo.svg';
  static const String rate = 'assets/icons/rate.svg';
  static const String scan = 'assets/icons/scan.svg';
  static const String tho = 'assets/icons/tho.svg';
  static const String iconW = 'assets/icons/icon_web.svg';
  static const String fb = 'assets/icons/fb.svg';
  // Logo and branding
  static const String logo = 'assets/icons/logo.svg';
  static const String logoApp = 'assets/icons/logo_app.svg';
  static const String logoF = 'assets/icons/logoF.svg';
  static const String loginBg = 'assets/icons/loginbg.svg';

  // Utility method to get SVG widget
  static SvgPicture getSvgIcon(
    String path, {
    double? width,
    double? height,
    Color? color,
    BoxFit fit = BoxFit.contain,
  }) {
    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
      fit: fit,
    );
  }
}
