import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../config/app_colors.dart';
import '../../providers/auth_provider.dart';

class RfidWebviewScreen extends ConsumerStatefulWidget {
  const RfidWebviewScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RfidWebviewScreen> createState() => _RfidWebviewScreenState();
}

class _RfidWebviewScreenState extends ConsumerState<RfidWebviewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isAutoLoggingIn = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) async {
            if (url.contains('/login') && !_isAutoLoggingIn) {
              _isAutoLoggingIn = true;
              final authState = ref.read(authProvider);
              final email = authState.userData?['email'] ?? '';
              final password = authState.userData?['password'] ?? '';

              await _controller.runJavaScript('''
                fetch('/api/auth/login', {
                  method: 'POST',
                  headers: {'Content-Type': 'application/json'},
                  body: JSON.stringify({email: '$email', password: '$password'})
                }).then(res => {
                  if(res.ok) {
                    window.location.href = '/dashboard/smart-receiving';
                  }
                });
              ''');
            } else {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView Error: ${error.description}');
          },
        ),
      )
      // Note: Menggunakan URL production Vercel
      ..loadRequest(Uri.parse('https://kongsi-logi.vercel.app/dashboard/smart-receiving'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Receiving (RFID)', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: AppColors.brandPrimary),
            ),
        ],
      ),
    );
  }
}
