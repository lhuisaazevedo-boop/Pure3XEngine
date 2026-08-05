package com.pure3x.lhuis;

import java.io.File;

public class GameStorageManager {

    private final File root;
    private final File isoFolder;
    private final File pkgFolder;
    private final File firmwareFolder;
    private final File saveFolder;

    public GameStorageManager(File root) {

        this.root = root;

        isoFolder = new File(root, "ISOs");
        pkgFolder = new File(root, "PKG");
        firmwareFolder = new File(root, "Firmware");
        saveFolder = new File(root, "Saves");
    }

    public void createFolders() {

        isoFolder.mkdirs();
        pkgFolder.mkdirs();
        firmwareFolder.mkdirs();
        saveFolder.mkdirs();
    }

    public File getIsoFolder() {
        return isoFolder;
    }

    public File getPkgFolder() {
        return pkgFolder;
    }

    public File getFirmwareFolder() {
        return firmwareFolder;
    }

    public File getSaveFolder() {
        return saveFolder;
    }
}
