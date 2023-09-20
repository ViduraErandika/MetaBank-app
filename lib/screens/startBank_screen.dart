import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gaspal/modules/rounded_button.dart';
import 'package:gaspal/screens/dashboard_screen.dart';
import 'package:gaspal/screens/verify_customer_screen.dart';

class StartBankScreen extends StatelessWidget {
  const StartBankScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Start",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontFamily: 'AudioWide',
                          ),
                        ),
                        TextSpan(
                          text: " Banking",
                          style: TextStyle(
                            fontSize: 35,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'AudioWide',
                          ),
                        ),
                        TextSpan(
                          text: " in",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontFamily: 'AudioWide',
                          ),
                        ),
                        TextSpan(
                          text: " Metaverse",
                          style: TextStyle(
                            fontSize: 35,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'AudioWide',
                          ),
                        ),
                      ]),
                    ),
                  ),
                  Image.asset(
                    "images/welcome.png",
                    height: screenHeight / 2.5,
                    width: screenHeight / 2.5,
                  ),
                  RoundedButton(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return VerifyCusScreen();
                        },
                      ),
                    );
                  }, Colors.greenAccent, "Take Me In"),
                  RoundedButton(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return DashboardScreen();
                        },
                      ),
                    );
                  }, Colors.redAccent, "Do It Later"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
