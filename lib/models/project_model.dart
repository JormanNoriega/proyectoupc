
import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String id; // ID único del proyecto (puede ser generado automáticamente por Firestore)
  final String title; // Título del proyecto
  final String description; // Descripción del proyecto
  final String objectives; // Objetivos del proyecto
  final DateTime startDate; // Fecha de inicio
  final DateTime endDate; // Fecha de finalización
  final String status; // Estado actual del proyecto (por ejemplo, 'En progreso', 'Finalizado', 'Pendiente')
  final String faculty; // Facultad a la que pertenece el proyecto
  final String program; // Programa al que pertenece el proyecto
  final List<String> phaseIds; // IDs de las fases asociadas
  final List<String> imageUrls; // URLs de las imágenes asociadas
  final String ownerId; // ID del dueño del proyecto

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.objectives,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.faculty,
    required this.program,
    required this.phaseIds,
    required this.imageUrls,
    required this.ownerId,
  });

  // Convertir el ProjectModel a un Map para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'objectives': objectives,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'faculty': faculty,
      'program': program,
      'phaseIds': phaseIds,
      'imageUrls': imageUrls,
      'ownerId': ownerId,
    };
  }

  // Crear una instancia de ProjectModel a partir de Firestore
  factory ProjectModel.fromMap(Map<String, dynamic> data, String id) {
    return ProjectModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      objectives: data['objectives'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      status: data['status'] ?? 'Pendiente', // Estado por defecto
      faculty: data['faculty'] ?? '',
      program: data['program'] ?? '',
      phaseIds: List<String>.from(data['phaseIds'] ?? []),
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      ownerId: data['ownerId'] ?? '',
    );
  }
}
