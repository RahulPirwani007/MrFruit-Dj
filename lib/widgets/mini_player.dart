import 'package:flutter/material.dart';
import 'package:music_player/services/audio_player_service.dart';

class MiniPlayer extends StatefulWidget {
  final Map<String, dynamic> song;

  const MiniPlayer({super.key, required this.song});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  Widget build(BuildContext context) {
    final songName = widget.song["name"] ?? "Unknown Song";

    final imageUrl = widget.song["image"] != null
        ? widget.song["image"].last["url"]
        : "";

    final artistName =
        widget.song["artists"]?["primary"]?[0]?["name"] ?? "Unknown Artist";

    return Container(
      height: 75,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 15),
      width: double.infinity,

      decoration: BoxDecoration(
        color: Color(0xFF211B2B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color.fromRGBO(255, 255, 255, 0.078),
          width: 1,
        ),
      ),

      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),

            child: Image.network(
              imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          // Song Name + Artist
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  songName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  artistName,

                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          AnimatedBuilder(
            animation: AudioPlayerService.instance,
            builder: (context, _) {
              final isPlaying = AudioPlayerService.instance.isPlaying;

              return IconButton(
                onPressed: () async {
                  if (isPlaying) {
                    await AudioPlayerService.instance.pauseSong();
                  } else {
                    await AudioPlayerService.instance.resumeSong();
                  }
                },
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
