package com.pure3x.lhuis;

public class NetworkManager {

    private boolean wifiConnected = false;
    private boolean psnEnabled = false;
    private String networkName = "Desconectado";

    public void setWifiConnected(boolean value) {
        wifiConnected = value;
    }

    public boolean isWifiConnected() {
        return wifiConnected;
    }

    public void setNetworkName(String name) {
        networkName = name;
    }

    public String getNetworkName() {
        return networkName;
    }

    public void setPSNEnabled(boolean value) {
        psnEnabled = value;
    }

    public boolean isPSNEnabled() {
        return psnEnabled;
    }

    public String getStatus() {

        if (!wifiConnected)
            return "Offline";

        if (psnEnabled)
            return "PSN Disponível";

        return "Online";
    }
}
