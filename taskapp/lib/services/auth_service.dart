import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream de estado de autenticación
  Stream<User?> get user => _auth.authStateChanges();

  // Registro con email y contraseña
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      debugPrint('Error en registro: ${e.toString()}');
      return null;
    }
  }

  // Inicio de sesión con email y contraseña
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      debugPrint('Error en login: ${e.toString()}');
      return null;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      debugPrint('Error en logout: ${e.toString()}');
    }
  }

  // Obtener UID del usuario actual
  String? get currentUserUid => _auth.currentUser?.uid;
}
