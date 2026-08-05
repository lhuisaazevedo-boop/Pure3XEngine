package com.pure3x.lhuis;

public class FirmwareInstaller {

    private final FirmwareManager firmwareManager;
    private int progress = 0;

    public FirmwareInstaller(FirmwareManager manager) {
        this.firmwareManager = manager;
    }

    public void startInstall(String version) {

        firmwareManager.setInstalling(true);
        firmwareManager.setVersion(version);

        progress = 0;
    }

    public void updateProgress(int value) {

        if (value < 0)
            value = 0;

        if (value > 100)
            value = 100;

        progress = value;

        if (progress >= 100) {

            firmwareManager.setInstalling(false);
            firmwareManager.setInstalled(true);
        }
    }

    public int getProgress() {
        return progress;
    }

    public boolean isFinished() {
        return progress >= 100;
    }

    public void cancel() {
        progress = 0;
        firmwareManager.reset();
    }
}
