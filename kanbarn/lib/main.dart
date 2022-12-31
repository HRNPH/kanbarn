import 'dart:async';
import 'dart:convert' show json;

import 'package:firebase_core/firebase_core.dart';
import 'package:kanbarn/home.dart';
import 'package:kanbarn/services/firebase_services.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

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
        child: ElevatedButton(
          child: const Text('Sign in with Google'),
          onPressed: () async {
            await FirebaseServices().signInWithGoogle().then((value) {
              // pop up another screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(),
                ),
              );
            });
          },
        ),
      ),
    );
  }
}
