import 'package:flutter/material.dart';
import 'package:pchr/constants/app_colors.dart';
import 'package:pchr/screens/dashboard/provider/dashboard_provider.dart';
import 'package:pchr/screens/stats/widgets/area_wise_chart.dart';
import 'package:pchr/screens/stats/widgets/filter_right_icon.dart';
import 'package:pchr/screens/stats/widgets/time_wise_chart.dart';
import 'package:pchr/utils/localization_utils.dart';
import 'package:pchr/utils/size_utils.dart';
import 'package:pchr/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAppbar(
          onBackPressed: () {
            context.read<DashboardProvider>().backToHome();
          },
          titleText: context.tr("statistics"),
          subtitleText: context.tr("stats_subtitle"),
          action: IconButton(
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
            icon: FilterRightIcon(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: context.percentHeight(2)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.date_range,
                    color: primaryBlue,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    context.tr("time_wise_distribution"),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: primaryBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(),
              const SizedBox(height: 10),
              TimeWiseChart(),
              SizedBox(height: context.percentHeight(3)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.location_on_sharp,
                    color: primaryBlue,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    context.tr("area_wise_distribution"),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: primaryBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(),
              const SizedBox(height: 10),
              AreaWiseChart(),
            ],
          ),
        ),
      ],
    );
  }
}
