import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Interface du service d'authentification
abstract class AuthService {
  /// L'utilisateur Firebase actuellement connecté (null si déconnecté)
  User? get currentUser;

  /// Stream qui émet à chaque changement d'état d'auth
  Stream<User?> get authStateChanges;

  /// Crée un compte avec e-mail et mot de passe
  Future<User?> signUpWithEmail(String email, String password);

  /// Connecte un utilisateur existant
  Future<User?> signInWithEmail(String email, String password);

  /// Déconnecte l'utilisateur courant
  Future<void> signOut();

  /// Supprime définitivement le compte Firebase
  Future<void> deleteAccount();
}

/// Implémentation Firebase du service d'authentification
class AuthServiceImpl implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  @override
  Future<User?> signUpWithEmail(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  @override
  Future<User?> signInWithEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
  }
}

/// Provider global du service Auth
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthServiceImpl();
});

/// Provider du stream d'état Auth Firebase (User? — null = déconnecté)
final firebaseUserProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
