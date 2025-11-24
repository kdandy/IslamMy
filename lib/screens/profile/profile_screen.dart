import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// --- Counter Text ---
            Text(
              '$counter',
              style: const TextStyle(
                fontSize: 100,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            /// --- Add Counter Button ---
            ElevatedButton(
              onPressed: () {
                setState(() {
                  counter++;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 35,
                  vertical: 15,
                ),
              ),
              child: const Text(
                'Add Counter',
                style: TextStyle(fontSize: 18),
              ),
            ),

            const SizedBox(height: 20),

            /// --- Reset Button ---
            TextButton(
              onPressed: () {
                setState(() {
                  counter = 0;
                });
              },
              child: const Text(
                'Reset',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
