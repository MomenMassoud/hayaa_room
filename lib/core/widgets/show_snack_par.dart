import 'package:flutter/material.dart';

void showSnackBar(String message, context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: const Color.fromARGB(255, 37, 0, 204),
    padding: const EdgeInsets.all(15),
  ));
}
