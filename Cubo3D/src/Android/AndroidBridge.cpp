#include <jni.h>
#include <android/log.h>
#include <android/native_window.h>
#include <android/native_window_jni.h>

#include <EGL/egl.h>
#include <GLES3/gl3.h>

#define TAG "Cubo3D-Native"

#define LOGI(...) \
    __android_log_print(ANDROID_LOG_INFO, TAG, __VA_ARGS__)

#define LOGE(...) \
    __android_log_print(ANDROID_LOG_ERROR, TAG, __VA_ARGS__)

// ============================================================
// Estado Android
// ============================================================

static ANativeWindow* gWindow = nullptr;

static int gWidth = 0;
static int gHeight = 0;

// ============================================================
// Estado EGL / OpenGL ES
// ============================================================

static EGLDisplay gDisplay = EGL_NO_DISPLAY;
static EGLSurface gEglSurface = EGL_NO_SURFACE;
static EGLContext gContext = EGL_NO_CONTEXT;
static EGLConfig gConfig = nullptr;

static bool gEglReady = false;


// ============================================================
// Destruir EGL
// ============================================================

static void destroyEGL()
{
    LOGI("destroyEGL()");

    if (gDisplay != EGL_NO_DISPLAY) {

        eglMakeCurrent(
            gDisplay,
            EGL_NO_SURFACE,
            EGL_NO_SURFACE,
            EGL_NO_CONTEXT
        );

        if (gEglSurface != EGL_NO_SURFACE) {
            eglDestroySurface(
                gDisplay,
                gEglSurface
            );

            gEglSurface = EGL_NO_SURFACE;
        }

        if (gContext != EGL_NO_CONTEXT) {
            eglDestroyContext(
                gDisplay,
                gContext
            );

            gContext = EGL_NO_CONTEXT;
        }

        eglTerminate(gDisplay);

        gDisplay = EGL_NO_DISPLAY;
    }

    gConfig = nullptr;
    gEglReady = false;

    LOGI("EGL destruido.");
}


// ============================================================
// Inicializar EGL + OpenGL ES 3
// ============================================================

static bool initializeEGL()
{
    LOGI("initializeEGL()");

    if (gWindow == nullptr) {
        LOGE("initializeEGL: gWindow == nullptr");
        return false;
    }

    // --------------------------------------------------------
    // Display
    // --------------------------------------------------------

    gDisplay = eglGetDisplay(EGL_DEFAULT_DISPLAY);

    if (gDisplay == EGL_NO_DISPLAY) {
        LOGE(
            "eglGetDisplay falhou. erro=0x%x",
            eglGetError()
        );

        return false;
    }

    EGLint major = 0;
    EGLint minor = 0;

    if (!eglInitialize(
            gDisplay,
            &major,
            &minor)) {

        LOGE(
            "eglInitialize falhou. erro=0x%x",
            eglGetError()
        );

        destroyEGL();
        return false;
    }

    LOGI(
        "EGL inicializado: %d.%d",
        major,
        minor
    );


    // --------------------------------------------------------
    // Configuração framebuffer
    // --------------------------------------------------------

    const EGLint configAttribs[] = {

        EGL_SURFACE_TYPE,
        EGL_WINDOW_BIT,

        EGL_RENDERABLE_TYPE,
        EGL_OPENGL_ES3_BIT,

        EGL_RED_SIZE,
        8,

        EGL_GREEN_SIZE,
        8,

        EGL_BLUE_SIZE,
        8,

        EGL_ALPHA_SIZE,
        8,

        EGL_DEPTH_SIZE,
        24,

        EGL_NONE
    };

    EGLint numConfigs = 0;

    if (!eglChooseConfig(
            gDisplay,
            configAttribs,
            &gConfig,
            1,
            &numConfigs)) {

        LOGE(
            "eglChooseConfig falhou. erro=0x%x",
            eglGetError()
        );

        destroyEGL();
        return false;
    }

    if (numConfigs <= 0 || gConfig == nullptr) {
        LOGE("Nenhuma EGLConfig OpenGL ES 3 encontrada.");

        destroyEGL();
        return false;
    }

    LOGI(
        "EGLConfig encontrada. configs=%d",
        numConfigs
    );


    // --------------------------------------------------------
    // Formato da janela Android
    // --------------------------------------------------------

    EGLint format = 0;

    if (eglGetConfigAttrib(
            gDisplay,
            gConfig,
            EGL_NATIVE_VISUAL_ID,
            &format)) {

        ANativeWindow_setBuffersGeometry(
            gWindow,
            0,
            0,
            format
        );

        LOGI(
            "ANativeWindow formato=%d",
            format
        );
    }


    // --------------------------------------------------------
    // Criar Surface EGL
    // --------------------------------------------------------

    gEglSurface =
        eglCreateWindowSurface(
            gDisplay,
            gConfig,
            gWindow,
            nullptr
        );

    if (gEglSurface == EGL_NO_SURFACE) {

        LOGE(
            "eglCreateWindowSurface falhou. erro=0x%x",
            eglGetError()
        );

        destroyEGL();
        return false;
    }


    // --------------------------------------------------------
    // Criar contexto OpenGL ES 3
    // --------------------------------------------------------

    const EGLint contextAttribs[] = {

        EGL_CONTEXT_CLIENT_VERSION,
        3,

        EGL_NONE
    };

    gContext =
        eglCreateContext(
            gDisplay,
            gConfig,
            EGL_NO_CONTEXT,
            contextAttribs
        );

    if (gContext == EGL_NO_CONTEXT) {

        LOGE(
            "eglCreateContext ES3 falhou. erro=0x%x",
            eglGetError()
        );

        destroyEGL();
        return false;
    }


    // --------------------------------------------------------
    // Ativar contexto
    // --------------------------------------------------------

    if (!eglMakeCurrent(
            gDisplay,
            gEglSurface,
            gEglSurface,
            gContext)) {

        LOGE(
            "eglMakeCurrent falhou. erro=0x%x",
            eglGetError()
        );

        destroyEGL();
        return false;
    }


    // --------------------------------------------------------
    // Descobrir tamanho real da Surface
    // --------------------------------------------------------

    EGLint surfaceWidth = 0;
    EGLint surfaceHeight = 0;

    eglQuerySurface(
        gDisplay,
        gEglSurface,
        EGL_WIDTH,
        &surfaceWidth
    );

    eglQuerySurface(
        gDisplay,
        gEglSurface,
        EGL_HEIGHT,
        &surfaceHeight
    );

    if (surfaceWidth > 0) {
        gWidth = surfaceWidth;
    }

    if (surfaceHeight > 0) {
        gHeight = surfaceHeight;
    }


    // --------------------------------------------------------
    // Informações OpenGL
    // --------------------------------------------------------

    const GLubyte* vendor =
        glGetString(GL_VENDOR);

    const GLubyte* renderer =
        glGetString(GL_RENDERER);

    const GLubyte* version =
        glGetString(GL_VERSION);

    const GLubyte* shading =
        glGetString(GL_SHADING_LANGUAGE_VERSION);


    LOGI(
        "GL_VENDOR: %s",
        vendor ? reinterpret_cast<const char*>(vendor) : "null"
    );

    LOGI(
        "GL_RENDERER: %s",
        renderer ? reinterpret_cast<const char*>(renderer) : "null"
    );

    LOGI(
        "GL_VERSION: %s",
        version ? reinterpret_cast<const char*>(version) : "null"
    );

    LOGI(
        "GLSL: %s",
        shading ? reinterpret_cast<const char*>(shading) : "null"
    );


    // --------------------------------------------------------
    // VSync
    // --------------------------------------------------------

    eglSwapInterval(
        gDisplay,
        1
    );


    // --------------------------------------------------------
    // Viewport
    // --------------------------------------------------------

    glViewport(
        0,
        0,
        gWidth,
        gHeight
    );

    gEglReady = true;

    LOGI(
        "OpenGL ES pronto: %dx%d",
        gWidth,
        gHeight
    );

    return true;
}


// ============================================================
// JNI
// Surface criada
// ============================================================

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


    // Se já existia uma janela, limpar primeiro.

    if (gEglReady) {
        destroyEGL();
    }

    if (gWindow != nullptr) {

        ANativeWindow_release(gWindow);

        gWindow = nullptr;
    }


    // Obter ANativeWindow da Surface Java.

    gWindow =
        ANativeWindow_fromSurface(
            env,
            surface
        );

    if (gWindow == nullptr) {

        LOGE(
            "ANativeWindow_fromSurface falhou."
        );

        return JNI_FALSE;
    }


    gWidth =
        ANativeWindow_getWidth(
            gWindow
        );

    gHeight =
        ANativeWindow_getHeight(
            gWindow
        );


    LOGI(
        "ANativeWindow criada: %dx%d",
        gWidth,
        gHeight
    );


    // Inicializar EGL.

    if (!initializeEGL()) {

        LOGE(
            "Falha inicializando EGL/OpenGL ES."
        );

        ANativeWindow_release(gWindow);

        gWindow = nullptr;

        return JNI_FALSE;
    }


    // Primeiro frame.
    // Fundo temporário para provar que EGL está funcionando.

    glViewport(
        0,
        0,
        gWidth,
        gHeight
    );

    glClearColor(
        0.05f,
        0.12f,
        0.22f,
        1.0f
    );

    glClear(
        GL_COLOR_BUFFER_BIT |
        GL_DEPTH_BUFFER_BIT
    );


    if (!eglSwapBuffers(
            gDisplay,
            gEglSurface)) {

        LOGE(
            "Primeiro eglSwapBuffers falhou. erro=0x%x",
            eglGetError()
        );

        return JNI_FALSE;
    }


    LOGI(
        "Primeiro frame Cubo3D apresentado."
    );

    return JNI_TRUE;
}


// ============================================================
// JNI
// Surface mudou de tamanho
// ============================================================

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


    gWidth =
        static_cast<int>(width);

    gHeight =
        static_cast<int>(height);


    // Recuperar ANativeWindow somente se necessário.

    if (gWindow == nullptr &&
        surface != nullptr) {

        gWindow =
            ANativeWindow_fromSurface(
                env,
                surface
            );

        if (gWindow != nullptr) {

            LOGI(
                "ANativeWindow recuperada em surfaceChanged."
            );

        } else {

            LOGE(
                "Falha recuperando ANativeWindow."
            );

            return;
        }
    }


    if (!gEglReady) {

        LOGI(
            "EGL ainda nao estava pronto. Inicializando."
        );

        if (!initializeEGL()) {

            LOGE(
                "initializeEGL falhou em surfaceChanged."
            );

            return;
        }
    }


    if (!eglMakeCurrent(
            gDisplay,
            gEglSurface,
            gEglSurface,
            gContext)) {

        LOGE(
            "eglMakeCurrent falhou em surfaceChanged. erro=0x%x",
            eglGetError()
        );

        return;
    }


    glViewport(
        0,
        0,
        gWidth,
        gHeight
    );


    LOGI(
        "Viewport atualizado: %dx%d",
        gWidth,
        gHeight
    );
}


// ============================================================
// JNI
// Surface destruída
// ============================================================

extern "C"
JNIEXPORT void JNICALL
Java_com_pure3x_cubo3d_MainActivity_nativeSurfaceDestroyed(
        JNIEnv*,
        jclass)
{
    LOGI(
        "nativeSurfaceDestroyed()"
    );


    destroyEGL();


    if (gWindow != nullptr) {

        ANativeWindow_release(
            gWindow
        );

        gWindow = nullptr;
    }


    gWidth = 0;
    gHeight = 0;


    LOGI(
        "Surface Cubo3D destruida."
    );
}


// ============================================================
// JNI
// Renderizar frame
// ============================================================

extern "C"
JNIEXPORT void JNICALL
Java_com_pure3x_cubo3d_MainActivity_nativeRenderFrame(
        JNIEnv*,
        jclass)
{
    if (gWindow == nullptr) {

        LOGE(
            "Render solicitado sem ANativeWindow."
        );

        return;
    }


    if (!gEglReady ||
        gDisplay == EGL_NO_DISPLAY ||
        gEglSurface == EGL_NO_SURFACE ||
        gContext == EGL_NO_CONTEXT) {

        LOGE(
            "Render solicitado sem EGL pronto."
        );

        return;
    }


    if (!eglMakeCurrent(
            gDisplay,
            gEglSurface,
            gEglSurface,
            gContext)) {

        LOGE(
            "eglMakeCurrent falhou no render. erro=0x%x",
            eglGetError()
        );

        return;
    }


    glViewport(
        0,
        0,
        gWidth,
        gHeight
    );


    // ========================================================
    // Frame de teste
    //
    // Depois este bloco será substituído pelo CubeRenderer.
    // ========================================================

    glClearColor(
        0.05f,
        0.12f,
        0.22f,
        1.0f
    );

    glClear(
        GL_COLOR_BUFFER_BIT |
        GL_DEPTH_BUFFER_BIT
    );


    // Apresentar frame na tela Android.

    if (!eglSwapBuffers(
            gDisplay,
            gEglSurface)) {

        LOGE(
            "eglSwapBuffers falhou. erro=0x%x",
            eglGetError()
        );

        return;
    }


    LOGI(
        "Frame apresentado: %dx%d",
        gWidth,
        gHeight
    );
}
