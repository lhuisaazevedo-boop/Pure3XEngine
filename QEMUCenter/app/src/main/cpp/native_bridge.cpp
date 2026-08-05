#include <jni.h>
#include <android/log.h>

#define LOG_TAG "P3XE-QEMUCenter"
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)

extern "C"
JNIEXPORT jstring JNICALL
Java_com_pure3x_qemucenter_MainActivity_nativeGetVersion(
        JNIEnv* env,
        jobject /* thiz */) {

    LOGI("P3XE QEMU Center Native Runtime iniciado");

    return env->NewStringUTF("P3XE QEMU Center Native 0.1.0 Alpha");
}
