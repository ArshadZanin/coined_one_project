import 'package:flutter/material.dart';

void validationAlertBox(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        'This overlaps with\nanother schedule and\ncan`t be saved.',
        style: TextStyle(
            color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content:const  Text(
        'Please modify and try again.',
        style: TextStyle(color: Colors.blue, fontSize: 16),
      ),
      titlePadding: const EdgeInsets.only(top: 30, left: 20),
      contentPadding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.blue,
            ),
          ),
          child:const  Text('Okay'),
        ),
      ],
    ),
  );
}
