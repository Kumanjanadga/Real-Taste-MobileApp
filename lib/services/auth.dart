import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register with email and password and save additional user data
  Future<User?> registerWithEmailAndPassword(String email, String password, {Map<String, String>? userData}) async {
    try {
      print('Attempting registration for $email');
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      User? user = result.user;
      if (user != null && userData != null) {
        try {
          await _firestore.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'email': email.trim(),
            'firstName': userData['firstName'] ?? '',
            'lastName': userData['lastName'] ?? '',
            'address': userData['address'] ?? '',
            'createdAt': FieldValue.serverTimestamp(),
            'lastUpdated': FieldValue.serverTimestamp(),
          });
        } catch (firestoreError) {
          print('Firestore Error: $firestoreError');
        }
      }
      print('Registration successful for $email');
      return user;
    } catch (e) {
      print('Registration Error: $e');
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return user;
    } catch (e) {
      print('Sign In Error: $e');
      return null;
    }
  }

  // Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print('Sign Out Error: $e');
      return null;
    }
  }

  // Get current user
  User? get currentUser {
    return _auth.currentUser;
  }

  // Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print('Get User Data Error: $e');
      return null;
    }
  }

  // Update user data
  Future<bool> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      data['lastUpdated'] = FieldValue.serverTimestamp();
      await _firestore.collection('users').doc(uid).update(data);
      return true;
    } catch (e) {
      print('Update User Data Error: $e');
      return false;
    }
  }

  // Delete user account and data
  Future<bool> deleteUserAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).delete();
        await user.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Delete Account Error: $e');
      return false;
    }
  }

  // Stream of auth changes
  Stream<User?> get user {
    return _auth.authStateChanges();
  }
}