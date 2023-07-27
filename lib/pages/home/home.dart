import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../service/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        onPressed: () {
          final authService = Provider.of<AuthService>(context, listen: false);

          authService.signOut();
        },
        child: const Text("Logout"),
      ),
    );
  }
}
