import 'package:flutter/material.dart';
import 'package:users_app/helper/sizebox_helper.dart';
import 'package:users_app/widgets/custom_text_field.dart';

class LoginTabPage extends StatefulWidget {
  const LoginTabPage({super.key});

  @override
  State<LoginTabPage> createState() => _LoginTabPageState();
}

class _LoginTabPageState extends State<LoginTabPage> {
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBoxHelper.sizeBox12,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/login.png",
              height: MediaQuery.of(context).size.height * 0.40,
            ),
          ),
          //inputs fields
          Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextField(
                    textEditingController: emailEditingController,
                    iconData: Icons.email,
                    hintText: "Email"),
                CustomTextField(
                    textEditingController: passwordTextEditingController,
                    iconData: Icons.lock,
                    isObscure: true,
                    hintText: "Password"),
                SizedBoxHelper.sizeBox30,
              ],
            ),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            ),
            onPressed: () {},
            child: const Text(
              "Sign In",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
