import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:pchr/constants/app_colors.dart';
import 'package:pchr/models/complaint/complaint.dart';
import 'package:pchr/utils/size_utils.dart';
import 'package:pchr/widgets/custom_appbar.dart';

class ComplaintDetailsScreen extends StatefulWidget {
  final Complaint complaint;
  const ComplaintDetailsScreen({super.key, required this.complaint});

  @override
  State<ComplaintDetailsScreen> createState() => _ComplaintDetailsScreenState();
}

class _ComplaintDetailsScreenState extends State<ComplaintDetailsScreen> {
  TileLayer openStreetMapTileLayer = TileLayer(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            CustomAppbar(titleText: widget.complaint.subject ?? 'Details'),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20).copyWith(top: 0),
                  child: Column(
                    children: [
                      Text(
                        widget.complaint.subject ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 80,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: widget.complaint.status?.bgColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: primaryBlue),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 4,
                                  color: Color(0xFF2A9D8F),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                widget.complaint.status?.prettyName ?? '',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: widget.complaint.status?.textColor,
                                ),
                              ),
                            ),
                          ),
                          if (widget.complaint.concernedDepartment != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFF2A9D8F),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: primaryBlue),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 4,
                                    color: Color(0xFF2A9D8F),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  widget.complaint.concernedDepartment ?? '',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('MMMM d, y h:mm a')
                                .format(widget.complaint.datetime!),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: darkGrey,
                            ),
                          ),
                          Text(
                            widget.complaint.category?.prettyName ?? '',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: darkGrey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.complaint.description ?? '',
                        style: TextStyle(
                          fontSize: 10,
                          color: black,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_sharp,
                            color: primaryBlue,
                            size: 15,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Location",
                            // "Location: ${widget.complaint.location}",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: primaryBlue,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      Container(
                        height: context.percentHeight(30),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF5F5F5F).withValues(alpha: 0.25),
                              offset: const Offset(0, 3),
                              spreadRadius: 1,
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: widget.complaint.position ??
                                  LatLng(30.3753, 69.3451),
                              initialZoom: 11,
                              interactionOptions: InteractionOptions(
                                flags: ~InteractiveFlag.pinchZoom,
                              ),
                            ),
                            children: [
                              openStreetMapTileLayer,
                              MarkerLayer(
                                markers: [
                                  if (widget.complaint.position != null)
                                    Marker(
                                      point: LatLng(
                                        widget.complaint.position!.latitude,
                                        widget.complaint.position!.longitude,
                                      ),
                                      child: Icon(
                                        Icons.location_pin,
                                        color: red,
                                        size: 40,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
