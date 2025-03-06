import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moviego/LoginWithGoogle/google_auth.dart';
import 'package:moviego/pages/sign_in_password.dart';
import 'package:moviego/screens/changePassWord.dart';
import 'package:moviego/screens/ticket.dart';
import 'package:moviego/screens/edit_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback? onTabChange;

  const ProfilePage({super.key, this.onTabChange});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<String> _userNameFuture;
  final FirebaseServices _authService = FirebaseServices();

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _userNameFuture = _getUserName(user!.uid);
  }

  Future<String> _getUserName(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists && userDoc.data() != null) {
        return (userDoc.data() as Map<String, dynamic>)['name'] ?? 'User Name';
      }
      return 'User Name';
    } catch (e) {
      return 'User Name';
    }
  }

  void _refreshUserName() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      _userNameFuture = _getUserName(user!.uid);
    });
  }

  Future<void> signOut() async {
    bool success = await _authService.googleSignOut();
    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInPass()),
      );
    } else {
      print("Sign out failed");
    }
  }

  void showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Log Out',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(); // Đóng dialog
                    await signOut(); // Gọi hàm signOut
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Colors.yellow),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: ListView(
          children: [
            SizedBox(height: screenHeight * 0.06),
            Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      user?.photoURL ?? '',
                      width: screenWidth * 0.2,
                      height: screenWidth * 0.2,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/avatar.png',
                          fit: BoxFit.cover,
                          width: screenWidth * 0.2,
                          height: screenWidth * 0.2,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<String>(
                          future: _userNameFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator(
                                  color: Colors.white);
                            }
                            if (snapshot.hasError) {
                              return const Text(
                                'Error',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                            return Text(
                              snapshot.data ?? 'User Name',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.08,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.email,
                              color: Colors.grey,
                              size: screenWidth * 0.04,
                            ),
                            SizedBox(width: screenWidth * 0.01),
                            Text(
                              user?.email ?? 'email@example.com',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditProfile()),
                      );
                      _refreshUserName();
                    },
                    child: Image.asset(
                      'assets/images/edit-2.png',
                      width: screenWidth * 0.06,
                      height: screenWidth * 0.06,
                      fit: BoxFit.contain,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.06),
            _buildMenuItem(
              context,
              imagePath: 'assets/images/ticket-2.png',
              title: "My ticket",
              onTap: () {
                if (widget.onTabChange != null) {
                  widget.onTabChange!();
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TicketPage()),
                  );
                }
              },
              screenHeight: screenHeight,
              showDivider: true,
            ),
            _buildMenuItem(
              context,
              imagePath: 'assets/images/shopping-cart.png',
              title: "Payment history",
              onTap: () {},
              screenHeight: screenHeight,
              showDivider: true,
            ),
            _buildMenuItem(
              context,
              imagePath: 'assets/images/translate.png',
              title: "Change language",
              onTap: () {},
              screenHeight: screenHeight,
              showDivider: true,
            ),
            _buildMenuItem(
              context,
              imagePath: 'assets/images/lock.png',
              title: "Change password",
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChangePassScreen()));
              },
              screenHeight: screenHeight,
              showDivider: true,
            ),
            _buildMenuItem(
              context,
              imagePath: 'assets/images/logout.png',
              title: "Log out",
              onTap: showLogoutDialog,
              screenHeight: screenHeight,
              showDivider: false,
              isLogout: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String imagePath,
    required String title,
    required VoidCallback onTap,
    required double screenHeight,
    required bool showDivider,
    bool isLogout = false,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    bool isPressed = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            GestureDetector(
              onTapDown: (_) {
                setState(() {
                  isPressed = true;
                });
              },
              onTapUp: (_) {
                setState(() {
                  isPressed = false;
                });
                onTap();
              },
              onTapCancel: () {
                setState(() {
                  isPressed = false;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                color: isPressed
                    ? Colors.white.withOpacity(0.6)
                    : Colors.transparent,
                child: ListTile(
                  leading: Image.asset(
                    imagePath,
                    width: screenWidth * 0.08,
                    height: screenWidth * 0.08,
                    fit: BoxFit.contain,
                    color: isPressed ? Colors.black : null,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.error,
                        color: isPressed ? Colors.black : Colors.white,
                        size: screenWidth * 0.08,
                      );
                    },
                  ),
                  title: Text(
                    title,
                    style: TextStyle(
                      color: isPressed
                          ? Colors.black
                          : const Color.fromARGB(230, 255, 255, 255),
                      fontSize: screenWidth * 0.04,
                      fontFamily: 'Open_Sans_1',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: isLogout
                      ? null
                      : Icon(
                          Icons.chevron_right,
                          color: isPressed ? Colors.black : Colors.grey,
                          size: screenWidth * 0.08,
                        ),
                ),
              ),
            ),
            if (showDivider)
              Container(
                height: 1,
                color: Colors.grey.withOpacity(0.3),
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
              ),
          ],
        );
      },
    );
  }
}
