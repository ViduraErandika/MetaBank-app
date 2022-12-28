import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gaspal/modules/constants.dart';
import 'package:flutter_webview_pro/platform_interface.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:gaspal/services/firebase_controller.dart';
import 'package:provider/provider.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  // late final WebViewController webViewController;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  late String avatarUrl;

  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthFunctions>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff63cdd7),
        elevation: 0,
        title: const Text(
          "Meta Bank",
          style: TextStyle(fontFamily: "AudioWide", color: Color(0xFF050a30)),
        ),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: 'https://metaversebank.readyplayer.me?frameApi',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            javascriptChannels: {
              JavascriptChannel(
                  name: 'ReactNativeWebView',
                  onMessageReceived: (message) {
                    String data = message.message;
                    avatarUrl = data.substring(1, (data.length - 1));
                    if (avatarUrl.toString().endsWith("glb")) {
                      provider.getUser();
                      String userId = provider.firebaseUser!.uid;
                      provider.updateAccInfo(userId, 'avatarUrl', avatarUrl);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          duration: Duration(milliseconds: 2000),
                          content: Text('Avatar created',
                              style: TextStyle(
                                color: kDeepBlue,
                                fontSize: 15,
                                fontFamily: 'AudioWide',
                              )),
                        ),
                      );
                    }
                  })
            },
            onProgress: (int progress) {
              if (progress == 100) {
                setState(() {
                  isLoading = false;
                });
              }
            },
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                print('blocking navigation to $request}');
                return NavigationDecision.prevent;
              }
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              print('Page started loading: $url');
            },
            onPageFinished: (String url) {
              print('Page finished loading: $url');
            },
            gestureNavigationEnabled: true,
            geolocationEnabled: false, //support geolocation or not
          ),
          isLoading
              ? Stack(
                  children: [
                    Container(
                      color: kDeepBlue,
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              child: const Text("Loading..",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'AudioWide',
                                  ))),
                          const SizedBox(
                            height: 15,
                          ),
                          CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  ],
                )
              : Stack()
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Powered by MetaXA",
              style: TextStyle(
                  color: kDeepBlue,
                  fontSize: 18,
                  fontFamily: 'AudioWide',
                  letterSpacing: 2),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
