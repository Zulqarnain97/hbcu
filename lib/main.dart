import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final WebViewController _controller;
  bool _isLoading = true; // To track loading status

  @override
  void initState() {
    super.initState();
    // Initialize the controller
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://hbcunews.com/'));

    // Add a listener to track loading status
    _controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (String url) {
          setState(() {
            _isLoading = true; // Show loading indicator
          });
        },
        onPageFinished: (String url) {
          setState(() {
            _isLoading = false; // Hide loading indicator
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack( // Use Stack to overlay the loading indicator
          children: [
            // The WebView
            Padding(
              padding:  EdgeInsets.only(top: 40),
              child: WebViewWidget(controller: _controller),
            ),
            // Loading indicator
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(), // Show loading indicator
              ),
          ],
        ),
      ),
    );
  }
}
