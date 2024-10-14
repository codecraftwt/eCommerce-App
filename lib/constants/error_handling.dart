import 'dart:convert';
import 'package:ecommerce_app/common/custom_tost.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      try {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        if (errorResponse['errors'] != null) {
          for (var error in errorResponse['errors']) {
            CommonToast.showToast(
              context: context,
              message: error.toString(), 
              primaryColor: Colors.red,
            );
          }
        } else {
          CommonToast.showToast(
            context: context,
            message: errorResponse['msg'] ?? 'Validation error',
            primaryColor: Colors.red,
          );
        }
      } catch (e) {
        CommonToast.showToast(
          context: context,
          message: 'An unexpected error occurred.',
          primaryColor: Colors.red,
        );
      }
      break;
    case 500:
      CommonToast.showToast(
        context: context,
        message: 'Server error: ${response.body}',
        primaryColor: Colors.red,
      );
      break;
    default:
      CommonToast.showToast(
        context: context,
        message: 'Unexpected error occurred. Please try again.',
        primaryColor: Colors.orange,
      );
  }
}
