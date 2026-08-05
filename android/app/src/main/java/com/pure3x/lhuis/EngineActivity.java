package com.pure3x.lhuis;

import android.app.Activity;
import android.os.Bundle;
import android.view.Gravity;
import android.widget.TextView;

public class EngineActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        TextView tv = new TextView(this);
        tv.setText("▶ Pure3X Engine\n\nInicializando engine...");
        tv.setTextSize(22);
        tv.setGravity(Gravity.CENTER);

        setContentView(tv);
    }
}
