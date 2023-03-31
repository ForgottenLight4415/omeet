import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardDetailText extends StatelessWidget {
  final String title;
  final String content;

  const CardDetailText({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: RichText(
          text: TextSpan(
              text: title + '\n',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              children: <TextSpan>[
            TextSpan(
              text: content,
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ])),
    );
  }
}
