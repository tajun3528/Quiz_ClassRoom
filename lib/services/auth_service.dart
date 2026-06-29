
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseAuthException, User;
import '../Shared_Preferance_Manager/Shared_preferance.dart';


class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// In-memory flag — set sync on signIn/signUp, cleared on signOut.
  /// Used by GoRouter's sync redirect to avoid the async black-screen delay.
  static bool _loggedIn = false;

  /// Sync getter — no SharedPreferences call. Returns the in-memory flag.
  static bool get isLoggedInSync => _loggedIn;

  // --- Check if user is already logged in (async, reads SharedPreferences) ---
  static Future<bool> isLoggedIn() async {
    if (!_loggedIn) {
      _loggedIn = await SharedPreserance.isLoggedIn();
    }
    return _loggedIn;
  }

  // --- Get saved email (for display) ---
  static Future<String?> getSavedEmail() => SharedPreserance.getEmail();

  // --- Login ---
  static Future<User?> signIn(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      _loggedIn = true;
      await SharedPreserance.setLoggedIn(true);
      await SharedPreserance.setEmail(email.trim());
      return cred.user;
    } on FirebaseAuthException catch (e) {
      throw _mapError(e);
    }
  }

  // --- Register ---
  static Future<User?> signUp(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      _loggedIn = true;
      await SharedPreserance.setLoggedIn(true);
      await SharedPreserance.setEmail(email.trim());
      return cred.user;
    } on FirebaseAuthException catch (e) {
      throw _mapError(e);
    }
  }

  // --- Forgot Password ---
  static Future<void> sendResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _mapError(e);
    }
  }

  // --- Sign Out ---
  static Future<void> signOut() async {
    _loggedIn = false;
    await SharedPreserance.clear();
    await _auth.signOut();
  }

  // --- Map errors to user-friendly messages ---
  static String _mapError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found for this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
