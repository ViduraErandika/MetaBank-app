import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gaspal/modules/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class GrabImage extends StatefulWidget {
  const GrabImage({Key? key}) : super(key: key);
  @override
  State<GrabImage> createState() => _GrabImageState();
}

class _GrabImageState extends State<GrabImage> {
  final ImagePicker _picker = ImagePicker();
  String? frontImgUrl;
  bool frontImgCalled = false;
  String? backImgUrl;
  bool backImgCalled = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              if (frontImgUrl == null)
                InkWell(
                  onTap: () {
                    _selectPhoto();
                    frontImgCalled = true;
                  },
                  child: const Icon(
                    Icons.image,
                    size: 100,
                  ),
                ),
              if (frontImgUrl != null)
                InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      _selectPhoto();
                      frontImgCalled = true;
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image(
                        image: FileImage(File(frontImgUrl!)),
                        width: 150,
                        height: 150,
                      ),
                    )),
              InkWell(
                onTap: () {
                  _selectPhoto();
                  frontImgCalled = true;
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    frontImgUrl != null
                        ? 'Change front photo'
                        : 'Select front photo',
                    style: const TextStyle(
                      color: kDeepBlue,
                      fontSize: 15,
                      fontFamily: 'AudioWide',
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              if (backImgUrl == null)
                InkWell(
                  onTap: () {
                    _selectPhoto();
                    backImgCalled = true;
                  },
                  child: const Icon(
                    Icons.image,
                    size: 100,
                  ),
                ),
              if (backImgUrl != null)
                InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      _selectPhoto();
                      backImgCalled = true;
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image(
                        image: FileImage(File(backImgUrl!)),
                        width: 150,
                        height: 150,
                      ),
                    )),
              InkWell(
                onTap: () {
                  _selectPhoto();
                  backImgCalled = true;
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    backImgUrl != null
                        ? 'Change back photo'
                        : 'Select back photo',
                    style: const TextStyle(
                      color: kDeepBlue,
                      fontSize: 15,
                      fontFamily: 'AudioWide',
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Future _selectPhoto() async {
    await showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        enableDrag: false,
        context: context,
        builder: (context) => BottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40), topLeft: Radius.circular(40)),
            ),
            enableDrag: false,
            onClosing: () {},
            builder: (context) => Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 15, bottom: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.camera,
                          color: kDeepBlue,
                          size: 30,
                        ),
                        title: const Text(
                          'Open Camera',
                          style: TextStyle(
                            color: kDeepBlue,
                            fontSize: 17,
                            fontFamily: 'AudioWide',
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          _pickImage(ImageSource.camera);
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.collections,
                          color: kDeepBlue,
                          size: 30,
                        ),
                        title: const Text(
                          'Open Gallery',
                          style: TextStyle(
                            color: kDeepBlue,
                            fontSize: 17,
                            fontFamily: 'AudioWide',
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          _pickImage(ImageSource.gallery);
                        },
                      )
                    ],
                  ),
                )));
  }

  Future _pickImage(ImageSource imageSource) async {
    final pickedFile =
        await _picker.pickImage(source: imageSource, imageQuality: 50);
    if (pickedFile == null) {
      return;
    }
    final newPath = p.join((await getTemporaryDirectory()).path,
        '${DateTime.now()}.${p.extension(pickedFile.path)}');
    final result = await FlutterImageCompress.compressAndGetFile(
        pickedFile.path, newPath,
        quality: 35);
    await _uploadFile(result?.path);
  }

  Future _uploadFile(String? path) async {
    setState(() {
      if (frontImgCalled) {
        frontImgUrl = path;
        frontImgCalled = false;
      } else if (backImgCalled) {
        backImgUrl = path;
        backImgCalled = false;
      }
    });
  }
}
