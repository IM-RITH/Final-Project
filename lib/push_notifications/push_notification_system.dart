import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:easyshop/views/screens/profile/my_order.dart';

class PushNotificationSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  PushNotificationSystem() {
    _initializeLocalNotifications();
  }

  void _initializeLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        if (notificationResponse.payload != null) {
          // Handle notification tapped logic here
          _handleNotificationTap(notificationResponse.payload!);
        }
      },
    );
  }

  void _handleNotificationTap(String payload) {
    // Navigate to specific screen based on payload
    Get.to(() => const MyOrderScreen());
  }

  // notification arrived and received
  Future<void> whenNotificationReceived(context) async {
    // terminated
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        // open app then show notification data
        showNotificationWhenOpenApp(
          remoteMessage.data["buyerOrderId"],
          context,
        );
      }
    });

    // foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        // directly show notification
        _showNotification(remoteMessage);
      }
    });

    // background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        // directly show notification
        _showNotification(remoteMessage);
      }
    });
  }

  // device recognition token
  Future<void> generateDeviceRecognitionToken(String buyerId) async {
    try {
      String? registrationDeviceToken = await messaging.getToken();
      if (registrationDeviceToken != null) {
        FirebaseFirestore.instance.collection("buyers").doc(buyerId).update({
          "buyerDeviceToken": registrationDeviceToken,
        });
        messaging.subscribeToTopic("allVendors");
        messaging.subscribeToTopic("allBuyers");
        print("Buyer device token updated successfully");
      } else {
        print("Failed to get buyer device token");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // show notification
  Future<void> showNotificationWhenOpenApp(String orderId, context) async {
    try {
      DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection("orders")
          .doc(orderId)
          .get();

      if (orderSnapshot.exists) {
        var orderData = orderSnapshot.data() as Map<String, dynamic>;

        // Create the notification content
        String title = "Order Confirmed";
        String body =
            "Your order ${orderData['productName']} has been confirmed by the vendor.";

        // Display notification using flutter_local_notifications
        const AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
          'order_notifications',
          'Order Notifications',
          channelDescription: 'This channel is used for order notifications',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
        );
        const NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);

        await flutterLocalNotificationsPlugin.show(
          1, // Notification ID
          title,
          body,
          platformChannelSpecifics,
          payload: orderId,
        );
      } else {
        print("Order not found.");
      }
    } catch (e) {
      print("Error in showNotificationWhenOpenApp: $e");
    }
  }

  // Show notification directly for foreground and background
  Future<void> _showNotification(RemoteMessage remoteMessage) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'order_notifications',
      'Order Notifications',
      channelDescription: 'This channel is used for order notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      remoteMessage.notification?.title ?? 'New Notification',
      remoteMessage.notification?.body ?? 'You have a new notification.',
      platformChannelSpecifics,
      payload: remoteMessage.data['buyerOrderId'],
    );
  }
}
