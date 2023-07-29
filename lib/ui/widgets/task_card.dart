import 'package:flutter/material.dart';
import 'package:task_manager/ui/utils/colors.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListTile(
            title: Text('Task Title which is very very large and long than you can think of',
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
                Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                  style: Theme.of(context).primaryTextTheme.titleSmall,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 8),
                Text('Date: 20/02/2022',
                    style: Theme.of(context).primaryTextTheme.titleSmall?.copyWith(
                        color: Colors.black
                    )
                ),
                Row(
                  children: [
                    Chip(
                      label: SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.20,
                        child: const Center(child: Text('New',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ))
                      ),
                      backgroundColor: Colors.blue,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: (){},
                      icon: const Icon(Icons.edit, color: mainColor,)
                    ),
                    IconButton(
                        onPressed: (){},
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