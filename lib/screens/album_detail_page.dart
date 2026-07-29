import 'package:flutter/material.dart';
import 'package:music_player/services/api_services.dart';
import 'package:music_player/services/audio_player_service.dart';
import 'package:music_player/widgets/app_background.dart';
import 'package:music_player/utils/favorite_utils.dart';

class AlbumDetailPage extends StatefulWidget {
  final Map<String, dynamic> album;

  const AlbumDetailPage({super.key, required this.album});

  @override
  State<AlbumDetailPage> createState() => _AlbumDetailPageState();
}

class _AlbumDetailPageState extends State<AlbumDetailPage> {
  List<dynamic> songList = [];

  Future<void> callApi() async {
    final result = await ApiServices().getAlbumDetails(widget.album["id"]);

    setState(() {
      songList = result["songs"] ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    callApi();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: SizedBox.expand(
        child: SafeArea(
          child: Column(
            children: [
              // Album Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        widget.album["image"].last["url"],
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Text(
                        widget.album["name"] ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Songs List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: songList.length,

                  itemBuilder: (context, index) {
                    final song = songList[index];

                    final songName = song["name"].toString().replaceAll(
                      RegExp(r'\s*\(From.*?\)'),
                      '',
                    );

                    final primaryArtists =
                        (song["artists"]?["primary"] as List? ?? []);

                    final featuredArtists =
                        (song["artists"]?["featured"] as List? ?? []);

                    final allArtists = [...primaryArtists, ...featuredArtists];

                    final artistNames = allArtists
                        .map((artist) => artist["name"])
                        .toSet()
                        .join(", ");

                    return GestureDetector(
                      onTap: () async {
                        await AudioPlayerService.instance.playSong(song);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),

                        padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 255, 255, 0.15),

                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),

                              child: Image.network(
                                song["image"].last["url"],

                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    songName,

                                    maxLines: 1,

                                    overflow: TextOverflow.ellipsis,

                                    style: const TextStyle(
                                      color: Colors.white,

                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                    artistNames,

                                    maxLines: 2,

                                    overflow: TextOverflow.ellipsis,

                                    style: TextStyle(
                                      color: const Color.fromRGBO(
                                        255,
                                        255,
                                        255,
                                        0.7,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (FavoriteUtils.isFavorite(song)) {
                                    FavoriteUtils.removeFavorite(song);
                                  } else {
                                    FavoriteUtils.addFavorite(song);
                                  }
                                });
                              },

                              icon: Icon(
                                FavoriteUtils.isFavorite(song)
                                    ? Icons.favorite
                                    : Icons.favorite_border,

                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
