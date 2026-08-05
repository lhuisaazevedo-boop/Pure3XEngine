package com.pure3x.lhuis;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ProgressBar;

public class MainActivity extends Activity {

    private Button btnStart;
    private Button btnGames;
    private Button btnFirmware;
    private Button btnStorage;
    private Button btnConfig;
    private Button btnAbout;

    private ProgressBar progressBar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        btnStart = findViewById(R.id.btnStart);
        btnGames = findViewById(R.id.btnGames);
        btnFirmware = findViewById(R.id.btnFirmware);
        btnStorage = findViewById(R.id.btnStorage);
        btnConfig = findViewById(R.id.btnConfig);
        btnAbout = findViewById(R.id.btnAbout);

        progressBar = findViewById(R.id.progressBar);

        btnStart.setOnClickListener(v ->
                startActivity(new Intent(MainActivity.this, DashboardActivity.class)));

        btnGames.setOnClickListener(v ->
                startActivity(new Intent(MainActivity.this, GamesActivity.class)));

        btnFirmware.setOnClickListener(v -> {
            progressBar.setVisibility(View.VISIBLE);
            StoragePicker.open(MainActivity.this);
        });

        btnStorage.setOnClickListener(v ->
                StoragePicker.open(MainActivity.this));

        btnConfig.setOnClickListener(v ->
                startActivity(new Intent(MainActivity.this, SettingsActivity.class)));

        btnAbout.setOnClickListener(v ->
                startActivity(new Intent(MainActivity.this, AboutActivity.class)));
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        progressBar.setVisibility(View.GONE);

        if (requestCode == StoragePicker.REQUEST_FOLDER
                && resultCode == RESULT_OK
                && data != null) {

            Uri uri = data.getData();

            if (uri != null) {

                getContentResolver().takePersistableUriPermission(
                        uri,
                        Intent.FLAG_GRANT_READ_URI_PERMISSION
                                | Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                );

                progressBar.setVisibility(View.VISIBLE);

                FirmwareManager firmware = new FirmwareManager();
                firmware.checkFirmware(this, uri);

                progressBar.setVisibility(View.GONE);

                if (firmware.isInstalled()) {
                    btnFirmware.setText("✅ Firmware PS3 Instalado");
                } else {
                    btnFirmware.setText("❌ Firmware PS3 Não encontrado");
                }
            }
        }
    }
}
