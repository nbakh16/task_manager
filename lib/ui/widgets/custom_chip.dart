import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  const CustomChip(
      {super.key, required this.radio, this.chipColor = Colors.blue});

  final Widget radio;
  final Color chipColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Chip(padding: EdgeInsets.zero,
          label: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.4,
            child: radio,
          ),
          backgroundColor: chipColor,
        ),
      ),
    );
  }
}
