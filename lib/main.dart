import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pchr/constants/hive_boxes.dart';
import 'package:pchr/core/locale_provider.dart';
import 'package:pchr/models/user/user.dart';
import 'package:pchr/screens/splash/splash_screen.dart';
import 'package:pchr/utils/localization_utils.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await openHiveBoxes();

  runApp(
    ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      child: MyApp(),
    ),
  );
}

Future<Locale> getCurrentLocale(BuildContext context) async {
  Locale locale = Locale(
    languageBox.get('language_code', defaultValue: 'en'),
    languageBox.get('country_code', defaultValue: 'US'),
  );
  
  await context.setLocale(locale, true);
  return locale;
}

Future<void> openHiveBoxes() async {
  // initialization
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);
  Hive.registerAdapter(UserAdapter());

  // open boxes
  languageBox = await Hive.openBox(languageBoxName);
  userBox = await Hive.openBox(userBoxName);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCurrentLocale(context),
      builder: (context, snapshot) {
        return Consumer<LocaleProvider>(
          builder: (context, localeProvider, child) {
            bool isRTL = localeProvider.locale.languageCode == 'ur';
            return MaterialApp(
              title: 'PCHR',
              navigatorKey: navigatorKey,
              theme: ThemeData(
                scaffoldBackgroundColor: Colors.white,
                fontFamily: GoogleFonts.roboto().fontFamily,
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              locale: localeProvider.locale,
              debugShowCheckedModeBanner: false,
              builder: (context, child) {
                return Directionality(
                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                  child: child!,
                );
              },
              home: const SplashScreen(),
            );
          },
        );
      },
    );
  }
}
