package com.pure3x.lhuis;

public class EmulatorManager {

    private final EngineManager engine;
    private boolean running;
    private String currentGame = "Nenhum";

    public EmulatorManager(EngineManager engine) {
        this.engine = engine;
        this.running = false;
    }

    public void start() {
        engine.initialize();
        running = true;
    }

    public void stop() {
        running = false;
    }

    public boolean isRunning() {
        return running;
    }

    public void loadGame(String gameName) {
        currentGame = gameName;
    }

    public String getCurrentGame() {
        return currentGame;
    }

    public EngineManager getEngine() {
        return engine;
    }

    public String getStatus() {
        if (!running) {
            return "Emulador desligado";
        }

        return "Executando";
    }
}
