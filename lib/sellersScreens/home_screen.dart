import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/push_notifications/push_notifications_system.dart';
import 'package:users_app/sellersScreens/sellers_ui_design_widget.dart';
import 'package:users_app/widgets/my_drawer.dart';
import 'package:users_app/global/global.dart';

import '../models/sellers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.generateDeviceRecognitionToken();
    pushNotificationSystem.whenNotificationReceived();
    cartMethods.clearCart(context);
  }

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
        centerTitle: true,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.20,
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                  options: CarouselOptions(
                    //among the 30%, we take 90% in it. refer the top line
                    height: MediaQuery.of(context).size.height * 0.9,
                    aspectRatio: 18 / 9,
                    viewportFraction: 0.9,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.3,
                    scrollPhysics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                  ),
                  items: itemsImageList.map((index) {
                    return Builder(builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 1.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            index,
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    });
                  }).toList(),
                ),
              ),
            ),
          ),
          StreamBuilder(
            stream: _firebaseFirestore.collection("sellers").snapshots(),
            builder: (context, AsyncSnapshot dataSnapshot) {
              if (dataSnapshot.hasData) {
                return SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1,
                  staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                  itemBuilder: (context, index) {
                    Sellers model = Sellers.fromJson(
                        dataSnapshot.data.docs[index].data()
                            as Map<String, dynamic>);
                    return SellersUiDesignWidget(
                      model: model,
                    );
                  },
                  itemCount: dataSnapshot.data.docs.length,
                );
              } else {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text("No data exists"),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
