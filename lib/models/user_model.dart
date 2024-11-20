class UserModel {
  final String uid;
  final String name;
  final String lastName;
  final String phone;
  final String email;
  final String role; // Rol (student, teacher, admin)
  String? profileImageUrl; 
  DateTime? createdAt; // Fecha de creación

  UserModel({
    required this.uid,
    required this.name,
    required this.lastName,
    required this.phone,
    required this.email,
    this.role = 'student',
    this.profileImageUrl,
    this.createdAt ,
  });

  // Convertir el UserModel a un Map para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'role': role,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt,
    };
  }

  // Crear una instancia de UserModel a partir de Firestore
  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      name: data['name'] ?? '',
      lastName: data['lastName'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'student',
      profileImageUrl: data['profileImageUrl'],
      createdAt: data['createdAt']?.toDate(),
    );
  }
}
