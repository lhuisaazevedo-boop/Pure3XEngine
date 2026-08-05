package com.pure3x.lhuis;

public class SettingsManager {

    private boolean vulkan = true;
    private boolean audio = true;
    private boolean vibration = true;
    private boolean showFPS = false;

    private int resolutionScale = 100;

    public boolean isVulkanEnabled() {
        return vulkan;
    }

    public void setVulkanEnabled(boolean value) {
        vulkan = value;
    }

    public boolean isAudioEnabled() {
        return audio;
    }

    public void setAudioEnabled(boolean value) {
        audio = value;
    }

    public boolean isVibrationEnabled() {
        return vibration;
    }

    public void setVibrationEnabled(boolean value) {
        vibration = value;
    }

    public boolean isShowFPSEnabled() {
        return showFPS;
    }

    public void setShowFPS(boolean value) {
        showFPS = value;
    }

    public int getResolutionScale() {
        return resolutionScale;
    }

    public void setResolutionScale(int value) {

        if (value < 50)
            value = 50;

        if (value > 300)
            value = 300;

        resolutionScale = value;
    }

    public void reset() {

        vulkan = true;
        audio = true;
        vibration = true;
        showFPS = false;
        resolutionScale = 100;
    }
}
