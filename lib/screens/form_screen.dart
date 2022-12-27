import 'dart:typed_data';
import 'dart:io';
import 'package:block_ui/block_ui.dart';
import 'package:flutter/material.dart';
import 'package:cool_stepper/cool_stepper.dart';
import 'package:gaspal/modules/constants.dart';
import 'package:gaspal/services/firebase_controller.dart';
import 'package:gaspal/services/grab_image.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'package:gaspal/modules/constants.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  int _currentStep = 0;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNum;
  String? address;
  String? NIC;
  Uint8List? signature;

  SignatureController controller = SignatureController(
      penStrokeWidth: 3,
      penColor: kDeepBlue,
      exportPenColor: Colors.black,
      exportBackgroundColor: Colors.white);

  @override
  void dispose() {
    // IMPORTANT to dispose of the controller
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthFunctions>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff63cdd7),
          title: const Text(
            "Complete the Form",
            style: TextStyle(fontFamily: "AudioWide", color: Color(0xFF050a30)),
          ),
          centerTitle: true,
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
            await provider.getUser();
            String userId = provider.firebaseUser!.uid;
            if (firstName != null &&
                lastName != null &&
                email != null &&
                phoneNum != null &&
                address != null &&
                NIC != null) {
              print('called here');
              provider.updateFormTable(userId, firstName!, lastName!, email!,
                  phoneNum!, address!, NIC!);
            }
            if (provider.frontImgUrl != null &&
                provider.backImgUrl != null &&
                signature != null) {
              await provider.updateStorage(
                  userId, '${userId}_NICFront', File(provider.frontImgUrl!));
              await provider.updateStorage(
                  userId, '${userId}_NICBack', File(provider.backImgUrl!));
              provider.updateAccInfo(userId, 'sign', signature!.toString());
            }
            BlockUi.hide(context);
            Future.delayed(const Duration(milliseconds: 200), () {
              Navigator.of(context).pop();
            });
          },
          config: const CoolStepperConfig(
              icon: Icon(null),
              backText: "",
              titleTextStyle:
                  TextStyle(fontFamily: "AudioWide", color: Color(0xFF050a30)),
              subtitleTextStyle:
                  TextStyle(fontFamily: "AudioWide", color: Colors.black38)),
          steps: <CoolStep>[
            CoolStep(
                title: "Account Information",
                subtitle: "Please fill below details to get started",
                content: Column(
                  children: [
                    TextFormField(
                      onChanged: (value) {
                        firstName = value;
                      },
                      decoration: const InputDecoration(
                          labelText: 'First name',
                          labelStyle: TextStyle(
                            fontFamily: "AudioWide",
                          )),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        lastName = value;
                      },
                      decoration: const InputDecoration(
                          labelText: 'Last name',
                          labelStyle: TextStyle(
                            fontFamily: "AudioWide",
                          )),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: const InputDecoration(
                          labelText: 'E-mail',
                          labelStyle: TextStyle(
                            fontFamily: "AudioWide",
                          )),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        phoneNum = value;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'Phone number',
                          labelStyle: TextStyle(
                            fontFamily: "AudioWide",
                          )),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        address = value;
                      },
                      decoration: const InputDecoration(
                          labelText: 'Address',
                          labelStyle: TextStyle(
                            fontFamily: "AudioWide",
                          )),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        NIC = value;
                      },
                      decoration: const InputDecoration(
                          labelText: 'NIC/Passport',
                          labelStyle: TextStyle(
                            fontFamily: "AudioWide",
                          )),
                    ),
                  ],
                ),
                validation: () {}),
            CoolStep(
                title: "Security Documents",
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
                                  width: 1000, height: 1000);
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
          ],
        ));
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
// Column(
// mainAxisSize: MainAxisSize.min,
// children: [
// Flexible(
// fit: FlexFit.loose,
// child: Stepper(
// type: StepperType.horizontal,
// physics: const ScrollPhysics(),
// currentStep: _currentStep,
// onStepTapped: (step) => tapped(step),
// onStepContinue: continued,
// onStepCancel: cancel,
// steps: <Step>[
// Step(
// title: const Text('Account',
// style: TextStyle(
// fontFamily: "AudioWide", color: Color(0xFF050a30))),
// content: Column(
// children: <Widget>[
// TextFormField(
// onChanged: (value) {
// firstName = value;
// },
// decoration: const InputDecoration(
// labelText: 'First name',
// labelStyle: TextStyle(
// fontFamily: "AudioWide",
// )),
// ),
// const SizedBox(
// height: 15,
// ),
// TextFormField(
// onChanged: (value) {
// lastName = value;
// },
// decoration: const InputDecoration(
// labelText: 'Last name',
// labelStyle: TextStyle(
// fontFamily: "AudioWide",
// )),
// ),
// const SizedBox(
// height: 15,
// ),
// TextFormField(
// keyboardType: TextInputType.emailAddress,
// onChanged: (value) {
// email = value;
// },
// decoration: const InputDecoration(
// labelText: 'E-mail',
// labelStyle: TextStyle(
// fontFamily: "AudioWide",
// )),
// ),
// const SizedBox(
// height: 15,
// ),
// TextFormField(
// onChanged: (value) {
// phoneNum = value as int;
// },
// keyboardType: TextInputType.number,
// decoration: const InputDecoration(
// labelText: 'Phone number',
// labelStyle: TextStyle(
// fontFamily: "AudioWide",
// )),
// ),
// const SizedBox(
// height: 15,
// ),
// TextFormField(
// onChanged: (value) {
// address = value;
// },
// decoration: const InputDecoration(
// labelText: 'Address',
// labelStyle: TextStyle(
// fontFamily: "AudioWide",
// )),
// ),
// const SizedBox(
// height: 15,
// ),
// TextFormField(
// onChanged: (value) {
// NIC = value;
// },
// decoration: const InputDecoration(
// labelText: 'NIC/Passport',
// labelStyle: TextStyle(
// fontFamily: "AudioWide",
// )),
// ),
// ],
// ),
// isActive: _currentStep >= 0,
// state: _currentStep >= 0
// ? StepState.complete
//     : StepState.disabled,
// ),
// Step(
// title: const Text('Documents',
// style: TextStyle(
// fontFamily: "AudioWide", color: Color(0xFF050a30))),
// content: Column(
// children: <Widget>[
// TextFormField(
// decoration: InputDecoration(labelText: 'Home Address'),
// ),
// TextFormField(
// decoration: InputDecoration(labelText: 'Postcode'),
// ),
// ],
// ),
// isActive: _currentStep >= 1,
// state: _currentStep >= 1
// ? StepState.complete
//     : StepState.disabled,
// ),
// ],
// ),
// ),
// ],
// ),
