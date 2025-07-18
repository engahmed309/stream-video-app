import 'package:flutter/material.dart';
import 'package:group_video_app/views/call_screen.dart';

class EndCallPage extends StatelessWidget {
  const EndCallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Call Ended',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const CallPage()),
                );
              },
              child: const Text('Rejoin Call'),
            ),
          ],
        ),
      ),
    );
  }
}
