import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/widgets/mini_player.dart';
import 'package:music_player/services/audio_player_service.dart';

class MainLayout extends StatefulWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;

  final List<String> routes = ["/", "/search", "/favorite"];

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
    context.push(routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      extendBody: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80,
        leading: Image.asset(
          "assets/images/launcher_logo.png",
          fit: BoxFit.cover,
        ),
      ),

      body: Stack(
        children: [
          widget.child,

          ListenableBuilder(
            listenable: AudioPlayerService.instance,
            builder: (context, child) {
              return AudioPlayerService.instance.currentSong != null
                  ? Positioned(
                      bottom: 40,
                      left: 0,
                      right: 0,

                      child: MiniPlayer(
                        song: AudioPlayerService.instance.currentSong!,
                      ),
                    )
                  : const SizedBox();
            },
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Color(0xff241734),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorite",
          ),
        ],
      ),
    );
  }
}
