package com.pure3x.lhuis;

import android.app.Activity;
import android.os.Bundle;
import android.view.Gravity;
import android.widget.TextView;

public class FirmwareActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        TextView tv = new TextView(this);
        tv.setText("💿 Firmware PS3\n\nNenhum firmware instalado.");
        tv.setTextSize(22);
        tv.setGravity(Gravity.CENTER);

        setContentView(tv);
    }
}
