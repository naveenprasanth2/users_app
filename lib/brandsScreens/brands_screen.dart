import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../models/brands.dart';
import '../models/sellers.dart';
import '../widgets/my_drawer.dart';
import 'brands_ui_design_widget.dart';

class BrandsScreen extends StatefulWidget {
  final Sellers? model;

  const BrandsScreen({super.key, this.model});

  @override
  State<BrandsScreen> createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
        drawer: const MyDrawer(),
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
          title: const Text(
            "iShop",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: true,
          centerTitle: true,
        ),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            StreamBuilder(
              stream: _firebaseFirestore
                  .collection("sellers")
                  .doc(widget.model!.uid)
                  .collection("brands")
                  .orderBy("publishDate", descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot dataSnapShot) {
                if (dataSnapShot.hasData) {
                  //if brands exists
                  return SliverStaggeredGrid.countBuilder(
                    crossAxisCount: 1,
                    staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                    itemBuilder: (context, index) {
                      Brands brandsModel = Brands.fromJson(
                          dataSnapShot.data.docs[index].data()
                              as Map<String, dynamic>);
                      return BrandsUiDesignWidget(
                        context: context,
                        model: brandsModel,
                      );
                    },
                    itemCount: dataSnapShot.data.docs.length,
                  );
                } else {
                  //if brand doesn't exists
                  //as we are using slivers make sure using sliverToBoxAdapter
                  return const SliverToBoxAdapter(
                      child: Center(
                    child: Text("No brands exists"),
                  ));
                }
              },
            )
          ],
        ));
  }
}
