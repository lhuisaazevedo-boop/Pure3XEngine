public class EngineStatus {

    private boolean firmwareInstalled = false;
    private boolean gameLoaded = false;
    private boolean emulatorRunning = false;

    public boolean isFirmwareInstalled() {
        return firmwareInstalled;
    }

    public void setFirmwareInstalled(boolean value) {
        firmwareInstalled = value;
    }

    public boolean isGameLoaded() {
        return gameLoaded;
    }

    public void setGameLoaded(boolean value) {
        gameLoaded = value;
    }

    public boolean isEmulatorRunning() {
        return emulatorRunning;
    }

    public void setEmulatorRunning(boolean value) {
        emulatorRunning = value;
    }

    public String getStatus() {

        if (!firmwareInstalled)
            return "Aguardando Firmware";

        if (!gameLoaded)
            return "Aguardando Jogo";

        if (!emulatorRunning)
            return "Pronto para iniciar";

        return "Em execução";
    }
}
