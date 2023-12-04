import 'dart:typed_data';
import 'dart:io';
import 'package:block_ui/block_ui.dart';
import 'package:flutter/material.dart';
import 'package:cool_stepper/cool_stepper.dart';
import 'package:gaspal/modules/constants.dart';
import 'package:gaspal/screens/dashboard_screen.dart';
import 'package:gaspal/screens/verify_customer_screen.dart';
import 'package:gaspal/services/firebase_controller.dart';
import 'package:gaspal/services/grab_image.dart';
import 'package:gaspal/services/web_client.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import 'package:gaspal/modules/constants.dart';

class AddFormScreen extends StatefulWidget {
  @override
  _AddFormScreenState createState() => _AddFormScreenState();
}

class _AddFormScreenState extends State<AddFormScreen> {
  late String customerID;

  int _currentStep = 0;

  Uint8List? signature;
  String? signImgUrl;

  late final SharedPreferences prefs;

  SignatureController controller = SignatureController(
      penStrokeWidth: 3,
      penColor: kDeepBlue,
      exportPenColor: Colors.black,
      exportBackgroundColor: Colors.white);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _requestPermission();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      prefs = await SharedPreferences.getInstance();
    });
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthFunctions>(context, listen: false);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xff63cdd7),
            title: const Text(
              "Complete the Form",
              style:
                  TextStyle(fontFamily: "AudioWide", color: Color(0xFF050a30)),
            ),
            centerTitle: false,
            automaticallyImplyLeading: false,
          ),
          body: CoolStepper(
            onCompleted: () async {
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
                          child: const Text("Saving..",
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
              await authProvider.getUser();
              String userId = authProvider.firebaseUser!.uid;

              if (authProvider.frontImgUrl != null &&
                  authProvider.backImgUrl != null &&
                  authProvider.signImgUrl != null) {
                print(authProvider.frontImgUrl);
                print(authProvider.signImgUrl);
                authProvider.updateStorage(userId, '${userId}_NICFront',
                    File(authProvider.frontImgUrl!));
                authProvider.updateStorage(userId, '${userId}_NICBack',
                    File(authProvider.backImgUrl!));
                authProvider.updateStorage(userId, '${userId}_Signature',
                    File(authProvider.signImgUrl!));
              } else {
                BlockUi.hide(context);
                Future.delayed(const Duration(milliseconds: 100), () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return DashboardScreen();
                      },
                    ),
                  );
                });
              }
            },
            config: const CoolStepperConfig(
                icon: Icon(null),
                backText: "",
                titleTextStyle: TextStyle(
                    fontFamily: "AudioWide", color: Color(0xFF050a30)),
                subtitleTextStyle:
                    TextStyle(fontFamily: "AudioWide", color: Colors.black38)),
            steps: <CoolStep>[
              CoolStep(
                  title: "Legal Documents",
                  subtitle: "Submit below details for use in the Metaverse",
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Submit your NIC',
                        style: TextStyle(
                          color: kDeepBlue,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'AudioWide',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GrabImage(),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Draw your Signature',
                        style: TextStyle(
                          color: kDeepBlue,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'AudioWide',
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Signature(
                        controller: controller,
                        width: 350,
                        height: 200,
                        backgroundColor: kSecBlue,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () async {
                                signature = await controller.toPngBytes(
                                    width: 350, height: 200);
                                if (signature != null) {
                                  final time = DateTime.now().millisecond;
                                  final name = "${time}_signature.png";
                                  final result =
                                      await ImageGallerySaver.saveImage(
                                          signature!,
                                          quality: 100,
                                          name: name);
                                  final isSuccess = result['isSuccess'];
                                  print(result);
                                  if (isSuccess) {
                                    final path = result['filePath']
                                        .toString()
                                        .split(':');
                                    Provider.of<AuthFunctions>(context,
                                            listen: false)
                                        .signImgUrl = path.last;
                                  }
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.green,
                                    duration: Duration(milliseconds: 500),
                                    content: Text('Saved',
                                        style: TextStyle(
                                          color: kDeepBlue,
                                          fontSize: 15,
                                          fontFamily: 'AudioWide',
                                        )),
                                  ),
                                );
                              },
                              iconSize: 45,
                              tooltip: 'Save signature',
                              icon: const Icon(
                                Icons.check_circle,
                                color: Colors.lightGreenAccent,
                                size: 45,
                              )),
                          const SizedBox(
                            width: 20,
                          ),
                          IconButton(
                              iconSize: 45,
                              tooltip: 'Clear signature',
                              onPressed: () {
                                controller.clear();
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.redAccent,
                                size: 45,
                              ))
                        ],
                      )
                    ],
                  ),
                  validation: () {}),
              // CoolStep(
              //     title: "Legel Information",
              //     subtitle: "Please fill below details to get started",
              //     content: Column(
              //       children: [
              //         Row(
              //           children: [
              //             Padding(
              //               padding: const EdgeInsets.only(top: 10.0),
              //               child: Text(
              //                 'Are you a tax payer?',
              //                 textAlign: TextAlign.start,
              //                 style: TextStyle(
              //                     fontFamily: "AudioWide",
              //                     fontSize: 18,
              //                     color: Colors.black54),
              //               ),
              //             ),
              //           ],
              //           mainAxisAlignment: MainAxisAlignment.start,
              //         ),
              //         const SizedBox(
              //           height: 15,
              //         ),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             Expanded(
              //               child: Row(
              //                 children: [
              //                   Radio<int>(
              //                       value: 1,
              //                       groupValue: _taxSelectBoolValue,
              //                       onChanged: (value) {
              //                         setState(() {
              //                           _taxPayer = true;
              //                           _taxSelectBoolValue = value!;
              //                         });
              //                       }),
              //                   SizedBox(
              //                     width: 10,
              //                   ),
              //                   Text(
              //                     'Yes',
              //                     style: TextStyle(
              //                       fontFamily: "AudioWide",
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //             Expanded(
              //               child: Row(
              //                 children: [
              //                   Radio<int>(
              //                       value: 2,
              //                       groupValue: _taxSelectBoolValue,
              //                       onChanged: (value) {
              //                         setState(() {
              //                           _taxPayer = false;
              //                           _taxSelectBoolValue = value!;
              //                         });
              //                       }),
              //                   SizedBox(
              //                     width: 10,
              //                   ),
              //                   Text(
              //                     'No',
              //                     style: TextStyle(
              //                       fontFamily: "AudioWide",
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //         //gender
              //         const SizedBox(
              //           height: 20,
              //         ),
              //         (_taxPayer)
              //             ? TextFormField(
              //                 onChanged: (value) {
              //                   taxId = value;
              //                 },
              //                 decoration: const InputDecoration(
              //                     labelText: 'Tax file no:',
              //                     labelStyle: TextStyle(
              //                       fontFamily: "AudioWide",
              //                     )),
              //               )
              //             : SizedBox(
              //                 height: 0,
              //               ),
              //         //tax id if tax payer
              //         const SizedBox(
              //           height: 15,
              //         ),
              //         //terms and condition
              //         //gender
              //         //martial status
              //       ],
              //     ),
              //     validation: () {}),
            ],
          )),
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 1 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
