package com.pure3x.lhuis;

import android.content.Context;
import android.net.Uri;

import androidx.documentfile.provider.DocumentFile;

public class FirmwareManager {

    private boolean installed;
    private boolean installing;
    private String version;

    private DocumentFile firmwareFile;

    public FirmwareManager() {
        installed = false;
        installing = false;
        version = "";
        firmwareFile = null;
    }

    public void checkFirmware(Context context, Uri folderUri) {

        installed = false;
        firmwareFile = null;

        if (folderUri == null) {
            return;
        }

        DocumentFile folder = DocumentFile.fromTreeUri(context, folderUri);

        if (folder == null || !folder.exists()) {
            return;
        }

        for (DocumentFile file : folder.listFiles()) {

            if (file.isFile()
                    && "PS3UPDAT.PUP".equalsIgnoreCase(file.getName())) {

                firmwareFile = file;
                installed = true;
                break;
            }
        }
    }

    public boolean isInstalled() {
        return installed;
    }

    public void setInstalled(boolean installed) {
        this.installed = installed;
    }

    public boolean isInstalling() {
        return installing;
    }

    public void setInstalling(boolean installing) {
        this.installing = installing;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getVersion() {
        return version;
    }

    public String getStatus() {

        if (installing) {
            return "Instalando...";
        }

        if (installed) {
            return "Firmware PS3 instalado";
        }

        return "Firmware PS3 não instalado";
    }

    public DocumentFile getFirmwareFile() {
        return firmwareFile;
    }

    public String getFirmwareName() {

        if (firmwareFile == null) {
            return "";
        }

        return firmwareFile.getName();
    }

    public long getFirmwareSize() {

        if (firmwareFile == null) {
            return 0;
        }

        return firmwareFile.length();
    }

    public void reset() {
        installed = false;
        installing = false;
        version = "";
        firmwareFile = null;
    }
}
