package com.pure3x.lhuis;

public class EngineManager {

    private final DashboardManager dashboard;
    private final MainMenuManager menu;
    private final StorageManager storage;
    private final GameScanner scanner;
    private final FirmwareManager firmware;
    private final NetworkManager network;
    private final ControlManager controls;

    public EngineManager(
            DashboardManager dashboard,
            MainMenuManager menu,
            StorageManager storage,
            GameScanner scanner,
            FirmwareManager firmware,
            NetworkManager network,
            ControlManager controls) {

        this.dashboard = dashboard;
        this.menu = menu;
        this.storage = storage;
        this.scanner = scanner;
        this.firmware = firmware;
        this.network = network;
        this.controls = controls;
    }

    public void initialize() {

        // As pastas são criadas automaticamente pelo StorageManager.

        scanner.scan(storage.getIsoFolder());
        scanner.scan(storage.getPkgFolder());

        network.setWifiConnected(false);
        controls.setTouchEnabled(true);
    }

    public DashboardManager getDashboard() {
        return dashboard;
    }

    public MainMenuManager getMenu() {
        return menu;
    }

    public GameScanner getScanner() {
        return scanner;
    }

    public FirmwareManager getFirmware() {
        return firmware;
    }

    public NetworkManager getNetwork() {
        return network;
    }

    public ControlManager getControls() {
        return controls;
    }

    public StorageManager getStorage() {
        return storage;
    }
}
