import 'package:flutter/material.dart';
import 'package:pchr/constants/app_urls.dart';
import 'package:pchr/constants/hive_boxes.dart';
import 'package:pchr/data/network/network_api_services.dart';
import 'package:pchr/utils/localization_utils.dart';
import 'package:pchr/widgets/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_colors.dart';

class EmergencyNumbersScreen extends StatelessWidget {
  const EmergencyNumbersScreen({super.key});

  void _dialNumber(String phoneNumber) async {
    final Uri url = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "Could not launch $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            CustomAppbar(
              titleText: context.tr("emergency_numbers"),
            ),
            Expanded(
              child: FutureBuilder(
                future: NetworkApiServices().getApi(
                  getEmergencyNumbersApiUrl,
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
                                'https://media.istockphoto.com/id/535695503/photo/pakistan-monument-islamabad.jpg?s=612x612&w=0&k=20&c=bNqjdf8L-5igcRB89DdMgx0kNOmyeo1J_zzXmoxxl8w=',
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              snapshot.data['data'][index]['number'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: primaryBlue,
                              ),
                            ),
                            subtitle: Text(
                              snapshot.data['data'][index]['title'],
                              style: TextStyle(
                                fontSize: 10,
                                color: darkGrey,
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                _dialNumber(
                                    snapshot.data['data'][index]['number']);
                              },
                              icon: Icon(Icons.call),
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
                        context.tr("no_emergency_numbers"),
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
