package com.pure3x.lhuis;

public class VirtualButton {

    private String name;

    private float x;
    private float y;

    private float radius;

    private boolean pressed;

    public VirtualButton(String name, float x, float y, float radius) {
        this.name = name;
        this.x = x;
        this.y = y;
        this.radius = radius;
        this.pressed = false;
    }

    public String getName() {
        return name;
    }

    public float getX() {
        return x;
    }

    public float getY() {
        return y;
    }

    public float getRadius() {
        return radius;
    }

    public boolean isPressed() {
        return pressed;
    }

    public void setPressed(boolean value) {
        pressed = value;
    }

    public boolean contains(float touchX, float touchY) {

        float dx = touchX - x;
        float dy = touchY - y;

        return (dx * dx + dy * dy) <= radius * radius;
    }

    public void move(float newX, float newY) {
        x = newX;
        y = newY;
    }

    public void resize(float newRadius) {
        radius = newRadius;
    }
}
