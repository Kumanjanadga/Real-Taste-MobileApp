import 'package:flutter/material.dart';
import 'package:flutter_auth1/Screens/authentication/authenticate.dart';
import 'package:flutter_auth1/Screens/home/home.dart';
import 'package:flutter_auth1/models/userModel.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Usermodel?>(context);

    return Scaffold(
      body: Container(
        color: const Color(0xFFCC3333),
        width: double.infinity, // Ensure container takes full width
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white,
              child: Icon(Icons.fastfood, size: 100, color: Color(0xFFCC3333)),
            ),
            const SizedBox(height: 20),
            const Text(
              'ARE YOU HUNGRY?',
              style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                if (user == null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Authenticate()),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('GET START', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}