import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyectoupc/models/project_model.dart';

class ProjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Obtener datos de los proyectos
  Stream<List<ProjectModel>> getProjects() {
    return _firestore.collection('projects').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ProjectModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Obtener un proyecto por ID
  Future<ProjectModel?> getProjectById(String id) async {
    try {
      DocumentSnapshot projectDoc =
          await _firestore.collection('projects').doc(id).get();
      if (projectDoc.exists) {
        return ProjectModel.fromMap(
            projectDoc.data() as Map<String, dynamic>, projectDoc.id);
      }
    } catch (e) {
      print("Error al obtener el proyecto: $e");
    }
    return null;
  }

  // Obtener proyectos por ID de usuario
  Future<List<ProjectModel>> getProjectByOwenr(String ownerId) async {
    try {
      QuerySnapshot projectDocs = await _firestore
          .collection('projects')
          .where('ownerId', isEqualTo: ownerId)
          .get();
      return projectDocs.docs
          .map((doc) =>
              ProjectModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      debugPrint("Error al obtener el proyecto: $e");
    }
    return [];
  }

  // Guardar datos de un proyecto
  Future<void> saveProject(ProjectModel project) async {
    try {
      await _firestore
          .collection('projects')
          .doc(project.id)
          .set(project.toMap());
    } catch (e) {
      print("Error al guardar el proyecto: $e");
    }
  }

  // Actualizar datos de un proyecto
  Future<void> updateProject(ProjectModel project) async {
    try {
      await _firestore
          .collection('projects')
          .doc(project.id)
          .update(project.toMap());
    } catch (e) {
      print("Error al actualizar el proyecto: $e");
    }
  }

  // Eliminar un proyecto
  Future<void> deleteProject(String id) async {
    try {
      await _firestore.collection('projects').doc(id).delete();
    } catch (e) {
      print("Error al eliminar el proyecto: $e");
    }
  }

  // Método para seleccionar múltiples imágenes dependiendo de la plataforma
  Future<List<String?>> pickProjectImages(bool fromCamera) async {
    if (kIsWeb) {
      // Si es web, usamos FilePicker
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.image, allowMultiple: true);
      if (result != null && result.files.first.bytes != null) {
        return result.files.map((file) => file.name).toList();
      } else {
        return [];
      }
    } else {
      final picker = ImagePicker();
      final pickedFiles = await picker.pickMultiImage();
      if (pickedFiles != []) {
        return pickedFiles.map((file) => file.path).toList();
      } else {
        return [];
      }
    }
  }

  // Subir imágenes de un proyecto desde el móvil
  Future<List<String?>> uploadProjectImages(
      List<File> imageFile, String projectId) async {
    List<String?> imageUrls = [];
    for (File file in imageFile) {
      try {
        Reference storageReference =
            _storage.ref('projects/$projectId/${file.path.split('/').last}');
        UploadTask uploadTask = storageReference.putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        imageUrls.add(await snapshot.ref.getDownloadURL());
      } catch (e) {
        print("Error al subir la imagen del proyecto: $e");
        imageUrls.add(null);
      }
    }
    return imageUrls;
  }

  // Subir imágenes de un proyecto desde la web
  Future<List<String?>> uploadProjectImagesWeb(
      List<Uint8List> imageBytesList, String projectId) async {
    List<String?> imageUrls = [];
    for (Uint8List imageBytes in imageBytesList) {
      try {
        Reference storageReference = _storage.ref('projects/$projectId');
        UploadTask uploadTask = storageReference.putData(imageBytes);
        TaskSnapshot snapshot = await uploadTask;
        imageUrls.add(await snapshot.ref.getDownloadURL());
      } catch (e) {
        print("Error al subir la imagen del proyecto: $e");
        imageUrls.add(null);
      }
    }
    return imageUrls;
  }

  // Método para subir imágenes según la plataforma
  Future<List<String?>> uploadImagesForPlatform(
      dynamic imageFiles, String projectId) async {
    if (kIsWeb && imageFiles is List<Uint8List>) {
      return await uploadProjectImagesWeb(imageFiles, projectId);
    } else if (imageFiles is List<File>) {
      return await uploadProjectImages(imageFiles, projectId);
    } else {
      print("Error: tipo de archivo no soportado");
      return [];
    }
  }
}
