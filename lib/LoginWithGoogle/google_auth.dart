import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices {
  final auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        print("Google Sign-In canceled by user");
        return false;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential userCredential =
          await auth.signInWithCredential(authCredential);
      User? user = userCredential.user;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection("users").doc(user.uid).get();
        if (!userDoc.exists) {
          await _firestore.collection("users").doc(user.uid).set({
            'uid': user.uid,
            'name': googleSignInAccount.displayName ?? "Google User",
            'email': googleSignInAccount.email,
            'password': null,
            'authMethod': 'google',
          });
        }
      }

      print("Google Sign-In successful");
      return true;
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.message}");
      return false;
    } catch (e) {
      print("Unexpected error during Google Sign-In: $e");
      return false;
    }
  }

  Future<bool> googleSignOut() async {
    try {
      await googleSignIn.disconnect();
      await googleSignIn.signOut();
      await auth.signOut();
      print("Sign out successful");
      return true;
    } catch (e) {
      print("Error during sign out: $e");
      return false;
    }
  }
}
