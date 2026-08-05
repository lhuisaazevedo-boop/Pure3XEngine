package com.pure3x.lhuis;

public class FirmwareDatabase {

    private String installedVersion = "Nenhum";
    private String installDate = "Nunca";
    private boolean installed = false;

    public void setInstalled(String version, String date) {
        installedVersion = version;
        installDate = date;
        installed = true;
    }

    public boolean isInstalled() {
        return installed;
    }

    public String getInstalledVersion() {
        return installedVersion;
    }

    public String getInstallDate() {
        return installDate;
    }

    public void clear() {
        installed = false;
        installedVersion = "Nenhum";
        installDate = "Nunca";
    }
}
