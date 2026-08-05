package com.pure3x.lhuis;

import android.app.Activity;
import android.graphics.Color;
import android.os.Bundle;
import android.widget.LinearLayout;
import android.widget.Switch;
import android.widget.TextView;

public class SettingsActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        LinearLayout layout = new LinearLayout(this);
        layout.setOrientation(LinearLayout.VERTICAL);
        layout.setBackgroundColor(Color.parseColor("#0D1117"));
        layout.setPadding(40,40,40,40);

        TextView title = new TextView(this);
        title.setText("⚙ Configurações");
        title.setTextSize(28);
        title.setTextColor(Color.WHITE);

        layout.addView(title);

        layout.addView(createSwitch("🎮 Habilitar Vulkan"));
        layout.addView(createSwitch("📱 Mostrar FPS"));
        layout.addView(createSwitch("🔊 Áudio"));
        layout.addView(createSwitch("🌙 Tema escuro"));
        layout.addView(createSwitch("💾 Salvar configurações"));
        layout.addView(createSwitch("📂 Escolher pasta de jogos"));
        layout.addView(createSwitch("💿 Firmware PS3"));
        layout.addView(createSwitch("🧠 Otimização de memória"));

        setContentView(layout);
    }

    private Switch createSwitch(String text){

        Switch sw = new Switch(this);
        sw.setText(text);
        sw.setTextColor(Color.WHITE);

        return sw;
    }
}
