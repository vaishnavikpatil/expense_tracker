import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 

// ignore: camel_case_types
class datefield extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;

  const datefield({
    super.key,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  // ignore: library_private_types_in_public_api
  _datefieldState createState() => _datefieldState();
}

// ignore: camel_case_types
class _datefieldState extends State<datefield> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          readOnly: true, // Make text field read-only
          onTap: () {
            _selectDate(context);
          },
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.calendar_today_outlined),
            filled: true,
            fillColor: Color(0xFFEAEAEA),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
       
          ),
          validator: widget.validator,
          onChanged: (value) {}, // Handle onChanged if needed
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate:  DateTime(2200),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.controller.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
      });
    }
  }
}
