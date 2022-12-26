import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gaspal/modules/rounded_button.dart';
import 'package:gaspal/screens/welcome_screen.dart';
import 'package:gaspal/services/firebase_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:gaspal/modules/constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  void signOut() async {
    final provider = Provider.of<AuthFunctions>(context, listen: false);
    await provider.signOut();
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return WelcomeScreen();
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff63cdd7),
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            PopupMenuButton(
                icon: const Icon(
                  Icons.sort,
                  color: Colors.black,
                ),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                elevation: 15,
                itemBuilder: (BuildContext bc) => [
                      const PopupMenuItem(
                          child: Text("Sign Out",
                              style: TextStyle(
                                letterSpacing: 1.5,
                              )),
                          value: 'sign'),
                    ],
                onSelected: (value) {
                  if (value == 'sign') {
                    signOut();
                  }
                }),
          ],
          title: const Text(
            "Meta Bank",
            style: TextStyle(fontFamily: "AudioWide", color: Color(0xFF050a30)),
          ),
        ),
        body: Scaffold(
          body: Stack(
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
              ListView(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      Card(
                        color: kDeepBlue,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50),
                                bottomLeft: Radius.circular(50))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 13.0, horizontal: 13.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const ListTile(
                                title: Text(
                                  'Create New Avatar',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: 'AudioWide',
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 3),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 40),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: kSecBlue,
                                      elevation: 10,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)))),
                                  child: const Text(
                                    'Start process',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'AudioWide',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Image.asset(
                          'images/avatar.png',
                          height: 170,
                          width: 170,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                    color: kThdBlue,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 13.0, horizontal: 13.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ListTile(
                            title: Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                'Complete Your Profile',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'AudioWide',
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 3),
                              ),
                            ),
                            subtitle: Text(
                              '0 / 3 Completed',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'AudioWide',
                              ),
                            ),
                            trailing: Icon(
                              Icons.incomplete_circle_outlined,
                              size: 60,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.greenAccent,
                                  elevation: 10,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)))),
                              child: const Text(
                                'Complete profile',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'AudioWide',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Any problem contact ",
                  style: GoogleFonts.josefinSans(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 14.0),
                  child: Icon(
                    FontAwesomeIcons.handPointer,
                    color: kSecBlue,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}