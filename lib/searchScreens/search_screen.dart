import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:users_app/sellersScreens/sellers_ui_design_widget.dart';

import '../models/sellers.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String sellerNameText = "";
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Future<QuerySnapshot>? storesDocumentsList;

  initializeSearchingStores(String sellerNameText) async {
    storesDocumentsList = firebaseFirestore
        .collection("sellers")
        .where("name", isGreaterThanOrEqualTo: sellerNameText)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: [
                  Colors.pinkAccent,
                  Colors.purpleAccent,
                ]),
          ),
        ),
        title: TextField(
          onChanged: (textEntered) {
            setState(() {
              textEntered = textEntered;
            });
            initializeSearchingStores(sellerNameText);
          },
          decoration: InputDecoration(
            hintText: "Enter seller name...",
            hintStyle: const TextStyle(color: Colors.white54),
            suffixIcon: IconButton(
              onPressed: () {
                initializeSearchingStores(sellerNameText);
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white54,
              ),
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
        future: storesDocumentsList,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                Sellers model = Sellers.fromJson(
                    snapshot.data.docs[index].data() as Map<String, dynamic>);
                return SellersUiDesignWidget(
                  model: model,
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                "No Seller Found",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }
        },
      ),
    );
  }
}
