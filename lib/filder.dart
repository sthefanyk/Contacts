import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';


class Filder extends StatelessWidget {
  final TextEditingController controller;
  final String hintTextName;
  final IconData iconData;
  final TextInputType textInputType;
  final MaskTextInputFormatter mask;

  const Filder(
      {super.key,
      required this.controller,
      required this.hintTextName,
      required this.iconData,
      required this.mask,
      this.textInputType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        icon: Icon(iconData),
        //hintText: hintTextName,
        filled: true,
        iconColor: Colors.deepPurple.shade700,
        fillColor: Colors.white,
        labelText: hintTextName,
      ),
      keyboardType: textInputType,
      inputFormatters: [mask],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor digite $hintTextName';
        }
        if (hintTextName == 'Email' && !validateEmail(value)) {
          return 'Digite um email válido';
        }
        if (hintTextName == 'Telefone' && !validateTelefone(value)) {
          return 'Digite um telefone válido';
        }
        return null;
      },
    );
  }
}

validateEmail(String email) {
  final emailReg = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  return emailReg.hasMatch(email);
}

validateTelefone(String telefone) {
  final telefoneReg =
      RegExp(r"^\([1-9]{2}\) (?:[2-8]|9[1-9])[0-9]{3}\-[0-9]{4}$");
  //final telefoneReg = RegExp(r"^(?:[+0]9)?[0-9]{10}$");
  return telefoneReg.hasMatch(telefone);
}
