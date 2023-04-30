import 'dart:convert';

import 'package:flutter/material.dart';
// this page is to update user details and doctor list during every login
// it pass down the data to all widget treee

class AuthModel extends ChangeNotifier {
  bool _isLogin = false;
  // retrieve latest or update user details during login
  Map<String, dynamic> user = {};
  // retrieve latest or update upcoming appointment during login
  Map<String, dynamic> appointment = {};
  // get the list of updated favorite doctor
  List<Map<String, dynamic>> favDoc = [];
  // get all favourite doc id in list
  List<dynamic> _fav = [];

  bool get isLogin {
    return _isLogin;
  }

  List<dynamic> get getFav {
    return _fav;
  }

  Map<String, dynamic> get getUser {
    return user;
  }

  Map<String, dynamic> get getAppointment {
    return appointment;
  }

// update current fav doc list and notify all the widgets
  void setFavList(List<dynamic> list) {
    _fav = list;
    notifyListeners();
  }

// return the current fav doc list
  List<Map<String, dynamic>> get getFavDoc {
    // clear all the prev record before get the current latest list
    favDoc.clear();

    // list out doctor list according to fav list
    for (var num in _fav) {
      for (var doc in user['doctor']) {
        if (num == doc['doc_id']) {
          favDoc.add(doc);
        }
      }
    }
    return favDoc;
  }

//once successfully login, update the status
  void loginSuccess(
      Map<String, dynamic> userData, Map<String, dynamic> appointmentInfo) {
    _isLogin = true;

    //update all the data during login
    user = userData;
    appointment = appointmentInfo;

    // need to check if the fav list return null
    // bcs initially the fav list is NULL
    if (user['details']['fav'] != null) {
      // the details are return from user controller
      _fav = json.decode(user['details']['fav']);
    }

    notifyListeners();
  }

  // void loginSuccess() {
  //   _isLogin = true;
  //   notifyListeners();
  // }
}
