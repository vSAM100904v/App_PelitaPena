import 'package:flutter/material.dart';

void openSnackBar(context, snackMessage, color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snackMessage, style: TextStyle(fontSize: 14),), backgroundColor: color, action: SnackBarAction(label: "OK", textColor: Colors.white,onPressed: (){},),));
}

