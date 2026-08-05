package com.pure3x.lhuis;

public class DashboardSystem {

    private String cpu = "--";
    private String gpu = "Vulkan";
    private String ram = "--";
    private String androidVersion = "--";
    private String driver = "--";
    private int fps = 60;

    private String firmwareStatus = "Não instalado";
    private String engineStatus = "Ready";

    public String getCPU() {
        return cpu;
    }

    public void setCPU(String cpu) {
        this.cpu = cpu;
    }

    public String getGPU() {
        return gpu;
    }

    public void setGPU(String gpu) {
        this.gpu = gpu;
    }

    public String getRAM() {
        return ram;
    }

    public void setRAM(String ram) {
        this.ram = ram;
    }

    public String getAndroidVersion() {
        return androidVersion;
    }

    public void setAndroidVersion(String version) {
        this.androidVersion = version;
    }

    public String getDriver() {
        return driver;
    }

    public void setDriver(String driver) {
        this.driver = driver;
    }

    public int getFPS() {
        return fps;
    }

    public void setFPS(int fps) {
        this.fps = fps;
    }

    public String getFirmwareStatus() {
        return firmwareStatus;
    }

    public void setFirmwareStatus(String status) {
        this.firmwareStatus = status;
    }

    public String getEngineStatus() {
        return engineStatus;
    }

    public void setEngineStatus(String status) {
        this.engineStatus = status;
    }
}
