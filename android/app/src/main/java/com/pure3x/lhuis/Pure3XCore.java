package com.pure3x.lhuis;

import java.io.File;

public class Pure3XCore {

    private final VersionManager version;
    private final SettingsManager settings;
    private final PerformanceManager performance;
    private final SystemInfoManager system;
    private final NetworkManager network;
    private final ControlManager controls;
    private final FirmwareManager firmware;

    private final StorageManager storage;
    private final GameScanner scanner;

    private final MainMenuManager menu;
    private final DashboardManager dashboard;
    private final EngineManager engine;
    private final EmulatorManager emulator;

    public Pure3XCore(File rootFolder) {

        version = new VersionManager();
        settings = new SettingsManager();
        performance = new PerformanceManager();
        system = new SystemInfoManager();
        network = new NetworkManager();
        controls = new ControlManager();

        storage = new StorageManager(rootFolder);
        scanner = new GameScanner();
        firmware = new FirmwareManager();

        dashboard = new DashboardManager(
                firmware,
                scanner,
                controls,
                network,
                settings,
                performance,
                system,
                version
        );

        menu = new MainMenuManager();

        engine = new EngineManager(
                dashboard,
                menu,
                storage,
                scanner,
                firmware,
                network,
                controls
        );

        emulator = new EmulatorManager(engine);
    }

    public void initialize() {

        engine.initialize();

        scanner.scan(storage.getRoot());
    }

    public VersionManager getVersion() {
        return version;
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

    public NetworkManager getNetwork() {
        return network;
    }

    public ControlManager getControls() {
        return controls;
    }

    public FirmwareManager getFirmware() {
        return firmware;
    }

    public StorageManager getStorage() {
        return storage;
    }

    public GameScanner getScanner() {
        return scanner;
    }

    public MainMenuManager getMenu() {
        return menu;
    }

    public DashboardManager getDashboard() {
        return dashboard;
    }

    public EmulatorManager getEmulator() {
        return emulator;
    }
}
