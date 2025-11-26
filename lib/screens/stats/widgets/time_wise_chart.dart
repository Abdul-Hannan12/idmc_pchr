import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pchr/utils/size_utils.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../provider/stats_provider.dart';

class TimeWiseChart extends StatefulWidget {
  const TimeWiseChart({super.key});

  @override
  State<TimeWiseChart> createState() => _TimeWiseChartState();
}

class _TimeWiseChartState extends State<TimeWiseChart> {
  @override
  void initState() {
    context.read<StatsProvider>().getTimeWiseStats();
    super.initState();
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
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    rightTitles: AxisTitles(),
                    topTitles: AxisTitles(),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta titleMeta) {
                          String txt = '';
                          switch (value.toInt()) {
                            case 1:
                              txt = 'Jan';
                            case 2:
                              txt = 'Feb';
                            case 3:
                              txt = 'Mar';
                            case 4:
                              txt = 'Apr';
                            case 5:
                              txt = 'May';
                            case 6:
                              txt = 'Jun';
                            case 7:
                              txt = 'Jul';
                            case 8:
                              txt = 'Aug';
                            case 9:
                              txt = 'Sep';
                            case 10:
                              txt = 'Oct';
                            case 11:
                              txt = 'Nov';
                            case 12:
                              txt = 'Dec';
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              txt,
                              style: TextStyle(
                                color: slateGrey,
                                fontSize: 7,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              color: slateGrey,
                              fontSize: 7,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: List<BarChartGroupData>.generate(
                    12,
                    (index) => BarChartGroupData(
                      x: index + 1,
                      barRods: [
                        BarChartRodData(
                          toY: double.tryParse(statsProvider.timeWiseData !=
                                      null
                                  ? statsProvider
                                              .timeWiseData!['${index + 1}'] !=
                                          null
                                      ? statsProvider
                                          .timeWiseData!['${index + 1}']
                                          .toString()
                                      : '0.0'
                                  : '0.0') ??
                              0.0,
                          color: purple,
                          borderRadius: BorderRadius.circular(0.5),
                          width: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: primaryBlue,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(5)),
                ),
                child: Text(
                  statsProvider.selectedYear ?? DateTime.now().year.toString(),
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
}
