package com.pure3x.cubo3d;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;

public class MainActivity extends Activity {

    static {
        try {
            // Biblioteca padrão do C++
            System.loadLibrary("c++_shared");

            // Núcleo do emulador
            System.loadLibrary("lhuis.pure3x");

            // Engine gráfica
            System.loadLibrary("Cubo3D");

            Log.i("P3XE", "Bibliotecas carregadas com sucesso.");

        } catch (UnsatisfiedLinkError e) {
            Log.e("P3XE", "Erro ao carregar bibliotecas.", e);
            throw e;
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Log.i("P3XE", "Pure3XEngenie iniciado.");
    }
}
