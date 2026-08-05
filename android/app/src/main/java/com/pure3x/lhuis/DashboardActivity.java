package com.pure3x.lhuis;

import android.app.Activity;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.widget.LinearLayout;
import android.widget.TextView;

public class DashboardActivity extends Activity {

    private Pure3XCore core;
    private DashboardManager dashboard;
    private SystemInfoManager systemInfo;
    private PerformanceManager performance;

    private final Handler handler = new Handler(Looper.getMainLooper());

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        core = new Pure3XCore(getFilesDir());
        core.initialize();

        dashboard = core.getDashboard();
        systemInfo = core.getSystemInfo();
        performance = core.getPerformance();

        LinearLayout layout = new LinearLayout(this);
        layout.setOrientation(LinearLayout.VERTICAL);
        layout.setBackgroundColor(Color.parseColor("#0D1117"));
        layout.setPadding(40, 40, 40, 40);

        TextView logo = new TextView(this);
        logo.setText("PURE3XENGENIE");
        logo.setTextSize(32);
        logo.setTextColor(Color.parseColor("#4CAF50"));

        TextView version = new TextView(this);
        version.setText("Dashboard 2026\n" + dashboard.getVersion());
        version.setTextSize(20);
        version.setTextColor(Color.WHITE);

        TextView info = new TextView(this);
        info.setTextColor(Color.LTGRAY);
        info.setTextSize(18);

        layout.addView(logo);
        layout.addView(version);
        layout.addView(info);

        setContentView(layout);

        updateDashboard(info);
    }

    private void updateDashboard(TextView info) {

        String text =
                "\nDispositivo: " + systemInfo.getDevice() +
                "\nAndroid: " + systemInfo.getAndroidVersion() +
                "\nCPU Threads: " + systemInfo.getCPUThreads() +
                "\nRAM: " + systemInfo.getTotalRAM() + " MB" +
                "\nVulkan: " + (systemInfo.isVulkanSupported() ? "Sim" : "Não") +
                "\nFirmware: " + dashboard.getFirmwareStatus() +
                "\nJogos: " + dashboard.getGameCount() +
                "\nRede: " + dashboard.getNetworkStatus() +
                "\nFPS: " + performance.getFPS() +
                "\nStatus: Ready";

        info.setText(text);

        handler.postDelayed(() -> updateDashboard(info), 1000);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        handler.removeCallbacksAndMessages(null);
    }
}
