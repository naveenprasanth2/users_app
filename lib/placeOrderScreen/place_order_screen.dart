import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/helper/sizebox_helper.dart';
import 'package:users_app/sellersScreens/home_screen.dart';

class PlaceOrderScreen extends StatefulWidget {
  String? addressId;
  String? totalAmount;
  String? sellerUid;

  PlaceOrderScreen({
    super.key,
    this.addressId,
    this.totalAmount,
    this.sellerUid,
  });

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  String orderId = DateTime.now().millisecondsSinceEpoch.toString();

  orderDetails() {
    saveOrderDetailsForUser({
      "addressId": widget.addressId,
      "totalAmount": widget.totalAmount,
      "orderBy": sharedPreferences!.getString("uid"),
      "productIds": sharedPreferences!.getStringList("userCart"),
      "paymentDetails": "Cash on Delivery",
      "orderTime": orderId,
      "orderId": orderId,
      "sellerUid": widget.sellerUid,
      "isSuccess": true,
      "status": "normal"
    }).whenComplete(() {
      saveOrderDetailsForSeller({
        "addressId": widget.addressId,
        "totalAmount": widget.totalAmount,
        "orderBy": sharedPreferences!.getString("uid"),
        "productIds": sharedPreferences!.getStringList("userCart"),
        "paymentDetails": "Cash on Delivery",
        "orderTime": orderId,
        "orderId": orderId,
        "sellerUid": widget.sellerUid,
        "isSuccess": true,
        "status": "normal"
      });
    }).whenComplete(() {
      cartMethods.clearCart(context);
      //send notification to seller on the order from the user
      Fluttertoast.showToast(msg: "Order has been placed successfully");
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (e) => const HomeScreen()));
      sendNotificationToSeller(widget.sellerUid.toString(), orderId);
      orderId = "";
    });
  }

  saveOrderDetailsForUser(Map<String, dynamic> orderDetailsMap) async {
    await _firebaseFirestore
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("orders")
        .doc(orderId)
        .set(orderDetailsMap);
  }

  saveOrderDetailsForSeller(Map<String, dynamic> orderDetailsMap) async {
    await _firebaseFirestore
        .collection("orders")
        .doc(orderId)
        .set(orderDetailsMap);
  }

  sendNotificationToSeller(String sellerUid, String orderId) async {
    String sellerDeviceToken = "";
    await _firebaseFirestore
        .collection("sellers")
        .doc(sellerUid)
        .get()
        .then((snapshot) {
      if (snapshot.data()!["sellerDeviceToken"] != null) {
        sellerDeviceToken = snapshot.data()!["sellerDeviceToken"].toString();
      }

      notificationFormat(
          sellerDeviceToken, orderId, sharedPreferences!.getString("name"));
    });
  }

  notificationFormat(String sellerDeviceToken, String orderId, String? name) {
    //all these things are as per fcm documentation, don't deviate
    Map<String, String> headerNotification = {
      'Content-Type': 'application/json',
      'Authorization': fcmServerToken,
    };

    Map<String, String> bodyNotification = {
      'body':
          'Dear Seller, new order number (# $orderId) has been placed by $name \n Please ship as soon as possible',
      'title': 'New Order'
    };

    Map dataMap = {
      'click_action': "FLUTTER_NOTIFICATION_CLICK",
      'id': '1',
      'status': 'done',
      'userOrderId': orderId
    };

    Map officialNotificationFormat = {
      'notification': bodyNotification,
      'data': dataMap,
      'priority': 'high',
      'to': sellerDeviceToken
    };
    //comes from http dependency
    post(
      //uri is as per documentation
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: headerNotification,
        body: jsonEncode(officialNotificationFormat)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.pinkAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          )),
        ),
        title: const Text(
          "Complete Order",
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/delivery.png"),
          SizedBoxHelper.sizeBox12,
          ElevatedButton(
            onPressed: () {
              orderDetails();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("Place Order"),
          ),
        ],
      ),
    );
  }
}
