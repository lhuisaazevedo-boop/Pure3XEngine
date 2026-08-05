package com.pure3x.lhuis;

import java.io.File;

public class StorageManager {

    private final File root;

    public StorageManager(File filesDir) {

        root = new File(filesDir, "Pure3XEngine");

        create();
    }

    private void create() {

        mkdir("firmware");

        mkdir("games");
        mkdir("games/ISO");
        mkdir("games/PKG");
        mkdir("games/Installed");
        mkdir("games/Updates");

        mkdir("cache");
        mkdir("config");
        mkdir("logs");
        mkdir("saves");
        mkdir("screenshots");
        mkdir("shaders");
        mkdir("database");
        mkdir("bios");
    }

    private void mkdir(String path) {

        File dir = new File(root, path);

        if (!dir.exists()) {
            dir.mkdirs();
        }
    }

    public File getRoot() {
        return root;
    }

    public File getFirmwareFolder() {
        return new File(root, "firmware");
    }

    public File getIsoFolder() {
        return new File(root, "games/ISO");
    }

    public File getPkgFolder() {
        return new File(root, "games/PKG");
    }

    public File getInstalledFolder() {
        return new File(root, "games/Installed");
    }

    public File getSaveFolder() {
        return new File(root, "saves");
    }

    public File getConfigFolder() {
        return new File(root, "config");
    }

    public File getLogFolder() {
        return new File(root, "logs");
    }

    public File getDatabaseFolder() {
        return new File(root, "database");
    }

    public File getScreenshotFolder() {
        return new File(root, "screenshots");
    }
}
