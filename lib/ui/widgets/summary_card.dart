import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    required this.taskCount,
    required this.taskType,
    this.textColor,
    super.key
  });

  final int taskCount;
  final String taskType;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(taskCount.toString(),
              style: Theme.of(context).primaryTextTheme.titleLarge?.copyWith(
                fontSize: 20, color: textColor
              )
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(taskType,
                style: Theme.of(context).primaryTextTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500, color: textColor
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}