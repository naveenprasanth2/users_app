import 'dart:async';

import 'package:flutter/material.dart';
import 'package:users_app/helper/sizebox_helper.dart';
import 'package:users_app/mainScreens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  splashScreenTimer() {
    Timer(const Duration(seconds: 1), () async {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashScreenTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.pinkAccent, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.topRight)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/welcome.png"),
              SizedBoxHelper.sizeBox12,
              const Text(
                "iShop",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 5,
                    color: Colors.white
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
