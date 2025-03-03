import 'package:flutter/material.dart';
import 'package:moviego/CustomUI/linecustom.dart';
import 'package:moviego/LoginWithGoogle/google_auth.dart';
import 'package:moviego/auth/auth_service.dart';
import 'package:moviego/pages/sign_in_password.dart';
import 'package:moviego/pages/snack_bar.dart';
import 'package:moviego/widgets/bottom_app_bar.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Color _facebookButtonColor = const Color.fromARGB(197, 55, 38, 38);
  Color _googleButtonColor = const Color.fromARGB(197, 55, 38, 38);
  Color _appleButtonColor = const Color.fromARGB(197, 55, 38, 38);

  bool _isObscured = true;
  bool _isPressed = false;
  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _userNameController.dispose();
  }

  void signUpUsers() async {
    String res = await AuthService().signUpUser(
      email: _emailController.text,
      userName: _userNameController.text,
      password: _passwordController.text,
    );
    if (res == "Successfully") {
      setState(() {
        isLoading = true;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const MainScreen(),
      ));
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _background(),
          _content(context),
        ],
      ),
    );
  }

  Positioned _background() {
    return Positioned.fill(
      child: Stack(
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
        ],
      ),
    );
  }

  Positioned _content(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      bottom: 0,
      left: screenWidth * 0.05,
      right: screenWidth * 0.05,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/mg.png',
              width: screenWidth * 0.6,
              height: screenHeight * 0.25,
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              "Create Your Account",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Kanit',
                fontSize: screenWidth * 0.08,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Column(
              children: [
                TextFormField(
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: const Color.fromARGB(150, 152, 157, 149),
                      size: screenWidth * 0.05,
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(197, 55, 38, 38),
                    contentPadding: EdgeInsets.all(screenWidth * 0.04),
                    hintText: 'Email',
                    hintStyle: TextStyle(
                      color: const Color.fromARGB(100, 152, 157, 149),
                      fontSize: screenWidth * 0.04,
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(screenWidth * 0.03)),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  controller: _emailController,
                ),
                SizedBox(height: screenHeight * 0.015),
                TextFormField(
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: const Color.fromARGB(150, 152, 157, 149),
                      size: screenWidth * 0.05,
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(197, 55, 38, 38),
                    contentPadding: EdgeInsets.all(screenWidth * 0.04),
                    hintText: 'User Name',
                    hintStyle: TextStyle(
                      color: const Color.fromARGB(100, 152, 157, 149),
                      fontSize: screenWidth * 0.04,
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(screenWidth * 0.03)),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  controller: _userNameController,
                ),
                SizedBox(height: screenHeight * 0.015),
                TextFormField(
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  obscureText: _isObscured,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock,
                      color: const Color.fromARGB(150, 152, 157, 149),
                      size: screenWidth * 0.05,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscured
                            ? Icons.remove_red_eye
                            : Icons.visibility_off,
                        color: const Color.fromARGB(150, 152, 157, 149),
                        size: screenWidth * 0.05,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(197, 55, 38, 38),
                    contentPadding: EdgeInsets.all(screenWidth * 0.04),
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      color: const Color.fromARGB(100, 152, 157, 149),
                      fontSize: screenWidth * 0.04,
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(screenWidth * 0.03)),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  controller: _passwordController,
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
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
                signUpUsers();
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
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                ),
                child: Center(
                  child: Text(
                    "Continue",
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
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                  child: Text(
                    'or',
                    style: TextStyle(
                      color: Colors.white,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    print("Sign In with Facebook");
                  },
                  onTapDown: (_) {
                    setState(() {
                      _facebookButtonColor =
                          const Color.fromARGB(111, 174, 146, 146);
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      _facebookButtonColor =
                          const Color.fromARGB(197, 55, 38, 38);
                    });
                  },
                  onTapCancel: () {
                    setState(() {
                      _facebookButtonColor =
                          const Color.fromARGB(197, 55, 38, 38);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(screenWidth * 0.045),
                    decoration: BoxDecoration(
                      color: _facebookButtonColor,
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                    child: Image.asset(
                      'assets/icon/Facebook-logo.png',
                      width: screenWidth * 0.07,
                      height: screenWidth * 0.07,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                GestureDetector(
                  onTap: () {
                    print("Sign In with Google");
                  },
                  onTapDown: (_) {
                    setState(() {
                      _googleButtonColor =
                          const Color.fromARGB(111, 174, 146, 146);
                    });
                  },
                  onTapUp: (_) async {
                    setState(() {
                      _googleButtonColor =
                          const Color.fromARGB(197, 55, 38, 38);
                    });
                    await FirebaseServices().signInWithGoogle();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(),
                      ),
                    );
                  },
                  onTapCancel: () {
                    setState(() {
                      _googleButtonColor =
                          const Color.fromARGB(197, 55, 38, 38);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(screenWidth * 0.045),
                    decoration: BoxDecoration(
                      color: _googleButtonColor,
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                    child: Image.asset(
                      'assets/icon/Google-logo.png',
                      width: screenWidth * 0.065,
                      height: screenWidth * 0.065,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                GestureDetector(
                  onTap: () {
                    print("Sign In with Apple");
                  },
                  onTapDown: (_) {
                    setState(() {
                      _appleButtonColor =
                          const Color.fromARGB(111, 174, 146, 146);
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      _appleButtonColor = const Color.fromARGB(197, 55, 38, 38);
                    });
                  },
                  onTapCancel: () {
                    setState(() {
                      _appleButtonColor = const Color.fromARGB(197, 55, 38, 38);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(screenWidth * 0.045),
                    decoration: BoxDecoration(
                      color: _appleButtonColor,
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                    child: Image.asset(
                      'assets/icon/Apple-logo.png',
                      width: screenWidth * 0.07,
                      height: screenWidth * 0.07,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
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
                  const TextSpan(text: "You have an account? "),
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
                                builder: (context) => const SignInPass()),
                          );
                        },
                        child: Text(
                          'Sign-in',
                          style: TextStyle(
                            fontFamily: 'Open_Sans_2',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.045,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
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
    );
  }
}
