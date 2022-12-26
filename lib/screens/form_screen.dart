import 'package:flutter/material.dart';
import 'package:cool_stepper/cool_stepper.dart';
import 'package:gaspal/modules/constants.dart';
import 'package:gaspal/services/grab_image.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  int _currentStep = 0;
  late String firstName;
  late String lastName;
  late String email;
  late int phoneNum;
  late String address;
  late String NIC;

  late String frontImgUrl;
  late String backImgUrl;

  @override
  Widget build(BuildContext context) {
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
          onCompleted: () => Navigator.of(context).pop(),
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
                        phoneNum = value as int;
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
                  children: const [
                    Text(
                      'Submit your NIC',
                      style: TextStyle(
                        color: kDeepBlue,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'AudioWide',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GrabImage(),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      'Draw your Signature',
                      style: TextStyle(
                        color: kDeepBlue,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'AudioWide',
                      ),
                    ),
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
