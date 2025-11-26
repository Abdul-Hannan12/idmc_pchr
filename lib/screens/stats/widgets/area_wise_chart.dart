import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pchr/screens/stats/provider/stats_provider.dart';
import 'package:pchr/utils/size_utils.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';

class AreaWiseChart extends StatefulWidget {
  const AreaWiseChart({super.key});

  @override
  State<AreaWiseChart> createState() => _AreaWiseChartState();
}

class _AreaWiseChartState extends State<AreaWiseChart> {
  @override
  void initState() {
    context.read<StatsProvider>().getAreaWiseStats();
    super.initState();
  }

  final Map<String, Color> _colorMap = {};

  Color _getColorForKey(String key) {
    return _colorMap.putIfAbsent(
      key,
      () => Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
          .withOpacity(1.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StatsProvider>(
      builder: (context, statsProvider, child) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: offWhite,
                borderRadius: BorderRadius.circular(8),
              ),
              height: context.percentHeight(25),
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 30, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sections: statsProvider.areaWiseData?.entries
                                .map(
                                  (entry) => _sectionData(
                                    entry.value.toDouble(),
                                    _getColorForKey(entry.key),
                                    context.percentHeight(10),
                                  ),
                                )
                                .toList() ??
                            [],
                        sectionsSpace: 0, // Space between sections
                        centerSpaceRadius: 0, // Empty space in the center
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 3,
                    children: statsProvider.areaWiseData?.entries
                            .map(
                              (entry) => _legend(
                                "${entry.key} complaints",
                                _getColorForKey(entry.key),
                              ),
                            )
                            .toList() ??
                        [],
                  ),
                ],
              ),
            ),
            if (statsProvider.selectedProvinceName != null)
              Positioned(
                left: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(5)),
                  ),
                  child: Text(
                    statsProvider.selectedProvinceName ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _legend(String title, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          title,
          style: TextStyle(
            fontSize: 7,
            color: charcoalGrey,
          ),
        ),
      ],
    );
  }

  PieChartSectionData _sectionData(
    double value,
    Color color, [
    double? radius,
  ]) {
    return PieChartSectionData(
      color: color,
      value: value,
      title: '${value.toInt()}%',
      radius: radius ?? 60,
      titleStyle: TextStyle(
        fontSize: 7,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}
