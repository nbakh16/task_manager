import 'package:flutter/material.dart';
import 'package:task_manager/data/utils/colors.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.onEdit,
    required this.onDelete,
    this.chipColor,
  });

  final String title, description, date, status;
  final Function() onEdit, onDelete;
  final Color? chipColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListTile(
            title: Text(title,
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
                Text(description,
                  style: Theme.of(context).primaryTextTheme.titleSmall,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 8),
                Text(date,
                    style: Theme.of(context).primaryTextTheme.titleSmall?.copyWith(
                        color: Colors.black
                    )
                ),
                Row(
                  children: [
                    Chip(
                      label: SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.20,
                        child: Center(child: Text(status,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
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