import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/helper/sizebox_helper.dart';

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
              Navigator.pop(context);
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

                Fluttertoast.showToast(msg: "Order Delivered Successfully");
                Navigator.pop(context);
              });
            }
            if (orderStatus == "normal") {
              //implement rate seller feature
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
