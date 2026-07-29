import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ArtistSection extends StatelessWidget {
  final List<dynamic> singersData;

  const ArtistSection({super.key, required this.singersData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: singersData.length,
        itemBuilder: (context, index) {
          final singer = singersData[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: () {
                context.push("/singerdetailpage", extra: singer);
              },
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(singer['image'].last['url']),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: 80,
                    child: Text(
                      singer['name'],
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
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
