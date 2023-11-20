import 'package:u_traffic_enforcer/config/utils/exports.dart';

class EnforcerSuspendedPage extends ConsumerWidget {
  const EnforcerSuspendedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Your account has been suspended!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "If you think this is a mistake, please contact your supervisor.",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(authProvider).signOut();
            },
            child: const Text("Okay"),
          ),
        ],
      ),
    );
  }
}
