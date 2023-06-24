import 'package:cart_stepper/cart_stepper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/Items.dart';
import '../widgets/appbar_with_cart_badge.dart';
import '../assistant_methods/cart_methods.dart';

class ItemDetailsScreen extends StatefulWidget {
  Items? model;

  ItemDetailsScreen({super.key, this.model});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final CartMethods _cartMethods = CartMethods();
  int counterLimit = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBarWithCartBadge(
        title: widget.model!.itemTitle.toString(),
        sellerUid: widget.model!.sellerUid,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          int itemCounter = counterLimit;
          //1. check if item exists in the cart. can't be done until we add item into cart
          if (_cartMethods
              .separateItemIdsFromUserCartList()
              !.contains(widget.model!.itemId)) {
            Fluttertoast.showToast(msg: "Item already exists in cart");
          }else{
            //2. add item in cart
            _cartMethods.addItemToCart(
                widget.model!.itemId!, itemCounter, context);
          }
        },
        label: const Text("Add to cart"),
        icon: const Icon(Icons.shopping_cart_rounded),
        backgroundColor: Colors.pinkAccent,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.network(widget.model!.thumbnailUrl.toString())),
            //implement counter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${widget.model!.price} ₹",
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.pink),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CartStepperInt(
                    size: 40,
                    style: const CartStepperStyle(
                      activeBackgroundColor: Colors.pinkAccent,
                    ),
                    value: counterLimit,
                    didChangeCount: (value) {
                      if (value < 1) {
                        Fluttertoast.showToast(
                            msg: "Quantity cannot be less than 1.");
                      } else {
                        setState(() {
                          counterLimit = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                top: 8.0,
              ),
              child: Text(
                "${widget.model!.itemTitle}:",
                textAlign: TextAlign.justify,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.pinkAccent),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0),
              child: Text(
                widget.model!.longDescription.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
