import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gaspal/modules/constants.dart';
import 'package:gaspal/modules/rounded_button.dart';
import 'package:gaspal/screens/dashboard_screen.dart';
import 'package:gaspal/screens/form_screen.dart';
import 'package:gaspal/services/web_client.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class VerifyCusScreen extends StatefulWidget {
  const VerifyCusScreen({Key? key}) : super(key: key);

  @override
  State<VerifyCusScreen> createState() => _VerifyCusScreenState();
}

class _VerifyCusScreenState extends State<VerifyCusScreen> {
  bool _haveAcc = false;
  late String NIC;
  final _nicPass = GlobalKey<FormState>();
  bool _showSpinner = false;

  bool _saveForm() {
    final isValidPass = _nicPass.currentState!.validate();
    if (isValidPass) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final webProvider = Provider.of<WebClient>(context, listen: false);
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
            ModalProgressHUD(
              inAsyncCall: _showSpinner,
              child: Container(
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: Form(
                                  key: _nicPass,
                                  child: TextFormField(
                                    onChanged: (value) {
                                      NIC = value.toString();
                                    },
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Enter NIC first!';
                                      } else if (text.length != 10) {
                                        if (text.length != 12)
                                          return 'NIC cannot be validated! Retry.';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                        label: Center(
                                            child: Text(
                                                'Enter your Nationality ID')),
                                        alignLabelWithHint: true,
                                        labelStyle: TextStyle(
                                          fontFamily: "AudioWide",
                                        )),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              RoundedButton(() async {
                                if (_saveForm()) {
                                  print("vrfy started");
                                  setState(() {
                                    _showSpinner = true;
                                  });
                                  bool verified =
                                      await webProvider.verifyCustomer(NIC);
                                  if (verified) {
                                    _showSpinner = false;
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return DashboardScreen();
                                        },
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.green,
                                        duration: Duration(milliseconds: 2000),
                                        content: Text('Successfully Verified',
                                            style: TextStyle(
                                              color: kDeepBlue,
                                              fontSize: 15,
                                              fontFamily: 'AudioWide',
                                            )),
                                      ),
                                    );
                                  } else {
                                    setState(() {
                                      _showSpinner = false;
                                    });
                                    Alert(
                                      style: const AlertStyle(
                                          backgroundColor: Colors.white),
                                      context: context,
                                      type: AlertType.error,
                                      title: "NO USER FOUND!",
                                      desc: "Create Customer Profile First",
                                      buttons: [
                                        DialogButton(
                                          child: const Text(
                                            "OK",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return VerifyCusScreen();
                                                },
                                              ),
                                            );
                                          },
                                          color: Colors.redAccent,
                                          width: 120,
                                        )
                                      ],
                                    ).show();
                                  }
                                }
                              }, Colors.amberAccent, "Verify"),
                            ],
                          )
                        : RoundedButton(() {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return FormScreen();
                                },
                              ),
                            );
                          }, Colors.redAccent, "No"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
