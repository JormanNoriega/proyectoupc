// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyectoupc/controllers/project_controller.dart';
import 'package:proyectoupc/models/project_model.dart';
import 'package:proyectoupc/pages/project_pages/add_project_page.dart';
import 'package:proyectoupc/pages/widget/custom_buttom.dart';
// Asegúrate de tener este modelo

class MyProjectsPage extends StatelessWidget {
  final ProjectController _projectController = Get.find();

  MyProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Llamar al método para obtener los proyectos del usuario actual
    _projectController.fetchProjectsByOwner();

    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Proyectos'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navegar a la página de creación de proyecto
              Get.to(() => AddProjectPage());
            },
          ),
        ],
      ),
      body: Obx(() {
        if (_projectController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (_projectController.projectListByOwner.isEmpty) {
          return Center(child: Text('No tienes proyectos registrados.'));
        }

        return ListView.builder(
          itemCount: _projectController.projectListByOwner.length,
          itemBuilder: (context, index) {
            final project = _projectController.projectListByOwner[index];

            return Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    // Imagen del proyecto
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: (project.imageUrls.isNotEmpty &&
                              project.imageUrls.first.isNotEmpty)
                          ? Image.network(
                              project.imageUrls.first,
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/no_image.png',
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(width: 16),
                    // Información del proyecto
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            project.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Botones de editar y eliminar
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            // Navegar a la página de edición del proyecto
                            Get.to(() => AddProjectPage(), arguments: project);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmation(context, project);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // Mostrar el cuadro de confirmación para eliminar
  void _showDeleteConfirmation(BuildContext context, ProjectModel project) {
    Get.defaultDialog(
      title: "Eliminar Proyecto",
      middleText: "¿Estás seguro de que deseas eliminar este proyecto?",
      cancel: CustomButton(
        buttonText: "Cancelar",
        onPressed: () {
          Get.back(); // Cerrar el diálogo
        },
      ),
      confirm: CustomButton(
        buttonText: "Eliminar",
        onPressed: () {
          _projectController.deleteProject(project);
          Get.back(); // Cerrar el diálogo después de confirmar
        },
      ),
    );
  }
}
