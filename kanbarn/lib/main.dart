import 'dart:async';
import 'dart:convert' show json;

import 'package:firebase_core/firebase_core.dart';
import 'package:kanbarn/services/firebase_services.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

// pages
import 'package:kanbarn/signedin.dart';
import 'package:kanbarn/rejected.dart';

// init firebase
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MaterialApp(
      title: 'kanbarn',
      home: Main(),
    ),
  );
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white70,
            backgroundColor: Colors.redAccent[200],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            minimumSize: Size(
              MediaQuery.of(context).size.width * 0.6,
              MediaQuery.of(context).size.height * 0.05,
            ),
            // width limit
            maximumSize: Size(
              MediaQuery.of(context).size.width * 0.8,
              MediaQuery.of(context).size.height * 0.07,
            ),
          ),
          child: Row(
            // center the text and logo
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text(
                'Sign in with Google',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              // google logo
              SizedBox(width: 10),
              Image(
                image: AssetImage('assets/google_logo.png'),
                height: 20,
              ),
            ],
          ),
          onPressed: () async {
            // loading screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Loading(),
              ),
            );
            // sign in with google
            await FirebaseServices().signInWithGoogle().then((value) {
              if (value == true) {
                // pop up another screen and clear history
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignedIn(),
                  ),
                  (route) => false,
                );
              } else {
                // remove loading screen
                Navigator.pop(context);
                // pop up rejected screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Rejected(),
                  ),
                );
              }
            });
          },
        ),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // loading screen
      color: Colors.white,
      child: const Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.redAccent,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
        ),
      ),
    );
  }
}
