import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/orderScreens/status_banner_widget.dart';

class OrderDetailsScreen extends StatefulWidget {
  String? orderId;

  OrderDetailsScreen({super.key, this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  String? orderStatus = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _firebaseFirestore
              .collection("users")
              .doc(sharedPreferences!.getString("uid"))
              .collection("orders")
              .doc(widget.orderId)
              .get(),
          builder: (c, AsyncSnapshot dataSnapshot) {
            Map? orderDataMap;
            if (dataSnapshot.hasData) {
              orderDataMap = dataSnapshot.data.data() as Map<String, dynamic>;
              orderStatus = orderDataMap["status"].toString();
              return Column(
                children: [
                  StatusBanner(
                    status: orderDataMap["isSuccess"],
                    orderStatus: orderStatus!,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Order Value: ₹ ${orderDataMap["totalAmount"]}",
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Order Id: ${orderDataMap["orderId"]}",
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Ordered Time: ${DateFormat("dd-MM-yyyy - hh mm aa").format(DateTime.fromMillisecondsSinceEpoch(int.parse(orderDataMap["orderId"])))}",
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.pinkAccent,
                  ),
                  orderStatus == "ended"
                      ? Image.asset("assets/delivered.png")
                      : Image.asset("assets/state.png"),
                  const Divider(
                    thickness: 2,
                    color: Colors.pinkAccent,
                  ),
                  FutureBuilder(
                    future: _firebaseFirestore
                        .collection("users")
                        .doc(sharedPreferences!.getString("uid"))
                        .collection("userAddress")
                        .doc(orderDataMap["addressId"])
                        .get(),
                    builder: (c, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return
                      } else {
                        return const Center(
                            child: Text("OOPS!No Address exists"));
                      }
                    },
                  ),
                ],
              );
            } else {
              return const Center(child: Text("No data exists"));
            }
          },
        ),
      ),
    );
  }
}
