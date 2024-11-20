class PhaseModel {
  final String id; // ID único de la fase
  final String projectId; // ID del proyecto asociado
  final String
      name; // Nombre de la fase: 'Planificación', 'Desarrollo', 'Evaluación'
  final String description; // Descripción específica de la fase
  final bool isCompleted; // Indica si la fase está completada
  final DateTime createdAt; // Fecha de creación de la fase

  PhaseModel({
    required this.id,
    required this.projectId,
    required this.name,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
  });

  factory PhaseModel.fromMap(Map<String, dynamic> map) {
    return PhaseModel(
      id: map['id'],
      projectId: map['projectId'],
      name: map['name'],
      description: map['description'],
      isCompleted: map['isCompleted'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'name': name,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
