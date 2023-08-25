import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'config/constants/navigator_key.dart';
import 'pages/ticket/create_ticket_page.dart';
import 'config/themes/textstyles.dart';
import 'pages/ticket/scanned_preview.dart';
import 'providers/create_ticket_form_notifier.dart';
import 'providers/printer_provider.dart';
import 'config/themes/colors.dart';
import 'config/themes/components/app_bar_theme.dart';
import 'config/themes/components/fab.dart';
import 'config/themes/components/input_decoration.dart';
import 'config/themes/components/elevated_button.dart';
import 'config/themes/components/text_button.dart';
import 'firebase_options.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';
import 'pages/printer/device_scan_page.dart';
import 'pages/printer/printer_home.dart';
import 'pages/ticket/preview_page.dart';
import 'pages/ticket/violation_select_page.dart';
import 'pages/wrapper.dart';
import 'providers/ticket_provider.dart';
import 'providers/violations_provider.dart';
import 'services/auth_service.dart';

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
        ChangeNotifierProvider<PrinterProvider>(
          create: (_) => PrinterProvider(),
        ),
        ChangeNotifierProvider<TicketProvider>(
          create: (_) => TicketProvider(),
        ),
        ChangeNotifierProvider<ViolationProvider>(
          create: (_) => ViolationProvider(),
        ),
        ChangeNotifierProvider<CreateTicketFormNotifier>(
          create: (_) => CreateTicketFormNotifier(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: "U-Traffic Enforcer",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: UColors.blue600,
          ),
          useMaterial3: true,
          fontFamily: GoogleFonts.inter().fontFamily,
          elevatedButtonTheme: elevatedButtonTheme,
          inputDecorationTheme: inputDecorationTheme,
          textButtonTheme: textButtonTheme,
          floatingActionButtonTheme: fabTheme,
          appBarTheme: appBarTheme,
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              textStyle: const UTextStyle().textbasefontmedium,
              side: const BorderSide(
                color: UColors.blue500,
                width: 1.5,
              ),
              foregroundColor: UColors.blue500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          scaffoldBackgroundColor: UColors.white,
        ),
        initialRoute: "/",
        routes: {
          "/": (context) => const Wrapper(),
          "/auth/login": (context) => const Login(),
          "/auth/register": (context) => const Register(),
          "/ticket/create": (context) => const CreateTicketPage(),
          "/ticket/violations": (context) => const ViolationsList(),
          "/ticket/preview": (context) => const TicketPreview(),
          "/ticket/scanpreview": (context) => const ScannedLicensePreview(),
          "/printer/": (context) => const PrinterHome(),
          "/printer/scan": (context) => const DeviceScanPage(),
        },
      ),
    );
  }
}
