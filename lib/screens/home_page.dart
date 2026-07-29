import 'package:flutter/material.dart';
import 'package:music_player/services/api_services.dart';
import 'package:music_player/services/audio_player_service.dart';
import 'package:music_player/widgets/album_section.dart';
import 'package:music_player/widgets/app_background.dart';
import 'package:music_player/widgets/artist_section.dart';
import 'package:music_player/widgets/trending_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final trendingSongs = [
    // Bollywood
    "Saiyaara",
    "Ghera hua",
    "Ishq Hai",
    "Aaj Ki Raat",
    "Naina",
    "Angaaron",
    "Aayi Nai",
    "Kissik",
    "Sooseki",
    "Raa Macha Macha",
    "Dhop",
    "Kurchi Madathapetti",
    "Espresso",
    "Beautiful Things",
    "Lose Control",
    "Stargazing",
    "Ordinary",
    "That's So True",
  ];

  final singersList = [
    "Arijit Singh",
    "Yo Yo Honey Singh",
    "Shakira",
    "Neha Kakkar",
    "Shreya Ghoshal",
    "Sonu Nigam",
    "Justin Bieber",
    "Eminem",
  ];

  final albumList = [
    "Hanuman Chalisa",
    "Dhurandhar",
    "Saiyaara",
    "Shree Ram Bhajan",
    "Ram Siya Ram",
    "Jai Hanuman",
    "Animal",
    "Shri Ram Bhakti",
    "Stree 2",
    "Kabir Singh",
    "Aashiqui 2",
  ];

  List<dynamic> trendingData = [];
  List<dynamic> singersData = [];
  List<dynamic> albumData = [];

  bool isLoading = true;

  Future<void> callApi() async {
    setState(() {
      isLoading = true;
    });

    /// Solution 3: Clear old data before loading
    trendingData.clear();
    singersData.clear();
    albumData.clear();

    try {
      final trendingResults = await Future.wait(
        trendingSongs.map((song) => ApiServices().getSongs(song)),
      );

      trendingData = trendingResults
          .where((result) => result.isNotEmpty)
          .map((result) => result.first)
          .toList();

      final artistResults = await Future.wait(
        singersList.map((artist) => ApiServices().getArtists(artist)),
      );

      singersData = artistResults
          .where((result) => result.isNotEmpty)
          .map((result) => result.first)
          .toList();

      final albumResults = await Future.wait(
        albumList.map((album) => ApiServices().getAlbum(album)),
      );

      albumData = albumResults
          .where((result) => result.isNotEmpty)
          .map((result) => result.first)
          .toList();
    } catch (e) {
      debugPrint("API Error: $e");
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    callApi();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: AudioPlayerService.instance.currentSong != null
                      ? 60
                      : 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Trending Slider
                    TrendingSlider(trendingData: trendingData),

                    const SizedBox(height: 15),

                    // Artists Title
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Artists",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Artists Section
                    ArtistSection(singersData: singersData),

                    const SizedBox(height: 15),

                    // Albums Title
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Albums",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Albums Section
                    AlbumSection(albumData: albumData),
                  ],
                ),
              ),
            ),
    );
  }
}
