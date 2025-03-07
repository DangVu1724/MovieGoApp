import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moviego/CustomUI/linecustom.dart';
import 'package:moviego/LoginWithGoogle/google_auth.dart';
import 'package:moviego/pages/register.dart';
import 'package:moviego/pages/sign_in_btn.dart';
import 'package:moviego/pages/sign_in_password.dart';
import 'package:moviego/widgets/bottom_app_bar.dart';

class SignInAPI extends StatefulWidget {
  const SignInAPI({super.key});

  @override
  State<SignInAPI> createState() => _SignInAPIState();
}

class _SignInAPIState extends State<SignInAPI> {
  Color _facebookButtonColor = const Color.fromARGB(197, 55, 38, 38);
  Color _facebookTextColor = const Color.fromARGB(162, 255, 255, 255);

  Color _googleButtonColor = const Color.fromARGB(197, 55, 38, 38);
  Color _googleTextColor = const Color.fromARGB(162, 255, 255, 255);

  Color _appleButtonColor = const Color.fromARGB(197, 55, 38, 38);
  Color _appleTextColor = const Color.fromARGB(162, 255, 255, 255);
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          Image.asset(
            'assets/images/BG.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/Movie-imgs.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black,
                  Color.fromARGB(220, 0, 0, 0),
                  Color.fromARGB(160, 0, 0, 0),
                ],
                stops: [0.0, 0.55, 1.0],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: screenWidth * 0.05,
            child: SizedBox(
              width: screenWidth * 0.9,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/mg.png',
                      width: screenWidth * 0.6,
                      height: screenHeight * 0.25,
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      "Welcome Back",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Kanit',
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    SignInButton(
                      text: "Continue with Facebook",
                      iconPath: 'assets/icon/Facebook-logo.png',
                      buttonColor: _facebookButtonColor,
                      textColor: _facebookTextColor,
                      onTap: () {
                        print("Sign In with Facebook");
                      },
                      onTapDown: () {
                        setState(() {
                          _facebookButtonColor =
                              const Color.fromARGB(111, 174, 146, 146);
                          _facebookTextColor = Colors.black;
                        });
                      },
                      onTapUp: () {
                        setState(() {
                          _facebookButtonColor =
                              const Color.fromARGB(197, 55, 38, 38);
                          _facebookTextColor =
                              const Color.fromARGB(162, 255, 255, 255);
                        });
                      },
                      onTapCancel: () {
                        setState(() {
                          _facebookButtonColor =
                              const Color.fromARGB(197, 55, 38, 38);
                          _facebookTextColor =
                              const Color.fromARGB(162, 255, 255, 255);
                        });
                      },
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    SignInButton(
                      text: "Continue with Google",
                      iconPath: 'assets/icon/Google-logo.png',
                      buttonColor: _googleButtonColor,
                      textColor: _googleTextColor,
                      onTap: () {
                        print("Sign In with Google");
                      },
                      onTapDown: () {
                        setState(() {
                          _googleButtonColor =
                              const Color.fromARGB(111, 174, 146, 146);
                          _googleTextColor = Colors.black;
                        });
                      },
                      onTapUp: () async {
                        setState(() {
                          _googleButtonColor =
                              const Color.fromARGB(197, 55, 38, 38);
                          _googleTextColor =
                              const Color.fromARGB(162, 255, 255, 255);
                        });
                        await FirebaseServices().signInWithGoogle();
                        if (FirebaseAuth.instance.currentUser != null) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainScreen()),
                            (Route<dynamic> route) =>
                                false, 
                          );
                        }
                      },
                      onTapCancel: () {
                        setState(() {
                          _googleButtonColor =
                              const Color.fromARGB(197, 55, 38, 38);
                          _googleTextColor =
                              const Color.fromARGB(162, 255, 255, 255);
                        });
                      },
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    SignInButton(
                      text: "Continue with Apple",
                      iconPath: 'assets/icon/Apple-logo.png',
                      buttonColor: _appleButtonColor,
                      textColor: _appleTextColor,
                      onTap: () {
                        print("Sign In with Apple");
                      },
                      onTapDown: () {
                        setState(() {
                          _appleButtonColor =
                              const Color.fromARGB(111, 174, 146, 146);
                          _appleTextColor = Colors.black;
                        });
                      },
                      onTapUp: () {
                        setState(() {
                          _appleButtonColor =
                              const Color.fromARGB(197, 55, 38, 38);
                          _appleTextColor =
                              const Color.fromARGB(162, 255, 255, 255);
                        });
                      },
                      onTapCancel: () {
                        setState(() {
                          _appleButtonColor =
                              const Color.fromARGB(197, 55, 38, 38);
                          _appleTextColor =
                              const Color.fromARGB(162, 255, 255, 255);
                        });
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: DashedDivider(
                            color: const Color.fromARGB(255, 149, 148, 148),
                            dashWidth: screenWidth * 0.01,
                            dashSpace: screenWidth * 0.012,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03),
                          child: Text(
                            'or',
                            style: TextStyle(
                              color: const Color.fromARGB(162, 255, 255, 255),
                              fontSize: screenWidth * 0.045,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: DashedDivider(
                            color: const Color.fromARGB(255, 149, 148, 148),
                            dashWidth: screenWidth * 0.01,
                            dashSpace: screenWidth * 0.012,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          _isPressed = true;
                        });
                      },
                      onTapUp: (_) {
                        setState(() {
                          _isPressed = false;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInPass()),
                        );
                      },
                      onTapCancel: () {
                        setState(() {
                          _isPressed = false;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              const Color(0xFFF6B027)
                                  .withOpacity(_isPressed ? 0.9 : 1.0),
                              const Color(0xFFB27600)
                                  .withOpacity(_isPressed ? 0.9 : 1.0),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "Log in with password",
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.05,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Open_Sans_2',
                          color: Colors.white,
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          const TextSpan(text: "Don't have an account? "),
                          WidgetSpan(
                            child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xFFF6B027),
                                  Color(0xFFB27600),
                                ],
                              ).createShader(bounds),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Register()),
                                  );
                                },
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                    fontFamily: 'Open_Sans_2',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.045,
                                    decoration: TextDecoration.underline,
                                    decorationColor: const Color.fromARGB(
                                        162, 255, 255, 255),
                                    decorationThickness: 2.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
