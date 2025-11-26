import 'package:flutter/material.dart';

class FilterRightIcon extends StatelessWidget {
  const FilterRightIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 3.5,
      children: [
        Container(
          color: Colors.white,
          width: 22,
          height: 1.8,
        ),
        Container(
          color: Colors.white,
          width: 15,
          height: 1.8,
        ),
        Container(
          color: Colors.white,
          width: 8,
          height: 1.8,
        ),
      ],
    );
  }
}
