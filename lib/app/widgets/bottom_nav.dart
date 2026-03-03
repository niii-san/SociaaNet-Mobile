import 'package:flutter/material.dart';
import 'package:sociaanet/core/constants/app_color.dart';

/// Bottom navigation bar items enum for type safety
enum NavItem { home, search, post, dm, profile }

/// Custom bottom navigation bar widget
class SociaaNetBottomNav extends StatelessWidget {
  final NavItem currentItem;
  final ValueChanged<NavItem> onItemSelected;

  const SociaaNetBottomNav({
    super.key,
    required this.currentItem,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: NavItem.values.map((item) {
              return _NavItemWidget(
                item: item,
                isSelected: currentItem == item,
                onTap: () => onItemSelected(item),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItemWidget extends StatelessWidget {
  final NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItemWidget({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Special styling for Post button
    if (item == NavItem.post) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.add, color: AppColors.textOnPrimary, size: 26),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Icon(
          _getIcon(item, isSelected),
          color: isSelected ? AppColors.primary : AppColors.textTertiary,
          size: 28,
        ),
      ),
    );
  }

  IconData _getIcon(NavItem item, bool isSelected) {
    switch (item) {
      case NavItem.home:
        return isSelected ? Icons.home : Icons.home_outlined;
      case NavItem.search:
        return isSelected ? Icons.search : Icons.search_outlined;
      case NavItem.post:
        return Icons.add_box_outlined;
      case NavItem.dm:
        return isSelected ? Icons.chat_bubble : Icons.chat_bubble_outline;
      case NavItem.profile:
        return isSelected ? Icons.person : Icons.person_outline;
    }
  }
}

// Added badge count for notifications tab
