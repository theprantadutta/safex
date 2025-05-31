import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/insights_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/transfer_screen.dart';

const kTopLevelPages = [
  HomeScreen(),
  TransferScreen(),
  InsightsScreen(),
  ProfileScreen(),
];

class TopLevelPageView extends StatelessWidget {
  final PageController pageController;
  final Function(int) onPageChanged;
  const TopLevelPageView({
    super.key,
    required this.pageController,
    required this.onPageChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Decoration (non-interactive)
        // IgnorePointer(
        //   ignoring: true,
        //   child: Container(
        //     decoration: const BoxDecoration(
        //       image: DecorationImage(
        //         image: AssetImage("assets/images/zakat_logo_2.png"),
        //         fit: BoxFit.fitHeight,
        //         opacity: 0.05,
        //       ),
        //     ),
        //   ),
        // ),
        // PageView (handles gestures)
        // PageView(
        //   onPageChanged: onPageChanged,
        //   controller: pageController,
        //   padEnds: true,
        //   children: kTopLevelPages,
        // ),
        PageView.builder(
          onPageChanged: onPageChanged,
          controller: pageController,
          padEnds: true,
          itemCount: kTopLevelPages.length,
          itemBuilder: (context, index) {
            return kTopLevelPages[index];
          },
        ),
        // Floating button overlay
        // TODO: Uncomment this later
        // if (!kReleaseMode)
        //   Positioned(
        //     right: 10,
        //     bottom: 10,
        //     child: const FloatingThemeChangeButton(),
        //   ),
      ],
    );
  }
}
