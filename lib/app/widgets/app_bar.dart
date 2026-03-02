import 'package:flutter/material.dart';
import 'package:sociaanet/core/constants/app_color.dart';

/// Custom AppBar widget for consistent styling across the app
class SociaaNetAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showLogo;
  final bool centerTitle;

  const SociaaNetAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.showLogo = true,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      surfaceTintColor: AppColors.surface,
      leading: leading,
      centerTitle: centerTitle,
      title: showLogo ? _buildLogo() : _buildTitle(),
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.divider, height: 1),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'SociaaNet',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: AppColors.primary,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget? _buildTitle() {
    if (title == null) return null;
    return Text(
      title!,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: AppColors.textPrimary,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}

/// Notification icon button with optional badge
class NotificationIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final int notificationCount;

  const NotificationIconButton({
    super.key,
    this.onPressed,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppColors.textPrimary,
            size: 26,
          ),
          onPressed: onPressed,
        ),
        if (notificationCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                notificationCount > 9 ? '9+' : notificationCount.toString(),
                style: const TextStyle(
                  color: AppColors.textOnPrimary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

// Added notification badge support
