import 'package:flutter/material.dart';

class TextFieldAddressWidget extends StatelessWidget {
  String? hint;
  String? message;
  String? keyBoardType;
  TextEditingController? controller;

  TextFieldAddressWidget(
      {super.key, this.hint, this.controller, this.message, this.keyBoardType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          TextFormField(
            scrollPhysics: const BouncingScrollPhysics(),
            keyboardType: keyBoardType == "number"
                ? TextInputType.number
                : TextInputType.text,
            controller: controller,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration.collapsed(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.grey,
              ),
            ),
            validator: (value) => value!.isEmpty ? message : null,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
