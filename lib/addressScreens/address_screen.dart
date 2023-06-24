import 'package:flutter/material.dart';
import 'package:users_app/addressScreens/save_new_address_screen.dart';

class AddressScreen extends StatefulWidget {
  String? sellerUid;
  double? totalAmount;

  AddressScreen({super.key, this.sellerUid, this.totalAmount});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      //2. model
      //3. design


    );
  }
}
