package com.pure3x.lhuis;

import android.content.Context;

public class SystemManager {

    private final DeviceInfo deviceInfo;

    public SystemManager(Context context) {
        deviceInfo = new DeviceInfo(context);
    }

    public String getCPU() {
        return deviceInfo.getCpuModel();
    }

    public String getRAM() {
        return deviceInfo.getTotalRamMB() + " MB";
    }

    public String getAndroid() {
        return deviceInfo.getAndroidVersion() +
                " (API " + deviceInfo.getAndroidApi() + ")";
    }

    public String getArchitecture() {
        return deviceInfo.getArchitecture();
    }

    public String getModel() {
        return deviceInfo.getManufacturer() +
                " " + deviceInfo.getDeviceModel();
    }

    public String getGPU() {
        // Temporário.
        // Depois será detectado automaticamente pelo renderer Vulkan/OpenGL.
        return "Vulkan";
    }

    public String getDriver() {
        // Temporário.
        // Depois leremos o driver real (Mesa Turnip, Qualcomm etc.).
        return "Detectando...";
    }

    public int getFPS() {
        return 60;
    }
}
