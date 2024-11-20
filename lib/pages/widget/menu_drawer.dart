// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:proyectoupc/controllers/auth_controller.dart';
import 'package:proyectoupc/pages/main_pages/profile_page.dart';

class MenuDrawer extends StatelessWidget {
  final AuthController authController;
  final Function(int) onPageSelected; // Función para navegar entre páginas

  MenuDrawer({required this.authController, required this.onPageSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // Ancho del menú
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: Icon(Icons.arrow_back),
              title: Text('Cerrar'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(), // Línea separadora
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return EditProfilePage();
                }));
                onPageSelected(3); // Navegar a la página de perfil
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Salir'),
              onTap: () {
                Navigator.pop(context);
                authController.signOut(); // Llamar al método de cerrar sesión
              },
            ),
          ],
        ),
      ),
    );
  }
}
