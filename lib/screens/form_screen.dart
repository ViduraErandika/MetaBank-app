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

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  late String customerID;

  int _currentStep = 0;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNum;
  String? phNumPrefix;
  String? dob;
  String gender = 'Male';
  int _genderValue = 1;
  // String? mStatus = 'Un-married';
  // int _mValue = 2;

  String? houseNum;
  String? street;
  String? city;
  String? country;
  String? resStatus;
  String? _resStatusValue;
  bool _multiCitizen = false;
  int? _multiCitizenBoolValue;
  String multiNationalId = 'null';

  String? NIC;
  bool _occupied = false;
  int? _occupiedBoolValue;
  String occupation = 'null';
  // String? currency;
  // String? depositVolume;
  // String? branch;
  // String? _branchStatusValue;

  Uint8List? signature;
  String? signImgUrl;

  bool _taxPayer = false;
  int? _taxSelectBoolValue;
  String taxId = 'null';

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
    final webProvider = Provider.of<WebClient>(context, listen: false);
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
              if (firstName != null &&
                  lastName != null &&
                  email != null &&
                  phoneNum != null &&
                  phNumPrefix != null &&
                  dob != null) {
                authProvider.updateFormTableOne(userId, firstName!, lastName!,
                    email!, phoneNum!, phNumPrefix!, dob!, gender!);
              }
              if (houseNum != null &&
                  street != null &&
                  city != null &&
                  country != null &&
                  resStatus != null) {
                authProvider.updateFormTableTwo(userId, houseNum!, street!,
                    city!, country!, resStatus!, multiNationalId!);
              }
              if (NIC != null) {
                authProvider.updateFormTableThree(userId, NIC!, occupation!);
              }
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
              }
              // Making the API call
              if (firstName != null &&
                  lastName != null &&
                  email != null &&
                  phoneNum != null &&
                  phNumPrefix != null &&
                  dob != null &&
                  houseNum != null &&
                  street != null &&
                  city != null &&
                  country != null &&
                  resStatus != null &&
                  NIC != null) {
                Map<String, dynamic> response =
                    await webProvider.createCustomer(
                  mnemonic: firstName?.toUpperCase(),
                  shortName: firstName,
                  firstname: firstName,
                  lastName: lastName,
                  gender: gender.toUpperCase(),
                  phNum: "${phNumPrefix} ${phoneNum}",
                  email: email,
                  dob: dob,
                  address: "${houseNum}, ${street}, ${city}, ${country}",
                  nic: NIC,
                );
                if (response["status"] == "success") {
                  customerID = response["id"];
                  authProvider.updateAccInfo(userId, "customerID", customerID);
                  await prefs.setString('customerID', customerID);
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
                } else if (response["status"] == "failed") {
                  BlockUi.hide(context);
                  Alert(
                    style: const AlertStyle(backgroundColor: Colors.white),
                    context: context,
                    type: AlertType.error,
                    title: "ERROR",
                    desc: "Contact Administration",
                    buttons: [
                      DialogButton(
                        child: const Text(
                          "OK",
                          style: TextStyle(color: Colors.white, fontSize: 20),
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
                  print(response["override"]["overrideDetails"]);
                }
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
                  title: "Personal Information",
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
                      ), //first name
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
                      ), //last name
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              onChanged: (value) {
                                phNumPrefix = value;
                              },
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                  labelText: 'Phone prefix',
                                  labelStyle: TextStyle(
                                    fontFamily: "AudioWide",
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              onChanged: (value) {
                                phoneNum = value;
                              },
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                  labelText: 'Phone number',
                                  labelStyle: TextStyle(
                                    fontFamily: "AudioWide",
                                  )),
                            ),
                          ),
                        ],
                      ), //phone num
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
                      ), //email
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          dob = value;
                        },
                        keyboardType: TextInputType.datetime,
                        decoration: const InputDecoration(
                            labelText: 'Date of Birth',
                            labelStyle: TextStyle(
                              fontFamily: "AudioWide",
                            )),
                      ), //dob
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                'Gender',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontFamily: "AudioWide",
                                    fontSize: 18,
                                    color: Colors.black54),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Radio<int>(
                                    value: 1,
                                    groupValue: _genderValue,
                                    onChanged: (value) {
                                      setState(() {
                                        gender = 'Male';
                                        print(gender);
                                        _genderValue = value!;
                                      });
                                    }),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Male',
                                  style: TextStyle(
                                    fontFamily: "AudioWide",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Radio<int>(
                                    value: 2,
                                    groupValue: _genderValue,
                                    onChanged: (value) {
                                      setState(() {
                                        gender = 'Female';
                                        _genderValue = value!;
                                      });
                                    }),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Female',
                                  style: TextStyle(
                                    fontFamily: "AudioWide",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ), //gender
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // Row(
                      //   children: [
                      //     Container(
                      //       width: 115,
                      //       child: Padding(
                      //         padding: const EdgeInsets.only(
                      //           top: 8.0,
                      //         ),
                      //         child: Text(
                      //           'Martial status',
                      //           textAlign: TextAlign.start,
                      //           style: TextStyle(
                      //               fontFamily: "AudioWide",
                      //               fontSize: 18,
                      //               color: Colors.black54),
                      //         ),
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: Row(
                      //         children: [
                      //           Radio<int>(
                      //               value: 1,
                      //               groupValue: _mValue,
                      //               onChanged: (value) {
                      //                 setState(() {
                      //                   mStatus = 'Married';
                      //                   print(mStatus);
                      //                   _mValue = value!;
                      //                 });
                      //               }),
                      //           Text(
                      //             'Married',
                      //             style: TextStyle(
                      //               fontFamily: "AudioWide",
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: Row(
                      //         children: [
                      //           Radio<int>(
                      //               value: 2,
                      //               groupValue: _mValue,
                      //               onChanged: (value) {
                      //                 setState(() {
                      //                   mStatus = 'Un-married';
                      //                   print(mStatus);
                      //                   _mValue = value!;
                      //                 });
                      //               }),
                      //           Text(
                      //             'Un-married',
                      //             style: TextStyle(
                      //               fontFamily: "AudioWide",
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      //martial status
                    ],
                  ),
                  validation: () {}),
              CoolStep(
                  title: "Residence Information",
                  subtitle: "Please fill below details to get started",
                  content: Column(
                    children: [
                      TextFormField(
                        onChanged: (value) {
                          houseNum = value;
                        },
                        decoration: const InputDecoration(
                            labelText: 'House Number',
                            labelStyle: TextStyle(
                              fontFamily: "AudioWide",
                            )),
                      ), //house num
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          street = value;
                        },
                        decoration: const InputDecoration(
                            labelText: 'Street',
                            labelStyle: TextStyle(
                              fontFamily: "AudioWide",
                            )),
                      ), //street
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              onChanged: (value) {
                                city = value;
                              },
                              decoration: const InputDecoration(
                                  labelText: 'City',
                                  labelStyle: TextStyle(
                                    fontFamily: "AudioWide",
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              onChanged: (value) {
                                country = value;
                              },
                              decoration: const InputDecoration(
                                  labelText: 'Country',
                                  labelStyle: TextStyle(
                                    fontFamily: "AudioWide",
                                  )),
                            ),
                          ),
                        ],
                      ), //city and country
                      const SizedBox(
                        height: 25,
                      ),
                      DropdownButton<String>(
                        hint: Text(
                          'Status of Residence',
                          style:
                              TextStyle(fontFamily: "AudioWide", fontSize: 17),
                        ),
                        value: _resStatusValue,
                        items: [
                          DropdownMenuItem(
                            child: Text(
                              'Owner',
                              style: TextStyle(
                                fontFamily: "AudioWide",
                              ),
                            ),
                            value: 'Owner',
                          ),
                          DropdownMenuItem(
                            child: Text(
                              'Rent',
                              style: TextStyle(
                                fontFamily: "AudioWide",
                              ),
                            ),
                            value: 'Rent',
                          ),
                          DropdownMenuItem(
                            child: Text(
                              'Other',
                              style: TextStyle(
                                fontFamily: "AudioWide",
                              ),
                            ),
                            value: 'Other',
                          )
                        ],
                        onChanged: (value) {
                          setState(() {
                            resStatus = value;
                            print(resStatus);
                            _resStatusValue = value;
                          });
                        },
                        isExpanded: true,
                      ), //drop down residence status
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              'Have multiple citizenships?',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontFamily: "AudioWide",
                                  fontSize: 18,
                                  color: Colors.black54),
                            ),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.start,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Radio<int>(
                                    value: 1,
                                    groupValue: _multiCitizenBoolValue,
                                    onChanged: (value) {
                                      setState(() {
                                        _multiCitizen = true;
                                        _multiCitizenBoolValue = value!;
                                      });
                                    }),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Yes',
                                  style: TextStyle(
                                    fontFamily: "AudioWide",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Radio<int>(
                                    value: 2,
                                    groupValue: _multiCitizenBoolValue,
                                    onChanged: (value) {
                                      setState(() {
                                        _multiCitizen = false;
                                        _multiCitizenBoolValue = value!;
                                      });
                                    }),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'No',
                                  style: TextStyle(
                                    fontFamily: "AudioWide",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      //gender
                      const SizedBox(
                        height: 20,
                      ),
                      (_multiCitizen)
                          ? TextFormField(
                              onChanged: (value) {
                                multiNationalId = value;
                              },
                              keyboardType: TextInputType.datetime,
                              decoration: const InputDecoration(
                                  labelText: 'Other Nationality ID',
                                  labelStyle: TextStyle(
                                    fontFamily: "AudioWide",
                                  )),
                            )
                          : SizedBox(
                              height: 5,
                            ), //other nationality id if multiple citizen
                    ],
                  ),
                  validation: () {}),
              CoolStep(
                  title: "Security Information",
                  subtitle: "Please fill below details to get started",
                  content: Column(
                    children: [
                      TextFormField(
                        onChanged: (value) {
                          NIC = value;
                        },
                        decoration: const InputDecoration(
                            labelText: 'NIC',
                            labelStyle: TextStyle(
                              fontFamily: "AudioWide",
                            )),
                      ), //occupation if employed
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                'Occupied?',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontFamily: "AudioWide",
                                    fontSize: 18,
                                    color: Colors.black54),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Radio<int>(
                                    value: 1,
                                    groupValue: _occupiedBoolValue,
                                    onChanged: (value) {
                                      setState(() {
                                        _occupied = true;
                                        _occupiedBoolValue = value!;
                                      });
                                    }),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Yes',
                                  style: TextStyle(
                                    fontFamily: "AudioWide",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Radio<int>(
                                    value: 2,
                                    groupValue: _occupiedBoolValue,
                                    onChanged: (value) {
                                      setState(() {
                                        _occupied = false;
                                        _occupiedBoolValue = value!;
                                      });
                                    }),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'No',
                                  style: TextStyle(
                                    fontFamily: "AudioWide",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      (_occupied)
                          ? Column(
                              children: [
                                TextFormField(
                                  onChanged: (value) {
                                    occupation = value;
                                  },
                                  decoration: const InputDecoration(
                                      labelText: 'Occupation',
                                      labelStyle: TextStyle(
                                        fontFamily: "AudioWide",
                                      )),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            )
                          : SizedBox(
                              height: 5,
                            ), //occupation
                      // TextFormField(
                      //   onChanged: (value) {
                      //     currency = value;
                      //   },
                      //   decoration: const InputDecoration(
                      //       labelText: 'Currency',
                      //       labelStyle: TextStyle(
                      //         fontFamily: "AudioWide",
                      //       )),
                      // ), //currency
                      // const SizedBox(
                      //   height: 15,
                      // ),
                      // TextFormField(
                      //   keyboardType: TextInputType.number,
                      //   onChanged: (value) {
                      //     depositVolume = value;
                      //   },
                      //   decoration: const InputDecoration(
                      //       labelText: 'Anticipated deposit volume',
                      //       labelStyle: TextStyle(
                      //         fontFamily: "AudioWide",
                      //       )),
                      // ), //deposit volume better be dropdown
                      // const SizedBox(
                      //   height: 25,
                      // ),
                      // DropdownButton<String>(
                      //   hint: Text(
                      //     'Preferred branch',
                      //     style:
                      //         TextStyle(fontFamily: "AudioWide", fontSize: 17),
                      //   ),
                      //   value: _branchStatusValue,
                      //   items: [
                      //     DropdownMenuItem(
                      //       child: Text(
                      //         'Panadura',
                      //         style: TextStyle(
                      //           fontFamily: "AudioWide",
                      //         ),
                      //       ),
                      //       value: 'Panadura',
                      //     ),
                      //     DropdownMenuItem(
                      //       child: Text(
                      //         'Colombo',
                      //         style: TextStyle(
                      //           fontFamily: "AudioWide",
                      //         ),
                      //       ),
                      //       value: 'Colombo',
                      //     ),
                      //     DropdownMenuItem(
                      //       child: Text(
                      //         'Katubadda',
                      //         style: TextStyle(
                      //           fontFamily: "AudioWide",
                      //         ),
                      //       ),
                      //       value: 'Katubadda',
                      //     )
                      //   ],
                      //   onChanged: (value) {
                      //     setState(() {
                      //       branch = value;
                      //       _branchStatusValue = value;
                      //     });
                      //   },
                      //   isExpanded: true,
                      // ), //drop down branch
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
