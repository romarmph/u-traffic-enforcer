import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../model/user_model.dart';
import '../service/auth_service.dart';
import 'auth/login_page.dart';
import 'home/home_page.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            return const Login();
          }

          return const HomePage();
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}