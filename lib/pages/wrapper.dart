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

          setEnforcer(context);
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

  void setEnforcer(BuildContext context) async {
    final enforcerProvider =
        Provider.of<EnforcerProvider>(context, listen: false);
    final enforcer = await EnforcerDBHelper.instance.getEnforcer();

    enforcerProvider.setEnforcer(enforcer);
  }
}
