Pure3XEngine v0.1.8 Alpha

Experimental PlayStation 3 Engine for Android

Sobre

O Pure3XEngine é um projeto experimental desenvolvido do zero em C++, com foco na pesquisa e implementação de uma engine de emulação para PlayStation 3 (PS3) otimizada para Android.

A versão 0.1.8 Alpha representa um dos maiores avanços da arquitetura interna do projeto, adicionando novos componentes do pipeline gráfico RSX, melhorias no sistema de carregamento de firmware e a primeira base do novo sistema de entrada (Input Framework).

---

Novidades da versão 0.1.8 Alpha

RSX Framework

Implementação inicial da arquitetura gráfica.

Componentes

- Renderer
- ShaderManager
- TextureManager
- VertexBuffer

Esta estrutura será utilizada futuramente para integração com Vulkan/OpenGL ES.

---

Sistema de Firmware

Novo gerenciamento de firmware.

Componentes

- FirmwareManager
- FirmwareInfo

Preparação para validação, leitura e gerenciamento do firmware do PlayStation 3.

---

Novo Sistema de Input

Primeira implementação do framework de entrada.

Implementado

- InputManager
- DualShock3
- InputState
- ButtonMap

O objetivo é permitir suporte modular para diversos controles.

---

Controles planejados

- DualShock 3
- DualShock 4
- DualSense
- Xbox 360
- Xbox One
- Xbox Series
- Gamepads Bluetooth
- Controles USB HID
- Android Game Controller API

---

Estrutura RSX

Implementados os primeiros módulos:

- Renderer
- Shader Manager
- Texture Manager
- Vertex Buffer

Esses módulos servirão de base para o pipeline gráfico da GPU RSX.

---

Build

Compilação realizada com sucesso utilizando:

- CMake 3.16+
- C++20
- Clang
- Termux
- Android 16

Build concluído com sucesso (100%).

---

Status do Projeto

Versão: 0.1.8 Alpha

Estado atual:

- Engine Base
- Boot System
- Logger
- Config Manager
- Version System
- Memory Manager
- Loader
- Firmware Manager
- Emulator Core
- Kernel
- Scheduler
- RSX Framework
- Input Framework

---

Próximos Objetivos

- RSX Command Processor
- Texture Cache
- Shader Cache
- Vulkan Backend
- HID Input
- Áudio
- Boot de executáveis SELF
- Primeira execução de homebrew
- Integração Android NDK

---

Desenvolvido por

Lhuisa Azevedo

Projeto independente focado em pesquisa, arquitetura e desenvolvimento de uma engine experimental para PlayStation 3 em Android.

---

Pure3XEngine

Version 0.1.8 Alpha

Experimental PlayStation 3 Engine for Android.
