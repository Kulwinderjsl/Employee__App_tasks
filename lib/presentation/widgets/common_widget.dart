import 'package:flutter/material.dart';

void showOkDialog(BuildContext context,String title,String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}