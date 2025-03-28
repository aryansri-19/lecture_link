import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUser(
      {required String email,
      required String password,
      required String username}) async {
    String res = 'Could not sign in';
    try {
      if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
        User? user = (await _auth.createUserWithEmailAndPassword(
                email: email, password: password))
            .user;
        res = 'Success';
        if (user != null) {
          user.updateDisplayName(username);
          await _firestore.collection('users').doc(user.uid).set({
            'username': username,
            'email': email,
            'password': password,
            "status": "Unavailable",
            "uid": _auth.currentUser!.uid,
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        res = 'Such a weak password. Try again.';
      } else if (e.code == 'email-already-in-use') {
        res = 'Email already registered.';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'Could not log in';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        User? user = (await _auth.signInWithEmailAndPassword(
                email: email, password: password))
            .user;
        res = 'Success';
        QuerySnapshot<Map<String, dynamic>> getUser = await _firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .get();
        String username = getUser.docs[0]['username'];
        if (user != null) {
          user.updateDisplayName(username);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = 'Sign Up First. Duh!';
      } else if (e.code == 'wrong-password') {
        res = "That's not your password";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> signOut() async {
    String res = 'Error signing out';
    try {
      String? userUid = _auth.currentUser!.uid;
      await _firestore.collection("users").doc(userUid).update({
        "status": "Offline",
      });
      await _auth.signOut();
      res = 'Signed out successfully';
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<String> deleteUser() async {
    String res = "Error deleting account";
    try {
      User? user = _auth.currentUser!;
      await user.delete();
      res = "Account Deleted";
    } catch (e) {
      print(e);
    }
    return res;
  }
}
