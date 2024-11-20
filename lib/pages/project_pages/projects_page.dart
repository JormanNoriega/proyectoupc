// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyectoupc/controllers/project_controller.dart';

class ProjectsPage extends StatelessWidget {
  final ProjectController _projectController = Get.put(ProjectController());
  final TextEditingController _searchController = TextEditingController();

  ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    _projectController.fetchProjects(); // Obtener los proyectos
    return Scaffold(
      appBar: AppBar(
        title: Text('Proyectos'),
      ),
      body: Column(
        children: [
          // Campo de texto para la búsqueda
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar por nombre',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _projectController.updateSearchQuery(
                    value); // Actualizar la búsqueda en el controlador
              },
            ),
          ),
          // Mostrar los proyectos
          Expanded(
            child: Obx(() {
              if (_projectController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (_projectController.projectList.isEmpty) {
                return Center(child: Text('No tienes proyectos registrados.'));
              }

              // Aplicar filtro si hay uno ingresado
              final filteredProjects = _projectController.filteredProjectList;

              return ListView.builder(
                itemCount: filteredProjects.length,
                itemBuilder: (context, index) {
                  final project = filteredProjects[index];

                  return GestureDetector(
                    onTap: () {
                      // Navegar a la página de detalles del proyecto
                      //Get.to(() => ProjectDetailPage(project: project));
                    },
                    child: Card(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
                                      'assets/images/no_image.png', // Imagen por defecto
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
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
