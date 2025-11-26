import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';

class StatFilter extends StatefulWidget {
  final Widget title;
  final List<Widget> children;
  const StatFilter({
    super.key,
    required this.title,
    this.children = const [],
  });

  @override
  State<StatFilter> createState() => _StatFilterState();
}

class _StatFilterState extends State<StatFilter> {
  final expanded = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      trailing: ValueListenableBuilder<bool>(
        valueListenable: expanded,
        builder: (context, value, child) {
          return AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState:
                value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Icon(
              size: 20,
              Icons.remove,
              color: black,
            ),
            secondChild: Icon(
              size: 20,
              Icons.add,
              color: black,
            ),
          );
        },
      ),
      onExpansionChanged: (bool expanded) {
        this.expanded.value = expanded;
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      collapsedIconColor: black,
      iconColor: black,
      title: widget.title,
      children: widget.children,
    );
  }
}
