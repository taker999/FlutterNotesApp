import 'package:flutter/material.dart';

class TagWidget extends StatelessWidget {
  const TagWidget({super.key, required this.tag, required this.themeColors});

  final String tag;
  final ColorScheme themeColors;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: themeColors.secondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(tag),
          InkWell(
              onTap: () {},
              child: Icon(
                Icons.close,
                size: 16,
              )),
        ],
      ),
    );
  }
}
