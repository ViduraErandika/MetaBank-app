import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gaspal/modules/rounded_button.dart';
import 'package:gaspal/screens/dashboard_screen.dart';

class VerifyCusScreen extends StatefulWidget {
  const VerifyCusScreen({Key? key}) : super(key: key);

  @override
  State<VerifyCusScreen> createState() => _VerifyCusScreenState();
}

class _VerifyCusScreenState extends State<VerifyCusScreen> {
  bool _haveAcc = false;
  late String NIC;
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                            text: "Do you already have a",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontFamily: 'AudioWide',
                            ),
                          ),
                          TextSpan(
                            text: " Meta-Bank",
                            style: TextStyle(
                              fontSize: 35,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'AudioWide',
                            ),
                          ),
                          TextSpan(
                            text: " account",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontFamily: 'AudioWide',
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  RoundedButton(() {
                    setState(() {
                      _haveAcc = true;
                    });
                  }, Colors.greenAccent, "Yes"),
                  (_haveAcc)
                      ? Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: TextFormField(
                                onChanged: (value) {
                                  NIC = value;
                                },
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    label: Center(
                                        child:
                                            Text('Enter your Nationality ID')),
                                    alignLabelWithHint: true,
                                    labelStyle: TextStyle(
                                      fontFamily: "AudioWide",
                                    )),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            RoundedButton(() {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) {
                              //       return DashboardScreen();
                              //     },
                              //   ),
                              // );
                            }, Colors.amberAccent, "Verify"),
                          ],
                        )
                      : RoundedButton(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return DashboardScreen();
                              },
                            ),
                          );
                        }, Colors.redAccent, "No"),
                ],
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
