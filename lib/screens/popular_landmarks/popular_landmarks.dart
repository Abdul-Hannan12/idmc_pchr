import 'package:flutter/material.dart';
import 'package:pchr/constants/app_urls.dart';
import 'package:pchr/constants/hive_boxes.dart';
import 'package:pchr/data/network/network_api_services.dart';
import 'package:pchr/utils/localization_utils.dart';
import 'package:pchr/widgets/custom_appbar.dart';

import '../../constants/app_colors.dart';

class PopularLandmarksScreen extends StatelessWidget {
  const PopularLandmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            CustomAppbar(
              title: Image.asset('assets/icons/landmark.png'),
              titleText: context.tr("popular_landmarks"),
            ),
            Expanded(
              child: FutureBuilder(
                future: NetworkApiServices().getApi(
                  getPopularLandmarksNumbersApiUrl,
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
                                // 'https://media.istockphoto.com/id/535695503/photo/pakistan-monument-islamabad.jpg?s=612x612&w=0&k=20&c=bNqjdf8L-5igcRB89DdMgx0kNOmyeo1J_zzXmoxxl8w=',
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
                        context.tr("no_landmarks"),
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
