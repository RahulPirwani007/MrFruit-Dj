import 'package:go_router/go_router.dart';
import 'package:music_player/layout/main_layout.dart';
import 'package:music_player/screens/album_detail_page.dart';
import 'package:music_player/screens/favorite_page.dart';
import 'package:music_player/screens/home_page.dart';
import 'package:music_player/screens/search_page.dart';
import 'package:music_player/screens/singer_detail_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(path: "/", builder: (context, state) => HomePage()),
        GoRoute(
          path: "/singerdetailpage",
          builder: (context, state) {
            final selectedSinger = state.extra as Map<String, dynamic>;

            return SingerDetailPage(selectedSinger: selectedSinger);
          },
        ),
        GoRoute(
          path: "/albumdetailpage",
          builder: (context, state) {
            final album = state.extra as Map<String, dynamic>;
            return AlbumDetailPage(album: album);
          },
        ),
        GoRoute(path: "/search", builder: (context, state) => SearchPage()),
        GoRoute(path: "/favorite", builder: (context, state) => FavoritePage()),
      ],
    ),
  ],
);
