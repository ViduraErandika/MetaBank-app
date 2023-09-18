import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gaspal/modules/rounded_button.dart';
import 'package:gaspal/screens/webview_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaY: 0, sigmaX: 0),
              child: Opacity(
                opacity: 0.3,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/bg.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                            text: "Welcome to",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontFamily: 'AudioWide',
                            ),
                          ),
                          TextSpan(
                            text: " Metaverse Banking",
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'AudioWide',
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  RoundedButton(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return WebViewScreen();
                        },
                      ),
                    );
                  }, const Color(0xff63cdd7), "Start Process"),
                  Image.asset("images/onboard.png"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
