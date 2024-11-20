import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyectoupc/models/project_model.dart';
import 'package:proyectoupc/service/project_service.dart';
import 'package:uuid/uuid.dart';

class ProjectController extends GetxController {
  final ProjectService _projectService = ProjectService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var isLoading = false.obs;
  var imageFiles = <File>[].obs;
  var imageWebFiles = <Uint8List>[].obs;
  RxList<ProjectModel> projectList = <ProjectModel>[].obs;
  RxList<ProjectModel> projectListByOwner = <ProjectModel>[].obs;
  var filteredProjectList = <ProjectModel>[].obs;
  var searchQuery = ''.obs;

  // Método para seleccionar imágenes para el proyecto
  Future<void> pickProjectImages(bool fromCamera) async {
    if (kIsWeb) {
      // Seleccionar imagen en Flutter Web usando FilePicker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );
      if (result != null && result.files.first.bytes != null) {
        imageWebFiles.value = result.files
            .map((file) => file.bytes!)
            .toList(); // Guardar imagen para la web
      } else {
        Get.snackbar("Error", "No se seleccionó ninguna imagen");
      }
    } else {
      // Seleccionar imagen en dispositivos móviles usando ImagePicker
      final picker = ImagePicker();
      final pickedFiles = await picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        imageFiles.value = pickedFiles
            .map((file) => File(file.path))
            .toList(); // Guardar la imagen en móviles
      } else {
        Get.snackbar("Error", "No se seleccionó ninguna imagen");
      }
    }
  }

  // Método para guardar un nuevo proyecto
  Future<void> saveNewProject(
    String title,
    String description,
    String objetives,
    String ownerId,
    String projectDate,
    String status,
  ) async {
    try {
      isLoading.value = true;
      String id = const Uuid().v4(); // Generar un ID único para el proyecto
      List<String> imageUrls = [];

      // Verificar si hay imágenes seleccionadas
      if (imageFiles.isNotEmpty || imageWebFiles.isNotEmpty) {
        List<String?> uploadedUrls =
            await _projectService.uploadImagesForPlatform(
          kIsWeb ? imageWebFiles : imageFiles,
          id,
        );

        // Filtrar URLs no nulas
        imageUrls =
            uploadedUrls.where((url) => url != null).cast<String>().toList();
      }

      // Crear una instancia de ProjectModel con todos los datos
      ProjectModel project = ProjectModel(
        id: id,
        title: title,
        description: description,
        imageUrls: imageUrls,
        startDate: DateTime.parse(projectDate),
        endDate: DateTime.parse(projectDate),
        status: status, // or any default value
        faculty: 'default_faculty', // or any default value
        program: 'default_program', // or any default value
        objectives: objetives, // or any default value
        phaseIds: [], // or any default value
        ownerId: ownerId,
      );

      // Guardar el proyecto usando el servicio
      await _projectService.saveProject(project);
      Get.snackbar('Éxito', 'Publicación exitosa');
      fetchProjectsByOwner();
      fetchProjects(); // Volver a cargar los proyectos después de guardar
    } catch (e) {
      Get.snackbar('Error', 'No se pudo guardar la publicación');
    } finally {
      isLoading.value = false;
    }
  }

  // Método para obtener todos los proyectos
  void fetchProjects() {
    isLoading.value = true;
    _projectService.getProjects().listen((fetchedProjects) {
      // Aquí actualizas la lista y aplicas el filtro
      projectList.value = fetchedProjects;
      applyFilter(); // Asegúrate de que esto no desencadene un rebuild
      isLoading.value = false; // Mueve esto después de aplicar el filtro
    });
  }

  // Método para obtener los proyectos por el id del dueño
  void fetchProjectsByOwner() {
    isLoading.value = true;
    String ownerId = _auth.currentUser!.uid;
    _projectService.getProjectByOwenr(ownerId).then((fetchedProjectsByOwner) {
      projectListByOwner.value = fetchedProjectsByOwner;
      isLoading.value = false;
    });
  }

  // Método para aplicar el filtro basado en el texto de búsqueda
  void applyFilter() {
    if (searchQuery.value.isEmpty) {
      // Si no hay búsqueda, mostrar todos los ítems
      filteredProjectList.value = projectList;
    } else {
      // Filtrar los ítems según el texto de búsqueda
      filteredProjectList.value = projectList.where((project) {
        return project.title
            .toLowerCase()
            .contains(searchQuery.value.toLowerCase());
      }).toList();
    }
  }

  // Método para actualizar el texto de búsqueda
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    applyFilter(); // Aplicar el filtro cada vez que se actualice el texto de búsqueda
  }

  // Método para obtener un proyecto por su ID
  Future<ProjectModel?> getItemProjectById(String id) async {
    try {
      return await _projectService.getProjectById(id);
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un error al buscar el proyecto');
      return null;
    }
  }

  // Método para actualizar un proyecto
  Future<void> updateProject(ProjectModel project) async {
    try {
      isLoading.value = true;
      List<String> imageUrls = List.from(project.imageUrls);
      // Verificar si hay nuevas imágenes seleccionadas
      if (imageFiles.isNotEmpty || imageWebFiles.isNotEmpty) {
        List<String?> uploadedUrls =
            await _projectService.uploadImagesForPlatform(
          kIsWeb ? imageWebFiles : imageFiles,
          project.id,
        );
        // Filtrar URLs no nulas y añadirlas a las URLs existentes
        imageUrls.addAll(
            uploadedUrls.where((url) => url != null).cast<String>().toList());
      }
      // Actualizar los datos del proyecto en Firestore
      await _projectService.updateProject(project);
      Get.snackbar('Éxito', 'Proyecto actualizado correctamente');
      fetchProjects(); // Volver a cargar los proyectos después de actualizar
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un error al actualizar el proyecto');
    } finally {
      isLoading.value = false;
    }
  }

  // Método para eliminar un proyecto
  Future<void> deleteProject(ProjectModel project) async {
    try {
      isLoading.value = true;
      await _projectService.deleteProject(project.id);
      Get.snackbar('Éxito', 'Proyecto eliminado correctamente');
      fetchProjects();
      fetchProjectsByOwner();
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un error al eliminar el proyecto');
    } finally {
      isLoading.value = false;
    }
  }
}
