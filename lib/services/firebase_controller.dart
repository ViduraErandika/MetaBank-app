import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthFunctions with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  late User? _firebaseUser;
  late GoogleSignInAccount _user;

  GoogleSignInAccount get user => _user;
  User? get firebaseUser => _firebaseUser;

  String? frontImgUrl;
  String? backImgUrl;
  // String? avatarUrl;
  bool accInfoDone = false;

  Future googleLogIn() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      print("Error No user");
      return;
    }
    _user = googleUser;

    final googleAuth = await googleUser.authentication;
    print('access token');
    print(googleAuth.accessToken);
    print('id token');
    print(googleAuth.idToken);

    final credentials = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    var result = await _auth.signInWithCredential(credentials);
    notifyListeners();
    return result.user!.uid;
  }

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (e) {
      print(e);
    }
    notifyListeners();
    return false;
  }

  Future<bool> emailSignIn(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (e) {
      print(e);
    }
    notifyListeners();
    return false;
  }

  Future<bool> emailLogIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
//      print('error is');
//      print(e.toString());
    }
    notifyListeners();
    return false;
  }

  Future getUser() async {
    _firebaseUser = _auth.currentUser;

    notifyListeners();
  }

  Future isSignedInCheck() async {
    var user = _auth.currentUser;

    if (user != null) {
      await getUser();
      debugPrint(firebaseUser!.uid);
      await FirebaseFirestore.instance
          .collection("users")
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          print(doc.data());
          var userID = doc.id;
          if (userID == user.uid) {
            print("USER " + userID);
          }
        });
      });
    }
    notifyListeners();
  }

  Future signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  void createData(String docId, String keyField, String data) {
    _fireStore.collection('users').doc(docId).set({
      keyField: data,
    });
    notifyListeners();
  }

  void createAnalytics(
      String collectionId, String docId, String keyField, List<int> data) {
    _fireStore.collection(collectionId).doc(docId).set({
      keyField: data,
    }, SetOptions(merge: true));
    notifyListeners();
  }

  Future<bool> checkDoc(String collectionId, String uid) async {
    DocumentSnapshot docSnap =
        await _fireStore.collection(collectionId).doc(uid).get();
    if (docSnap.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkField(
      String collectionId, String uid, String keyField) async {
    DocumentSnapshot docSnap =
        await _fireStore.collection(collectionId).doc(uid).get();
    if (docSnap.exists) {
      if ((docSnap.data() as Map<String?, dynamic>).containsKey(keyField)) {
        return true;
      }
    }
    return false;
  }

  void completeProfileCheck() async {
    getUser();
    String userId = firebaseUser!.uid;
    bool check = await checkDoc('accountDetails', userId);
    (check) ? accInfoDone = true : accInfoDone = false;
    notifyListeners();
  }

  Future<String> getAvatarUrl(String uid) async {
    String avatarUrl = '';
    bool checkAvatarUrl = await checkField('accountDetails', uid, 'avatarUrl');
    if (checkAvatarUrl) {
      await _fireStore
          .collection('accountDetails')
          .doc(uid)
          .get()
          .then((value) => avatarUrl = value.get('avatarUrl'));
      notifyListeners();
    }
    return avatarUrl;
  }

  void updateFormTable(String docId, String firstName, String lastName,
      String email, String phoneNum, String address, String NIC) {
    _fireStore.collection('accountDetails').doc(docId).set({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNum': phoneNum,
      'address': address,
      'NIC': NIC,
    }, SetOptions(merge: true));
    accInfoDone = true;
    notifyListeners();
  }

  void updateAccInfo(String docId, String keyField, String data) {
    _fireStore.collection('accountDetails').doc(docId).set({
      keyField: data,
    }, SetOptions(merge: true));
    notifyListeners();
  }

  Future<void> updateStorage(
      String folderName, String imgName, var file) async {
    await _storage.ref().child('$folderName/$imgName').putFile(file);
    notifyListeners();
  }

  void updateData(String docId, String keyField, String data) {
    _fireStore.collection('users').doc(docId).update({
      keyField: data,
    });
    notifyListeners();
  }
}
