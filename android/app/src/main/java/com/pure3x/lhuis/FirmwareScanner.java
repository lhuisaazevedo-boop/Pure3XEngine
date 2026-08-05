package com.pure3x.lhuis;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class FirmwareScanner {

    private final List<File> firmwareList = new ArrayList<>();

    public void scan(File directory) {

        firmwareList.clear();

        if (directory == null || !directory.exists())
            return;

        File[] files = directory.listFiles();

        if (files == null)
            return;

        for (File file : files) {

            if (file.isDirectory()) {
                scan(file);
            } else if (file.getName().toLowerCase().endsWith(".pup")) {
                firmwareList.add(file);
            }
        }
    }

    public List<File> getFirmwares() {
        return firmwareList;
    }

    public boolean hasFirmware() {
        return !firmwareList.isEmpty();
    }
}
