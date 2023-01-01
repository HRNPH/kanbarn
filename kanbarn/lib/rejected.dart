import 'package:flutter/material.dart';

import 'main.dart';

class Rejected extends StatefulWidget {
  const Rejected({super.key});

  @override
  State<Rejected> createState() => _RejectedState();
}

class _RejectedState extends State<Rejected> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //center the widget (vertical)
      body: Center(
        child: Wrap(
          // center the widget (horizontal)
          alignment: WrapAlignment.center,
          children: <Widget>[
            Container(
              // left right padding
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'ปฎิเสธการเข้าใช้งาน ต้องใช้บัญชี Google ที่ลงท้ายด้วย @nmrsw2.ac.th เท่านั้น',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 100 * 4,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                softWrap: true,
              ),
            ),
            ElevatedButton(
              child: const Text('กลับไปหน้าหลัก'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Main(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
