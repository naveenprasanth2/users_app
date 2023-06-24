import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/addressScreens/text_field_address_widget.dart';
import 'package:users_app/global/global.dart';

class SaveNewAddressScreen extends StatefulWidget {
  String? sellerUid;
  double? totalAmount;

  SaveNewAddressScreen({super.key, this.sellerUid, this.totalAmount});

  @override
  State<SaveNewAddressScreen> createState() => _SaveNewAddressScreenState();
}

class _SaveNewAddressScreenState extends State<SaveNewAddressScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController flatHouseNumber = TextEditingController();
  TextEditingController streetName = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController stateCountry = TextEditingController();
  String completeAddress = "";
  final GlobalKey<FormState> _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
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
          "Add New Address",
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_globalKey.currentState!.validate()) {
            completeAddress = "${flatHouseNumber.text}, ${streetName.text},"
                " ${city.text}, ${stateCountry.text}";

            _firebaseFirestore
                .collection("users")
                .doc(sharedPreferences!.getString("uid"))
                .collection("userAddress")
                .doc(DateTime.now().millisecondsSinceEpoch.toString())
                .set({
              "name": name.text,
              "phoneNumber": phoneNumber.text,
              "flatHouseNumber": flatHouseNumber.text,
              "streetName": streetName.text,
              "city": city.text,
              "stateCountry": stateCountry.text,
              "completeAddress": completeAddress
            }).then((value) => Fluttertoast.showToast(
                    msg: "Address has been added successfully"));
            _globalKey.currentState!.reset();
            Navigator.of(context).pop();
          }
        },
        label: const Text(
          "Save Address",
        ),
        icon: const Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 10),
            child: Column(
              children: [
                Form(
                    key: _globalKey,
                    child: Column(
                      children: [
                        TextFieldAddressWidget(
                          controller: name,
                          hint: "Name",
                          message: "Please enter a valid name",
                        ),
                        TextFieldAddressWidget(
                          controller: phoneNumber,
                          hint: "Phone Number",
                          keyBoardType: "number",
                          message: "Please enter a valid name",
                        ),
                        TextFieldAddressWidget(
                          controller: flatHouseNumber,
                          hint: "Flat No.",
                          keyBoardType: "number",
                          message: "Please enter a valid Flat number",
                        ),
                        TextFieldAddressWidget(
                          controller: streetName,
                          hint: "Street Name",
                          message: "Please enter a valid street name",
                        ),
                        TextFieldAddressWidget(
                          controller: city,
                          hint: "City",
                          message: "Please enter a valid city name",
                        ),
                        TextFieldAddressWidget(
                          controller: stateCountry,
                          hint: "State Country",
                          message: "Please enter a valid state country",
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
