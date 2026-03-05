import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Reusable avatar widget with cached network image support
class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final String? fallbackName;
  final VoidCallback? onTap;
  final bool showOnlineIndicator;
  final bool isOnline;

  const UserAvatar({
    super.key,
    this.imageUrl,
    this.radius = 20,
    this.fallbackName,
    this.onTap,
    this.showOnlineIndicator = false,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget avatar;
    
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      // Fix localhost URLs for Android emulator
      String url = imageUrl!;
      if (url.contains('localhost')) {
        url = url.replaceAll('localhost', '10.0.2.2');
      }
      if (!url.startsWith('http')) {
        url = 'http://10.0.2.2:8000$url';
      }
      
      avatar = CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: radius,
          backgroundImage: imageProvider,
        ),
        placeholder: (context, url) => CircleAvatar(
          radius: radius,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
          child: Icon(
            Icons.person,
            size: radius,
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
          ),
        ),
        errorWidget: (context, url, error) => _buildFallback(theme),
      );
    } else {
      avatar = _buildFallback(theme);
    }
    
    Widget result = avatar;
    
    if (showOnlineIndicator) {
      result = Stack(
        children: [
          avatar,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: radius * 0.45,
              height: radius * 0.45,
              decoration: BoxDecoration(
                color: isOnline ? Colors.green : Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.surface,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      );
    }
    
    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: result);
    }
    
    return result;
  }
  
  Widget _buildFallback(ThemeData theme) {
    final initial = (fallbackName?.isNotEmpty == true)
        ? fallbackName![0].toUpperCase()
        : '?';
    
    return CircleAvatar(
      radius: radius,
      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
      child: Text(
        initial,
        style: TextStyle(
          fontSize: radius * 0.8,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

// Added online status indicator
