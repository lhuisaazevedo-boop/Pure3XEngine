package com.pure3x.lhuis;

public class VersionManager {

    private final String engineName = "Pure3XEngine";
    private final String version = "v0.2.5 Alpha";
    private final String language = "C++20";
    private final String runtime = "Android Runtime (ART)";
    private final String license = "MIT";

    public String getEngineName() {
        return engineName;
    }

    public String getVersion() {
        return version;
    }

    public String getLanguage() {
        return language;
    }

    public String getRuntime() {
        return runtime;
    }

    public String getLicense() {
        return license;
    }

    public String getFullVersion() {
        return engineName + " " + version;
    }

    public String getBuildInfo() {
        return getFullVersion()
                + " | " + language
                + " | " + runtime
                + " | Licença " + license;
    }
}
