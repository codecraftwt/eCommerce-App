import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap; // Change to nullable
  final Color? color;
  final bool isLoading; // Add loading state

  const CustomButton({
    Key? key,
    required this.text,
    this.onTap,
    this.color,
    this.isLoading = false, // Default to false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: isLoading
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(color ?? Colors.white),
            )
          : Text(
              text,
              style: TextStyle(
                color: color == null ? Colors.white : Colors.black,
              ),
            ),
      onPressed: isLoading ? null : onTap, // Disable button when loading
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: color,
      ),
    );
  }
}
