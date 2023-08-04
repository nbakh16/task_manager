import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final Function() onPress;
  final String title;
  final String content;
  final String actionText;

  const CustomAlertDialog(
      {super.key,
      required this.onPress,
      required this.title,
      this.content = '',
      required this.actionText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.only(left: 25, right: 8),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Text(title,
              style: Theme.of(context).primaryTextTheme.titleLarge,
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.cancel_outlined,
                color: Colors.red.withOpacity(0.75),
              ))
        ],
      ),
      content: Text(content,
          style: Theme.of(context).primaryTextTheme.titleSmall
      ),
      actions: [
        TextButton(
          onPressed: onPress,
          child: Text(actionText),
        ),
      ],
    );
  }
}
