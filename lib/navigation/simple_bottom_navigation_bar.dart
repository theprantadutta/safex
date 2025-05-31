import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../packages/advanced_salomon_bottom_bar/advanced_salomon_bottom_bar.dart';

class SimpleBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) updateCurrentPageIndex;

  const SimpleBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.updateCurrentPageIndex,
  });

  @override
  Widget build(BuildContext context) {
    return AdvancedSalomonBottomBar(
      currentIndex: selectedIndex,
      onTap: updateCurrentPageIndex,
      items: [
        AdvancedSalomonBottomBarItem(
          icon: const Icon(Symbols.home),
          title: const Text('Home'),
        ),
        AdvancedSalomonBottomBarItem(
          icon: const Icon(Symbols.money),
          title: const Text('Transfers'),
        ),
        AdvancedSalomonBottomBarItem(
          icon: const Icon(Symbols.insights),
          title: const Text('Insights'),
        ),
        AdvancedSalomonBottomBarItem(
          icon: const Icon(Symbols.person),
          title: const Text('Profile'),
        ),
      ],
    );
  }
}
