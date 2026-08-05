package com.pure3x.lhuis;

public class SystemInfoManager {

    private String device = "Desconhecido";
    private String androidVersion = "Android";
    private int cpuThreads = 0;
    private long totalRAM = 0;
    private boolean vulkanSupported = false;

    public void setDevice(String value) {
        device = value;
    }

    public String getDevice() {
        return device;
    }

    public void setAndroidVersion(String value) {
        androidVersion = value;
    }

    public String getAndroidVersion() {
        return androidVersion;
    }

    public void setCPUThreads(int value) {
        cpuThreads = value;
    }

    public int getCPUThreads() {
        return cpuThreads;
    }

    public void setTotalRAM(long value) {
        totalRAM = value;
    }

    public long getTotalRAM() {
        return totalRAM;
    }

    public void setVulkanSupported(boolean value) {
        vulkanSupported = value;
    }

    public boolean isVulkanSupported() {
        return vulkanSupported;
    }

    public String getSummary() {
        return device + " | " +
               androidVersion + " | " +
               cpuThreads + " Threads | " +
               totalRAM + " MB RAM | Vulkan: " +
               (vulkanSupported ? "Sim" : "Não");
    }
}
