import 'config/utils/exports.dart';

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
        Provider<FormValidators>(
          create: (_) => FormValidators(),
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
        ChangeNotifierProvider(
          create: (context) => EnforcerProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UTrafficImageProvider(),
        )
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
          "/printer/": (context) => const PrinterHome(),
          "/printer/scan": (context) => const DeviceScanPage(),
        },
      ),
    );
  }
}
