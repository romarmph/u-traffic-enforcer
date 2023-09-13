import '../config/utils/exports.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<UTrafficUser?>(
      stream: authService.user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            return const Login();
          }

          return FutureBuilder(
            future: setEnforcer(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                load(context);
                return const HomePage();
              } else {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Future<void> setEnforcer(BuildContext context) async {
    final enforcerProvider =
        Provider.of<EnforcerProvider>(context, listen: false);
    final enforcer = await EnforcerDBHelper.instance.getEnforcer();

    enforcerProvider.setEnforcer(enforcer);
  }

  void load(BuildContext context) async {
    final violationsProvider = Provider.of<ViolationProvider>(
      context,
      listen: false,
    );
    final violations = await ViolationsDatabase().getViolations();

    violationsProvider.setViolations(violations);
  }
}
