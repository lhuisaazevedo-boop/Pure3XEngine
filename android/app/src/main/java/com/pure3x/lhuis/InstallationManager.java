package com.pure3x.lhuis;

public class InstallationManager {

    private final FirmwareDatabase database;
    private final FirmwareInstaller installer;
    private final ProgressManager progress;

    public InstallationManager(FirmwareDatabase database,
                               FirmwareInstaller installer,
                               ProgressManager progress) {

        this.database = database;
        this.installer = installer;
        this.progress = progress;
    }

    public void beginInstall(String version) {

        installer.startInstall(version);

        progress.reset();
        progress.setMessage("Preparando instalação...");
    }

    public void update(int value, String message) {

        installer.updateProgress(value);
        progress.setProgress(value);
        progress.setMessage(message);

        if (value >= 100) {

            database.setInstalled(
                    "PS3 Firmware " + installer.getProgress(),
                    java.time.LocalDate.now().toString()
            );
        }
    }

    public ProgressManager getProgressManager() {
        return progress;
    }

    public FirmwareDatabase getDatabase() {
        return database;
    }
}
