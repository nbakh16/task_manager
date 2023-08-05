import 'package:flutter/material.dart';
import 'package:task_manager/data/utils/colors.dart';

import '../../data/models/task_model.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.taskData,
    required this.onEdit,
    required this.onDelete,
    this.chipColor,
  });

  final TaskData taskData;
  final Function() onEdit, onDelete;
  final Color? chipColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListTile(
            title: Text(taskData.title ?? 'No Title',
              style: Theme.of(context).primaryTextTheme.titleLarge?.copyWith(
                  fontSize: 18
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(taskData.description ?? '',
                  style: Theme.of(context).primaryTextTheme.titleSmall,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 8),
                Text(taskData.createdDate ?? '',
                    style: Theme.of(context).primaryTextTheme.titleSmall
                ),
                Row(
                  children: [
                    Chip(
                      label: SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.20,
                        child: Center(child: Text(taskData.status ?? 'New',
                          style: Theme.of(context).primaryTextTheme.labelMedium,
                        ))
                      ),
                      backgroundColor: chipColor,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, color: mainColor,)
                    ),
                    IconButton(
                        onPressed: onDelete,
                        icon: Icon(Icons.delete, color: Colors.red.shade400,)
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}