import 'package:flutter/material.dart';



class dropdownfield extends FormField<dynamic> {

  final bool required;
  final dynamic value;
  final List<DropdownMenuItem<dynamic>> items;
  final String? Function(dynamic)? validator; 
  final Function onChanged;
  final bool filled;
  final EdgeInsets contentPadding;

  dropdownfield({
    required FormFieldSetter<dynamic> onSaved,
    this.validator,
    AutovalidateMode autovalidate = AutovalidateMode.disabled,

    this.required = false,
    this.value,
    required this.items,
    required this.onChanged,
    this.filled = true,
    this.contentPadding = const EdgeInsets.fromLTRB(10, 0, 10, 0),
  }) : super(
          onSaved: onSaved,
          validator: validator != null
              ? (dynamic newValue) => validator(newValue) // Apply the validator function
              : null,
          autovalidateMode: autovalidate,
          initialValue: value == '' ? null : value,
          builder: (FormFieldState<dynamic> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InputDecorator(
                  decoration: const InputDecoration(
                    
                    filled: true,
                    fillColor: Color(0xFFEAEAEA),
                    border: OutlineInputBorder(
                     
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<dynamic>(
                    
                      underline: const SizedBox(),
                      value: value == '' ? null : value,
                      onChanged: (dynamic newValue) {
                        state.didChange(newValue);
                        onChanged(newValue);
                      },
                      items: items,
                    ),
                  ),
                ),
                SizedBox(height: state.hasError ? 5.0 : 0.0),
                Text(
                  state.errorText ?? '', 
                  style: TextStyle(
                    color: Colors.redAccent.shade700,
                    fontSize: state.hasError ? 12.0 : 0.0,
                  ),
                ),
              ],
            );
          },
        );
}
