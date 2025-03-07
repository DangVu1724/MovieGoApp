import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moviego/CustomUI/linecustom.dart';
import 'package:moviego/LoginWithGoogle/google_auth.dart';
import 'package:moviego/auth/auth_service.dart';
import 'package:moviego/pages/register.dart';
import 'package:moviego/pages/snack_bar.dart';
import 'package:moviego/widgets/bottom_app_bar.dart';

class SignInPass extends StatefulWidget {
  const SignInPass({super.key});

  @override
  State<SignInPass> createState() => _SignInPassState();
}

class _SignInPassState extends State<SignInPass> {
  Color _facebookButtonColor = const Color.fromARGB(197, 55, 38, 38);
  Color _googleButtonColor = const Color.fromARGB(197, 55, 38, 38);
  Color _appleButtonColor = const Color.fromARGB(197, 55, 38, 38);

  bool _isObscured = true;
  bool _isChecked = false;
  bool _isPressed = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailForgot = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailForgot.dispose();
  }

  void signUpUsers() async {
    String res = await AuthService().signinUser(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (res == "Successfully") {
      setState(() {
        isLoading = true;
      });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
        (Route<dynamic> route) => false, // 👈 Xóa tất cả màn hình trước đó
      );
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
              "Login to Your Account",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Kanit',
                fontSize: screenWidth * 0.08,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    controller: _emailController,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.04,
                    ),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: Color.fromARGB(150, 152, 157, 149),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(197, 55, 38, 38),
                      contentPadding: EdgeInsets.all(16),
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(100, 152, 157, 149),
                        fontSize: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  TextFormField(
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    controller: _passwordController,
                    obscureText: _isObscured,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.04,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Color.fromARGB(150, 152, 157, 149),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscured
                              ? Icons.remove_red_eye
                              : Icons.visibility_off,
                          color: const Color.fromARGB(150, 152, 157, 149),
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(197, 55, 38, 38),
                      contentPadding: const EdgeInsets.all(16),
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(100, 152, 157, 149),
                        fontSize: 18,
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: screenWidth * 0.06,
                            height: screenWidth * 0.06,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white),
                            ),
                            child: Checkbox(
                              value: _isChecked,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _isChecked = newValue ?? false;
                                });
                              },
                              activeColor: Colors.transparent,
                              checkColor: Colors.white,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              splashRadius: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Text(
                            "Remember me",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.045,
                              fontFamily: 'Open_Sans_1',
                            ),
                          ),
                        ],
                      ),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 246, 176, 39),
                            Color.fromARGB(255, 178, 118, 0),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ).createShader(bounds),
                        child: GestureDetector(
                          onTap: () {
                            myDialogBox(context);
                          },
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              color: Colors.white,
                              fontFamily: 'Open_Sans_1',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
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
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "Sign in",
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
            SizedBox(height: screenHeight * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: DashedDivider(
                    color: Color.fromARGB(255, 149, 148, 148),
                    dashWidth: 4.5,
                    dashSpace: 5,
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
                const Expanded(
                  child: DashedDivider(
                    color: Color.fromARGB(255, 149, 148, 148),
                    dashWidth: 4.5,
                    dashSpace: 5,
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
                      borderRadius: BorderRadius.circular(12),
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
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                    await FirebaseServices().signInWithGoogle();
                    Navigator.of(context).pop();
                    if (FirebaseAuth.instance.currentUser != null) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                        (Route<dynamic> route) =>
                            false, // 👈 Xóa tất cả màn hình trước đó
                      );
                    }
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
                      borderRadius: BorderRadius.circular(12),
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
                      borderRadius: BorderRadius.circular(12),
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
            SizedBox(height: screenHeight * 0.015),
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
                              builder: (context) => const Register(),
                            ),
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

  void myDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Forgot Your Password",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailForgot,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter the Email",
                    hintText: "eg abcd@gmail.com",
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () async {
                    await _auth
                        .sendPasswordResetEmail(email: _emailForgot.text)
                        .then((value) {
                      showSnackBar(
                        context,
                        "We have send you the reset password link to your email,Please check it",
                      );
                    }).onError((error, stackTrace) {
                      showSnackBar(context, error.toString());
                    });
                    Navigator.pop(context);
                    _emailForgot.clear();
                  },
                  child: const Text(
                    "Send",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
