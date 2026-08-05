package com.pure3x.lhuis;

import java.util.HashMap;
import java.util.Map;

public class FavoriteManager {

    private final Map<String, Long> playTime = new HashMap<>();
    private final Map<String, String> lastPlayed = new HashMap<>();

    public void updatePlayTime(String game, long minutes) {
        playTime.put(game, minutes);
    }

    public long getPlayTime(String game) {
        return playTime.getOrDefault(game, 0L);
    }

    public void setLastPlayed(String game, String date) {
        lastPlayed.put(game, date);
    }

    public String getLastPlayed(String game) {
        return lastPlayed.getOrDefault(game, "Nunca");
    }

    public boolean hasHistory(String game) {
        return lastPlayed.containsKey(game);
    }

    public void clearHistory(String game) {
        playTime.remove(game);
        lastPlayed.remove(game);
    }
}
