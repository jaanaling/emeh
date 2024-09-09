import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/src/core/theme/a_colors.dart';
import 'package:test_app/src/core/utils/icon_provider.dart';
import 'package:test_app/src/ui_kit/custom_icon/custom_icon.dart';

class CustomBottomBar extends StatefulWidget {
  final Function(int) onTap;

  const CustomBottomBar({super.key, required this.onTap});

  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      widget.onTap(_selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 26),
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(IconProvider.second.buildImageUrl(), 0),
          _buildNavItem(IconProvider.first.buildImageUrl(), 1),
        ],
      ),
    );
  }

  Widget _buildNavItem(String icon, int index) {
    final isSelected = _selectedIndex == index;
    const double size = 34;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedScale(
        scale: isSelected ? 1.2 : 1,
        duration: const Duration(milliseconds: 200),
        child: CustomIcon(
          asset: icon,
          width:  size ,
          height: size ,
          color: isSelected ? CupertinoColors.activeBlue : AColors.black100,
        ),
      ),
    );
  }
}
