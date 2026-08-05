package com.pure3x.lhuis;

public class ProgressManager {

    private int progress = 0;
    private String message = "Aguardando...";

    public void reset() {
        progress = 0;
        message = "Aguardando...";
    }

    public void setProgress(int value) {

        if (value < 0)
            value = 0;

        if (value > 100)
            value = 100;

        progress = value;
    }

    public int getProgress() {
        return progress;
    }

    public void setMessage(String text) {
        message = text;
    }

    public String getMessage() {
        return message;
    }

    public boolean isFinished() {
        return progress >= 100;
    }
}
