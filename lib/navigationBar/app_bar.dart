import 'package:flutter/material.dart';
import '../styles/color.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;

  MyAppBar(this.name);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Welcome",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColor.descColor,
                ),
              ),
              Text(
                "Samuel Sitorus",
                style: TextStyle(fontSize: 16, color: AppColor.descColor),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  print("Gilbert");
                },
              ),
              CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://random.imagecdn.app/500/150',
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: AppColor.primaryColor,
    );
  }
}
