import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pchr/constants/app_colors.dart';
import 'package:pchr/screens/emergency_units/emergency_units.dart';
import 'package:pchr/screens/popular_landmarks/popular_landmarks.dart';
import 'package:pchr/utils/gps_utils.dart';
import 'package:pchr/utils/localization_utils.dart';
import 'package:pchr/utils/nav_utils.dart';
import 'package:pchr/utils/size_utils.dart';
import 'package:pchr/widgets/custom_appbar.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({super.key});

  @override
  State<CurrentLocationScreen> createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  late final List<Map<String, dynamic>> _items = [
    // {
    //   'iconName': 'address',
    //   'title': context.tr("enter_address"),
    //   'ontap': () {},
    // },
    {
      'iconName': 'landmark',
      'title': context.tr("popular_landmarks"),
      'ontap': () {
        context.navigateTo(PopularLandmarksScreen());
      },
    },
    {
      'iconName': 'emergency_unit',
      'title': context.tr("nearest_emergency_units"),
      'ontap': () {
        context.navigateTo(EmergencyUnitsScreen());
      },
    },
  ];

  LatLng? currentLatLng;

  TileLayer openStreetMapTileLayer = TileLayer(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
  );

  late final MapController _mapController;

  @override
  void initState() {
    getLoc();
    _mapController = MapController();
    super.initState();
  }

  void getLoc() async {
    final location = await getLocation();
    if (location != null) {
      currentLatLng = LatLng(location.latitude, location.longitude);
      _mapController.move(currentLatLng!, 10);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            CustomAppbar(
              titleText: context.tr("current_location"),
              subtitleText: context.tr("select_nearest_location"),
              bottomSpacing: 0,
            ),
            Container(
              height: context.percentHeight(35),
              color: primaryBlue,
              padding: const EdgeInsets.all(25),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: currentLatLng ?? LatLng(30.3753, 69.3451),
                    initialZoom: 10,
                    // initialZoom: 11,
                    interactionOptions: InteractionOptions(
                      flags: ~InteractiveFlag.pinchZoom,
                    ),
                  ),
                  children: [
                    openStreetMapTileLayer,
                    MarkerLayer(
                      markers: [
                        if (currentLatLng != null)
                          Marker(
                            point: LatLng(
                              currentLatLng!.latitude,
                              currentLatLng!.longitude,
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
            SizedBox(height: context.percentHeight(4)),
            ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
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
                    onTap: _items[index]['ontap'],
                    leading: Image.asset(
                      height: 20,
                      "assets/icons/${_items[index]['iconName']}.png",
                      color: primaryBlue,
                    ),
                    title: Text(
                      _items[index]['title'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: primaryBlue,
                      ),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: primaryBlue,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) =>
                  SizedBox(height: context.percentHeight(3)),
              itemCount: _items.length,
            ),
          ],
        ),
      ),
    );
  }
}
