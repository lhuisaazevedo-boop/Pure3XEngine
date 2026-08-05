package com.pure3x.lhuis;

import android.app.ActivityManager;
import android.content.Context;
import android.os.Build;

public class DeviceInfo {

    private final Context context;

    public DeviceInfo(Context context) {
        this.context = context;
    }

    public String getAndroidVersion() {
        return Build.VERSION.RELEASE;
    }

    public int getAndroidApi() {
        return Build.VERSION.SDK_INT;
    }

    public String getDeviceModel() {
        return Build.MODEL;
    }

    public String getManufacturer() {
        return Build.MANUFACTURER;
    }

    public String getCpuModel() {
        if (Build.VERSION.SDK_INT >= 31) {
            return Build.SOC_MODEL;
        }
        return Build.HARDWARE;
    }

    public String getArchitecture() {
        return Build.SUPPORTED_64_BIT_ABIS.length > 0 ? "64-bit" : "32-bit";
    }

    public long getTotalRamMB() {
        ActivityManager.MemoryInfo memoryInfo = new ActivityManager.MemoryInfo();
        ActivityManager activityManager =
                (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);

        if (activityManager != null) {
            activityManager.getMemoryInfo(memoryInfo);
            return memoryInfo.totalMem / (1024 * 1024);
        }

        return 0;
    }
}
