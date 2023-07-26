import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import '../pages/auth/login.dart';
import '../pages/auth/register.dart';
import 'pages/wrapper.dart';
import 'service/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const UTrafficEnforcer(),
  );
}

class UTrafficEnforcer extends StatelessWidget {
  const UTrafficEnforcer({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "U-Traffic Enforcer",
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        initialRoute: "/",
        routes: {
          "/": (context) => const Wrapper(),
          "/login": (context) => const Login(),
          "/register": (context) => const Register(),
        },
      ),
    );
  }
}
