import '../config/utils/exports.dart';

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

          return FutureBuilder<bool>(
            future: loadData(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(USpace.space32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Loading data...",
                            style: const UTextStyle().textlgfontmedium,
                          ),
                          const SizedBox(height: USpace.space16),
                          const LinearProgressIndicator(),
                        ],
                      ),
                    ),
                  ),
                );
              }

              if (snapshot.hasError || snapshot.data == false) {
                return Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error,
                          color: UColors.red400,
                          size: USpace.space28,
                        ),
                        const SizedBox(height: USpace.space16),
                        const Text("Error loading data"),
                        const SizedBox(height: USpace.space16),
                        ElevatedButton(
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                          child: const Text("Close App"),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return const HomePage();
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

  Future<bool> loadData(BuildContext context) async {
    try {
      final enforcerProvider = Provider.of<EnforcerProvider>(
        context,
        listen: false,
      );

      final violationsProvider = Provider.of<ViolationProvider>(
        context,
        listen: false,
      );

      final vehicleTypeProvider = Provider.of<VehicleTypeProvider>(
        context,
        listen: false,
      );

      final enforcer = await EnforcerDBHelper.instance.getEnforcer();
      final violations = await ViolationsDatabase().getViolations();
      final vehicleTypes = await VehicleTypeDBHelper.instance.getVehicleTypes();

      violationsProvider.setViolations(violations);
      enforcerProvider.setEnforcer(enforcer);
      vehicleTypeProvider.setVehicleTypes(vehicleTypes);

      return true;
    } catch (e) {
      rethrow;
    }
  }
}
