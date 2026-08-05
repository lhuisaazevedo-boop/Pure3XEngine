#include <jni.h>
#include <android/log.h>

#define LOG_TAG "Pure3XEngine"
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)

extern "C"
JNIEXPORT void JNICALL
Java_com_pure3x_lhuis_MainActivity_nativeInit(JNIEnv* env, jobject thiz)
{
    LOGI("Pure3XEngine inicializado.");
}
