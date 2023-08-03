import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../data/utils/assets_utils.dart';


class ScreenBackground extends StatelessWidget {
  final Widget child;
  const ScreenBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SvgPicture.asset(AssetsUtils.backgroundSVG,
            fit: BoxFit.cover,
          ),
        ),

        GestureDetector(
          onTap: ()=> FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.075),
                  child: child,
          ),
              ),
            )),
        )
      ],
    );
  }
}