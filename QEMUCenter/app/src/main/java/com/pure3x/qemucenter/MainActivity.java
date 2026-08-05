package com.pure3x.qemucenter;

import android.app.Activity;
import android.os.Bundle;
import android.graphics.Color;
import android.view.Gravity;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Button;

public class MainActivity extends Activity {

    // Carrega a biblioteca nativa criada pelo CMake:
    // libp3xe_qemu_center.so
    static {
        System.loadLibrary("p3xe_qemu_center");
    }

    // Implementado em native_bridge.cpp
    public native String nativeGetVersion();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setGravity(Gravity.CENTER_HORIZONTAL);
        root.setPadding(32, 60, 32, 32);
        root.setBackgroundColor(Color.rgb(12, 16, 22));

        // Título
        TextView title = new TextView(this);
        title.setText("P3XE QEMU Center");
        title.setTextColor(Color.WHITE);
        title.setTextSize(28);
        title.setGravity(Gravity.CENTER);

        // Versão fornecida pela biblioteca C++
        TextView version = new TextView(this);

        try {
            version.setText(nativeGetVersion());
        } catch (Throwable error) {
            version.setText("P3XE QEMU Center 0.1.0 Alpha");
        }

        version.setTextColor(Color.LTGRAY);
        version.setTextSize(14);
        version.setGravity(Gravity.CENTER);
        version.setPadding(0, 8, 0, 50);

        // Primeira máquina
        Button msdos = new Button(this);
        msdos.setText("MS-DOS 6.22");

        // Futuro gerenciador de VMs
        Button machines = new Button(this);
        machines.setText("Máquinas Virtuais");

        // Configurações do QEMU Center
        Button settings = new Button(this);
        settings.setText("Configurações");

        root.addView(title);
        root.addView(version);
        root.addView(msdos);
        root.addView(machines);
        root.addView(settings);

        setContentView(root);
    }
}
