import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:zola/constants/route.dart';
import 'package:zola/screens/call/video_call_screen.dart';
import 'package:zola/screens/chat/chat_screen.dart';
import 'package:zola/screens/chat/components/create_chat_room_screen.dart';
import 'package:zola/screens/chat_detail/chat_detail_screen.dart';
import 'package:zola/screens/chat_detail/components/add_member_screen.dart';
import 'package:zola/screens/chat_detail/components/chat_room_info_screen.dart';
import 'package:zola/screens/chat_detail/components/manage_member_screen.dart';
import 'package:zola/screens/create_post/create_post_screen.dart';
import 'package:zola/screens/friend/friend_screen.dart';
import 'package:zola/screens/image_view/image_view_screen.dart';
import 'package:zola/screens/loading_screen.dart';
import 'package:zola/screens/notification/notification_screen.dart';
import 'package:zola/screens/post_detail/post_detail_screen.dart';
import 'package:zola/screens/profile/components/update_profile/update_profile.dart';
import 'package:zola/screens/profile/components/user_overview/user_overview_screen.dart';
import 'package:zola/screens/profile/profile_screen.dart';
import 'package:zola/screens/search/search_result_screen.dart';
import 'package:zola/screens/search/search_screen.dart';
import 'package:zola/screens/user_detail/user_detail_screen.dart';
import 'package:zola/screens/video_view/video_view_screen.dart';
import 'package:zola/screens/voice_call/voice_call_screen.dart';
import 'package:zola/widgets/bottom_bar_navigator.dart';
import 'package:zola/screens/home/diary_screen.dart';
import 'package:zola/screens/signup/signup_screen.dart';
import 'package:zola/screens/login/login_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation),
            child: child),
  );
}

// Build with slide transition
CustomTransitionPage buildPageWithSlideTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child),
  );
}

Function routerWithLoading = () => GoRouter(
      initialLocation: RouteConst.loading,
      navigatorKey: _rootNavigatorKey,
      routes: [
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          pageBuilder: (context, state, child) {
            return NoTransitionPage(
                child: ScaffoldWithNavBar(
              location: state.location,
              child: child,
            ));
          },
          routes: [
            GoRoute(
              path: RouteConst.diary,
              parentNavigatorKey: _shellNavigatorKey,
              pageBuilder: (context, state) {
                return const NoTransitionPage(
                    child: DiaryScreen(
                  key: ValueKey("Diary"),
                ));
              },
            ),
            GoRoute(
                parentNavigatorKey: _shellNavigatorKey,
                path: RouteConst.chat,
                pageBuilder: (context, state) {
                  return const NoTransitionPage(
                    child: ChatScreen(),
                    key: ValueKey("Chat"),
                  );
                }),
            GoRoute(
                parentNavigatorKey: _shellNavigatorKey,
                path: RouteConst.friend,
                pageBuilder: (context, state) {
                  return const NoTransitionPage(
                    child: FriendScreen(),
                    key: ValueKey("Friend"),
                  );
                }),
            GoRoute(
                parentNavigatorKey: _shellNavigatorKey,
                path: RouteConst.profile,
                pageBuilder: (context, state) {
                  return const NoTransitionPage(
                    child: ProfileScreen(),
                    key: ValueKey("Profile"),
                  );
                }),
          ],
        ),
        GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: RouteConst.message,
            pageBuilder: (context, state) {
              return NoTransitionPage(
                  child: ChatDetailScreen(id: state.pathParameters['id']!));
            }),
        GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: RouteConst.loading,
            pageBuilder: (context, state) {
              return const NoTransitionPage(child: LoadingScreen());
            }),
        GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: RouteConst.login,
            pageBuilder: (context, state) {
              return const NoTransitionPage(child: LoginScreen());
            }),
        GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: RouteConst.signup,
            pageBuilder: (context, state) {
              return const NoTransitionPage(child: SignUpScreen());
            }),
        GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: RouteConst.search,
            pageBuilder: (context, state) {
              return const NoTransitionPage(child: SearchScreen());
            }),
        GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: RouteConst.postDetail,
            pageBuilder: (context, state) {
              return NoTransitionPage(
                  child: PostDetailScreen(
                id: state.pathParameters['id']!,
              ));
            }),
        GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: RouteConst.userDetail,
            pageBuilder: (context, state) {
              return NoTransitionPage(
                  child: UserDetailScreen(
                username: state.pathParameters['id']!,
              ));
            }),
        GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: RouteConst.profileOverview,
            pageBuilder: (context, state) {
              return NoTransitionPage(
                  child: UserOverviewScreen(
                username: state.pathParameters["username"] as String,
              ));
            }),
        GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: RouteConst.updateProfile,
            pageBuilder: (context, state) {
              return NoTransitionPage(child: UpdateProfileScreen());
            }),
        GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: '/create_post',
            pageBuilder: (context, state) => buildPageWithSlideTransition<void>(
                  context: context,
                  state: state,
                  child: CreatePostScreen(),
                )),
        GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: RouteConst.notification,
            pageBuilder: (context, state) {
              return buildPageWithSlideTransition<void>(
                state: state,
                context: context,
                child: const NotificationScreen(),
              );
            }),
        GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: RouteConst.chatInfo,
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: ChatRoomInfoScreen(
                  id: state.pathParameters['id']!,
                ),
              );
            }),
        GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: RouteConst.createChatRoom,
            pageBuilder: (context, state) {
              return buildPageWithDefaultTransition<void>(
                state: state,
                context: context,
                child: CreateChatRoomScreen(),
              );
            }),
        GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: RouteConst.manageChatMember,
            pageBuilder: (context, state) {
              return buildPageWithDefaultTransition<void>(
                state: state,
                context: context,
                child: ManageChatMemberScreen(
                  id: state.pathParameters["id"]!,
                ),
              );
            }),
        GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: '/search-result',
            pageBuilder: (context, state) {
              return buildPageWithDefaultTransition<void>(
                state: state,
                context: context,
                child: SearchResultScreen(
                  searchText: state.queryParameters["search"]!,
                ),
              );
            }),
        GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: RouteConst.addMemberRoom,
            pageBuilder: (context, state) {
              return buildPageWithDefaultTransition<void>(
                state: state,
                context: context,
                child: const AddMemberScreen(),
              );
            }),
        GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: "/image-view",
            pageBuilder: (context, state) {
              return NoTransitionPage(
                  child: ImageViewScreen(
                imageUrls: state.extra! as List<String>,
                initialIndex: int.parse(state.queryParameters["initialIndex"]!),
              ));
            }),
        GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: "/video-view",
            pageBuilder: (context, state) {
              return NoTransitionPage(
                  child: VideoViewScreen(
                url: state.extra! as String,
              ));
            }),
        GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: RouteConst.voiceCall,
            pageBuilder: (context, state) =>
                buildPageWithDefaultTransition<void>(
                  context: context,
                  state: state,
                  child: VoiceCallScreen(),
                )),
        GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: "${RouteConst.videoCall}/:id",
            pageBuilder: (context, state) => buildPageWithSlideTransition<void>(
                  context: context,
                  state: state,
                  child: VideoCallScreen(),
                )),
      ],
    );
