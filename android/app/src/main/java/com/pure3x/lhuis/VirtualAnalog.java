package com.pure3x.lhuis;

public class VirtualAnalog {

    private float centerX;
    private float centerY;

    private float knobX;
    private float knobY;

    private float radius;

    private boolean pressed;

    public VirtualAnalog(float x, float y, float radius) {

        this.centerX = x;
        this.centerY = y;

        this.knobX = x;
        this.knobY = y;

        this.radius = radius;

        this.pressed = false;
    }

    public void press(float x, float y) {

        pressed = true;

        float dx = x - centerX;
        float dy = y - centerY;

        float distance = (float)Math.sqrt(dx * dx + dy * dy);

        if (distance > radius) {

            dx = dx * radius / distance;
            dy = dy * radius / distance;
        }

        knobX = centerX + dx;
        knobY = centerY + dy;
    }

    public void release() {

        pressed = false;

        knobX = centerX;
        knobY = centerY;
    }

    public boolean isPressed() {
        return pressed;
    }

    public float getCenterX() {
        return centerX;
    }

    public float getCenterY() {
        return centerY;
    }

    public float getKnobX() {
        return knobX;
    }

    public float getKnobY() {
        return knobY;
    }

    public float getRadius() {
        return radius;
    }

    public float getAxisX() {
        return (knobX - centerX) / radius;
    }

    public float getAxisY() {
        return (knobY - centerY) / radius;
    }

    public void setPosition(float x, float y) {

        centerX = x;
        centerY = y;

        knobX = x;
        knobY = y;
    }

    public boolean contains(float x, float y) {

        float dx = x - centerX;
        float dy = y - centerY;

        return dx * dx + dy * dy <= radius * radius;
    }
}
