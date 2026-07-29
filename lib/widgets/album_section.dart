import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AlbumSection extends StatelessWidget {
  final List<dynamic> albumData;

  const AlbumSection({super.key, required this.albumData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: albumData.length,
        itemBuilder: (context, index) {
          final album = albumData[index];

          return GestureDetector(
            onTap: () {
              context.push("/albumdetailpage", extra: album);
            },
            child: Container(
              width: 140,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      album["image"].last["url"],
                      height: 140,
                      width: 140,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    album["name"],
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white),
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
