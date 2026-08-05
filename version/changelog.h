#pragma once

namespace Pure3X
{

static const char* CHANGELOG = R"(

============================================
Pure3XEngine v0.2.6 Alpha
============================================

[Project Status]

Pure3XEngine / P3XE continua em desenvolvimento.

O projeto passou por uma pausa para reorganização,
correção da infraestrutura e desenvolvimento de novas
ferramentas.

O projeto NÃO foi encerrado ou abandonado.


[Pure3XEngine Core]

+ Reorganização da estrutura principal da Engine.
+ Padronização do projeto em C++20.
+ Revisão dos módulos internos.
+ Melhor integração entre Core e Android Runtime.
+ Correções na estrutura CMake.
+ Revisão dos caminhos utilizados pelo sistema de build.
+ Preparação da infraestrutura para evolução da emulação.


[Android Runtime]

+ Android SDK revisado.
+ Android NDK revisado.
+ Estrutura preparada para NDK r29.
+ Integração CMake / Gradle em revisão.
+ Suporte ARM64.
+ Vulkan / OpenGL ES.
+ Native Bridge.
+ Runtime Manager.
+ Memory Manager.
+ RSX Manager.
+ PPU Manager.
+ SPU Manager.
+ Audio Manager.
+ Input Manager.
+ Boot Manager.


[P3XE Development Kit]

+ Desenvolvimento do P3XE Development Kit.
+ Menu central de desenvolvimento.
+ Ferramentas de diagnóstico.
+ Ferramentas de reparação do projeto.
+ Verificação Android SDK.
+ Verificação Android NDK.
+ Diagnóstico CMake.
+ Diagnóstico C++20.
+ Diagnóstico de local.properties.
+ Detecção de caches e builds antigos.
+ Comparação das configurações dos módulos.
+ Ferramentas de desenvolvimento para Android e Termux.

O P3XE Development Kit também está sendo preparado
para fornecer ferramentas úteis à comunidade de
emulação no Android.


[Cubo3D]

+ Desenvolvimento do Cubo3D.
+ Estrutura Android independente.
+ Integração com o ambiente Pure3X.
+ Testes de renderização.
+ Preparação para Vulkan / OpenGL ES.


[P3XE Emulator]

+ Estrutura do emulador em desenvolvimento.
+ Gerenciamento de firmware.
+ Gerenciamento de jogos.
+ Gerenciamento de CPU.
+ Gerenciamento RSX.
+ Diagnóstico do estado do emulador.


[QEMU Center]

+ QEMU Center em desenvolvimento.
+ Gerenciamento de máquinas virtuais.
+ Integração com QEMU.
+ Estrutura Android própria.
+ Integração com o P3XE Development Kit.
+ Preparação para criação, configuração e execução
  de máquinas virtuais no Android.


[Current Development]

Estamos trabalhando principalmente em:

+ Correções de SDK / NDK.
+ Padronização no NDK r29.
+ Correção dos caminhos CMake.
+ Organização dos módulos.
+ Ferramentas automáticas de diagnóstico.
+ P3XE Development Kit.
+ Cubo3D.
+ P3XE Emulator.
+ QEMU Center.
+ Infraestrutura Android.


[Status]

Pure3XEngine        : Development Alpha
P3XE Development Kit: Development
P3XE Emulator       : Development
Cubo3D              : Development
QEMU Center         : Development

Version : 0.2.6 Alpha
Build   : 026

============================================

)";

} // namespace Pure3X
