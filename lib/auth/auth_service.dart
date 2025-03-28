import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUpUser({
    required String email,
    required String userName,
    required String password,
  }) async {
    String res = "Something went wrong";
    try {
      if (email.isNotEmpty && password.isNotEmpty && userName.isNotEmpty) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await _firestore.collection("users").doc(credential.user!.uid).set({
          'uid': credential.user!.uid,
          'name': userName,
          'email': email,
          'password': password,
          'authMethod': 'email/password',
        });
        res = "Successfully";
      } else {
        res = "Please enter all text fields";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        res = "Network error: Please check your internet connection.";
      } else {
        res = "Error: ${e.message}";
      }
    } catch (e) {
      res = "Unexpected error: ${e.toString()}";
    }
    return res;
  }

  Future<String> signinUser({
    required String email,
    required String password,
  }) async {
    String res = "Something went wrong";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "Successfully";
      } else {
        res = "Please enter all text fields";
      }
    } catch (e) {
      res = "Unexpected error: ${e.toString()}";
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String> getUserName() async {
    User? user = _auth.currentUser;
    if (user != null) {
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        return user.displayName!;
      }
      DocumentSnapshot userDoc =
          await _firestore.collection("users").doc(user.uid).get();
      if (userDoc.exists && userDoc.data() != null) {
        return (userDoc.data() as Map<String, dynamic>)['name'] ?? "Guest";
      }
    }
    return "Guest";
  }
}
