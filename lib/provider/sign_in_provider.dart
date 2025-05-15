import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInProvider extends ChangeNotifier {

  // final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // final FacebookAuth facebookAuth = FacebookAuth.instance;
  // final GoogleSignIn googleSignIn = GoogleSignIn();
  //
  // bool _isSignedIn = false;
  // bool get isSignedIs => _isSignedIn;
  //
  // bool _hasError = false;
  // bool get hasError => _hasError;
  //
  // String? _errorCode;
  // String? get errorCode => _errorCode;
  //
  // String? _provider;
  // String? get provider => _provider;
  //
  // String? _uid;
  // String? get uid => _uid;
  //
  // String? _name;
  // String? get name => _name;
  //
  // String? _email;
  // String? get email => _email;
  //
  // String? _imageUrl;
  // String? get imageUrl => _imageUrl;
  //
  // SignInProvider() {
  //   checkSignInUser();
  // }
  //
  // Future checkSignInUser() async {
  //   final SharedPreferences s = await SharedPreferences.getInstance();
  //   _isSignedIn = s.getBool("signed_in") ?? false;
  //   notifyListeners();
  // }
  //
  // Future setSignIn() async {
  //   final SharedPreferences s = await SharedPreferences.getInstance();
  //   s.setBool("sign_in", true);
  //   _isSignedIn = true;
  //   notifyListeners();
  // }
  //
  // Future<void> signInWithGoogle() async {
  //   final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  //
  //   if (googleSignInAccount != null) {
  //     try {
  //       final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
  //       final AuthCredential credential = GoogleAuthProvider.credential(
  //         accessToken: googleSignInAuthentication.accessToken,
  //         idToken: googleSignInAuthentication.idToken,
  //       );
  //
  //       final UserCredential authResult = await firebaseAuth.signInWithCredential(credential);
  //       final User? userDetails = authResult.user;
  //
  //       if (userDetails != null) {
  //         _name = userDetails.displayName;
  //         _email = userDetails.email;
  //         _imageUrl = userDetails.photoURL;
  //         _provider = "GOOGLE";
  //         _uid = userDetails.uid;
  //         _isSignedIn = true;
  //         await saveDataToFirestore();
  //         await saveDataToSharedPreference();
  //         notifyListeners();
  //       }
  //     } on FirebaseAuthException catch (e) {
  //       _errorCode = e.code;
  //       _hasError = true;
  //       notifyListeners();
  //     }
  //   } else {
  //     _hasError = true;
  //     notifyListeners();
  //   }
  // }
  //
  //
  // Future getUserDataFromFirestore(String? uid) async {
  //   await FirebaseFirestore.instance.collection("user").doc(uid).get().then((DocumentSnapshot snapshot) {
  //     _uid = snapshot['uid'];
  //     _name = snapshot['name'];
  //     _email = snapshot['email'];
  //     _imageUrl = snapshot['image_url'];
  //     _provider = snapshot['provider'];
  //   });
  // }
  //
  // Future saveDataToFirestore() async {
  //   final DocumentReference r = FirebaseFirestore.instance.collection("users").doc(uid);
  //   await r.set({
  //     "name" : _name,
  //     "email" : _email,
  //     "uid" : _uid,
  //     "image_url" : _imageUrl,
  //     "provider" : _provider,
  //   });
  //   notifyListeners();
  // }
  //
  // Future saveDataToSharedPreference() async {
  //   final SharedPreferences s = await SharedPreferences.getInstance();
  //   await s.setString('name', _name!);
  //   await s.setString('email', _email!);
  //   await s.setString('uid', _uid!);
  //   await s.setString('image_url', _imageUrl!);
  //   await s.setString('provider', _provider!);
  //   notifyListeners();
  // }
  //
  // Future<bool> checkUserExist() async {
  //   DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(_uid).get();
  //   if(snap.exists) {
  //     print("EXISTING USER");
  //     return true;
  //   }else {
  //     print("NEW USER");
  //     return false;
  //   }
  // }
  //
  // Future<void> userSignOut() async {
  //   await firebaseAuth.signOut();
  //   await googleSignIn.signOut();
  //   await facebookAuth.logOut();
  //   _isSignedIn = false;
  //   await clearStoredData();
  //   notifyListeners();
  // }
  //
  // Future clearStoredData() async {
  //   final SharedPreferences s = await SharedPreferences.getInstance();
  //   s.clear();
  // }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? _user;

  User? get user => _user;

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult = await _auth.signInWithCredential(credential);
        _user = authResult.user;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
    _user = null;
    notifyListeners();
  }
}