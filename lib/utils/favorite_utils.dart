class FavoriteUtils {
  static final List<dynamic> favorites = [];

  static void addFavorite(dynamic song) {
    if (!favorites.contains(song)) {
      favorites.add(song);
    }
  }

  static void removeFavorite(dynamic song) {
    favorites.remove(song);
  }

  static bool isFavorite(dynamic song) {
    return favorites.contains(song);
  }

  static List<dynamic> getFavorites() {
    return favorites;
  }
}
