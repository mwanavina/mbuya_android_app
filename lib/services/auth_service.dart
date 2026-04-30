// lib/services/auth_service.dart
//
// Mbuya — Firebase Auth Service
// All Firebase Auth calls live here. Screens never touch
// Firebase directly — they only call these methods.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Singleton so the same instance is reused everywhere
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth     _auth      = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn     _google    = GoogleSignIn();

  // ── Current user ──────────────────────────────────────────
  User? get currentUser => _auth.currentUser;

  // Stream that emits whenever auth state changes
  // (signed in, signed out, token refreshed)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── Sign Up with email + password ────────────────────────
  // Returns null on success, or an error message string on failure
  Future<String?> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      // 1. Create the Firebase Auth account
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user!;

      // 2. Update the display name in Auth
      await user.updateDisplayName(name);

      // 3. Send email verification
      await user.sendEmailVerification();

      // 4. Create the user document in Firestore
      //    This is the users/{uid} document from your schema
      await _firestore.collection('users').doc(user.uid).set({
        'uid':                user.uid,
        'display_name':       name,
        'email':              email,
        'phone':              phone,
        'avatar_url':         '',
        'role':               'traveller',
        'status':             'active',
        'fcm_token':          '',
        'preferred_language': 'en',
        'created_at':         FieldValue.serverTimestamp(),
        'last_seen':          FieldValue.serverTimestamp(),
      });

      return null; // success

    } on FirebaseAuthException catch (e) {
      return _authErrorMessage(e.code);
    } catch (e) {
      return 'Something went wrong. Please try again.';
    }
  }

  // ── Sign In with email + password ────────────────────────
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update last_seen on every sign in
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        final userDoc = _firestore.collection('users').doc(uid);
        final docSnapshot = await userDoc.get();

        if (docSnapshot.exists) {
          await userDoc.update({
            'last_seen': FieldValue.serverTimestamp(),
          });
        } else {
          // If the auth user exists but the firestore doc doesn't (rare sync issue)
          await userDoc.set({
            'uid':                uid,
            'display_name':       _auth.currentUser?.displayName ?? '',
            'email':              email,
            'phone':              '',
            'avatar_url':         '',
            'role':               'traveller',
            'status':             'active',
            'fcm_token':          '',
            'preferred_language': 'en',
            'created_at':         FieldValue.serverTimestamp(),
            'last_seen':          FieldValue.serverTimestamp(),
          });
        }
      }

      return null; // success

    } on FirebaseAuthException catch (e) {
      return _authErrorMessage(e.code);
    } catch (e) {
      return 'Something went wrong. Please try again.';
    }
  }

  // ── Sign In with Google ──────────────────────────────────
  Future<String?> signInWithGoogle() async {
    try {
      // 1. Trigger the Google sign-in flow
      final googleUser = await _google.signIn();
      if (googleUser == null) return 'Sign in cancelled.';

      // 2. Get the auth details from the Google account
      final googleAuth = await googleUser.authentication;

      // 3. Create a Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Sign in to Firebase
      final userCredential =
      await _auth.signInWithCredential(credential);
      final user = userCredential.user!;

      // 5. check if the Firestore user document exists
      final userDoc = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        await userDoc.set({
          'uid':                user.uid,
          'display_name':       user.displayName ?? '',
          'email':              user.email ?? '',
          'phone':              user.phoneNumber ?? '',
          'avatar_url':         user.photoURL ?? '',
          'role':               'traveller',
          'status':             'active',
          'fcm_token':          '',
          'preferred_language': 'en',
          'created_at':         FieldValue.serverTimestamp(),
          'last_seen':          FieldValue.serverTimestamp(),
        });
      } else {
        // Existing user — just update last_seen
        await userDoc.update({
          'last_seen': FieldValue.serverTimestamp(),
        });
      }

      return null; // success

    } on FirebaseAuthException catch (e) {
      return _authErrorMessage(e.code);
    } catch (e) {
      return 'Google sign-in failed. Please try again.';
    }
  }

  // ── Password reset ───────────────────────────────────────
  Future<String?> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return _authErrorMessage(e.code);
    }
  }

  // ── Sign Out ─────────────────────────────────────────────
  Future<void> signOut() async {
    await _google.signOut(); // clears Google session too
    await _auth.signOut();
  }

  // ── Fetch Firestore user profile ─────────────────────────
  Future<Map<String, dynamic>?> getUserProfile() async {
    final uid = currentUser?.uid;
    if (uid == null) return null;

    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data();
  }

  // ── Update FCM token (call this after getting token) ──────
  Future<void> updateFcmToken(String token) async {
    final uid = currentUser?.uid;
    if (uid == null) return;
    await _firestore.collection('users').doc(uid).update({
      'fcm_token': token,
    });
  }

  // ── Human-readable Firebase error messages ───────────────
  String _authErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password is too weak. Use at least 8 characters.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'network-request-failed':
        return 'No internet connection. Please check your network.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}