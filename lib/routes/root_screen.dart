
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import 'package:test_app/src/ui_kit/bottom_bar/bottom_bar.dart';
import 'package:test_app/src/core/theme/a_colors.dart';

class RootScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const RootScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int currentIndex = 0;


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AColors.white,
      child: Stack(
        children: [
          SafeArea(child: widget.navigationShell),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomBottomBar(
              onTap: _onTap,
            ),
          ),
        
        ],
      ),
    );
  }

  void _onTap(int index) {
    currentIndex = index;
    widget.navigationShell.goBranch(
      index,
      initialLocation: true,
    );
   
  }
}

