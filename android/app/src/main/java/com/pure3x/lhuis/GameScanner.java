package com.pure3x.lhuis;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class GameScanner {

    private final List<File> games = new ArrayList<>();

    public void scan(File folder) {

        games.clear();
        scanFolder(folder);
    }

    private void scanFolder(File folder) {

        if (folder == null || !folder.exists())
            return;

        File[] files = folder.listFiles();

        if (files == null)
            return;

        for (File file : files) {

            if (file.isDirectory()) {

                File ps3Game = new File(file, "PS3_GAME");
                File eboot = new File(ps3Game, "USRDIR/EBOOT.BIN");

                if (ps3Game.exists() || eboot.exists()) {
                    games.add(file);
                    continue;
                }

                scanFolder(file);
                continue;
            }

            String name = file.getName().toLowerCase();

            if (name.endsWith(".iso")
                    || name.endsWith(".pkg")
                    || name.endsWith(".rar")
                    || name.endsWith(".zip")
                    || name.endsWith(".7z")) {

                games.add(file);
            }
        }
    }

    public List<File> getGames() {
        return games;
    }

    public boolean hasGames() {
        return !games.isEmpty();
    }

    public int getGameCount() {
        return games.size();
    }

    public String getRegion(File file) {

        String name = file.getName().toUpperCase();

        if (name.contains("BLUS"))
            return "USA";

        if (name.contains("BLES"))
            return "EU";

        if (name.contains("BCES"))
            return "EU First Party";

        if (name.contains("BCUS"))
            return "USA First Party";

        if (name.contains("BLJM"))
            return "JAPÃO";

        if (name.contains("NPUB"))
            return "PSN USA";

        if (name.contains("NPEB"))
            return "PSN EUROPA";

        return "Desconhecida";
    }

    public boolean isDisc2(File file) {
        return file.getName().toLowerCase().contains("disc2");
    }

    public boolean isDisc3(File file) {
        return file.getName().toLowerCase().contains("disc3");
    }

    public boolean isPkg(File file) {
        return file.getName().toLowerCase().endsWith(".pkg");
    }

    public boolean isIso(File file) {
        return file.getName().toLowerCase().endsWith(".iso");
    }

    public boolean isFolderGame(File file) {
        return file.isDirectory();
    }

    public void clear() {
        games.clear();
    }
}
