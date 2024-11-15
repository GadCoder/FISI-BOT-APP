import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

class Login {
  var logger = Logger();

  void showAlertToast(String message) {
    Fluttertoast.showToast(msg: message, backgroundColor: Colors.red.shade400);
  }

  bool fieldIsEmpty(String fieldText) {
    return fieldText.isEmpty;
  }

  bool validateEmail(String email) {
    return RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(email);
  }

  bool validatePassword(String password) {
    return password.isEmpty;
  }

  bool areCredentialsValid(String email, String password) {
    logger.d("EMAIL: $email");
    logger.d("PASSWORD: $password");

    if (fieldIsEmpty(email)) {
      showAlertToast("EL correo no puede estar vacio");
      return false;
    }
    if (!validateEmail(email)) {
      showAlertToast("EL correo ingresado no es válido :(");
      return false;
    }
    if (validatePassword(password)) {
      showAlertToast("La contraseña no puede estar vacia");
      return false;
    }
    return true;
  }

}
