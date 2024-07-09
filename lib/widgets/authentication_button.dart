import 'package:flutter/material.dart';

class AuthenticationButton extends StatelessWidget {
  final String text;
  final bool loading;
  final Function()? onPressed;

  const AuthenticationButton({
    super.key,
    required this.text,
    this.loading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 50.0,
      minWidth: double.infinity,
      elevation: 2,
      highlightElevation: 5,
      color: Colors.blue,
      shape: const StadiumBorder(),
      onPressed: onPressed,
      disabledColor: Colors.blue[200],
      child: loading
          ? const CircularProgressIndicator(
              color: Colors.white,
              strokeAlign: -2,
            )
          : Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17.0,
              ),
            ),
    );
  }
}
