import 'package:u_traffic_enforcer/pages/common/bottom_nav.dart';

import '../../config/utils/exports.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  onTap: () {
                    Provider.of<NavIndexProvider>(
                      context,
                      listen: false,
                    ).changeIndex(0);
                    AuthService().signOut();
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
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text("Request Leave"),
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
