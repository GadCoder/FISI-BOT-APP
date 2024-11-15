import 'package:flutter/material.dart';

import '../home_page/input_field.dart';

class SearchField extends BaseInputField {
  const SearchField({
    super.key,
    required super.inputController,
  }) : super(
            inputLabel: "Buscar curso",
            inputInnerText: "Ingrese el curso que desee buscar",
            inputIcon: Icons.search);

  @override
  State<SearchField> createState() => _SearchFieldState();

  @override
  void validateField() {
    // Add email validation logic here
  }
}

class _SearchFieldState extends State<SearchField> {
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
