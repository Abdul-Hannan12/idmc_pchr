import 'package:flutter/material.dart';
import 'package:pchr/constants/app_colors.dart';
import 'package:pchr/constants/app_urls.dart';
import 'package:pchr/constants/hive_boxes.dart';
import 'package:pchr/data/network/network_api_services.dart';
import 'package:pchr/utils/localization_utils.dart';
import 'package:pchr/widgets/custom_appbar.dart';

class FaqsScreen extends StatelessWidget {
  const FaqsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomAppbar(
              titleText: 'FAQs',
              subtitleText:
                  'This FAQ section is here to help you find answers to common questions.',
            ),
            FutureBuilder(
              future: NetworkApiServices().getApi(
                getFaqsApiUrl,
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
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 1),
                              blurRadius: 7,
                              color: Colors.black.withValues(alpha: 0.08),
                            ),
                          ],
                        ),
                        child: ExpansionTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          collapsedIconColor: black,
                          iconColor: black,
                          title: Text(
                            snapshot.data['data'][index]['question'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: primaryBlue,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Text(
                                snapshot.data['data'][index]['answer'],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: slateGrey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: snapshot.data['data'].length,
                  );
                } else {
                  return Center(
                    child: Text(context.tr("no_faqs")),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
