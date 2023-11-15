import '../../config/utils/exports.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isObscure = true;

  void loginBtnPressed() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;
      final authService = ref.watch(authProvider);
      await authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    }
  }

  void navigateToHome() {
    Navigator.pushNamed(context, "/home");
  }

  void displayLoginError(User? result) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.toString()),
        backgroundColor: UColors.red400,
      ),
    );
  }

  Widget emailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Email", style: const UTextStyle().textbasefontnormal),
        const SizedBox(height: USpace.space4),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            hintText: 'Type your email here',
            prefixIcon: Icon(Icons.person),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
        ),
      ],
    );
  }

  // Widget passwordVisibility() {
  //   return IconButton(onPressed: onPressed, icon: icon)
  // }

  Widget passwordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Password", style: const UTextStyle().textbasefontnormal),
        const SizedBox(height: USpace.space4),
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: 'Type your password here',
            prefixIcon: Icon(Icons.lock),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget loginButton() {
    return ElevatedButton(
      onPressed: loginBtnPressed,
      child: const Text('Login'),
    );
  }

  Widget loginForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(
          top: USpace.space24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            emailField(),
            const SizedBox(height: USpace.space20),
            passwordField(),
            const SizedBox(height: USpace.space20),
            loginButton(),
          ],
        ),
      ),
    );
  }

  Widget welcomeMessage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "U-Traffic Enforcer",
          style: const UTextStyle().textxlfontblack.copyWith(
                color: UColors.white,
              ),
        ),
        const SizedBox(
          height: USpace.space56,
        ),
        Text(
          'Welcome!',
          style: const UTextStyle()
              .text4xlfontmedium
              .copyWith(color: UColors.white),
        ),
        const SizedBox(height: USpace.space10),
        Text(
          'Please login to continue',
          style: const UTextStyle()
              .textbasefontnormal
              .copyWith(color: UColors.white),
        ),
        const SizedBox(height: USpace.space28),
      ],
    );
  }

  Widget container({
    required double width,
    required double height,
    required Color bgColor,
    required Widget child,
  }) {
    return Container(
      width: width,
      height: height,
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: child,
    );
  }

  Widget positionWidget({
    required Widget child,
    required double top,
    required double left,
  }) {
    return Positioned(
      top: top,
      left: left,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final screenThird = deviceHeight * 0.3;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          positionWidget(
            child: container(
              width: deviceWidth,
              height: screenThird,
              bgColor: UColors.blue700,
              child: welcomeMessage(),
            ),
            top: 0,
            left: 0,
          ),
          positionWidget(
            child: container(
              width: deviceWidth,
              height: deviceHeight - screenThird,
              bgColor: UColors.white,
              child: loginForm(),
            ),
            top: screenThird,
            left: 0,
          ),
        ],
      ),
    );
  }
}
