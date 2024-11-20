// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyectoupc/controllers/auth_controller.dart';
import 'package:proyectoupc/controllers/project_controller.dart';
import 'package:proyectoupc/models/project_model.dart';
import 'package:proyectoupc/pages/widget/custom_buttom.dart';
import 'package:proyectoupc/pages/widget/custom_dropdown.dart';
import 'package:proyectoupc/pages/widget/custom_text_field.dart';

class AddProjectPage extends StatefulWidget {
  const AddProjectPage({super.key});

  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final ProjectController _projectController = Get.find();
  final AuthController _authController = Get.find();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _objectivesController = TextEditingController();

  ProjectModel? currentProject;
  List<String> projectStatuses = ['En progreso', 'Finalizado', 'Pendiente'];
  String? selectedStatus;

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      currentProject = Get.arguments as ProjectModel;
      _loadProjectData();
    }
  }

  void _loadProjectData() {
    _titleController.text = currentProject!.title;
    _descriptionController.text = currentProject!.description;
    _objectivesController.text = currentProject!.objectives;
    selectedStatus = currentProject!.status;
    startDate = currentProject!.startDate;
    endDate = currentProject!.endDate;

    if (currentProject!.imageUrls.isNotEmpty) {
      _projectController.imageFiles.value = [];
    }
  }

  // Método para mostrar el diálogo de selección de imagen
  void _showImagePicker(BuildContext context) {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Cámara'),
              onTap: () {
                _projectController.pickProjectImages(true);
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Galería'),
              onTap: () {
                _projectController.pickProjectImages(false);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            currentProject == null ? 'Agregar Proyecto' : 'Editar Proyecto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Sección para seleccionar la imagen
              GestureDetector(
                onTap: () => _showImagePicker(context),
                child: Obx(() {
                  if (_projectController.imageFiles.isNotEmpty) {
                    return SizedBox(
                      height: 150,
                      child: CarouselSlider.builder(
                        itemCount: _projectController.imageFiles.length,
                        itemBuilder: (context, index, realIndex) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                              _projectController.imageFiles[index],
                              height: 250,
                              width: 250,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 16 / 9,
                        ),
                      ),
                    );
                  } else if (_projectController.imageWebFiles.isNotEmpty) {
                    return SizedBox(
                      height: 150,
                      child: CarouselSlider.builder(
                        itemCount: _projectController.imageWebFiles.length,
                        itemBuilder: (context, index, realIndex) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.memory(
                              _projectController.imageWebFiles[index],
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 16 / 9,
                        ),
                      ),
                    );
                  } else if (currentProject != null &&
                      currentProject!.imageUrls.isNotEmpty) {
                    return SizedBox(
                      height: 150,
                      child: CarouselSlider.builder(
                        itemCount: currentProject!.imageUrls.length,
                        itemBuilder: (context, index, realIndex) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              currentProject!.imageUrls[index],
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 16 / 9,
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      height: 150,
                      color: Colors.grey[200],
                      child: Center(child: Text('Seleccionar Imagen')),
                    );
                  }
                }),
              ),
              SizedBox(height: 20),
              CustomTextField(hintText: "Título", controller: _titleController),
              SizedBox(height: 10),
              CustomTextField(
                  hintText: "Descripción", controller: _descriptionController),
              SizedBox(height: 10),
              CustomTextField(
                  hintText: "Objetivos", controller: _objectivesController),
              SizedBox(height: 10),
              CustomDropdownButton(
                value: selectedStatus,
                hint: 'Seleccione un estado',
                items: projectStatuses,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedStatus = newValue;
                  });
                },
              ),
              SizedBox(height: 10),
              // Botones para seleccionar fecha de inicio y fin
              GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: startDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != startDate)
                    setState(() {
                      startDate = picked;
                    });
                },
                child: CustomTextField(
                  hintText: startDate == null
                      ? 'Fecha de inicio'
                      : startDate!.toLocal().toString().split(' ')[0],
                  controller: TextEditingController(),
                  enabled: false,
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: endDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != endDate)
                    setState(() {
                      endDate = picked;
                    });
                },
                child: CustomTextField(
                  hintText: endDate == null
                      ? 'Fecha de finalización'
                      : endDate!.toLocal().toString().split(' ')[0],
                  controller: TextEditingController(),
                  enabled: false,
                ),
              ),
              SizedBox(height: 25),
              Obx(() {
                return _projectController.isLoading.value
                    ? CircularProgressIndicator()
                    : CustomButton(
                        onPressed: _handleSaveOrUpdate,
                        buttonText:
                            currentProject == null ? "Agregar" : "Actualizar",
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSaveOrUpdate() {
    final title = _titleController.text;

    final description = _descriptionController.text;
    final objectives = _objectivesController.text;
    final ownerId = _authController.userModel.value!.uid;

    if (selectedStatus == null) {
      Get.snackbar('Error', 'Debe seleccionar un estado para el proyecto');
      return;
    }

    if (_projectController.imageFiles.isEmpty &&
        (currentProject == null || currentProject!.imageUrls.isEmpty)) {
      Get.snackbar('Error', 'Debe seleccionar al menos una imagen');
      return;
    }

    if (currentProject == null) {
      _projectController.saveNewProject(
        title,
        description,
        objectives,
        ownerId,
        startDate!.toString(),
        selectedStatus!,
      );
      // } else {
      //   currentProject!.title = title;
      //   currentProject!.description = description;
      //   currentProject!.objectives = objectives;
      //   currentProject!.startDate = startDate!;
      //   currentProject!.endDate = endDate!;
      //   currentProject!.status = selectedStatus!;
      //   _projectController.updateProject(currentProject!);
    }
  }
}
