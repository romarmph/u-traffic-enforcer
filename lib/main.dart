import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'config/themes/colors.dart';
import 'config/themes/components/app_bar_theme.dart';
import 'config/themes/components/fab.dart';
import 'config/themes/components/input_decoration.dart';
import 'config/themes/components/elevated_button.dart';
import 'config/themes/components/text_button.dart';
import 'firebase_options.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';
import 'pages/ticket/preview_page.dart';
import 'pages/ticket/violations_list_page.dart';
import 'pages/ticket/violator_details_page.dart';
import 'pages/wrapper.dart';
import 'providers/ticket_provider.dart';
import 'providers/violations_provider.dart';
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
        ChangeNotifierProvider<TicketProvider>(
          create: (_) => TicketProvider(),
        ),
        ChangeNotifierProvider<ViolationProvider>(
          create: (_) => ViolationProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "U-Traffic Enforcer",
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: GoogleFonts.inter().fontFamily,
          elevatedButtonTheme: elevatedButtonTheme,
          inputDecorationTheme: inputDecorationTheme,
          textButtonTheme: textButtonTheme,
          floatingActionButtonTheme: fabTheme,
          appBarTheme: appBarTheme,
          scaffoldBackgroundColor: UColors.white,
        ),
        initialRoute: "/",
        routes: {
          "/": (context) => const Wrapper(),
          "/login": (context) => const Login(),
          "/register": (context) => const Register(),
          "/violatordetails": (context) => const ViolatorDetails(),
          "/violationslist": (context) => const ViolationsList(),
          "/ticketpreview": (context) => const TicketPreview(),
        },
      ),
    );
  }
}
