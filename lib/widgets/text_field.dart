import 'package:flutter/material.dart';

class text_field extends StatelessWidget {
   final TextEditingController controller;
  final String? hintText;
  final int?maxlines;

  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  const text_field({
     required this.controller,
    this.hintText,
this.maxlines,
    this.keyboardType = TextInputType.text,
    this.validator,
    super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxlines,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFEAEAEA),
        border: const OutlineInputBorder(
         
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
      ),
    );
  }
}