import 'package:flutter/material.dart';
import 'package:pchr/constants/app_urls.dart';
import 'package:pchr/data/network/network_api_services.dart';
import 'package:pchr/utils/localization_utils.dart';
import 'package:pchr/widgets/custom_appbar.dart';

import '../../constants/app_colors.dart';
import '../../constants/hive_boxes.dart';

class EmergencyUnitsScreen extends StatelessWidget {
  const EmergencyUnitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            CustomAppbar(
              title: Image.asset('assets/icons/emergency_unit.png'),
              titleText: context.tr("nearest_emergency_units"),
            ),
            Expanded(
              child: FutureBuilder(
                future: NetworkApiServices().getApi(
                  getEmergencyUnitsApiUrl,
                  isAuth: true,
                  token: storedUser.token,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: primaryOrange,
                        strokeWidth: 5,
                      ),
                    );
                  } else if (snapshot.hasData) {
                    return ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 10)
                          .copyWith(bottom: 40),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 7,
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: primaryOrange),
                              ),
                              child: Image.network(
                                // 'https://crystalpng.com/wp-content/uploads/2023/10/punjab-police-logo-png.png',
                                snapshot.data['data'][index]['image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              snapshot.data['data'][index]['title'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: primaryBlue,
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 15),
                      itemCount: snapshot.data['data'].length,
                    );
                  } else {
                    return Center(
                      child: Text(
                        context.tr("no_emergency_units"),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
