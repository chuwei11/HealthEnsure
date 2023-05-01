import 'package:flutter/cupertino.dart';

class InsuranceProvider with ChangeNotifier {
  late String status;

  filterOrder(status) {
    this.status = status;
    notifyListeners();
  }
}
