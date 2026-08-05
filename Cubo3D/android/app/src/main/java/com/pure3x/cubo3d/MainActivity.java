package com.pure3x.cubo3d;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.Gravity;
import android.view.Surface;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

public class MainActivity extends Activity
        implements SurfaceHolder.Callback {

    private static final String TAG = "Cubo3D";

    static {
        try {
            System.loadLibrary("c++_shared");
            System.loadLibrary("cubo3d");

            Log.i(TAG, "libcubo3d carregada.");
        } catch (UnsatisfiedLinkError e) {
            Log.e(TAG, "Falha carregando libcubo3d.", e);
            throw e;
        }
    }

    private SurfaceView surfaceView;

    // Ponte Java -> C++
    private static native boolean nativeSurfaceCreated(Surface surface);
    private static native void nativeSurfaceChanged(
            Surface surface,
            int width,
            int height
    );
    private static native void nativeSurfaceDestroyed();
    private static native void nativeRenderFrame();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setGravity(Gravity.CENTER_HORIZONTAL);
        root.setPadding(24, 24, 24, 24);

        TextView title = new TextView(this);
        title.setText("Cubo3D");
        title.setTextSize(30);
        title.setGravity(Gravity.CENTER);

        TextView subtitle = new TextView(this);
        subtitle.setText("Pure3X Graphics Laboratory");
        subtitle.setTextSize(16);
        subtitle.setGravity(Gravity.CENTER);
        subtitle.setPadding(0, 8, 0, 20);

        surfaceView = new SurfaceView(this);

        LinearLayout.LayoutParams surfaceParams =
                new LinearLayout.LayoutParams(
                        ViewGroup.LayoutParams.MATCH_PARENT,
                        0,
                        1.0f
                );

        surfaceView.setLayoutParams(surfaceParams);
        surfaceView.getHolder().addCallback(this);

        Button renderButton = createButton("Renderizar frame");

        renderButton.setOnClickListener(v -> {
            Log.i(TAG, "Solicitando frame nativo.");
            nativeRenderFrame();
        });

        Button openGLButton = createButton("OpenGL ES");

        openGLButton.setOnClickListener(v ->
                Toast.makeText(
                        this,
                        "OpenGL ES 3",
                        Toast.LENGTH_SHORT
                ).show()
        );

        Button vulkanButton = createButton("Vulkan");

        vulkanButton.setOnClickListener(v ->
                Toast.makeText(
                        this,
                        "Vulkan será integrado depois",
                        Toast.LENGTH_SHORT
                ).show()
        );

        root.addView(title);
        root.addView(subtitle);
        root.addView(surfaceView);
        root.addView(renderButton);
        root.addView(openGLButton);
        root.addView(vulkanButton);

        setContentView(root);

        Log.i(TAG, "Cubo3D iniciado.");
    }

    @Override
    public void surfaceCreated(SurfaceHolder holder) {
        Log.i(TAG, "Surface criada.");

        boolean ok = nativeSurfaceCreated(holder.getSurface());

        Log.i(TAG, "nativeSurfaceCreated = " + ok);
    }

    @Override
    public void surfaceChanged(
            SurfaceHolder holder,
            int format,
            int width,
            int height) {

        Log.i(
                TAG,
                "Surface alterada: " + width + "x" + height
        );

        nativeSurfaceChanged(
                holder.getSurface(),
                width,
                height
        );
    }

    @Override
    public void surfaceDestroyed(SurfaceHolder holder) {
        Log.i(TAG, "Surface destruída.");

        nativeSurfaceDestroyed();
    }

    private Button createButton(String text) {
        Button button = new Button(this);

        button.setText(text);
        button.setAllCaps(false);
        button.setTextSize(16);

        LinearLayout.LayoutParams params =
                new LinearLayout.LayoutParams(
                        ViewGroup.LayoutParams.MATCH_PARENT,
                        ViewGroup.LayoutParams.WRAP_CONTENT
                );

        params.setMargins(0, 8, 0, 8);

        button.setLayoutParams(params);

        return button;
    }
}
