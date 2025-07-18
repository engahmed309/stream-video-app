import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'constants.dart';
import 'views/contacts_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  StreamVideo(
    apiKey,
    user: User.regular(userId: userId, role: 'admin', name: "user $userName"),
    userToken: userToken,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: ContactsView());
  }
}
