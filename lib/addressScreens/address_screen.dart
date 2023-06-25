import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/addressScreens/address_design_widget.dart';
import 'package:users_app/addressScreens/save_new_address_screen.dart';
import 'package:users_app/assistant_methods/address_changer.dart';
import 'package:users_app/global/global.dart';

import '../models/address.dart';

class AddressScreen extends StatefulWidget {
  String? sellerUid;
  double? totalAmount;

  AddressScreen({super.key, this.sellerUid, this.totalAmount});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class
_AddressScreenState extends State<AddressScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

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
          "Select Address",
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (e) => SaveNewAddressScreen(
                    sellerUid: widget.sellerUid,
                    totalAmount: widget.totalAmount,
                  )));
        },
        label: const Text("Add New Address"),
        icon: const Icon(
          Icons.add_location,
          color: Colors.white,
        ),
      ),
      //1. query
      body: Column(
        children: [
          Consumer<AddressChanger>(builder: (context, address, c) {
            return Flexible(
                child: StreamBuilder(
              stream: _firebaseFirestore
                  .collection("users")
                  .doc(sharedPreferences!.getString("uid"))
                  .collection("userAddress")
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.docs.length > 0) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return AddressDesignWidget(
                          addressModel: Address.fromJson(
                              snapshot.data.docs[index].data()
                                  as Map<String, dynamic>),
                          index: address.count,
                          value: index,
                          addressId: snapshot.data.docs[index].id,
                          totalAmount: widget.totalAmount,
                          sellerUid: widget.sellerUid,
                        );
                      },
                      itemCount: snapshot.data.docs.length,
                    );
                  } else {
                    return const Center(child: Text("No address found"));
                  }
                } else {
                  return const Center(child: Text("No address found"));
                }
              },
            ));
          }),
        ],
      ),
      //2. model done
      //3. design done
    );
  }
}
