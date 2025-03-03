import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final VoidCallback onTap;
  final Color buttonColor;
  final Color textColor;
  final void Function() onTapDown;
  final void Function() onTapUp;
  final void Function() onTapCancel;

  const SignInButton({
    super.key,
    required this.text,
    required this.iconPath,
    required this.onTap,
    required this.buttonColor,
    required this.textColor,
    required this.onTapDown,
    required this.onTapUp,
    required this.onTapCancel,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      onTapDown: (_) => onTapDown(),
      onTapUp: (_) => onTapUp(),
      onTapCancel: onTapCancel,
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
        ),
        width: screenWidth * 0.9,
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                iconPath,
                width: screenWidth * 0.06,
                height: screenWidth * 0.06,
                fit: BoxFit.contain,
              ),
              SizedBox(width: screenWidth * 0.02),
              Text(
                text,
                style: TextStyle(
                    color: textColor,
                    fontSize: screenWidth * 0.042,
                    fontFamily: 'Open_Sans_1',
                    fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
