import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  final _firestoreDatabase = FirebaseFirestore.instance;

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

  Future<bool> storeUserMetaData(Map<String, dynamic> data) async {
    // check data structure if data is valid
    if (data['classroom'].length == 3 &&
        data['classroom'][0].contains(RegExp(r'[0-6]'))) {
      if (data['classroom'][0].contains(RegExp(r'[0-9]'))) {
        if (data['classroom'][1] == '0' || data['classroom'][1] == '1') {
          if (data['classroom'][2].contains(RegExp(r'[0-9]'))) {
            // if data is valid, store it to firebase
            // ----------------- COLLECTIONS -----------------
            final collection = _firestoreDatabase.collection('classes');
            final users = _firestoreDatabase.collection('users');
            // ----------------- USER -----------------
            // check if user exists in database by google uid key lookup
            final query = await users
                .where(
                  'key',
                  isEqualTo: _auth.currentUser!.uid,
                )
                .get();
            // get user student ID from email
            final studentID = _auth.currentUser!.email!.split('@')[0];
            if (query.docs.isEmpty) {
              // if user does not exist, create new user
              await users.add({
                'classroom': data['classroom'],
                'name': _auth.currentUser!.displayName,
                'contribution': 0,
                'email': _auth.currentUser!.email,
                'key': _auth.currentUser!.uid,
                'student_id': studentID,
              });
            } else {
              // if user exists, update user
              await users.doc(query.docs.first.id).update({
                'classroom': data['classroom'],
                'name': _auth.currentUser!.displayName,
                'email': _auth.currentUser!.email,
                'key': _auth.currentUser!.uid,
                'student_id': studentID,
              });
            }
            // ----------------- CLASSROOM -----------------
            // check if classroom exists in database by class ID lookup
            final classQuery = await collection
                .where(
                  'ID',
                  isEqualTo: data['classroom'],
                )
                .get();
            if (classQuery.docs.isEmpty) {
              // if classroom does not exist, create new classroom
              await collection.add({
                'ID': data['classroom'],
              }).then((classroom) async => {
                    // add student collection
                    await classroom.collection('students').add({
                      'student_id': studentID,
                      'name': _auth.currentUser!.displayName,
                    }),
                  });
            } else {
              // ---------- Check Existed STUDENT -------------
              // if not, check if student exists in classroom
              final classroom = classQuery.docs.first.reference;
              // lookup student by student ID
              final studentQuery = await classroom
                  .collection('students')
                  .where(
                    'student_id',
                    isEqualTo: studentID,
                  )
                  .get();

              if (studentQuery.docs.isEmpty) {
                // if student does not exist, add student to classroom
                await classroom.collection('students').add({
                  'student_id': studentID,
                  'name': _auth.currentUser!.displayName,
                });
              } else {
                // if student exists, update student name
                await classroom
                    .collection('students')
                    .doc(studentQuery.docs.first.id)
                    .update({
                  'name': _auth.currentUser!.displayName,
                });
              }
            }

            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
