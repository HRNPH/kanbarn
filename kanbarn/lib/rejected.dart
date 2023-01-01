import 'package:flutter/material.dart';
import 'main.dart';

class Rejected extends StatelessWidget {
  final String message; // reason of rejection
  final Widget routes; // routes to go back to
  const Rejected({
    super.key,
    this.message =
        'ปฎิเสธการเข้าใช้งาน ต้องใช้บัญชี Google ที่ลงท้ายด้วย @nmrsw2.ac.th เท่านั้น',
    this.routes = const Main(),
  });

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
                message,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 100 * 4,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                softWrap: true,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text('กลับไปหน้าที่แล้ว'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => routes,
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
