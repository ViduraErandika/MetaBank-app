import 'package:flutter/material.dart';
import 'package:gaspal/screens/welcome_screen.dart';
import 'package:gaspal/services/firebase_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
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
        backgroundColor: Colors.white12,
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
        title: Text(
          "Gas Pal",
          style: GoogleFonts.lato(
              color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: Colors.amber,
      ),
    );
  }
}
