package com.pure3x.lhuis;

public class ControlManager {

    private boolean touchEnabled = true;
    private boolean bluetoothConnected = false;
    private String controllerName = "Nenhum";

    public boolean isTouchEnabled() {
        return touchEnabled;
    }

    public void setTouchEnabled(boolean value) {
        touchEnabled = value;
    }

    public boolean isBluetoothConnected() {
        return bluetoothConnected;
    }

    public void setBluetoothConnected(boolean value) {
        bluetoothConnected = value;
    }

    public void setControllerName(String name) {
        controllerName = name;
    }

    public String getControllerName() {
        return controllerName;
    }

    public String getStatus() {

        if (bluetoothConnected) {
            return "Controle: " + controllerName;
        }

        if (touchEnabled) {
            return "Controle Virtual";
        }

        return "Sem controle";
    }
}
