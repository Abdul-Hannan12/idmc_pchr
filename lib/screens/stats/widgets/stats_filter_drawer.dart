// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pchr/screens/stats/provider/stats_provider.dart';
import 'package:pchr/screens/stats/widgets/stat_filter.dart';
import 'package:pchr/utils/localization_utils.dart';
import 'package:pchr/utils/nav_utils.dart';
import 'package:pchr/utils/size_utils.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_dropdown.dart';

class StatsFilterDrawer extends StatefulWidget {
  const StatsFilterDrawer({super.key});

  @override
  State<StatsFilterDrawer> createState() => _StatsFilterDrawerState();
}

class _StatsFilterDrawerState extends State<StatsFilterDrawer> {
  @override
  void initState() {
    context.read<StatsProvider>().getProvinces();
    super.initState();
  }

  final ValueNotifier<RangeValues> _rangeNotifier = ValueNotifier<RangeValues>(
      RangeValues(DateTime.now().year - 1, DateTime.now().year.toDouble()));
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(height: context.percentHeight(10)),
            StatFilter(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.date_range,
                    color: primaryBlue,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    context.tr("time_range"),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: primaryBlue,
                    ),
                  ),
                ],
              ),
              children: [
                // const SizedBox(height: 10),
                // CustomSelector(
                //   width: context.percentWidth(45),
                //   height: 30,
                //   firstTitle: context.tr("monthly"),
                //   secondTitle: context.tr("yearly"),
                // ),
                SliderTheme(
                  data: SliderThemeData(
                    rangeThumbShape: RoundRangeSliderThumbShape(
                      enabledThumbRadius: 6,
                      disabledThumbRadius: 6,
                    ),
                    rangeTickMarkShape: RoundRangeSliderTickMarkShape(
                      tickMarkRadius: 3,
                    ),
                    activeTickMarkColor: Colors.red,
                    inactiveTickMarkColor: Colors.red,
                    trackHeight: 5,
                  ),
                  child: ValueListenableBuilder<RangeValues>(
                    valueListenable: _rangeNotifier,
                    builder: (context, rangeValues, child) {
                      return RangeSlider(
                        min: DateTime.now().year - 5,
                        max: DateTime.now().year.toDouble(),
                        labels: RangeLabels(
                          rangeValues.start.toInt().toString(),
                          rangeValues.end.toInt().toString(),
                        ),
                        inactiveColor: grey,
                        values: rangeValues,
                        divisions: 5,
                        activeColor: primaryBlue,
                        onChanged: (values) {
                          // Handle when the start thumb is moved
                          if (_rangeNotifier.value.start != values.start) {
                            // Ensure the start thumb doesn't go beyond the end thumb or below the min
                            if (values.start >= DateTime.now().year - 5 &&
                                values.end - values.start == 1) {
                              _rangeNotifier.value = values;
                              context.read<StatsProvider>().selectedYear =
                                  values.start.toInt().toString();
                            } else if (values.start >=
                                DateTime.now().year - 5) {
                              _rangeNotifier.value = RangeValues(
                                values.start.roundToDouble(),
                                (values.start + 1)
                                    .clamp(DateTime.now().year - 5,
                                        DateTime.now().year)
                                    .roundToDouble(),
                              );
                              context.read<StatsProvider>().selectedYear =
                                  values.start.toInt().toString();
                            }
                          }
                          // Handle when the end thumb is moved
                          else if (_rangeNotifier.value.end != values.end) {
                            // Ensure the end thumb doesn't go beyond the max or below the start thumb
                            if (values.end <= DateTime.now().year &&
                                values.end - values.start == 1) {
                              _rangeNotifier.value = values;
                              context.read<StatsProvider>().selectedYear =
                                  values.start.toInt().toString();
                            } else if (values.end <= DateTime.now().year) {
                              _rangeNotifier.value = RangeValues(
                                (values.end - 1)
                                    .clamp(DateTime.now().year - 5,
                                        DateTime.now().year)
                                    .roundToDouble(),
                                values.end.roundToDouble(),
                              );
                              context.read<StatsProvider>().selectedYear =
                                  ((values.end - 1).clamp(
                                          DateTime.now().year - 5,
                                          DateTime.now().year))
                                      .toInt()
                                      .toString();
                            }
                          }
                        },
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(width: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "${DateTime.now().year - 5}",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: black,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "${DateTime.now().year}",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(thickness: 0.5),
            ),
            StatFilter(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on_sharp,
                    color: primaryBlue,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    context.tr("region_selector"),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: primaryBlue,
                    ),
                  ),
                ],
              ),
              children: [
                // CustomSelector(
                //   width: context.percentWidth(45),
                //   height: 30,
                //   firstTitle: context.tr("city"),
                //   secondTitle: context.tr("province"),
                // ),
                const SizedBox(height: 10),
                Consumer<StatsProvider>(
                  builder: (context, statsProvider, child) {
                    return CustomDropdown(
                      hint: Text(
                        context.tr("province"),
                        style: TextStyle(
                          fontSize: 14,
                          color: grey,
                        ),
                      ),
                      width: context.width / 2,
                      items: statsProvider.provinceIds,
                      labels: statsProvider.provinces,
                      selectedValue: statsProvider.selectedProvince,
                      onChange: (value) {
                        statsProvider.selectedProvince = value;
                      },
                    );
                  },
                )
              ],
            ),
            SizedBox(height: context.percentHeight(5)),
            CustomButton(
              onTap: () async {
                await context.read<StatsProvider>().getTimeWiseStats();
                await context.read<StatsProvider>().getAreaWiseStats();
                context.pop();
              },
              height: 35,
              text: context.tr("apply"),
            ),
          ],
        ),
      ),
    );
  }
}
