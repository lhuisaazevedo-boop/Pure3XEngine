package com.pure3x.lhuis;

import android.app.Activity;
import android.os.Bundle;
import android.widget.ProgressBar;
import android.widget.TextView;

import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

public class GamesActivity extends Activity {

    private Pure3XCore core;
    private DashboardManager dashboard;
    private GameScanner scanner;

    private RecyclerView recyclerGames;
    private TextView txtFirmware;
    private TextView txtStatus;
    private ProgressBar progressScan;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_games);

        recyclerGames = findViewById(R.id.recyclerGames);
        txtFirmware = findViewById(R.id.txtFirmware);
        txtStatus = findViewById(R.id.txtStatus);
        progressScan = findViewById(R.id.progressScan);

        core = new Pure3XCore(getFilesDir());
        core.initialize();

        dashboard = core.getDashboard();
        scanner = core.getScanner();

        txtFirmware.setText(
                "Firmware PS3: " + dashboard.getFirmwareStatus()
        );

        recyclerGames.setLayoutManager(
                new LinearLayoutManager(this)
        );

        GameAdapter adapter = new GameAdapter(
                scanner.getGames(),
                scanner
        );

        recyclerGames.setAdapter(adapter);

        if (dashboard.hasGames()) {

            txtStatus.setText(
                    "Jogos encontrados: " +
                    dashboard.getGameCount()
            );

        } else {

            txtStatus.setText(
                    "Nenhum jogo encontrado.\n\n" +
                    "Selecione uma pasta da memória interna ou cartão SD."
            );
        }

        progressScan.setVisibility(ProgressBar.GONE);
    }
}
