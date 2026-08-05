package com.pure3x.lhuis;

public class DashboardManager {

    private final FirmwareManager firmware;
    private final GameScanner scanner;
    private final ControlManager controls;
    private final NetworkManager network;

    private final SettingsManager settings;
    private final PerformanceManager performance;
    private final SystemInfoManager system;
    private final VersionManager version;

    public DashboardManager(
            FirmwareManager firmware,
            GameScanner scanner,
            ControlManager controls,
            NetworkManager network,
            SettingsManager settings,
            PerformanceManager performance,
            SystemInfoManager system,
            VersionManager version) {

        this.firmware = firmware;
        this.scanner = scanner;
        this.controls = controls;
        this.network = network;
        this.settings = settings;
        this.performance = performance;
        this.system = system;
        this.version = version;
    }

    public String getFirmwareStatus() {
        return firmware.getStatus();
    }

    public int getGameCount() {
        return scanner.getGames().size();
    }

    public String getControlStatus() {
        return controls.getStatus();
    }

    public String getNetworkStatus() {
        return network.getStatus();
    }

    public boolean isFirmwareInstalled() {
        return firmware.isInstalled();
    }

    public boolean hasGames() {
        return scanner.hasGames();
    }

    public SettingsManager getSettings() {
        return settings;
    }

    public PerformanceManager getPerformance() {
        return performance;
    }

    public SystemInfoManager getSystemInfo() {
        return system;
    }

    public VersionManager getVersionManager() {
        return version;
    }

    public String getVersion() {
        return version.getVersion();
    }

    public String getEngine() {
        return version.getLanguage();
    }

    public String getRuntime() {
        return version.getRuntime();
    }

    public String getLicense() {
        return version.getLicense();
    }

    public String getProjectName() {
        return version.getEngineName();
    }

    public String getDashboardSummary() {

        return version.getFullVersion() + "\n" +
               firmware.getStatus() + "\n" +
               "Jogos: " + scanner.getGames().size() + "\n" +
               controls.getStatus() + "\n" +
               network.getStatus() + "\n" +
               performance.getStatus() + "\n" +
               system.getSummary();
    }
}
