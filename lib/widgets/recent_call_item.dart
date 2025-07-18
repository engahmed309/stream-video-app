import 'package:flutter/material.dart';

import '../models/recent_talk_user_model.dart';
import '../views/call_screen.dart';
import 'custom_image_container.dart';

class RecentCallItem extends StatelessWidget {
  const RecentCallItem({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CallPage();
            },
          ),
        );
      },
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      leading: CustomImageContainer(imageUrl: dummyContacts[index].imageUrl),
      title: Text(
        dummyContacts[index].name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Text(
        dummyContacts[index].phone,
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.deepPurple.withOpacity(0.08),
            child: Icon(Icons.call_outlined, color: Colors.deepPurple),
          ),
          SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Colors.deepPurple,
            radius: 18,
            child: Icon(Icons.video_call_outlined, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
