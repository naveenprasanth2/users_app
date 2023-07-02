import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:users_app/functions/functions.dart';
import 'package:users_app/global/global.dart';

class PushNotificationSystem {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  Stream<RemoteMessage> firebaseMessagingListen = FirebaseMessaging.onMessage;
  Stream<RemoteMessage> firebaseMessagingOnOpen =
      FirebaseMessaging.onMessageOpenedApp;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future whenNotificationReceived(BuildContext homeScreenBuildContext) async {
    //1. Terminated
    //when app is completely closed and opened directly from the push notifications
    firebaseMessaging.getInitialMessage().then((RemoteMessage? remoteMessage) {
      //show notification
      if (remoteMessage != null) {
        //open app and show notification data
        showNotificationWhenOpenApp(homeScreenBuildContext, remoteMessage.data['userOrderId']);
      }
    });

    //2. Foreground
    //when the app is open and it receives a push notification
    firebaseMessagingListen.listen((RemoteMessage? remoteMessage) {
      //show notification
      if (remoteMessage != null) {
        //show notification data
        showNotificationWhenOpenApp(homeScreenBuildContext, remoteMessage.data['userOrderId']);
      }
    });

    //3. Background
    //when app is running in background and opened directly from the push notifications
    firebaseMessagingOnOpen.listen((RemoteMessage? remoteMessage) {
      //show notification
      if (remoteMessage != null) {
        //show notification data
        showNotificationWhenOpenApp(homeScreenBuildContext, remoteMessage.data['userOrderId']);
      }
    });
  }

  //generate device recognition token

  Future generateDeviceRecognitionToken() async {
    String? registrationDeviceToken = await firebaseMessaging.getToken();

    firebaseFirestore
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .update({
      "userDeviceToken": registrationDeviceToken,
    });
    firebaseMessaging.subscribeToTopic("allSellers");
    firebaseMessaging.subscribeToTopic("allUsers");
  }

  showNotificationWhenOpenApp(BuildContext homeScreenBuildContext, String orderId) {
    showReusableSnackBar(homeScreenBuildContext, "Your order: # $orderId has been shifted successfully", Colors.green);
  }
}
