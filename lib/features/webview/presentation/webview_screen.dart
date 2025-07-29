import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/widgets/appbar.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const WebViewScreen({super.key, required this.url, this.title = 'ເວັບໄຊທ໌'});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _canGoBack = false;
  bool _canGoForward = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar based on WebView loading progress
            if (progress == 100) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            _updateNavigationState();
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
            });
            _showErrorDialog(error.description);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _updateNavigationState() async {
    final canGoBack = await _controller.canGoBack();
    final canGoForward = await _controller.canGoForward();

    if (mounted) {
      setState(() {
        _canGoBack = canGoBack;
        _canGoForward = canGoForward;
      });
    }
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ຂໍ້ຜິດພາດ'),
          content: Text('ບໍ່ສາມາດໂຫຼດໜ້າໄດ້: $error'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _controller.reload();
              },
              child: const Text('ລອງໃໝ່'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ຍົກເລີກ'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GradientAppBar(
        title: widget.title,
        actions: [
          if (_isLoading)
            Padding(
              padding: EdgeInsets.only(right: fixedSize * 0.01),
              child: SizedBox(
                width: 20.w,
                height: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Navigation toolbar
          // Container(
          //   height: fixedSize * 0.04,
          //   color: Colors.grey[100],
          //   child: Row(
          //     children: [
          //       IconButton(
          //         onPressed: _canGoBack ? () => _controller.goBack() : null,
          //         icon: Icon(
          //           Icons.arrow_back,
          //           color: _canGoBack ? AppColors.color1 : Colors.grey,
          //         ),
          //       ),
          //       IconButton(
          //         onPressed: _canGoForward
          //             ? () => _controller.goForward()
          //             : null,
          //         icon: Icon(
          //           Icons.arrow_forward,
          //           color: _canGoForward ? AppColors.color1 : Colors.grey,
          //         ),
          //       ),
          //       IconButton(
          //         onPressed: () => _controller.reload(),
          //         icon: Icon(Icons.refresh, color: AppColors.color1),
          //       ),
          //       const Spacer(),
          //       IconButton(
          //         onPressed: () =>
          //             _controller.loadRequest(Uri.parse(widget.url)),
          //         icon: Icon(Icons.home, color: AppColors.color1),
          //       ),
          //     ],
          //   ),
          // ),
          // WebView content
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_isLoading)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.color1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'ກຳລັງໂຫຼດ...',
                          style: TextStyle(
                            color: AppColors.color1,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
