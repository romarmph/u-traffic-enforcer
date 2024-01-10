import 'package:u_traffic_enforcer/pages/auth/enforcer_suspended_page.dart';
import 'package:u_traffic_enforcer/pages/auth/enforcer_terminated_page.dart';
import 'package:u_traffic_enforcer/riverpod/sched.riverpod.dart';
import 'package:u_traffic_enforcer/riverpod/trafficpost.riverpod.dart';

import '../config/utils/exports.dart';

class Wrapper extends ConsumerStatefulWidget {
  const Wrapper({super.key});

  @override
  ConsumerState<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends ConsumerState<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final authService = ref.watch(authProvider);

    return ref.watch(authStreamProvider).when(
          data: (user) {
            if (user == null) {
              return const Login();
            }

            return ref.watch(enforcerStreamProvider(user.uid)).when(
                  data: (data) {
                    if (data.status == EmployeeStatus.suspended) {
                      return const EnforcerSuspendedPage();
                    }

                    if (data.status == EmployeeStatus.terminated) {
                      return const EnforcerTerminatedPage();
                    }

                    ref.watch(violationsStreamProvider);
                    ref.watch(vehicleTypeStreamProvider);
                    ref.watch(schedProviderStream);
                    ref.watch(getAllPost);
                    return const HomePage();
                  },
                  error: (error, stackTrace) {
                    return Scaffold(
                      body: SafeArea(
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
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
                          ),
                        ),
                      ),
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
