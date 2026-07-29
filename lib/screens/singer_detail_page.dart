import 'package:flutter/material.dart';
import 'package:music_player/services/api_services.dart';
import 'package:music_player/services/audio_player_service.dart';
import 'package:music_player/utils/favorite_utils.dart';
import 'package:music_player/widgets/app_background.dart';

class SingerDetailPage extends StatefulWidget {
  final Map<String, dynamic> selectedSinger;
  const SingerDetailPage({super.key, required this.selectedSinger});

  @override
  State<SingerDetailPage> createState() => _SingerDetailPageState();
}

class _SingerDetailPageState extends State<SingerDetailPage> {
  List<dynamic> songList = [];
  bool isIconFill = false;
  Map<String, bool> lickedSongs = {};
  Future<void> callApi() async {
    final result = await ApiServices().getArtistSongs(
      widget.selectedSinger['id'],
    );
    setState(() {
      songList = result;
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
      child: Column(
        children: [
          // artist data
          Padding(
            padding: const EdgeInsets.only(top: 90, left: 10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    widget.selectedSinger['image'].last['url'],
                    height: 100,
                  ),
                ),

                SizedBox(width: 10),

                Text(
                  widget.selectedSinger['name'],
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // song list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 120),
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

                final durationInSeconds =
                    int.tryParse(song["duration"]?.toString() ?? "0") ?? 0;

                final minutes = durationInSeconds ~/ 60;
                final seconds = durationInSeconds % 60;

                final duration =
                    "$minutes:${seconds.toString().padLeft(2, '0')}";

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
                      color: const Color.fromRGBO(255, 255, 255, 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        /// Song Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            song["image"].last["url"],
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// Song Info
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
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                artistNames.isEmpty
                                    ? "Unknown Artist"
                                    : artistNames,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: const Color.fromRGBO(
                                    255,
                                    255,
                                    255,
                                    0.7,
                                  ),
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        /// Duration + Favorite
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              duration,
                              style: TextStyle(
                                color: const Color.fromRGBO(255, 255, 255, 0.7),
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(width: 10),

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
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
