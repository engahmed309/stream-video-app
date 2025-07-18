import 'package:flutter/material.dart';

import '../widgets/custom_search_bar.dart';
import '../widgets/favorite_contacts_widget.dart';
import '../widgets/recent_talks_widget.dart';

class ContactsView extends StatelessWidget {
  const ContactsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: true,
        leading: Icon(Icons.arrow_back, color: Colors.black),
        title: Text(
          'CONTACTS',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add_alt, color: Colors.black),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.grey.shade200,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            CustomSearchBar(),
            FavoriteContactsWidget(),
            Expanded(child: RecentTalksWidget()),
          ],
        ),
      ),
    );
  }
}
