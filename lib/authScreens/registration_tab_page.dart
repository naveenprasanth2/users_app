import 'package:flutter/material.dart';

import '../helper/sizebox_helper.dart';
import '../widgets/custom_text_field.dart';

class RegistrationTabPage extends StatefulWidget {
  const RegistrationTabPage({super.key});

  @override
  State<RegistrationTabPage> createState() => _RegistrationTabPageState();
}

class _RegistrationTabPageState extends State<RegistrationTabPage> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmPasswordTextEditingController =
      TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBoxHelper.sizeBox12,
          //get image for profile
          GestureDetector(
            onTap: () {},
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.20,
              child: Icon(
                Icons.add_photo_alternate,
                color: Colors.grey,
                size: MediaQuery.of(context).size.width * 0.20,
              ),
            ),
          ),
          SizedBoxHelper.sizeBox12,
          //inputs fields

          //username
          Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextField(
                    textEditingController: nameTextEditingController,
                    iconData: Icons.person,
                    hintText: "User Name"),
                CustomTextField(
                    textEditingController: emailTextEditingController,
                    iconData: Icons.email,
                    hintText: "Email"),
                CustomTextField(
                    textEditingController: passwordTextEditingController,
                    iconData: Icons.lock,
                    isObscure: true,
                    hintText: "Password"),
                CustomTextField(
                    textEditingController: passwordTextEditingController,
                    iconData: Icons.lock,
                    isObscure: true,
                    hintText: "Confirm Password"),
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
              "Sign Up",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBoxHelper.sizeBox30,
        ],
      ),
    );
  }
}
