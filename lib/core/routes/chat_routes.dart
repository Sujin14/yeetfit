import 'package:go_router/go_router.dart';
import 'package:yeetfit/features/chat/presentation/screens/admin_list_screen.dart';
import 'package:yeetfit/features/chat/presentation/screens/chat_screen.dart';
import 'package:yeetfit/features/chatbot/presentation/screens/chatbot_screen.dart';
import 'chat_route_constants.dart';

// Routes for chat and chatbot features.
List<GoRoute> get chatRoutes => [
  GoRoute(
    path: ChatRouteConstants.adminList,
    builder: (context, state) => const AdminListScreen(),
  ),
  GoRoute(
    path: ChatRouteConstants.chat,
    builder: (context, state) => ChatScreen(adminId: state.extra as String),
  ),
  GoRoute(
    path: ChatRouteConstants.chatbot,
    builder: (context, state) => const ChatbotScreen(),
  ),
];
