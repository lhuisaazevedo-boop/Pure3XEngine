# P3XE — Pure3XEngine

P3XE é uma arquitetura própria de emulação nativa para Android, desenvolvida em C++ com foco em execução ARM64, modularidade e integração direta com o ecossistema Android/Termux.

O projeto é dividido em componentes independentes para que o núcleo de emulação, o backend gráfico e a integração Android possam evoluir separadamente.

## Arquitetura

```text
P3XE Emulator
│
├── JNI / Android
│
├── CoreEmulator
│   └── liblhuis.pure3x.so
│
└── Cubo3D
    └── libcubo3d.so
```

## CoreEmulator

O `CoreEmulator` é responsável pelo núcleo de execução da emulação e pela comunicação entre os subsistemas do sistema emulado.

Os componentes planejados e integrados incluem:

- SystemBus
- MemoryManager
- PPU
- SPU
- RSX / GPU
- FirmwareManager
- Boot System
- HardwareInfo
- Sistemas de I/O

Biblioteca nativa:

```text
liblhuis.pure3x.so
```

## Cubo3D

O `Cubo3D` é o backend gráfico nativo do P3XE.

Inclui:

- Vulkan
- OpenGL ES
- Gerenciamento de shaders
- Gerenciamento de recursos gráficos
- Integração com o `CoreEmulator`

Biblioteca nativa:

```text
libcubo3d.so
```

## JNI / Android

O JNI fornece a ponte entre o código nativo e o Android.

O APK funciona como a camada de integração responsável por carregar as bibliotecas nativas ARM64. O `CoreEmulator` e o `Cubo3D` são bibliotecas nativas e não precisam gerar um APK diretamente.

Estrutura ARM64 esperada:

```text
lib/arm64-v8a/
├── liblhuis.pure3x.so
├── libcubo3d.so
└── libc++_shared.so
```

## Ambiente atual

- Android 16
- API alvo do aplicativo: 36
- API nativa Android: 29
- ABI: `arm64-v8a`
- Android NDK: R29 (`29.0.14206865`)
- Clang: 21.1.8
- C++23
- CMake
- Termux

## Build nativo

O `CoreEmulator` é compilado independentemente do APK:

```bash
cd ~/Pure3XEngine

cmake --build CoreEmulator/build \
  --target lhuis.pure3x \
  -j4
```

Resultado esperado:

```text
CoreEmulator/build/liblhuis.pure3x.so
```

O `Cubo3D` possui seu próprio processo de build e produz:

```text
Cubo3D/build/libcubo3d.so
```

## Validação das bibliotecas

As bibliotecas geradas podem ser inspecionadas com:

```bash
file CoreEmulator/build/liblhuis.pure3x.so
file Cubo3D/build/libcubo3d.so

readelf -d CoreEmulator/build/liblhuis.pure3x.so | grep NEEDED
readelf -d Cubo3D/build/libcubo3d.so | grep NEEDED
```

As duas bibliotecas nativas devem ser compatíveis com ARM64 Android. Quando exigido pelas bibliotecas nativas, o runtime C++ compartilhado `libc++_shared.so` também deve estar disponível no APK.

## Princípios

O P3XE busca manter:

- arquitetura modular;
- separação entre emulação e renderização;
- execução nativa ARM64;
- integração direta com Android;
- compatibilidade com Termux;
- componentes independentes e reutilizáveis;
- diagnóstico e builds reproduzíveis.

## Estado atual

- O `CoreEmulator` possui um build nativo funcional e gera `liblhuis.pure3x.so`.
- O `Cubo3D` gera a biblioteca nativa `libcubo3d.so`.
- Os dois componentes são preparados para execução como bibliotecas nativas ARM64 no Android.
- A próxima etapa é integrar as duas bibliotecas por JNI e validar o carregamento conjunto no Android.

## Roadmap

### Alpha 0.2.6

- Estabilizar o build nativo do `CoreEmulator`.
- Gerar as bibliotecas ARM64 do `CoreEmulator` e do `Cubo3D`.
- Validar as dependências nativas.
- Preparar a integração JNI.

### 0.2.7

- Melhorar a interface Android.
- Simplificar a navegação e as configurações.
- Tornar a experiência mais clara para a comunidade.
- Preparar um fluxo simples para baixar e executar jogos.

## Licença

GNU General Public License v3.0 (GPL-3.0).
