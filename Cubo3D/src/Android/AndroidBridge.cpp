#include <jni.h>
#include <android/log.h>
#include <android/native_window.h>
#include <android/native_window_jni.h>

#define TAG "Cubo3D-Native"

#define LOGI(...) \
    __android_log_print(ANDROID_LOG_INFO, TAG, __VA_ARGS__)

#define LOGE(...) \
    __android_log_print(ANDROID_LOG_ERROR, TAG, __VA_ARGS__)

static ANativeWindow* gWindow = nullptr;
static int gWidth = 0;
static int gHeight = 0;

extern "C"
JNIEXPORT jboolean JNICALL
Java_com_pure3x_cubo3d_MainActivity_nativeSurfaceCreated(
        JNIEnv* env,
        jclass,
        jobject surface)
{
    LOGI("nativeSurfaceCreated()");

    if (surface == nullptr) {
        LOGE("Surface Java nula.");
        return JNI_FALSE;
    }

    if (gWindow != nullptr) {
        ANativeWindow_release(gWindow);
        gWindow = nullptr;
    }

    gWindow = ANativeWindow_fromSurface(env, surface);

    if (gWindow == nullptr) {
        LOGE("ANativeWindow_fromSurface falhou.");
        return JNI_FALSE;
    }

    gWidth = ANativeWindow_getWidth(gWindow);
    gHeight = ANativeWindow_getHeight(gWindow);

    LOGI(
        "ANativeWindow criada: %dx%d",
        gWidth,
        gHeight
    );

    return JNI_TRUE;
}

extern "C"
JNIEXPORT void JNICALL
Java_com_pure3x_cubo3d_MainActivity_nativeSurfaceChanged(
        JNIEnv* env,
        jclass,
        jobject surface,
        jint width,
        jint height)
{
    LOGI(
        "nativeSurfaceChanged(): %dx%d",
        static_cast<int>(width),
        static_cast<int>(height)
    );

    gWidth = static_cast<int>(width);
    gHeight = static_cast<int>(height);

    if (gWindow == nullptr && surface != nullptr) {
        gWindow = ANativeWindow_fromSurface(env, surface);

        if (gWindow != nullptr) {
            LOGI("ANativeWindow recuperada em surfaceChanged.");
        } else {
            LOGE("Falha recuperando ANativeWindow.");
        }
    }
}

extern "C"
JNIEXPORT void JNICALL
Java_com_pure3x_cubo3d_MainActivity_nativeSurfaceDestroyed(
        JNIEnv*,
        jclass)
{
    LOGI("nativeSurfaceDestroyed()");

    if (gWindow != nullptr) {
        ANativeWindow_release(gWindow);
        gWindow = nullptr;
    }

    gWidth = 0;
    gHeight = 0;
}

extern "C"
JNIEXPORT void JNICALL
Java_com_pure3x_cubo3d_MainActivity_nativeRenderFrame(
        JNIEnv*,
        jclass)
{
    if (gWindow == nullptr) {
        LOGE("Render solicitado sem ANativeWindow.");
        return;
    }

    LOGI(
        "Render solicitado. Surface=%dx%d",
        gWidth,
        gHeight
    );

    // Próxima etapa:
    // OpenGLESManager -> EGL -> glClear -> eglSwapBuffers.
}
