import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServices {
  Future<dynamic> getSongs(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://saavn.sumit.co/api/search/songs?query=${Uri.encodeComponent(query)}",
        ),
      );

      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body);

      return data["data"]?["results"] ?? [];
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> getArtists(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://saavn.sumit.co/api/search/artists?query=${Uri.encodeComponent(query)}",
        ),
      );

      final data = jsonDecode(response.body);

      return data['data']?['results'] ?? [];
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> getArtistSongs(String id) async {
    final response = await http.get(
      Uri.parse("https://saavn.sumit.co/api/artists/$id/songs"),
    );

    final data = jsonDecode(response.body);

    return data["data"]?["songs"] ?? [];
  }

  Future<dynamic> getAlbum(String query) async {
    final response = await http.get(
      Uri.parse(
        "https://saavn.sumit.co/api/search/albums?query=${Uri.encodeComponent(query)}",
      ),
    );

    final data = jsonDecode(response.body);

    return data['data']['results'] ?? [];
  }

  Future<dynamic> getAlbumDetails(String albumId) async {
    final response = await http.get(
      Uri.parse("https://saavn.sumit.co/api/albums?id=$albumId"),
    );

    final data = jsonDecode(response.body);

    return data["data"];
  }

  Future<Map<String, dynamic>> searchAll(String query) async {
    if (query.trim().isEmpty) {
      return {"songs": [], "artists": [], "albums": []};
    }

    final results = await Future.wait([
      getSongs(query),
      getArtists(query),
      getAlbum(query),
    ]);

    return {"songs": results[0], "artists": results[1], "albums": results[2]};
  }
}
