import 'package:flutter/material.dart';
import 'package:pchr/constants/hive_boxes.dart';
import 'package:pchr/screens/auth/login/login_screen.dart';
import 'package:pchr/screens/verification/verification_status/verification_status.dart';
import 'package:pchr/utils/dialog_utils.dart';
import 'package:pchr/utils/size_utils.dart';
import 'package:provider/provider.dart';

import '../dashboard/dashboard.dart';
import '../verification/provider/verification_provider.dart';
import 'widgets/splash_container_painter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _splashAnimationController;
  late Animation<double> _splashAnimation;

  bool splashAnimated = false;
  bool showScreen = false;

  @override
  void initState() {
    _splashAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    Future.delayed(Duration(seconds: 3)).then((value) {
      // ignore: use_build_context_synchronously
      context.showDisclaimer(
        "This platform is designed solely for the documentation of threats reported by journalists. It does not provide emergency response, legal assistance, physical protection, or any form of direct intervention. Submitting a report through this system does not guarantee any action beyond documentation.\n\nUsers are encouraged to take necessary precautions for their safety and seek support from relevant authorities, legal representatives, or organizations equipped to provide assistance. The platform and its administrators bear no responsibility for any consequences arising from the use of this system.\n\nBy proceeding, you acknowledge and agree that this system is for documentation purposes only and that you are solely responsible for any actions taken based on the information submitted or received.",
      );
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _splashAnimation = Tween<double>(
      begin: -context.height,
      end: 0,
    ).animate(_splashAnimationController);

    _splashAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        showScreen = true;
        Future.delayed(const Duration(milliseconds: 150)).then((val) {
          _splashAnimationController.reverse();
        });
      }
    });

    if (!splashAnimated) {
      _splashAnimationController
        ..reset()
        ..forward();
      splashAnimated = true;
    }
  }

  @override
  void dispose() {
    _splashAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _splashAnimationController,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned.fill(
                child: userBox.isEmpty
                    ? LoginScreen()
                    : storedUser.isApproved ?? false
                        ? Dashboard()
                        : ChangeNotifierProvider<VerificationProvider>(
                            create: (context) => VerificationProvider(),
                            builder: (context, child) {
                              return VerificationStatusScreen();
                            },
                          ),
              ),
              if (!showScreen)
                Positioned.fill(
                  child: ColoredBox(
                    color: Colors.white,
                  ),
                ),
              Positioned(
                top: _splashAnimation.value,
                child: CustomPaint(
                  size: Size(context.width, context.height),
                  painter: SplashDesignContainerPainter(),
                ),
              ),
              Positioned(
                bottom: _splashAnimation.value,
                child: CustomPaint(
                  size: Size(context.width, context.height),
                  painter: SplashDesignContainerPainter(isBottom: true),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
