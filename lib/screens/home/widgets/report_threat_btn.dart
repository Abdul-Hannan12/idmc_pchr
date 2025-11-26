import 'package:flutter/material.dart';
import 'package:pchr/constants/app_colors.dart';
import 'package:pchr/screens/complaint_form/provider/form_provider.dart';
import 'package:pchr/utils/localization_utils.dart';
import 'package:pchr/utils/size_utils.dart';
import 'package:provider/provider.dart';

class ReportThreatBtn extends StatelessWidget {
  const ReportThreatBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FormProvider>(
      create: (context) => FormProvider(),
      builder: (context, child) {
        return InkWell(
          onTap: () {
            context.read<FormProvider>().sendPanicAlert(context);
          },
          child: Container(
            height: context.percentHeight(12.5),
            width: double.infinity,
            decoration: BoxDecoration(
              color: red,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 3),
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 7,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  height: context.percentHeight(9),
                  'assets/icons/warning.png',
                ),
                const SizedBox(width: 5),
                Text(
                  context.tr("emergency_alert"),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
