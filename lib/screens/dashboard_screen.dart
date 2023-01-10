import 'dart:ui';
import 'package:block_ui/block_ui.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gaspal/modules/rounded_button.dart';
import 'package:gaspal/screens/avatarDisplay_screen.dart';
import 'package:gaspal/screens/form_screen.dart';
import 'package:gaspal/screens/webview_screen.dart';
import 'package:gaspal/screens/welcome_screen.dart';
import 'package:gaspal/services/firebase_controller.dart';
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
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AuthFunctions>(context, listen: false);
      provider.completeProfileCheck();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthFunctions>(context, listen: false);
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
                          value: 'sign',
                          child: Text("Sign Out",
                              style: TextStyle(
                                letterSpacing: 1.5,
                              ))),
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
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const WebViewScreen(),
                                        ));
                                  },
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
                          ListTile(
                            title: const Padding(
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
                              context.watch<AuthFunctions>().accInfoDoneOne
                                  ? '2 / 2 Completed'
                                  : '0 / 2 Completed',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'AudioWide',
                              ),
                            ),
                            trailing: const Icon(
                              Icons.incomplete_circle_outlined,
                              size: 60,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return FormScreen();
                                  },
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.greenAccent,
                                  elevation: 10,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)))),
                              child: const Text(
                                'Edit profile',
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
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                    color: kSecRed,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            // topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                            bottomLeft: Radius.circular(50))),
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
                                'Submit Additional Docs',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'AudioWide',
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 3),
                              ),
                            ),
                            trailing: Icon(
                              Icons.verified_user,
                              size: 60,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: kFstred,
                                  elevation: 10,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)))),
                              child: const Text(
                                'Submit Documents',
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
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 5),
            child: ElevatedButton(
              onPressed: () async {
                BlockUi.show(
                  context,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
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
                );
                provider.getUser();
                String userId = provider.firebaseUser!.uid;
                String? avatarUrl = await provider.getAvatarUrl(userId);
                BlockUi.hide(context);
                if (avatarUrl != '') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AvatarDisplay(avatarUrl: avatarUrl),
                      ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.redAccent,
                      duration: Duration(milliseconds: 1000),
                      content: Text('No avatar found',
                          style: TextStyle(
                            color: kDeepBlue,
                            fontSize: 15,
                            fontFamily: 'AudioWide',
                          )),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: kSecBlue,
                  elevation: 10,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              child: const Text(
                'Show my avatar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'AudioWide',
                ),
              ),
            ),
          ),
        ));
  }
}
