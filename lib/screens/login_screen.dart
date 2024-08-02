import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:realtime_chat/helpers/custom_page_route.dart';
import 'package:realtime_chat/helpers/show_alert.dart';
import 'package:realtime_chat/screens/screens.dart';
import 'package:realtime_chat/services/auth_service.dart';
import 'package:realtime_chat/services/socket_service.dart';
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
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

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
        AuthenticationButton(
          text: 'Login',
          loading: authService.authenticating,
          onPressed: authService.authenticating
              ? null
              : () async {
                  FocusScope.of(context).unfocus();
                  final loginError = await authService.login(
                      emailController.text.trim(),
                      passwordController.text.trim());

                  if (loginError == null) {
                    socketService.connect();

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ContactsScreen(),
                        ));
                  } else {
                    showAlert(context, 'Login incorrecto', loginError);
                  }
                },
        ),
      ],
    );
  }
}
