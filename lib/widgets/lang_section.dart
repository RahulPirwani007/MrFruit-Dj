import 'package:flutter/material.dart';

class LangSection extends StatelessWidget {
  final Color customColor;
  final String langImg;
  final String langText;
  const LangSection({
    super.key,
    required this.customColor,
    required this.langImg,
    required this.langText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: customColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            langImg,
            color: Colors.grey,
            colorBlendMode: BlendMode.srcIn,
          ),
          Text(langText, style: TextStyle(fontSize: 24, color: Colors.white)),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
