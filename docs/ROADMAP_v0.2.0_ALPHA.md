Pure3XEngine v0.2.0 Alpha - Planejamento Inicial

Visão Geral

A versão 0.2.0 Alpha marca o início da transição do Pure3XEngine para uma infraestrutura Android moderna baseada em Android NDK r29.

O objetivo principal desta versão não é implementar emulação completa de PlayStation 3, mas preparar toda a fundação técnica necessária para futuras versões.

---

Objetivos Principais

Android NDK r29

- Atualização completa da toolchain.
- Compatibilidade ARM64.
- Integração com Android moderno.
- Preparação para geração futura de APK.

Sistema Gráfico

- Base Vulkan.
- Driver Manager.
- Detecção automática de GPU.
- Compatibilidade com drivers do sistema e drivers personalizados.

Sistema de Configuração

- Config.ini modular.
- Perfis automáticos.
- Configurações por dispositivo.
- Estrutura preparada para configurações por jogo.

Diagnóstico

- Identificação de CPU.
- Identificação de GPU.
- Informações de memória.
- Informações Vulkan.

Cache

- Shader Cache.
- Pipeline Cache.
- Memory Cache.

---

Driver Manager

O Pure3XEngine não exigirá drivers específicos.

Modos disponíveis:

- Auto Detect
- System Driver
- Custom Driver
- Experimental Driver

O usuário poderá selecionar manualmente um driver quando necessário.

---

Estrutura Base

Core/

- Engine
- System
- Memory
- Graphics
- Vulkan
- DriverManager

Config/

- ConfigManager
- Profiles

Logs/

- Runtime Logs
- Diagnostics

Platform/

- Android
- ARM64

---

Status

Versão atual:
v0.1.9 Alpha

Próxima etapa:
Início da série v0.2.x Alpha com foco total em Android NDK r29.

Pure3XEngine 0.2.0 Alpha
=========================

Objetivo:
Migração para Android NDK r29

FASE 1
✓ Atualizar Toolchain
✓ Android NDK r29
✓ ARM64 nativo
✓ Revisão do CMake

FASE 2
✓ Vulkan Backend Base
✓ Driver Manager
✓ Auto Detect GPU
✓ Configuração gráfica modular

FASE 3
✓ Config.ini avançado
✓ Perfis Low/Medium/High
✓ Logs aprimorados
✓ Diagnóstico de hardware

FASE 4
✓ Shader Cache
✓ Pipeline Cache
✓ Memory Cache
✓ Sistema de perfis por jogo

FASE 5
✓ Preparação para APK
✓ Estrutura JNI
✓ Frontend Android inicial

Driver Manager
==============
Modo Automático
Modo Sistema
Modo Personalizado
Modo Experimental

Adreno 610
Driver recomendado:
- System Driver
- Turnip Compatível

0.2.0 = Infraestrutura Android

0.3.0 = Desenvolvimento pesado do Engine

0.4.0 = Primeiros testes gráficos reais
