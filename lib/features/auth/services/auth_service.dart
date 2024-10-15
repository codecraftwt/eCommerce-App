import 'dart:convert';
import 'dart:developer';

import 'package:ecommerce_app/Provider/user_provider.dart';
import 'package:ecommerce_app/common/bottom_bar.dart';
import 'package:ecommerce_app/common/custom_tost.dart';
import 'package:ecommerce_app/constants/error_handling.dart';
import 'package:ecommerce_app/constants/global_variables.dart';
import 'package:ecommerce_app/constants/utils.dart';
import 'package:ecommerce_app/features/admin/screen/admin_screen.dart';
import 'package:ecommerce_app/features/auth/screens/auth_screen.dart';
import 'package:ecommerce_app/features/home/screens/home_screen.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

class AuthService {
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String businessSector,
    required String gstNumber,
    required String? userType,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController nameController,
    required TextEditingController phoneNumberController,
    required TextEditingController businessSectorController,
    required TextEditingController gstNumberController,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        password: password,
        email: email,
        address: '',
        type: userType ?? '',
        token: '',
        cart: [],
        phoneNumber: phoneNumber,
        businessSector: businessSector,
        gstNumber: gstNumber,
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          nameController.clear();
          emailController.clear();
          passwordController.clear();
          phoneNumberController.clear();
          businessSectorController.clear();
          gstNumberController.clear();

          toastification.show(
            context: context,
            title:
                const Text('Account created! Login with the same credentials!'),
            autoCloseDuration: const Duration(seconds: 5),
          );
        },
      );
    } catch (e) {
      log('Error: ' + e.toString());
      CommonToast.showToast(
        context: context,
        message: e.toString(),
        autoCloseDuration: const Duration(seconds: 5),
        primaryColor: Colors.red,
      );
    }
  }

  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);

          final userType = jsonDecode(res.body)['type'];
          if (userType == 'Seller') {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AdminScreen.routeName,
              (route) => false,
            );
          } else if (userType == 'Buyer') {
            Navigator.pushNamedAndRemoveUntil(
              context,
              BottomBar.routeName,
              (route) => false,
            );
          }
          emailController.clear();
          passwordController.clear();
        },
      );
    } catch (e) {
      CommonToast.showToast(
        context: context,
        message: 'Failed to sign in. Please check your credentials.',
        autoCloseDuration: const Duration(seconds: 5),
        primaryColor: Colors.red,
      );
    }
  }

  // get user data
  void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('$uri/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      CommonToast.showToast(
        context: context,
        message: e.toString(),
        autoCloseDuration: const Duration(seconds: 5),
        primaryColor: Colors.red,
      );
    }
  }

  void logoutUser(BuildContext context) async {
    try {
      Provider.of<UserProvider>(context, listen: false).resetUser();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('x-auth-token');

      Future.delayed(Duration(milliseconds: 100), () {
        Navigator.pushNamed(context, AuthScreen.routeName);
      });

      CommonToast.showToast(
        context: context,
        message: 'Logged out successfully!',
        autoCloseDuration: const Duration(seconds: 5),
        primaryColor: Colors.green,
      );
    } catch (e) {
      CommonToast.showToast(
        context: context,
        message: e.toString(),
        autoCloseDuration: const Duration(seconds: 5),
        primaryColor: Colors.red,
      );
    }
  }
}
