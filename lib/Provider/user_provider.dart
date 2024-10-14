import 'package:ecommerce_app/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    name: '',
    email: '',
    password: '',
    address: '',
    type: '',
    token: '',
    cart: [],
    phoneNumber: '',
    businessSector: '',
    gstNumber: '',
  );

  User get user => _user;

  // Set user from JSON string with error handling
  void setUser(String userJson) {
    try {
      _user = User.fromJson(userJson);
      notifyListeners();
    } catch (e) {
      print('Failed to set user from JSON: $e');
    }
  }

  // Set user from User model
  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }

  // Reset user data to default state
  void resetUser() {
    _user = User(
      id: '',
      name: '',
      email: '',
      password: '',
      address: '',
      type: '',
      token: '',
      cart: [],
      phoneNumber: '',
      businessSector: '',
      gstNumber: '',
    );
    notifyListeners();
  }
}
