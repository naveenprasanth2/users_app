import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/splashScreen/splash_screen.dart';
import 'package:users_app/widgets/appbar_with_cart_badge.dart';

import '../assistant_methods/cart_item_counter.dart';
import '../assistant_methods/total_amount.dart';
import '../models/Items.dart';
import 'cart_tem_design_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  List<int>? quantitiesList;
  double totalPrice = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    quantitiesList = cartMethods.separateItemQuantitiesFromUserCartList();
    totalPrice = 0;
    Provider.of<TotalAmount>(context, listen: false)
        .showTotalAmountOfCartItems(totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBarWithCartBadge(
        title: "Cart Contents",
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton.extended(
              //without this hero tag it will show error when using more than one floating action button
              heroTag: "btn1",
              onPressed: () {
                cartMethods.clearCart(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (e) => const SplashScreen()));
              },
              label: const Text("Clear Cart"),
              icon: const Icon(Icons.clear_all),
            ),
            FloatingActionButton.extended(
              //without this hero tag it will show error when using more than one floating action button
              heroTag: "btn2",
              onPressed: () {},
              label: const Text("Checkout"),
              icon: const Icon(Icons.shopping_cart_checkout),
            ),
          ],
        ),
      ),
      body: quantitiesList!.isEmpty
          ? const Center(
              child: Text(
              "No Items to display",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 20),
            ))
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                      color: Colors.black54,
                      child: Consumer2<TotalAmount, CartItemCounter>(
                          builder: (context, amountProvider, cartProvider, c) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: cartProvider.count == 0
                                ? Container()
                                : Text(
                                    "Total Price: $totalPrice",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 2,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        );
                      })),
                ),
                //query
                StreamBuilder(
                    stream: _firebaseFirestore
                        .collection("items")
                        .where("itemId",
                            whereIn:
                                cartMethods.separateItemIdsFromUserCartList())
                        .orderBy("publishDate", descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot dataSnapshot) {
                      if (dataSnapshot.hasData) {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              Items model = Items.fromJson(
                                  dataSnapshot.data.docs[index].data()
                                      as Map<String, dynamic>);
                              if (index == 0) {
                                totalPrice = 0;
                                totalPrice += double.parse(model.price!) *
                                    quantitiesList![index];
                              } else {
                                totalPrice += double.parse(model.price!) *
                                    quantitiesList![index];
                              }

                              if (dataSnapshot.data.docs.length - 1 == index) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((timeStamp) {
                                  Provider.of<TotalAmount>(context,
                                          listen: false)
                                      .showTotalAmountOfCartItems(totalPrice);
                                });
                              }
                              return CartItemDesignWidget(
                                model: model,
                                quantityNumber: quantitiesList?[index],
                              );
                            },
                            childCount: dataSnapshot.data.docs.length,
                          ),
                        );
                      } else {
                        return const SliverToBoxAdapter(
                          child: Center(child: Text("No items in cart")),
                        );
                      }
                    }),

                //model
                //design
              ],
            ),
    );
  }
}
