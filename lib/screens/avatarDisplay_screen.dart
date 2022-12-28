import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/platform_interface.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:gaspal/modules/constants.dart';

class AvatarDisplay extends StatefulWidget {
  const AvatarDisplay({Key? key, required this.avatarUrl}) : super(key: key);
  final String avatarUrl;
  @override
  State<AvatarDisplay> createState() => _AvatarDisplayState();
}

class _AvatarDisplayState extends State<AvatarDisplay> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  late String fileText;
  bool isLoading = true;
  @override
  void initState() {
    fileText = '''    <!DOCTYPE html>
     <html lang="en">
     <body>
     <style>
           html {
        height: 100%;
      }
      model-viewer {
        height: 100vh;
        width: 100vw;
        background-color: whitesmoke;
      }
      model-viewer::part(default-progress-bar) {
        background-color: #004275;
      }
     </style>
     <script type="module" src="https://unpkg.com/@google/model-viewer/dist/model-viewer.min.js"></script>
     <model-viewer src="${widget.avatarUrl}" camera-controls auto-rotate min-camera-orbit="auto auto 3.938m" min-field-of-view="30deg"> </model-viewer>
    </body>
    </html>
    ''';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            javascriptMode: JavascriptMode.unrestricted,
            zoomEnabled: false,
            initialUrl: '',
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
              webViewController.loadUrl(Uri.dataFromString(
                fileText,
                mimeType: 'text/html',
              ).toString());
            },
            onProgress: (int progress) {
              if (progress == 100) {
                setState(() {
                  isLoading = false;
                });
              }
            },
          ),
          isLoading
              ? Stack(
                  children: [
                    Container(
                      color: Color(0xFFF5F5F5),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              child: const Text("Loading..",
                                  style: TextStyle(
                                    color: kDeepBlue,
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
