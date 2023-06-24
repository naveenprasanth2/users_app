import 'package:flutter/cupertino.dart';

class TotalAmount extends ChangeNotifier{
  double _totalAmountOfCartItems = 0;

  double get tAmount => _totalAmountOfCartItems;

  showTotalAmountOfCartItems(double totalAmount) async {
    _totalAmountOfCartItems = totalAmount;

    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}