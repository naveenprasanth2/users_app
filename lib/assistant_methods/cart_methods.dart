import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/global/global.dart';

class CartMethods {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  addItemToCart(String itemId, int counter, BuildContext context) {
    //1. Local Storage
    List<String>? tempList = sharedPreferences!.getStringList("userCart");

   List<String>? newList =  tempList?.where((e) => e.split(":")[0].contains(itemId)).map((e) {
      String key = e.split(":")[0];
      int value = int.parse(e.split(":")[1]);
      value += counter;
      return "$key:$value";
    }).toList();

   newList?.forEach((element) {
     tempList!.removeWhere((tempElement) => tempElement.split(":")[0].contains(element.split(":")[0]));
     tempList.add(element);
   });

    // tempList!.add("$itemId:$counter");
    sharedPreferences!.setStringList("userCart", tempList!);

    //2. Firebase storage
    _firebaseFirestore
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .update({"userCart": tempList}).then((value) {
      Fluttertoast.showToast(msg: "Item added successfully");
    });
  }
}
