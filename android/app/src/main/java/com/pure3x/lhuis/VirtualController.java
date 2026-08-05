package com.pure3x.lhuis;

public class VirtualController {

    private boolean visible = true;
    private float opacity = 0.75f;
    private float scale = 1.0f;

    public boolean isVisible() {
        return visible;
    }

    public void setVisible(boolean value) {
        visible = value;
    }

    public float getOpacity() {
        return opacity;
    }

    public void setOpacity(float value) {

        if (value < 0f)
            value = 0f;

        if (value > 1f)
            value = 1f;

        opacity = value;
    }

    public float getScale() {
        return scale;
    }

    public void setScale(float value) {

        if (value < 0.5f)
            value = 0.5f;

        if (value > 2.0f)
            value = 2.0f;

        scale = value;
    }

    public void reset() {
        visible = true;
        opacity = 0.75f;
        scale = 1.0f;
    }
}
