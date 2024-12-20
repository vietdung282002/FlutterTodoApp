import 'package:flutter/cupertino.dart';

class AlertDialogWidget extends StatelessWidget {
  const AlertDialogWidget({super.key, required this.content});
  final String content;
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Alert'),
      content: Text(content),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
