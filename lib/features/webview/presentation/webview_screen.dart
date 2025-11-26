import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moblie_banking/widgets/appbar.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const WebViewScreen({Key? key, required this.url, this.title = 'ເວັບໄຊທ໌'})
    : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late InAppWebViewController webViewController;
  double progress = 0;
  bool canGoBack = false;
  bool canGoForward = false;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(widget.url)),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(javaScriptEnabled: true),
            android: AndroidInAppWebViewOptions(useHybridComposition: true),
          ),
          onReceivedServerTrustAuthRequest: (controller, challenge) async {
            // บังคับให้ bypass SSL error
            return ServerTrustAuthResponse(
              action: ServerTrustAuthResponseAction.PROCEED,
            );
          },
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          // ... callback อื่นๆ
        ),
      ),

      // appBar: GradientAppBar(
      //   title: widget.title,
      //   actions: [
      //     if (isLoading)
      //       Padding(
      //         padding: EdgeInsets.only(right: 16.w),
      //         child: SizedBox(
      //           width: 20.w,
      //           height: 20.w,
      //           child: CircularProgressIndicator(
      //             strokeWidth: 2,
      //             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      //           ),
      //         ),
      //       ),
      //   ],
      // ),
      // body: Column(
      //   children: [
      //     // Toolbar
      //     // Container(
      //     //   height: 48.h,
      //     //   color: Colors.grey[200],
      //     //   child: Row(
      //     //     children: [
      //     //       IconButton(
      //     //         onPressed: canGoBack
      //     //             ? () => webViewController.goBack()
      //     //             : null,
      //     //         icon: Icon(
      //     //           Icons.arrow_back,
      //     //           color: canGoBack ? AppColors.color1 : Colors.grey,
      //     //         ),
      //     //       ),
      //     //       IconButton(
      //     //         onPressed: canGoForward
      //     //             ? () => webViewController.goForward()
      //     //             : null,
      //     //         icon: Icon(
      //     //           Icons.arrow_forward,
      //     //           color: canGoForward ? AppColors.color1 : Colors.grey,
      //     //         ),
      //     //       ),
      //     //       IconButton(
      //     //         onPressed: () => webViewController.reload(),
      //     //         icon: Icon(Icons.refresh, color: AppColors.color1),
      //     //       ),
      //     //       const Spacer(),
      //     //       IconButton(
      //     //         onPressed: () => webViewController.loadUrl(
      //     //           urlRequest: URLRequest(url: WebUri(widget.url)),
      //     //         ),
      //     //         icon: Icon(Icons.home, color: AppColors.color1),
      //     //       ),
      //     //     ],
      //     //   ),
      //     // ),

      //     // WebView
      //     // Expanded(
      //     //   child: Stack(
      //     //     children: [
      //     //       InAppWebView(
      //     //         initialUrlRequest: URLRequest(url: WebUri(widget.url)),
      //     //         initialOptions: InAppWebViewGroupOptions(
      //     //           crossPlatform: InAppWebViewOptions(
      //     //             javaScriptEnabled: true,
      //     //             useShouldOverrideUrlLoading: true,
      //     //             mediaPlaybackRequiresUserGesture: false,
      //     //           ),
      //     //           android: AndroidInAppWebViewOptions(
      //     //             useHybridComposition: true,
      //     //           ),
      //     //           ios: IOSInAppWebViewOptions(
      //     //             allowsInlineMediaPlayback: true,
      //     //           ),
      //     //         ),
      //     //         onWebViewCreated: (controller) {
      //     //           webViewController = controller;
      //     //         },
      //     //         onLoadStart: (controller, url) {
      //     //           setState(() {
      //     //             isLoading = true;
      //     //           });
      //     //         },
      //     //         onLoadStop: (controller, url) async {
      //     //           setState(() {
      //     //             isLoading = false;
      //     //           });
      //     //           // อัพเดตสถานะปุ่มย้อนกลับไปข้างหน้า
      //     //           bool back = await controller.canGoBack();
      //     //           bool forward = await controller.canGoForward();
      //     //           setState(() {
      //     //             canGoBack = back;
      //     //             canGoForward = forward;
      //     //           });
      //     //         },
      //     //         onProgressChanged: (controller, progressValue) {
      //     //           setState(() {
      //     //             progress = progressValue / 100;
      //     //           });
      //     //         },
      //     //         onReceivedServerTrustAuthRequest:
      //     //             (controller, challenge) async {
      //     //               // ยอมรับ SSL ผิดพลาดด้วย (ถ้าต้องการ bypass SSL error)
      //     //               return ServerTrustAuthResponse(
      //     //                 action: ServerTrustAuthResponseAction.PROCEED,
      //     //               );
      //     //             },
      //     //         onLoadError: (controller, url, code, message) {
      //     //           setState(() {
      //     //             isLoading = false;
      //     //           });
      //     //           ScaffoldMessenger.of(context).showSnackBar(
      //     //             SnackBar(
      //     //               content: Text('โหลดหน้าเว็บไม่สำเร็จ: $message'),
      //     //             ),
      //     //           );
      //     //         },
      //     //       ),
      //     //       if (isLoading)
      //     //         Center(
      //     //           child: Column(
      //     //             mainAxisAlignment: MainAxisAlignment.center,
      //     //             children: [
      //     //               CircularProgressIndicator(
      //     //                 valueColor: AlwaysStoppedAnimation<Color>(
      //     //                   AppColors.color1,
      //     //                 ),
      //     //               ),
      //     //               const SizedBox(height: 16),
      //     //               Text(
      //     //                 'ກຳລັງໂຫຼດ...',
      //     //                 style: TextStyle(
      //     //                   color: AppColors.color1,
      //     //                   fontSize: 16,
      //     //                 ),
      //     //               ),
      //     //             ],
      //     //           ),
      //     //         ),
      //     //     ],
      //     //   ),
      //     // ),
      //   ],
      // ),
    );
  }
}
