import 'package:proyectoupc/pages/widget/custom_buttom.dart';
import 'package:proyectoupc/pages/widget/custom_text_field.dart';
import '../../controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final AuthController _authController = Get.find<AuthController>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  File? _selectedImage;

  @override
  void initState() {
    super.initState();

    // Inicializar campos con los datos del usuario
    UserModel? user = _authController.userModel.value;
    if (user != null) {
      _nameController.text = user.name;
      _lastNameController.text = user.lastName;
      _phoneController.text = user.phone;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    String name = _nameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String phone = _phoneController.text.trim();

    if (name.isEmpty || lastName.isEmpty || phone.isEmpty) {
      Get.snackbar("Error", "Todos los campos son obligatorios");
      return;
    }

    try {
      // Actualizar perfil del usuario
      await _authController.updateUserProfile(lastName, phone);

      // Subir imagen seleccionada si aplica
      if (_selectedImage != null) {
        await _authController.updateProfileImage(_selectedImage!);
      }

      Get.snackbar("Éxito", "Perfil actualizado correctamente");
    } catch (e) {
      Get.snackbar("Error", "No se pudo actualizar el perfil");
    }
  }

  void _showSelectionModal({
    required BuildContext context,
    required String title,
    required List<String> items,
    required ValueChanged<String> onItemSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        TextEditingController searchController = TextEditingController();
        List<String> filteredItems = List.from(items);

        return StatefulBuilder(
          builder: (context, setModalState) {
            void _filterItems(String query) {
              setModalState(() {
                filteredItems = items
                    .where((item) =>
                        item.toLowerCase().contains(query.toLowerCase()))
                    .toList();
              });
            }

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Buscar $title',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: _filterItems,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(filteredItems[index]),
                            onTap: () {
                              onItemSelected(filteredItems[index]);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          UserModel? user = _authController.userModel.value;

          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : (user.profileImageUrl != null
                          ? NetworkImage(user.profileImageUrl!)
                          : null),
                  child: _selectedImage == null && user.profileImageUrl == null
                      ? const Icon(Icons.person, size: 80)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: 'Correo Electrónico',
                controller: TextEditingController(text: user.email),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: 'Nombre',
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: 'Apellido',
                controller: _lastNameController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: 'Teléfono',
                keyboardType: TextInputType.number,
                controller: _phoneController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: 'Rol',
                controller: TextEditingController(text: user.role),
                readOnly: true,
              ),
              const SizedBox(height: 30),
              CustomButton(
                onPressed: _updateProfile,
                buttonText: 'Guardar cambios',
              ),
            ],
          );
        }),
      ),
    );
  }
}
