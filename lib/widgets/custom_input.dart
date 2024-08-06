import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final TextEditingController controller;

  const CustomInput({
    super.key,
    required this.icon,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 5),
              blurRadius: 5.0)
        ],
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 10.0),
          Expanded(
            child: TextFormField(
              controller: controller,
              autocorrect: false,
              keyboardType: keyboardType,
              textCapitalization: textCapitalization,
              obscureText: obscureText,
              decoration: InputDecoration(
                // prefixIcon: Icon(icon),
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
