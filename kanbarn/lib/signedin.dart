import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanbarn/classroom_board.dart';
import 'package:kanbarn/rejected.dart';
import 'package:kanbarn/services/firebase_services.dart';

// import another widgets
import 'main.dart';

class SignedIn extends StatefulWidget {
  const SignedIn({super.key});

  @override
  State<SignedIn> createState() => _SignedInState();
}

class _SignedInState extends State<SignedIn> {
  // text controller
  final TextEditingController _classroomController = TextEditingController();
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
                  children: <Widget>[
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
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        controller: _classroomController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText:
                              'หมายเลขชั้นเรียน (เช่น 608 = 6/8, 612 = 6/12)',
                        ),
                      ),
                    ),
                    ElevatedButton(
                      // green button
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent[200],
                      ),
                      onPressed: () async {
                        // loading screen
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.redAccent,
                                backgroundColor: Colors.white,
                              ),
                            );
                          },
                        );
                        // save data to firebase
                        await FirebaseServices().storeUserMetaData({
                          'classroom': _classroomController.text,
                        }).then((success) {
                          if (success == true) {
                            // clear loading screen
                            Navigator.pop(context);
                            // pop up another screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Classroomboard(),
                              ),
                            );
                          } else if (success == false) {
                            // rejected
                            // clear loading screen
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Rejected(
                                  message:
                                      'ไม่สามารถดาวน์โหลดข้อมูลได้ ห้องเรียนไม่ถูกต้อง',
                                  routes: SignedIn(),
                                ),
                              ),
                            );
                          }
                        });
                      },
                      child: Text(
                        'เชื่อมต่อเข้าสู่ระบบ',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.06,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent[100],
                ),
                child: Text(
                  'ออกจากระบบ',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  await FirebaseServices().signOut().then((value) {
                    // pop up another screen and clear all previous screen
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Main(),
                      ),
                      (route) => false,
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
