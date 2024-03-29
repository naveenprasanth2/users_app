import 'package:flutter/material.dart';
import 'package:users_app/authScreens/registration_tab_page.dart';

import 'login_tab_page.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.pinkAccent, Colors.purpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.topRight)),
            ),
            title: const Text(
              "iShop",
              style: TextStyle(
                  fontSize: 30, letterSpacing: 3, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            bottom: const TabBar(
              indicatorColor: Colors.white54,
              indicatorWeight: 6,
              tabs: [
                Tab(
                  text: "Login",
                  icon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                ),
                Tab(
                  text: "Register",
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.pinkAccent, Colors.purpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.topRight)),
            child: const TabBarView(children: [
                LoginTabPage(),
                RegistrationTabPage(),
            ]),

          ),
        ));
  }
}
