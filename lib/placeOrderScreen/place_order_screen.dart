import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
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
      "SellerUid": widget.sellerUid,
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
      Fluttertoast.showToast(msg: "Order has been placed successfully");
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (e) => const HomeScreen()));
      orderId = "";
      //send notifications
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
