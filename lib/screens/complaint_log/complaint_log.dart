import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pchr/constants/app_colors.dart';
import 'package:pchr/constants/app_urls.dart';
import 'package:pchr/constants/hive_boxes.dart';
import 'package:pchr/data/network/network_api_services.dart';
import 'package:pchr/models/complaint/complaint.dart';
import 'package:pchr/screens/complaint_details/complaint_details.dart';
import 'package:pchr/utils/localization_utils.dart';
import 'package:pchr/utils/nav_utils.dart';
import 'package:pchr/widgets/custom_appbar.dart';

class ComplaintLogScreen extends StatefulWidget {
  const ComplaintLogScreen({super.key});

  @override
  State<ComplaintLogScreen> createState() => _ComplaintLogScreenState();
}

class _ComplaintLogScreenState extends State<ComplaintLogScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            CustomAppbar(titleText: context.tr("complaint_log")),
            Expanded(
              child: FutureBuilder(
                future: NetworkApiServices().getApi(
                  getComplaintsApiUrl,
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
                    final complaints =
                        snapshot.data.map((c) => Complaint.fromMap(c)).toList();
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 15)
                          .copyWith(bottom: 30),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            context.navigateTo(
                              ComplaintDetailsScreen(
                                complaint: complaints[index],
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.all(15),
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
                            child: Column(
                              children: [
                                Text(
                                  complaints[index].subject ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: primaryBlue,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          complaints[index]
                                                  .status
                                                  ?.prettyName ??
                                              '',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: purple,
                                          ),
                                        ),
                                        Text(
                                          complaints[index]
                                                  .category
                                                  ?.prettyName ??
                                              '',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: darkGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${context.tr("location:")} ${complaints[index].location}",
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: darkGrey,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('MMMM d, y h:mm a').format(
                                              complaints[index].datetime!),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: darkGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 20),
                      itemCount: complaints.length,
                    );
                  } else {
                    return Center(
                      child: Text(
                        context.tr("no_complaints"),
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
