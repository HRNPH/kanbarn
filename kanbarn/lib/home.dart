import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanbarn/services/firebase_services.dart';

// import another widgets
import 'main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 200),
                child: Column(
                  children: [
                    ClipRRect(
                      // rounded corners
                      borderRadius: BorderRadius.circular(200),
                      child: Image.network(
                        FirebaseAuth.instance.currentUser!.photoURL!,
                        width: 100,
                        height: 100,
                        // rounded corners
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      FirebaseAuth.instance.currentUser!.email!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      FirebaseAuth.instance.currentUser!.displayName!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                child: const Text('Sign out'),
                onPressed: () async {
                  await FirebaseServices().signOut().then((value) {
                    // pop up another screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Main(),
                      ),
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
