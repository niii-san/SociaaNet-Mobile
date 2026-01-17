import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import 'home_feed_screen.dart';
import 'search_screen.dart';
import 'create_post_screen.dart';
import 'dm_screen.dart';
import 'profile_screen.dart';

/// Main navigation shell that handles bottom navigation and screen switching
class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  NavItem _currentItem = NavItem.home;

  // Keep screens alive when switching tabs
  final Map<NavItem, Widget> _screens = {
    NavItem.home: const HomeFeedScreen(),
    NavItem.search: const SearchScreen(),
    NavItem.dm: const DirectMessagesScreen(),
    NavItem.profile: const ProfileScreen(),
  };

  void _onItemSelected(NavItem item) {
    if (item == NavItem.post) {
      // Open create post screen as modal
      Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => const CreatePostScreen(),
        ),
      );
    } else {
      setState(() {
        _currentItem = item;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _getScreenIndex(_currentItem),
        children: [
          _screens[NavItem.home]!,
          _screens[NavItem.search]!,
          _screens[NavItem.dm]!,
          _screens[NavItem.profile]!,
        ],
      ),
      bottomNavigationBar: SociaaNetBottomNav(
        currentItem: _currentItem,
        onItemSelected: _onItemSelected,
      ),
    );
  }

  int _getScreenIndex(NavItem item) {
    switch (item) {
      case NavItem.home:
        return 0;
      case NavItem.search:
        return 1;
      case NavItem.dm:
        return 2;
      case NavItem.profile:
        return 3;
      case NavItem.post:
        return 0; // Fallback, though this shouldn't be called
    }
  }
}
