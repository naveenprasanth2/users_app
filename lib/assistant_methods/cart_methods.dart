import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistant_methods/cart_item_counter.dart';
import 'package:users_app/global/global.dart';

class CartMethods {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  addItemToCart(String itemId, int counter, BuildContext context) {
    //1. Local Storage
    List<String>? tempList = sharedPreferences!.getStringList("userCart");

    // List<String>? newList =  tempList?.where((e) => e.split(":")[0].contains(itemId)).map((e) {
    //    String key = e.split(":")[0];
    //    int value = int.parse(e.split(":")[1]);
    //    value += counter;
    //    return "$key:$value";
    //  }).toList();
    //
    // newList?.forEach((element) {
    //   tempList!.removeWhere((tempElement) => tempElement.split(":")[0].contains(element.split(":")[0]));
    //   tempList.add(element);
    // });

    tempList!.add("$itemId:$counter");
    sharedPreferences!.setStringList("userCart", tempList);

    //2. Firebase storage
    _firebaseFirestore
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .update({"userCart": tempList}).then((value) {
      Fluttertoast.showToast(msg: "Item added successfully");
    });
    Provider.of<CartItemCounter>(context, listen: false)
        .showCartListItemsNumber();
  }

  clearCart(BuildContext context) {
    sharedPreferences!.setStringList("userCart", ["defaultValue"]);
    List<String>? emptyList = sharedPreferences!.getStringList("userCart");

    _firebaseFirestore
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .update({"userCart": emptyList}).then((value) =>
            Fluttertoast.showToast(msg: "Items deleted successfully"));
    Provider.of<CartItemCounter>(context, listen: false)
        .showCartListItemsNumber();
  }

  List<String>? separateItemIdsFromUserCartList() {
    List<String>? userCartList = sharedPreferences!.getStringList("userCart");

    List<String>? itemsIdsList = userCartList
        ?.where((element) => element.contains(":"))
        .map((e) => e.split(":")[0])
        .toList();
    return itemsIdsList;
  }

  List<int>? separateItemQuantitiesFromUserCartList() {
    List<String>? userCartList = sharedPreferences!.getStringList("userCart");

    List<int>? quantityList = userCartList
        ?.where(
          (element) => element.contains(":"),
        )
        .map((e) => int.parse(e.split(":")[1]))
        .toList();
    return quantityList;
  }
}
