package com.pure3x.lhuis;

public class PerformanceManager {

    private int fps = 0;
    private long memoryUsage = 0;
    private float cpuUsage = 0f;

    public void setFPS(int value) {
        fps = Math.max(0, value);
    }

    public int getFPS() {
        return fps;
    }

    public void setMemoryUsage(long value) {
        memoryUsage = Math.max(0, value);
    }

    public long getMemoryUsage() {
        return memoryUsage;
    }

    public void setCPUUsage(float value) {

        if (value < 0f)
            value = 0f;

        if (value > 100f)
            value = 100f;

        cpuUsage = value;
    }

    public float getCPUUsage() {
        return cpuUsage;
    }

    public void reset() {
        fps = 0;
        memoryUsage = 0;
        cpuUsage = 0f;
    }

    public String getStatus() {
        return "FPS: " + fps +
               " | CPU: " + cpuUsage + "%" +
               " | RAM: " + memoryUsage + " MB";
    }
}
