// ignore_for_file: prefer_const_constructors
import 'package:proyectoupc/pages/main_pages/profile_page.dart';
import 'package:proyectoupc/pages/widget/menu_drawer.dart';

import '../../controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthController _authController = Get.find();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  // Pila para almacenar el historial de las páginas visitadas
  final List<int> _pageHistory = [];

  // Lista de las páginas
  final List<Widget> _pages = [EditProfilePage()];

  // Cambiar página y almacenar el índice anterior en el historial
  void changePage(int index) {
    setState(() {
      if (_selectedIndex != index) {
        _pageHistory.add(_selectedIndex); // Agrega el índice actual a la pila
      }
      _selectedIndex = index;
    });
  }

  // Regresar a la última página visitada (saca el último valor de la pila)
  void _goBack() {
    setState(() {
      if (_pageHistory.isNotEmpty) {
        _selectedIndex =
            _pageHistory.removeLast(); // Regresa a la última página en la pila
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF70B71F),
        leading: null,
        title: const Text(
          'UPC Proyectos',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      body: IndexedStack(
        // Cambiado a IndexedStack para mantener el estado de las páginas
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            _selectedIndex < 4 ? _selectedIndex : 0, // Previene errores
        backgroundColor: Color(0xFF70B71F),
        selectedItemColor: Colors.black,
        unselectedItemColor: const Color.fromARGB(255, 97, 96, 96),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: changePage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'algo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'algo2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'algo3',
          ),
        ],
      ),
      endDrawer: MenuDrawer(
        authController: _authController,
        onPageSelected: changePage,
      ),
    );
  }
}
