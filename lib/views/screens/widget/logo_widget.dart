import 'package:easyshop/views/screens/NotificationList/notification_list.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 4.0, right: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/images/logo.png",
            width: 100,
          ),
          const NotificationIcon(),
        ],
      ),
    );
  }
}

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('notifications')
          .where('buyerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('isRead', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildIcon(context, 0);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildIcon(context, 0);
        }

        int notificationCount = snapshot.data?.docs.length ?? 0;
        return _buildIcon(context, notificationCount);
      },
    );
  }

  Widget _buildIcon(BuildContext context, int notificationCount) {
    return badges.Badge(
      badgeContent: Text(
        '$notificationCount',
        style: const TextStyle(color: Colors.white),
      ),
      position: badges.BadgePosition.topEnd(top: 0, end: 3),
      showBadge: notificationCount > 0,
      badgeStyle: const badges.BadgeStyle(
        badgeColor: Colors.red,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const NotificationListScreen()),
          );
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(Icons.notifications, color: Colors.white),
        ),
      ),
    );
  }
}
