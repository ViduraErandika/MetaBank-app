import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gaspal/modules/rounded_button.dart';
import 'package:gaspal/screens/register_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = "welcome_screen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 14.0),
              child: Icon(FontAwesomeIcons.copyright),
            ),
            Text(
              "MetaXA  (Pvt) Ltd.",
              style: GoogleFonts.josefinSans(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              children: <Widget>[
                Hero(
                  tag: "logo",
                  child: SizedBox(
                    child: Image.asset('images/logo.png'),
                    height: 350,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundedButton(() {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            }, const Color(0xff63cdd7), "Log In"),
            RoundedButton(() {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return RegistrationScreen();
                  },
                ),
              );
            }, const Color(0xFF03989e), 'Register')
          ],
        ),
      ),
    );
  }
}
