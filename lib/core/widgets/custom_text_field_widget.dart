import 'package:flutter/material.dart';

// widget untuk membuat textfield custom sesuai kebutuhan
class CustomTextFieldWidget extends StatefulWidget {
  const CustomTextFieldWidget(
      {super.key,
      required this.controller,
      required this.label,
      this.hintText = "",
      this.obscureText = false,
      this.lines = 1,
      this.prefixIcon,
      this.enabled = true,
      this.validator});

  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool obscureText;
  final Icon? prefixIcon;
  final int lines;
  final bool enabled;
  final String? Function(String?)? validator;

  @override
  State<CustomTextFieldWidget> createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.multiline,
      obscureText: widget.obscureText,
      controller: widget.controller,
      enabled: widget.enabled,
      // untuk mengatur jumlah baris jika text field password maka diset menjadi 1 selain itu tergantung variable lines
      maxLines: widget.obscureText ? 1 : widget.lines,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
        fillColor: Colors.grey[200],
        filled: true,
        hintText: widget.hintText,
        labelText: widget.label,
      ),
    );
  }
}
