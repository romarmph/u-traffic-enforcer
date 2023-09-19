import '../../config/utils/exports.dart';

class PasswordChangePage extends StatefulWidget {
  const PasswordChangePage({super.key});

  @override
  State<PasswordChangePage> createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  final _formKey = GlobalKey<FormState>();

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _oldPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  bool isLoading = false;

  void _handleSaveButton() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _oldPasswordError = null;
        _newPasswordError = null;
        _confirmPasswordError = null;
        isLoading = true;
      });

      try {
        await AuthService().updatePassword(
          _newPasswordController.text,
          _oldPasswordController.text,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          setState(() {
            _oldPasswordError = "Incorrect password";
            isLoading = false;
            _formKey.currentState!.validate();
          });
          return;
        } else if (e.code == 'too-many-requests') {
          setState(() {
            isLoading = false;
          });
          showErrorDialog(
            'Too many requests. Please try again later.',
          );
          return;
        }
      } catch (e) {
        showErrorDialog();
      }

      showSuccessDialog();

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Password"),
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
                  onChanged: (value) {
                    setState(() {
                      _oldPasswordError = null;
                    });
                  },
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
                  onChanged: (value) {
                    setState(() {
                      _newPasswordError = null;
                    });
                  },
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
                  onChanged: (value) {
                    setState(() {
                      _confirmPasswordError = null;
                    });
                  },
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
                ElevatedButton(
                  onPressed: isLoading ? null : _handleSaveButton,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save),
                            Text("Save"),
                          ],
                        ),
                ),
                const SizedBox(
                  height: USpace.space16,
                ),
                // Cancel button
                TextButton(
                  onPressed: isLoading ? null : popCurrent,
                  child: const Text("Cancel"),
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
    );
  }

  void showSuccessDialog() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: "Success",
      text: "Password successfully changed",
    );
  }

  void showErrorDialog([String? message]) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: "Error",
      text: message ?? 'Password change failed',
    );
  }
}
