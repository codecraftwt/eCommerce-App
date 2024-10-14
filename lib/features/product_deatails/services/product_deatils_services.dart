import 'dart:convert';

import 'package:ecommerce_app/Provider/user_provider.dart';
import 'package:ecommerce_app/common/custom_tost.dart';
import 'package:ecommerce_app/constants/error_handling.dart';
import 'package:ecommerce_app/constants/global_variables.dart';
import 'package:ecommerce_app/constants/utils.dart';
import 'package:ecommerce_app/features/cart/screens/cart_screen.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class ProductDetailsServices {
  void addToCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/add-to-cart'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id!,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User user =
              userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
          userProvider.setUserFromModel(user);
          CommonToast.showToast(
            context: context,
            message: 'Item added to cart!',
            type: ToastificationType.success,
            primaryColor: Colors.green,
          );
          Navigator.pushReplacementNamed(context, CartScreen.routeName);
        },
      );
    } catch (e) {
      CommonToast.showToast(
        context: context,
        message: e.toString(),
        type: ToastificationType.error,
        primaryColor: Colors.red,
      );
    }
  }

  void rateProduct({
    required BuildContext context,
    required Product product,
    required double rating,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/rate-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({'id': product.id, 'rating': rating}),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          CommonToast.showToast(
            context: context,
            message: "Added the Rating",
            type: ToastificationType.success,
            primaryColor: Colors.green,
          );
        },
      );
    } catch (e) {
      CommonToast.showToast(
        context: context,
        message: e.toString(),
        type: ToastificationType.error,
        primaryColor: Colors.red,
      );
    }
  }
}
