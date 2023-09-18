import 'package:u_traffic_enforcer/pages/common/bottom_nav.dart';

import '../../config/utils/exports.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _oldPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

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
        padding: const EdgeInsets.symmetric(
            horizontal: USpace.space16, vertical: USpace.space10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Change Password',
                  style: const UTextStyle().textlgfontmedium,
                ),
                const SizedBox(
                  height: USpace.space16,
                ),
                TextFormField(
                  controller: _oldPasswordController,
                  decoration: const InputDecoration(
                    labelText: "Old Password",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your old password";
                    }
                    return _oldPasswordError;
                  },
                ),
                const SizedBox(
                  height: USpace.space16,
                ),
                TextFormField(
                  controller: _newPasswordController,
                  decoration: const InputDecoration(
                    labelText: "New Password",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your new password";
                    }

                    if (value.isPasswordLengthValid) {
                      return "Password must be at least 8 characters";
                    }

                    if (!value.passwordContainsUpperCase) {
                      return "Password must contain at least one uppercase letter";
                    }

                    if (!value.passwordContainsLowerCase) {
                      return "Password must contain at least one lowercase letter";
                    }

                    if (!value.passwordContainsAlphaNumeric) {
                      return "Password must contain at least one number";
                    }

                    return _newPasswordError;
                  },
                ),
                const SizedBox(
                  height: USpace.space16,
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: "Confirm Password",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please confirm your new password";
                    }

                    if (!value
                        .isPasswordConfirmed(_newPasswordController.text)) {
                      return "Password does not match";
                    }

                    return _confirmPasswordError;
                  },
                ),
                const SizedBox(
                  height: USpace.space16,
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                  label: const Text("Save"),
                ),
                const Divider(
                  color: UColors.gray200,
                ),
                const Text(
                  "Note: If you have forgotten your password, please contact your administrator to reset it.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: UColors.gray400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}
