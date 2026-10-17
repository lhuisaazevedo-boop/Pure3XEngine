# Stage 14.0.0–14.0.9 — Cubo3D Frame Renderer

## Implementado

- O `CubeRenderer` usa o contexto EGL já criado pelo `AndroidBridge.cpp`; não cria um segundo contexto.
- O renderer compila e vincula shaders GLSL ES 3.00, registra falhas no log nativo e desenha um cubo verde sombreado por face com VAO, VBO, EBO, matrizes MVP próprias e depth test.
- A superfície encaminha tamanho ao renderer. Os recursos GL são inicializados após `eglMakeCurrent` e liberados antes da destruição do contexto.
- A rotação usa o tempo entre frames. O FPS é calculado por janelas de aproximadamente um segundo, contando somente chamadas cujo `eglSwapBuffers` teve sucesso, e é publicado por JNI.
- A interface mostra o FPS do render do Cubo3D, explicitamente distinto do FPS da emulação PS3. A atualização visual ocorre a cada 500 ms e para quando a superfície é destruída ou a Activity termina.

## Validação no dispositivo

**Nada está validado no dispositivo.** A apresentação visual do cubo, a rotação, o valor de FPS e a recuperação do ciclo de vida precisam ser confirmados manualmente em um aparelho Android antes de considerar qualquer etapa de 14.0.0 a 14.0.9 concluída. A compilação, se executada em outro ambiente, não substitui esse teste.

## Checklist de teste manual

- [ ] Construir o APK debug com NDK `29.0.14206865`:

  ```bash
  cd Cubo3D/android
  ./gradlew assembleDebug
  ```

- [ ] Instalar o APK atualizado no aparelho e confirmar visualmente o cubo verde em rotação e o texto `Cubo3D render FPS`.
- [ ] Conferir os logs com `adb logcat -s Cubo3D-Native Cubo3D`; confirmar shader/contexto sem erros e FPS logado no máximo uma vez por segundo.
- [ ] Testar background/foreground, destruição/recriação da superfície e rotação do aparelho; confirmar que o renderer volta a desenhar e que o FPS continua sendo atualizado.
- [ ] Registrar evidências do aparelho e só então marcar as etapas correspondentes como validadas.
