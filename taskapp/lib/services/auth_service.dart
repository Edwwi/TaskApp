import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream de estado de autenticación
  Stream<User?> get user => _auth.authStateChanges();

  // Registro con email, contraseña, nombre y apellido
  Future<String?> registerWithEmail(
    String email, 
    String password, 
    String firstName, 
    String lastName,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Guardar datos adicionales en Firestore
      await _firestore.collection('users').doc(result.user!.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      return null; // Éxito
    } on FirebaseAuthException catch (e) {
      debugPrint('Error en registro: ${e.code}');
      return e.message;
    } catch (e) {
      return 'Ocurrió un error inesperado';
    }
  }

  // Inicio de sesión con email y contraseña
  Future<String?> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Éxito
    } on FirebaseAuthException catch (e) {
      debugPrint('Error en login: ${e.code}');
      return e.message;
    } catch (e) {
      return 'Ocurrió un error inesperado';
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
