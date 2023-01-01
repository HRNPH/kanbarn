import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kanbarn/services/firebase_services.dart';

class Classroomboard extends StatefulWidget {
  const Classroomboard({super.key});

  @override
  State<Classroomboard> createState() => _ClassroomboardState();
}

class _ClassroomboardState extends State<Classroomboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text('Classroom Board'),
            ElevatedButton(
              child: const Text('Sign Out'),
              onPressed: () {
                // do notting yet
              },
            ),
          ],
        ),
      ),
    );
  }
}
