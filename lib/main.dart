import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gaspal/screens/dashboard_screen.dart';
import 'package:gaspal/screens/startBank_screen.dart';
import 'package:gaspal/screens/welcome_screen.dart';
import 'package:gaspal/services/firebase_controller.dart';
import 'package:gaspal/services/web_client.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:gaspal/screens/start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthFunctions>(
            create: (context) => AuthFunctions()),
        ChangeNotifierProvider<WebClient>(create: (context) => WebClient()),
      ],
      child: Builder(
        builder: (BuildContext context) {
          final auth = AuthFunctions();
          // GoogleFonts.config.allowRuntimeFetching = false;
          auth.getUser();

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: (auth.firebaseUser == null)
                ? WelcomeScreen()
                : StartBankScreen(),
          );
        },
      ),
    );
  }
}
