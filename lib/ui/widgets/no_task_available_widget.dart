import 'package:flutter/material.dart';

import '../../data/utils/colors.dart';

class NoTaskAvailable extends StatelessWidget {
  const NoTaskAvailable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 56.0),
      child: Column(
        children: [
          Icon(
            Icons.info_outline,
            size: MediaQuery.sizeOf(context).width * 0.25,
            color: mainColor.shade300,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text('No New Task'),
          )
        ],
      ),
    );
  }
}