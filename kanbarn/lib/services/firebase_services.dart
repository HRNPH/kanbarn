import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        // if user cancels sign in, return null

        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        ); // this credential is used to sign in to firebase
        // check if user email ended with @nmrsw2.ac.th
        if (googleSignInAccount.email.endsWith('@nmrsw2.ac.th') == false) {
          // if not, sign out and return false -> will be redirected to rejected page
          await _auth.signOut();
          await _googleSignIn.signOut();
          return false;
        }
        await _auth.signInWithCredential(credential);
        // callback function
        return true;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      rethrow;
    }
  }

  signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    return true;
  }

  storeUserMetaData(Map<String, dynamic> data) async {
    // save data to firebase
    // https://firebase.flutter.dev/docs/firestore/usage/
  }
}
