import 'package:flutter/material.dart';
import 'package:proyectoupc/controllers/auth_controller.dart';
import 'package:proyectoupc/pages/widget/custom_buttom.dart';
import 'package:proyectoupc/pages/widget/custom_text_field.dart';
import '../auth_pages/login_page.dart';

import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Text(
                  'UPC Proyectos',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Crear una cuenta',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Nombre',
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email',
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Contraseña',
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirmar Contraseña',
                  obscureText: true,
                ),
                const SizedBox(height: 40),
                Obx(() => _authController.isLoading.value
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        onPressed: () {
                          String name = _nameController.text.trim();
                          String email = _emailController.text.trim();
                          String password = _passwordController.text.trim();
                          String confirmPassword =
                              _confirmPasswordController.text.trim();

                          if (password != confirmPassword) {
                            Get.snackbar(
                              'Error',
                              'Las contraseñas no coinciden',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          if (name.isEmpty ||
                              email.isEmpty ||
                              password.isEmpty) {
                            Get.snackbar(
                              'Error',
                              'Por favor complete todos los campos',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          _authController.register(email, password, name);
                        },
                        buttonText: 'Registrarse',
                      )),
                const SizedBox(height: 20),
                const Text(
                  'o inicie sesión con',
                  style: TextStyle(
                    color: Color(0xFFA7A7A7),
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Get.to(LoginPage()),
                  child: const Text(
                    '¿Ya tienes cuenta? Inicia sesión',
                    style: TextStyle(
                      color: Color(0xFFA7A7A7),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
