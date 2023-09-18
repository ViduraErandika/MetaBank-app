import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gaspal/modules/rounded_button.dart';
import 'package:gaspal/screens/dashboard_screen.dart';
import 'package:gaspal/screens/form_screen.dart';

class StartBankScreen extends StatelessWidget {
  const StartBankScreen({Key? key}) : super(key: key);

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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(
                    child: Text(
                      "Start Banking in Metaverse",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'AudioWide',
                      ),
                    ),
                  ),
                  Image.asset("images/welcome.png"),
                  RoundedButton(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return FormScreen();
                        },
                      ),
                    );
                  }, Colors.greenAccent, "Get Me In"),
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
