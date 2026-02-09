import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/features/auth/presentation/pages/splash_screen.dart';
import 'package:sociaanet/features/auth/presentation/pages/login_screen.dart';
import 'package:sociaanet/app/screens/onboarding_screen.dart';
import 'package:sociaanet/app/screens/main_shell.dart';
import 'package:sociaanet/app/screens/home_feed_screen.dart';
import 'package:sociaanet/app/screens/explore_screen.dart';
import 'package:sociaanet/app/screens/notifications_screen.dart';
import 'package:sociaanet/app/screens/inbox_screen.dart';
import 'package:sociaanet/app/screens/chat_screen.dart';
import 'package:sociaanet/app/screens/profile_screen.dart';
import 'package:sociaanet/app/screens/user_profile_screen.dart';
import 'package:sociaanet/app/screens/create_post_screen.dart';
import 'package:sociaanet/app/screens/create_reel_screen.dart';
import 'package:sociaanet/app/screens/reels_screen.dart';
import 'package:sociaanet/app/screens/post_detail_screen.dart';
import 'package:sociaanet/app/screens/settings_screen.dart';
import 'package:sociaanet/app/screens/activities_screen.dart';
import 'package:sociaanet/app/screens/change_password_screen.dart';
import 'package:sociaanet/app/screens/follow_requests_screen.dart';
import 'package:sociaanet/app/screens/edit_profile_screen.dart';
import 'package:sociaanet/features/auth/presentation/pages/signup_screen.dart';

/// Navigation keys
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Route names
class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const explore = '/explore';
  static const notifications = '/notifications';
  static const inbox = '/inbox';
  static const chat = '/inbox/:conversationId';
  static const profile = '/profile';
  static const userProfile = '/u/:username';
  static const createPost = '/create-post';
  static const createReel = '/create-reel';
  static const reels = '/reels';
  static const postDetail = '/posts/:postId';
  static const settings = '/settings';
  static const activities = '/settings/activities';
  static const changePassword = '/settings/change-password';
  static const followRequests = '/follow-requests';
  static const editProfile = '/edit-profile';
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      // Splash
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => SplashScreen(
          nextPage: OnboardingScreen(
            nextPage: const LoginScreen(),
          ),
        ),
      ),
      // Onboarding
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => OnboardingScreen(
          nextPage: const LoginScreen(),
        ),
      ),
      // Auth Routes
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),

      // Main Shell with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeFeedScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.explore,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ExploreScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.notifications,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: NotificationsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.inbox,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: InboxScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),

      // Full-screen routes (outside shell)
      GoRoute(
        path: AppRoutes.chat,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final conversationId = state.pathParameters['conversationId']!;
          return ChatScreen(conversationId: conversationId);
        },
      ),
      GoRoute(
        path: AppRoutes.userProfile,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final username = state.pathParameters['username']!;
          return UserProfileScreen(username: username);
        },
      ),
      GoRoute(
        path: AppRoutes.createPost,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreatePostScreen(),
      ),
      GoRoute(
        path: AppRoutes.createReel,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateReelScreen(),
      ),
      GoRoute(
        path: AppRoutes.reels,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ReelsScreen(),
      ),
      GoRoute(
        path: AppRoutes.postDetail,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final postId = state.pathParameters['postId']!;
          return PostDetailScreen(postId: postId);
        },
      ),
      GoRoute(
        path: AppRoutes.settings,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.activities,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ActivitiesScreen(),
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.followRequests,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const FollowRequestsScreen(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EditProfileScreen(),
      ),
    ],
  );
});
