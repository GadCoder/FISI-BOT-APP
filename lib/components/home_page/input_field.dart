import 'package:flutter/material.dart';

abstract class BaseInputField extends StatefulWidget {
  final String inputLabel;
  final String inputInnerText;
  final TextEditingController inputController;
  final IconData inputIcon;

  const BaseInputField({
    super.key,
    required this.inputLabel,
    required this.inputInnerText,
    required this.inputController,
    required this.inputIcon,
  });

  void validateField();
}

class EmailField extends BaseInputField {
  const EmailField({
    super.key,
    required super.inputController,
  }) : super(
            inputLabel: "Correo universitario",
            inputInnerText: "Ingrese su correo universitario",
            inputIcon: Icons.email);

  @override
  State<EmailField> createState() => _EmailFieldState();

  @override
  void validateField() {
    // Add email validation logic here
  }
}

class _EmailFieldState extends State<EmailField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.inputLabel,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          TextField(
            controller: widget.inputController,
            decoration: InputDecoration(
              prefixIcon: Icon(widget.inputIcon),
              hintText: widget.inputInnerText,
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PasswordField extends BaseInputField {
  const PasswordField({
    super.key,
    required super.inputController,
  }) : super(
            inputLabel: "Contraseña",
            inputInnerText: "Ingrese su contraseña",
            inputIcon: Icons.lock);

  @override
  State<PasswordField> createState() => _PasswordFieldState();

  @override
  void validateField() {
    // Add email validation logic here
  }
}

class _PasswordFieldState extends State<PasswordField> {
  late bool _obscureText = true;

  void togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.inputLabel,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          TextField(
              controller: widget.inputController,
              decoration: InputDecoration(
                prefixIcon: Icon(widget.inputIcon),
                hintText: widget.inputInnerText,
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    togglePasswordVisibility();
                  },
                ),
              ),
              obscureText: _obscureText),
        ],
      ),
    );
  }
}
