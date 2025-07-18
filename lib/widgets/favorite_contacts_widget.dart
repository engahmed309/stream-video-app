import 'package:flutter/material.dart';

import 'custom_image_container.dart';

class FavoriteContactsWidget extends StatelessWidget {
  FavoriteContactsWidget({super.key});
  final List<String> imageUrls = [
    "https://randomuser.me/api/portraits/men/44.jpg",
    "https://randomuser.me/api/portraits/women/45.jpg",
    "https://randomuser.me/api/portraits/women/46.jpg",
    "https://randomuser.me/api/portraits/women/47.jpg",
    "https://randomuser.me/api/portraits/women/48.jpg",
    "https://randomuser.me/api/portraits/women/49.jpg",
    "https://randomuser.me/api/portraits/women/50.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      height: size.height * 0.2,
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 16, right: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            offset: Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "FAVORITE",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(flex: 2),
          SizedBox(
            height: size.height * 0.07,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              //  padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: imageUrls.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return CustomImageContainer(imageUrl: imageUrls[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
