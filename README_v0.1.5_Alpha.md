<p align="center">
  <img src="docs/images/Pure3XEngine-0.1.5-Alpha.png" alt="Pure3XEngine v0.1.5 Alpha Banner">
</p>

<h1 align="center">Pure3XEngine</h1>

<p align="center">
Engine Experimental de PlayStation 3 para Android
</p>

---
# 🚀 Pure3XEngine v0.1.5 Alpha
«⚠️ O Pure3XEngine encontra-se em desenvolvimento na fase Alpha.»

A versão v0.1.5 Alpha representa a maior atualização da arquitetura do projeto até o momento, trazendo novos módulos fundamentais para o desenvolvimento futuro da engine.

---

## 📌 Status Atual ##

O Pure3XEngine é uma engine experimental de PlayStation 3 desenvolvida totalmente em C++20, com foco em Android.

Objetivos atuais:

- Arquitetura modular
- Base da Engine
- Emulator Core
- Kernel Base
- Loader PS3
- Virtual File System
- Compatibilidade futura com Vulkan
- Preparação para Android NDK

## Status: 🚧 Alpha v0.1.5 ##

---

## ✅ Funcionalidades Implementadas ##

## 🟢 Boot System ##

- Inicialização da Engine
- Logo ASCII
- Barra de carregamento
- Sequência de Boot
- Sistema de Logs

---

## 🧠 Engine Core ##

- Arquitetura Modular
- Organização da Engine
- Controle de Execução
- Estrutura preparada para expansão

---

## 📦 Version System ##

core/version/

- Nome da Engine
- Versão
- Build
- Desenvolvedor
- Plataforma
- Idioma

---

## ⚙️ Config Manager ##

- Configuração da Engine
- Configuração Modular
- Preparação para múltiplos idiomas

---

## 📄 Logger ##

- Logger da Engine
- Logs em arquivo
- Informações da Engine
- Níveis de Log
- Preparação para Debug

---

## 🌐 Network ##

- Teste de conexão
- Informações da Rede
- Endereço IP

---

## 🎮 Game Modules ##

- Estrutura para módulos de jogos
- Organização modular

---

## 📦 Module Manager ##

- Registro de módulos
- Inicialização automática
- Encerramento automático

---

## 💿 Loader ##

- ELF Loader
- SELF Loader
- SPRX Loader

---

## 📁 Virtual File System (VFS) ##

- Virtual File System
- File System
- Directory Manager

---

## ⚙️ Kernel Base ##

- Kernel
- Process Manager
- Thread Manager

---

## 🕹 Emulator Core ##

- Emulator
- CPU
- GPU
- SPU
- Memory

---

## 💽 Disc / Game Manager ##

- Disc Manager
- Game Manager

---

## 🧠 Memory Manager ##

- Gerenciamento de Memória
- Leitura de memória
- Escrita de memória
- Inicialização de memória

---

## 📁 Estrutura do Projeto ##
```
Pure3XEngine/
├── Config/
├── Docs/
│   └── images/
│       └── Pure3XEngine-0.1.5-Alpha.png
├── build/
├── core/
│   ├── boot/
│   ├── config/
│   ├── disc/
│   ├── emulator/
│   ├── gamemodules/
│   ├── kernel/
│   ├── loader/
│   ├── logger/
│   ├── memory/
│   ├── modules/
│   ├── network/
│   ├── platform/
│   ├── system/
│   ├── version/
│   └── vfs/
├── src/
├── CMakeLists.txt
├── README.md
└── LICENSE
```
---

## ⭐ Características ##

- C++20
- Arquitetura Modular
- Boot System
- Version Manager
- Config Manager
- Logger
- Network Manager
- Module Manager
- Emulator Core
- Disc Manager
- Memory Manager
- Kernel Base
- Loader
- Virtual File System

---

## ⚙️ Tecnologias ##

- C++20
- CMake
- Git
- GitHub
- Termux
- Android NDK (Preparação)

---

## 📚 Documentação ##

Toda a documentação oficial encontra-se na pasta Docs/.

- OfficialDocumentation.md
- DevelopmentRoadmap.md
- DevelopmentNotes.md

---

## 🗺️ Roadmap ##

## ✅ v0.1.5 Alpha ##

- Emulator Core
- Disc Manager
- Game Manager
- Memory Manager
- Module Manager
- Kernel Base
- Loader System
- Virtual File System
- Melhorias no Logger
- Reorganização do Projeto
- Migração para C++20

---

## 🚧 v0.1.6 Alpha ##

- Base RSX Graphics
- Backend Vulkan
- Shader Manager
- Texture Cache
- Framebuffer Manager
- Pipeline de Renderização

---

## 🚧 v0.1.7 Alpha ##

- Interpretador PPU
- Interpretador SPU
- Framework de Syscalls
- Audio Framework
- Input Manager
- Cache de Arquivos
- Melhorias de Desempenho

---

## 🚧 v0.1.8 Alpha ##

- Loader de Homebrew PS3
- Leitura de PARAM.SFO
- Execução inicial de EBOOT.BIN
- Sistema de Save Data
- Melhorias Gráficas
- Melhorias de Áudio
- Melhorias de Compatibilidade

---

## 🚀 v0.1.9 Alpha ##

- Primeiro Boot de Homebrew PS3
- Compatibilidade inicial com jogos
- Frontend Android
- Geração do APK
- Otimizações de desempenho
- Melhorias de estabilidade
- Testes públicos

---

## 🔮 Futuro ##

- Renderizador RSX Avançado
- Vulkan Otimizado
- Recompilador Dinâmico (JIT)
- Shader Cache
- Texture Cache
- Audio Engine
- Suporte a Controles
- Save States
- Interface Android
- Compatibilidade crescente com PlayStation 3

---

## 👨‍💻 Desenvolvedor ##

Lhuis (LhuisDev)

Projeto independente desenvolvido para pesquisa, aprendizado e evolução de uma Engine Experimental de PlayStation 3 para Android.

---

## 📜 Licença ##

Distribuído sob a licença MIT.

Você pode estudar, modificar e contribuir com o projeto, respeitando os termos da licença e mantendo os créditos do autor original.

---

## 📢 Aviso ##

A partir da versão v0.1.5 Alpha, o Pure3XEngine passará a receber uma atualização oficial por noite.

Esse novo ciclo permitirá mais tempo para desenvolvimento, testes, correções e estabilidade antes de cada nova versão.

Obrigado por acompanhar o desenvolvimento do Pure3XEngine! 🚀
