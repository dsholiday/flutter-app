import 'package:flutter/material.dart';

class LabelValue extends StatelessWidget {
  final String label;
  final String value;
  final double fontSize;
  final Color labelColor;
  final Color valueColor;

  const LabelValue({
    super.key,
    required this.label,
    required this.value,
    this.fontSize = 16,
    this.labelColor = Colors.black,
    this.valueColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: labelColor,
              fontSize: fontSize,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: valueColor,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}