import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistant_methods/cart_item_counter.dart';
import 'package:users_app/cartScreens/cart_screen.dart';
import 'package:users_app/models/Items.dart';

class AppBarWithCartBadge extends StatefulWidget
    implements PreferredSizeWidget {
  PreferredSizeWidget? preferredSizeWidget;
  Items? model;
  String? title;

  AppBarWithCartBadge(
      {super.key, this.preferredSizeWidget, this.model, this.title});

  @override
  State<AppBarWithCartBadge> createState() => _AppBarWithCartBadgeState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => preferredSizeWidget == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}

class _AppBarWithCartBadgeState extends State<AppBarWithCartBadge> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title!),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.pinkAccent, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.topRight)),
      ),
      automaticallyImplyLeading: true,
      actions: [
        Stack(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (e) => CartScreen(
                            model: widget.model,
                          )));
                },
                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                )),
            Positioned(
              child: Stack(
                children: [
                  const Icon(
                    Icons.brightness_1,
                    size: 20,
                    color: Colors.deepPurple,
                  ),
                  Positioned(
                    top: 3,
                    right: 5,
                    child: Center(
                      child: Consumer<CartItemCounter>(
                          builder: (context, provider, _) {
                        return Text(
                          provider.count.toString(),
                          style: const TextStyle(color: Colors.white),
                        );
                      }),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
