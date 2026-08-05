package com.pure3x.lhuis;

import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;

public class InputRenderer {

    private final Paint paint;

    public InputRenderer() {

        paint = new Paint();
        paint.setAntiAlias(true);
        paint.setTextSize(34f);
    }

    public void draw(Canvas canvas, VirtualControllerLayout layout) {

        if (canvas == null || layout == null)
            return;

        drawAnalog(canvas, layout.getLeftAnalog());
        drawAnalog(canvas, layout.getRightAnalog());

        drawButton(canvas, layout.getUp(), "↑");
        drawButton(canvas, layout.getDown(), "↓");
        drawButton(canvas, layout.getLeft(), "←");
        drawButton(canvas, layout.getRight(), "→");

        drawButton(canvas, layout.getTriangle(), "△");
        drawButton(canvas, layout.getCircle(), "○");
        drawButton(canvas, layout.getCross(), "✕");
        drawButton(canvas, layout.getSquare(), "□");

        drawButton(canvas, layout.getL1(), "L1");
        drawButton(canvas, layout.getL2(), "L2");
        drawButton(canvas, layout.getR1(), "R1");
        drawButton(canvas, layout.getR2(), "R2");

        drawButton(canvas, layout.getStart(), "START");
        drawButton(canvas, layout.getSelect(), "SELECT");
        drawButton(canvas, layout.getPS(), "PS");
    }

    private void drawAnalog(Canvas canvas, VirtualAnalog analog) {

        paint.setStyle(Paint.Style.STROKE);
        paint.setStrokeWidth(5f);
        paint.setColor(Color.argb(180,255,255,255));

        canvas.drawCircle(
                analog.getCenterX(),
                analog.getCenterY(),
                analog.getRadius(),
                paint);

        paint.setStyle(Paint.Style.FILL);

        canvas.drawCircle(
                analog.getKnobX(),
                analog.getKnobY(),
                analog.getRadius()/2f,
                paint);
    }

    private void drawButton(Canvas canvas,
                            VirtualButton button,
                            String text) {

        paint.setStyle(Paint.Style.FILL);

        if(button.isPressed())
            paint.setColor(Color.argb(230,70,170,255));
        else
            paint.setColor(Color.argb(160,255,255,255));

        canvas.drawCircle(
                button.getX(),
                button.getY(),
                button.getRadius(),
                paint);

        paint.setColor(Color.BLACK);
        paint.setTextAlign(Paint.Align.CENTER);

        canvas.drawText(
                text,
                button.getX(),
                button.getY()+12,
                paint);
    }
}
