import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:music_player/services/audio_player_service.dart';

class TrendingSlider extends StatelessWidget {
  final List<dynamic> trendingData;

  const TrendingSlider({super.key, required this.trendingData});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: trendingData.length,
      itemBuilder: (context, index, realIndex) {
        final song = trendingData[index];

        return GestureDetector(
          onTap: () async {
            await AudioPlayerService.instance.playSong(song);
          },
          child: Stack(
            children: [
              Image.network(
                song['image'][2]['url'],
                width: double.infinity,
                fit: BoxFit.fill,
              ),
              Positioned(
                bottom: 60,
                left: 10,
                child: Text(
                  song['name'].toString().replaceAll(
                    RegExp(r'\s*\(From.*?\)'),
                    '',
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      options: CarouselOptions(
        height: 250,
        viewportFraction: 1,
        autoPlay: true,
      ),
    );
  }
}
