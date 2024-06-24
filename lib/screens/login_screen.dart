import 'package:flutter/material.dart';
import 'package:realtime_chat/helpers/custom_page_route.dart';
import 'package:realtime_chat/screens/screens.dart';
import 'package:realtime_chat/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  static const String routerName = 'Login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            height: MediaQuery.sizeOf(context).height * 0.95,
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 50.0),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(title: 'Login'),
                _Form(),
                Labels(
                  title: '¿No tienes cuenta?',
                  subtitle: 'Crea una ahora!',
                  page: RegisterScreen(),
                  navigationDirection: CustomDirection.toRight,
                ),
                Text(
                  'Términos y condiciones de uso',
                  style: TextStyle(fontWeight: FontWeight.w200),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomInput(
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
          hintText: 'Email',
        ),
        const SizedBox(height: 14.0),
        CustomInput(
          icon: Icons.lock_outline,
          keyboardType: TextInputType.visiblePassword,
          controller: passwordController,
          hintText: 'Password',
          obscureText: true,
        ),
        const SizedBox(height: 36.0),
        BlueButton(
          text: 'Login',
          onPressed: () {
            print(emailController.text);
            print(passwordController.text);
          },
        ),
      ],
    );
  }
}
