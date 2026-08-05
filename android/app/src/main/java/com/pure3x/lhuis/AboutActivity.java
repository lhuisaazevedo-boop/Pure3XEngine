package com.pure3x.lhuis;

import android.app.Activity;
import android.graphics.Color;
import android.os.Bundle;
import android.view.Gravity;
import android.widget.LinearLayout;
import android.widget.TextView;

public class AboutActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        LinearLayout layout = new LinearLayout(this);
        layout.setOrientation(LinearLayout.VERTICAL);
        layout.setBackgroundColor(Color.parseColor("#0D1117"));
        layout.setPadding(40, 40, 40, 40);

        TextView title = new TextView(this);
        title.setText("PURE3XENGENIE");
        title.setTextSize(30);
        title.setTextColor(Color.parseColor("#4CAF50"));
        title.setGravity(Gravity.CENTER);

        TextView info = new TextView(this);
        info.setText(
                "\nVersão: v0.2.5 Alpha\n\n" +
                "Engine: C++20\n" +
                "Plataforma: Android\n" +
                "Desenvolvedor: Pure3XDev\n\n" +
                "Pure3XEngine é um projeto independente " +
                "desenvolvido do zero para Android.\n\n" +
                "Este projeto não possui qualquer afiliação, " +
                "aprovação ou parceria com a Sony Interactive " +
                "Entertainment ou com a marca PlayStation.\n\n" +
                "Todas as marcas registradas pertencem aos seus " +
                "respectivos proprietários.\n\n" +
                "O usuário é responsável por utilizar firmware " +
                "e jogos obtidos de forma legal.\n\n" +
                "Status: Em desenvolvimento."
        );

        info.setTextSize(16);
        info.setTextColor(Color.WHITE);

        layout.addView(title);
        layout.addView(info);

        setContentView(layout);
    }
}
