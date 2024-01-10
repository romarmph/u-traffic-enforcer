import 'config/utils/exports.dart';
import 'package:calendar_view/calendar_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: UTrafficEnforcer(),
    ),
  );
}

class UTrafficEnforcer extends StatelessWidget {
  const UTrafficEnforcer({super.key});

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: EventController(),
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
          "/settings": (context) => const SettingsPage(),
          "/settings/updatepassword": (context) => const PasswordChangePage(),
          "/settings/leave": (context) => const LeavePage(),
          "/auth/login": (context) => const Login(),
          "/auth/register": (context) => const Register(),
          "/ticket/create": (context) => const CreateTicketPage(),
          "/ticket/violations": (context) => const ViolationList(),
          "/ticket/preview": (context) => const TicketPreview(),
          "/ticket/signature": (context) => const SignaturePad(),
          "/printer/": (context) => const PrinterHome(),
          "/printer/scan": (context) => const DeviceScanPage(),
        },
      ),
    );
  }
}
