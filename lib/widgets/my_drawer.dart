import 'package:flutter/material.dart';
import 'package:users_app/helper/sizebox_helper.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black54,
      child: ListView(
        children: [
          //header
          Container(
            padding: const EdgeInsets.only(top: 26, bottom: 12),
            child: Column(
              children: [
                //user profile image
                Container(
                  height: 160,
                  width: 160,
                  child: const CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://img.freepik.com/free-photo/beautiful-natural-landscape_1112-205.jpg?w=1480&t=st=1686910266~exp=1686910866~hmac=66a2b30f1270641e8442237cb86217567e5dbe56f45f92d3b97281314fa9167e"),
                  ),
                ),
                SizedBoxHelper.sizeBox12,
                const Text(
                  "User Name",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBoxHelper.sizeBox12,
          const Divider(
            height: 10,
            color: Colors.grey,
            thickness: 2,
          ),

          //body
          Container(
            padding: const EdgeInsets.only(top: 1),
            child: Container(
              child: Column(
                children: [
                  //home
                  ListTile(
                    leading: const Icon(
                      Icons.home,
                      color: Colors.grey,
                    ),
                    title: const Text(
                      "Home",
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {},
                  ),
                  const Divider(
                    height: 10,
                    color: Colors.grey,
                    thickness: 1,
                  ),

                  //my_orders
                  ListTile(
                    leading: const Icon(
                      Icons.reorder,
                      color: Colors.grey,
                    ),
                    title: const Text(
                      "My Orders",
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {},
                  ),
                  const Divider(
                    height: 10,
                    color: Colors.grey,
                    thickness: 1,
                  ),

                  //not yet received orders button
                  ListTile(
                    leading: const Icon(
                      Icons.picture_in_picture_alt_rounded,
                      color: Colors.grey,
                    ),
                    title: const Text(
                      "Not yet received orders",
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {},
                  ),
                  const Divider(
                    height: 10,
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  //history
                  ListTile(
                    leading: const Icon(
                      Icons.access_time,
                      color: Colors.grey,
                    ),
                    title: const Text(
                      "History",
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {},
                  ),
                  const Divider(
                    height: 10,
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  //search button
                  ListTile(
                    leading: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    title: const Text(
                      "Search",
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {},
                  ),
                  const Divider(
                    height: 10,
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  //logout
                  ListTile(
                    leading: const Icon(
                      Icons.exit_to_app,
                      color: Colors.grey,
                    ),
                    title: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {},
                  ),
                  const Divider(
                    height: 10,
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
