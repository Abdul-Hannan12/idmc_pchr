import 'package:flutter/material.dart';
import 'package:pchr/screens/dashboard/provider/dashboard_provider.dart';
import 'package:pchr/screens/home/home.dart';
import 'package:pchr/screens/home/widgets/home_drawer.dart';
import 'package:pchr/screens/profile/profile.dart';
import 'package:pchr/screens/stats/stats.dart';
import 'package:pchr/screens/stats/widgets/stats_filter_drawer.dart';
import 'package:pchr/utils/localization_utils.dart';
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart'
    as pusher_channels;
import '../../constants/app_colors.dart';
import '../stats/provider/stats_provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final pusher_channels.PusherChannelsFlutter _pusher =
      pusher_channels.PusherChannelsFlutter.getInstance();

  @override
  void initState() {
    initPusher();
    super.initState();
  }

  void initPusher() async {
    try {
      await _pusher.init(
        apiKey: 'b555a7a708df7ccc823c',
        cluster: 'ap2',
      );

      _pusher.onConnectionStateChange = (current, previous) {
        debugPrint('Connection state changed: $current -> $previous');
      };

      _pusher.onError = (message, code, error) {
        debugPrint('Pusher Error: $message, Code: $code, Exception: $error');
      };

      _pusher.onEvent = (event) {
        debugPrint("Pusher Event: $event");
      };

      // await _pusher.subscribe(channelName: "public.notifications");

      await _pusher.connect();
    } catch (e) {
      debugPrint('Pusher initialization error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DashboardProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => StatsProvider(),
        ),
      ],
      child: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          return SafeArea(
            child: Scaffold(
              drawer: HomeDrawer(),
              endDrawer: StatsFilterDrawer(),
              body: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: provider.pageController,
                children: [
                  HomeScreen(),
                  StatsScreen(),
                  ProfileScreen(),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                onTap: (value) {
                  provider.updatePage(value);
                },
                backgroundColor: primaryBlue,
                selectedItemColor: primaryOrange,
                unselectedItemColor: Colors.white,
                currentIndex: provider.currentIndex,
                elevation: 0,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                iconSize: 20,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: context.tr("home"),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.bar_chart_sharp),
                    label: context.tr("stats"),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: context.tr("profile"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
