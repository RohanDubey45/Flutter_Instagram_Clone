import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final bool isPass;
  final TextInputType textInputType;

  const TextInputField({
    super.key,
    required this.textEditingController,
    required this.hintText,
    this.isPass = false,
    required this.textInputType,
  });

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );

    return TextField(
      style: TextStyle(
        fontSize: 15
      ),
      controller: widget.textEditingController,
      decoration: InputDecoration(
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder,
        hintText: widget.hintText,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
        suffixIcon: widget.isPass // checks if it is a password field
            ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                  color: CupertinoColors.systemGrey,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            : null,
      ),
      keyboardType: widget.textInputType,
      obscureText: widget.isPass ? _isObscure : false,
    );
  }
}
