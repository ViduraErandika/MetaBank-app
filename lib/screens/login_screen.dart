import 'package:gaspal/modules/constants.dart';
import 'package:gaspal/modules/rounded_button.dart';
import 'package:gaspal/services/firebase_controller.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showSpinner = false;
  late String email;
  late String password;
  final _formPass = GlobalKey<FormState>();
  final _formEmail = GlobalKey<FormState>();

  bool _saveForm() {
    final isValidPass = _formPass.currentState!.validate();
    final isValidMail = _formEmail.currentState!.validate();
    if (isValidPass && isValidMail) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthFunctions>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: "logo",
                  child: Container(
                    height: 260.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              Form(
                key: _formEmail,
                child: TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Email cannot be empty';
                    } else if (!(text.contains('@')) && text.isNotEmpty) {
                      return "Enter a valid email address!";
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      prefixIcon:
                          const Icon(Icons.email, color: Color(0xff63cdd7)),
                      hintText: 'Enter your email'),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Form(
                key: _formPass,
                child: TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Password cannot be empty';
                    } else if (text.length < 6) {
                      return 'Password must exceed 6 characters';
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      prefixIcon:
                          const Icon(Icons.lock_open, color: Color(0xff63cdd7)),
                      hintText: 'Enter your password'),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(() async {
                if (_saveForm()) {
                  setState(() {
                    _showSpinner = true;
                  });
                  bool user = await provider.emailLogIn(email, password);
                  if (user) {
                    setState(() {
                      _showSpinner = false;
                    });
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DashboardScreen(),
                        ));
                  } else {
                    setState(() {
                      _showSpinner = false;
                    });
                    Alert(
                      style: const AlertStyle(backgroundColor: Colors.white),
                      context: context,
                      type: AlertType.error,
                      title: "USER NOT FOUND",
                      desc: "Register with GasPal First!",
                      buttons: [
                        DialogButton(
                          child: const Text(
                            "OK",
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          color: Colors.redAccent,
                          width: 120,
                        )
                      ],
                    ).show();
                  }
                }
              }, const Color(0xff63cdd7), 'Log In'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () async {
                        setState(() {
                          _showSpinner = true;
                        });
                        await provider.googleLogIn();
                        await provider.getUser();
                        String userId = provider.firebaseUser!.uid;
                        bool check = await provider.checkDoc(userId);
                        if (!check) {
                          provider.createData(userId, "verified", "true");
                        }

                        setState(() {
                          _showSpinner = false;
                        });
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DashboardScreen(),
                          ),
                        );
                      },
                      icon: const Icon(
                        FontAwesomeIcons.google,
                        color: Color(0xff63cdd7),
                      ),
                      iconSize: 48,
                    ),
                  ),
                ],
              ),
              // RoundedButton(() async {
              //   setState(() {
              //     _showSpinner = true;
              //   });
              //   await provider.googleLogIn();
              //   await provider.getUser();
              //   String userId = provider.firebaseUser!.uid;
              //   bool check = await provider.checkDoc(userId);
              //   if (!check) {
              //     provider.createData(userId, "verified", "true");
              //   }
              //
              //   setState(() {
              //     _showSpinner = false;
              //   });
              //   Navigator.pop(context);
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => ConnectScreen(),
              //     ),
              //   );
              // }, Colors.redAccent, "Sign in with Google")
            ],
          ),
        ),
      ),
    );
  }
}
