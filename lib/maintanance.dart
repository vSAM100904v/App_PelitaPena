import 'package:flutter/material.dart';

class ShowDialogMaintanance {
  void showMyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Maintanance...'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Halaman ini sedang dalam proses'),
                Text('Mohon ditunggu ya...'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Oke'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}