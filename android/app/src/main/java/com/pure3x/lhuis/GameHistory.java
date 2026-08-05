package com.pure3x.lhuis;

public class GameHistory {

    private String gameName;
    private long playMinutes;
    private String lastPlayed;

    public GameHistory(String gameName) {
        this.gameName = gameName;
        this.playMinutes = 0;
        this.lastPlayed = "Nunca";
    }

    public String getGameName() {
        return gameName;
    }

    public long getPlayMinutes() {
        return playMinutes;
    }

    public void addPlayMinutes(long minutes) {
        playMinutes += minutes;
    }

    public void setLastPlayed(String date) {
        lastPlayed = date;
    }

    public String getLastPlayed() {
        return lastPlayed;
    }
}
