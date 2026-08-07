#include <jni.h>
#include <android/log.h>

#include "Engine.h"

#define TAG "Pure3XEngine"

extern "C" {

// Chamado automaticamente quando a biblioteca é carregada
JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM* vm, void*) {

    __android_log_print(
        ANDROID_LOG_INFO,
        TAG,
        "Pure3XEngine v0.2.3 Alpha carregada!"
    );

    return JNI_VERSION_1_6;
}

// Chamado pela MainActivity
JNIEXPORT void JNICALL
Java_com_pure3x_engenie_MainActivity_initEngine(
        JNIEnv* env,
        jobject thiz) {

    __android_log_print(
        ANDROID_LOG_INFO,
        TAG,
        "Inicializando Engine..."
    );

    if (Pure3X::Engine::Initialize())
    {
        __android_log_print(
            ANDROID_LOG_INFO,
            TAG,
            "Pure3XEngine inicializada com sucesso!"
        );
    }
    else
    {
        __android_log_print(
            ANDROID_LOG_ERROR,
            TAG,
            "Falha ao inicializar Pure3XEngine!"
        );
    }
}

}
