import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistant_methods/address_changer.dart';

import '../models/address.dart';

class AddressDesignWidget extends StatefulWidget {
  Address? addressModel;
  int? index;
  int? value;
  String? addressId;
  double? totalAmount;
  String? sellerUid;

  AddressDesignWidget({
    super.key,
    this.addressModel,
    this.index,
    this.value,
    this.addressId,
    this.totalAmount,
    this.sellerUid,
  });

  @override
  State<AddressDesignWidget> createState() => _AddressDesignWidgetState();
}

class _AddressDesignWidgetState extends State<AddressDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black54,
      child: Column(
        children: [
          Row(
            children: [
              Radio(
                groupValue: widget.index,
                value: widget.value!,
                activeColor: Colors.pink,
                onChanged: (val) {
                  //provider
                  Provider.of<AddressChanger>(context, listen: false)
                      .showSelectedAddress(val);
                },
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Table(
                      children: [
                        TableRow(children: [
                          const Text(
                            "Name: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.addressModel!.name!,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                        const TableRow(children: [
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ]),
                        TableRow(children: [
                          const Text(
                            "Phone Number: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.addressModel!.phoneNumber!,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                        const TableRow(children: [
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ]),
                        TableRow(children: [
                          const Text(
                            "Complete Address: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.addressModel!.completeAddress!,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                        const TableRow(children: [
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          widget.value == Provider.of<AddressChanger>(context).count
              ? ElevatedButton(
                  onPressed: () {
                    //send user to order screen
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Proceed"),
                )
              : Container(),
        ],
      ),
    );
  }
}
