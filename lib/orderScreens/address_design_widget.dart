import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:users_app/helper/sizebox_helper.dart';
import 'package:users_app/ratingScreen/rate_seller_screen.dart';

import '../global/global.dart';
import '../models/address.dart';

class AddressDesign extends StatelessWidget {
  Address? addressModel;
  String? orderStatus;
  String? orderId;
  String? sellerId;
  String? orderByUser;

  AddressDesign({
    super.key,
    this.addressModel,
    this.orderStatus,
    this.orderId,
    this.sellerId,
    this.orderByUser,
  });

  sendNotificationToSeller(String sellerUid, String orderId) async {
    String sellerDeviceToken = "";
    await FirebaseFirestore.instance
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
      'Dear Seller, new order number (# $orderId) has been received by the user $name successfully',
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
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Shipping Details",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: Table(
            children: [
              //name
              TableRow(children: [
                const Text(
                  "Name",
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                Text(
                  addressModel!.name!,
                  style: const TextStyle(color: Colors.grey, fontSize: 18),
                )
              ]),

              const TableRow(children: [
                SizedBox(
                  height: 4,
                ),
                SizedBox(
                  height: 4,
                ),
              ]),
              //phone Number
              TableRow(children: [
                const Text(
                  "Phone",
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                Text(
                  addressModel!.phoneNumber!,
                  style: const TextStyle(color: Colors.grey, fontSize: 18),
                )
              ]),
              const TableRow(children: [
                SizedBox(
                  height: 4,
                ),
                SizedBox(
                  height: 4,
                ),
              ]),
              //name
              TableRow(children: [
                const Text(
                  "Address",
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                Text(
                  addressModel!.completeAddress!,
                  style: const TextStyle(color: Colors.grey, fontSize: 18),
                )
              ]),
            ],
          ),
        ),
        SizedBoxHelper.sizeBox40,
        GestureDetector(
          onTap: () {
            if (orderStatus == "ended") {
              //implement rate seller feature
              print(sellerId);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (e) => RateSellerScreen(
                            sellerId: sellerId,
                          )));
            } else if (orderStatus == "shifted") {
              firebaseFirestore
                  .collection("orders")
                  .doc(orderId)
                  .update({"status": "ended"}).whenComplete(() {
                firebaseFirestore
                    .collection("users")
                    .doc(orderByUser)
                    .collection("orders")
                    .doc(orderId)
                    .update({"status": "ended"});

                //send notification to seller
                sendNotificationToSeller(sellerId!, orderId!);
                Fluttertoast.showToast(msg: "Order Delivered Successfully");
                Navigator.pop(context);
              });
            }
            if (orderStatus == "normal") {
              Navigator.pop(context);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.pinkAccent, Colors.purpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.topRight)),
              width: MediaQuery.of(context).size.width - 40,
              height: MediaQuery.of(context).size.height * .10,
              child: Center(
                child: Text(
                  orderStatus == "ended"
                      ? "Rate the seller"
                      : orderStatus == "shifted"
                          ? "Confirm Delivered"
                          : orderStatus == "normal"
                              ? "Go Back"
                              : "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
