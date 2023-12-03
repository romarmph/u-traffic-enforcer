import 'package:u_traffic_enforcer/pages/common/bottom_nav.dart';

import '../../config/utils/exports.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  void invalidateProviders(WidgetRef ref) {
    ref.invalidate(ticketChangeNotifierProvider);
    ref.invalidate(violationsStreamProvider);
    ref.invalidate(enforcerStreamProvider);
    ref.invalidate(getTicketsByEnforcerIdStream);
    ref.invalidate(violationsListProvider);
    ref.invalidate(selectedViolationsProvider);
    ref.invalidate(navIndexProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading: const Icon(Icons.settings),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: "logout",
                  padding: EdgeInsets.zero,
                  onTap: () async {
                    await AuthService().signOut();
                    invalidateProviders(ref);
                    Navigator.of(navigatorKey.currentContext!)
                        .pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const Wrapper(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Logout"),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(USpace.space16),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Change Password"),
              onTap: () {
                goChangePassword();
              },
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}
