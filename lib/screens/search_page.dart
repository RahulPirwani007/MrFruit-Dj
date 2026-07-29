import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_player/services/api_services.dart';
import 'package:music_player/services/audio_player_service.dart';
import 'package:music_player/widgets/app_background.dart';
import 'package:music_player/widgets/lang_section.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ApiServices api = ApiServices();

  final TextEditingController _controller = TextEditingController();

  Map<String, dynamic> searchData = {};

  bool loading = false;

  Timer? _debounce;

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      if (!mounted) return;
      setState(() {
        searchData = {};
        loading = false;
      });
      return;
    }

    setState(() {
      loading = true;
    });

    final data = await api.searchAll(query);

    if (!mounted) return;

    setState(() {
      searchData = data;
      loading = false;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final songs = searchData["songs"] ?? [];
    final artists = searchData["artists"] ?? [];
    final albums = searchData["albums"] ?? [];

    return AppBackground(
      child: SafeArea(
        child: Column(
          children: [
            /// Search Box
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 20, 12, 10),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Search songs, artists...",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _controller.clear();

                            setState(() {
                              searchData = {};
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  setState(() {});

                  _debounce?.cancel();

                  _debounce = Timer(
                    const Duration(milliseconds: 500),
                    () => _search(value),
                  );
                },
              ),
            ),

            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  /// Default Language Grid
                  : searchData.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: GridView(
                        padding: EdgeInsets.zero,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              mainAxisExtent: 80,
                            ),
                        children: const [
                          LangSection(
                            customColor: Colors.red,
                            langImg: "assets/images/hindi_icon.png",
                            langText: "Hindi",
                          ),
                          LangSection(
                            customColor: Colors.blue,
                            langImg: "assets/images/english_icon.png",
                            langText: "English",
                          ),
                        ],
                      ),
                    )
                  /// Search Results
                  : ListView(
                      padding: const EdgeInsets.only(bottom: 20),
                      children: [
                        /// Songs
                        if (songs.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              "Songs",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ...songs.map<Widget>((song) {
                            return ListTile(
                              onTap: () async {
                                final player = AudioPlayerService.instance;

                                if (player.currentSong?["id"] == song["id"]) {
                                  if (player.isPlaying) {
                                    await player.pauseSong();
                                  } else {
                                    await player.resumeSong();
                                  }
                                } else {
                                  await player.playSong(song);
                                }
                              },
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  (song["image"] != null &&
                                          song["image"].isNotEmpty)
                                      ? song["image"].last["url"]
                                      : "",
                                  width: 55,
                                  height: 55,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (
                                        BuildContext context,
                                        Object error,
                                        StackTrace? stackTrace,
                                      ) {
                                        return const Icon(
                                          Icons.music_note,
                                          color: Colors.white,
                                        );
                                      },
                                ),
                              ),
                              title: Text(
                                song["name"],
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                song["primaryArtists"] ?? "",
                                style: const TextStyle(color: Colors.white70),
                              ),
                            );
                          }).toList(),
                        ],

                        /// Artists
                        if (artists.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              "Artists",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ...artists.map<Widget>((artist) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    (artist["image"] != null &&
                                        artist["image"].isNotEmpty)
                                    ? NetworkImage(artist["image"].last["url"])
                                    : null,
                                child: artist["image"] == null
                                    ? const Icon(Icons.person)
                                    : null,
                              ),

                              title: Text(
                                artist["name"],
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                        ],

                        /// Albums
                        if (albums.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              "Albums",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ...albums.map<Widget>((album) {
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  album["image"][2]["url"],
                                  width: 55,
                                  height: 55,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                album["name"],
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                album["artist"]?["name"] ?? "",
                                style: const TextStyle(color: Colors.white70),
                              ),
                            );
                          }).toList(),
                        ],

                        if (songs.isEmpty && artists.isEmpty && albums.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 100),
                            child: Center(
                              child: Text(
                                "No results found",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
