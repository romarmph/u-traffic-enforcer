import 'package:u_traffic_enforcer/pages/auth/enforcer_suspended_page.dart';
import 'package:u_traffic_enforcer/pages/auth/enforcer_terminated_page.dart';
import 'package:u_traffic_enforcer/pages/home_wrapper.dart';

import '../config/utils/exports.dart';

class Wrapper extends ConsumerWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authProvider);

    return ref.watch(authStreamProvider).when(
          data: (user) {
            if (user == null) {
              return const Login();
            }
            return ref.watch(enforcerStreamProvider).when(
                  data: (data) {
                    if (data.status == EmployeeStatus.suspended) {
                      return const EnforcerSuspendedPage();
                    }

                    if (data.status == EmployeeStatus.terminated) {
                      return const EnforcerTerminatedPage();
                    }

                    return const ViewWrapper();
                  },
                  error: (error, stackTrace) {
                    return Column(
                      children: [
                        const Text("An error occured!"),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            authService.signOut();
                          },
                          child: const Text("Sign out"),
                        ),
                      ],
                    );
                  },
                  loading: () => const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
          },
          error: (error, stackTrace) {
            return Column(
              children: [
                const Text("An error occured!"),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    authService.signOut();
                  },
                  child: const Text("Sign out"),
                ),
              ],
            );
          },
          loading: () => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
  }
}
