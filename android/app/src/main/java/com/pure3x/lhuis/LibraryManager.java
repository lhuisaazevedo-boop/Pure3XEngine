package com.pure3x.lhuis;

import java.util.ArrayList;
import java.util.List;

public class LibraryManager {

    private final List<String> games = new ArrayList<>();
    private final List<String> favorites = new ArrayList<>();

    public void addGame(String game) {
        if (!games.contains(game)) {
            games.add(game);
        }
    }

    public List<String> getGames() {
        return games;
    }

    public void addFavorite(String game) {
        if (!favorites.contains(game)) {
            favorites.add(game);
        }
    }

    public void removeFavorite(String game) {
        favorites.remove(game);
    }

    public List<String> getFavorites() {
        return favorites;
    }

    public boolean isFavorite(String game) {
        return favorites.contains(game);
    }

    public int getGameCount() {
        return games.size();
    }

    public int getFavoriteCount() {
        return favorites.size();
    }
}
