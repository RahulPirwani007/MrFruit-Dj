import 'package:flutter/material.dart';
import 'package:music_player/services/audio_player_service.dart';
import 'package:music_player/utils/favorite_utils.dart';
import 'package:music_player/widgets/app_background.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    final favorites = FavoriteUtils.getFavorites();

    return AppBackground(
      child: favorites.isEmpty
          ? Center(
              child: Text(
                "No Favorite Songs",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.only(top: 80, bottom: 120),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final song = favorites[index];
                return GestureDetector(
                  onTap: () async{
                    await AudioPlayerService.instance.playSong(song);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    padding: EdgeInsets.all(12),
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
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                  
                        SizedBox(width: 12),
                  
                        Expanded(
                          child: Text(
                            song["name"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              FavoriteUtils.removeFavorite(song);
                            });
                          },
                          icon: Icon(Icons.favorite, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
