import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: RichText(
        text: TextSpan(
          text: title + '\n',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          children: <TextSpan>[
            TextSpan(
              text: content,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
