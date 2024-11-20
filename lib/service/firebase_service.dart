import 'dart:io'; // Para manejo de archivos
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Registro de usuario
  Future<UserModel?> registerWithEmail(
      String email, String password, String name) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        UserModel newUser = UserModel(
            uid: user.uid, name: name, email: email, phone: '', lastName: '');
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
        return newUser;
      }
    } catch (e) {
      print("Error en el registro: $e");
    }
    return null;
  }

  // Inicio de sesión
  Future<UserModel?> loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        return await getUserData(user.uid);
      }
    } catch (e) {
      print("Error en el inicio de sesión: $e");
    }
    return null;
  }

  // Obtener datos del usuario
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return UserModel.fromFirestore(
            userDoc.data() as Map<String, dynamic>, uid);
      }
    } catch (e) {
      print("Error al obtener datos del usuario: $e");
    }
    return null;
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error al cerrar sesión: $e");
    }
  }

  // Subir imagen de perfil a Firebase Storage desde Movil
  Future<String?> uploadProfileImage(String uid, File imageFile) async {
    try {
      Reference storageRef = _storage.ref().child('profileImages').child(uid);
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error al subir la imagen de perfil: $e");
      return null;
    }
  }

  // Actualizar URL de imagen de perfil
  Future<void> updateProfileImageUrl(String uid, String imageUrl) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'profileImageUrl': imageUrl,
      });
    } catch (e) {
      print("Error al actualizar la URL de la imagen de perfil: $e");
    }
  }

// Método para actualizar el perfil del usuario en Firestore
  Future<void> updateUserProfile(
      String uid, String lastName, String phone) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'lastName': lastName,
        'phone': phone,
      });
    } catch (e) {
      print("Error al actualizar el perfil del usuario: $e");
      throw Exception("No se pudo actualizar el perfil");
    }
  }
}
