package com.pure3x.engine;

public class NativeBridge {

    static {
        System.loadLibrary("Pure3XEngine");
    }

    public static native boolean initialize();

    public static native void shutdown();
}
