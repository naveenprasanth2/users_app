import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:users_app/brandsScreens/brands_screen.dart';
import 'package:users_app/sellersScreens/home_screen.dart';
import 'package:users_app/widgets/text_delegate_header_widget.dart';

import '../global/global.dart';
import '../models/Items.dart';
import '../models/brands.dart';
import 'items_ui_design_widget.dart';

class ItemsScreen extends StatefulWidget {
  final Brands? model;

  const ItemsScreen({super.key, this.model});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        title: const Text("iShop"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.pinkAccent, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight)),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
              delegate: TextDelegateHeaderWidget(
                  title: "${widget.model!.brandTitle}'s Items")),
          StreamBuilder(
            stream: _firebaseFirestore
                .collection("sellers")
                .doc(widget.model!.sellerUid)
                .collection("brands")
                .doc(widget.model!.brandId)
                .collection("items")
                .orderBy("publishDate", descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot dataSnapShot) {
              if (dataSnapShot.hasData) {
                //if brands exists
                return SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1,
                  staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                  itemBuilder: (context, index) {
                    Items itemsModel = Items.fromJson(
                        dataSnapShot.data.docs[index].data()
                        as Map<String, dynamic>);
                    return ItemsUiDesignWidget(
                      context: context,
                      model: itemsModel,
                    );
                  },
                  itemCount: dataSnapShot.data.docs.length,
                );
              } else {
                //if brand doesn't exists
                //as we are using slivers make sure using sliverToBoxAdapter
                return const SliverToBoxAdapter(
                    child: Center(
                      child: Text("No items exists"),
                    ));
              }
            },
          )
        ],
      ),
    );
  }
}
