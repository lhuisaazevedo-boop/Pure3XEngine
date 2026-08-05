## 🚀 Pure3XEngine v0.1.4 Alpha ##

«⚠️ O Pure3XEngine encontra-se em desenvolvimento na fase Alpha.

Novos recursos, melhorias, correções e otimizações são adicionados continuamente a cada atualização.»

---

## 📌 Status Atual ##

O Pure3XEngine é uma engine experimental desenvolvida em C++, focada em pesquisa, arquitetura modular e estudos relacionados à emulação e execução de sistemas complexos.

A versão v0.1.4 Alpha representa uma evolução importante da estrutura interna da engine, introduzindo um sistema centralizado de informações de versão através do Version Core, tornando futuras atualizações muito mais simples e organizadas.

---

## ⚠️ Suporte ao Android ##

O Pure3XEngine iniciou oficialmente a preparação para oferecer suporte ao Android.

O ambiente de desenvolvimento já possui uma base funcional utilizando Termux, CMake e Android NDK.

Atualmente o suporte permanece em fase experimental.

Status: 🚧 Experimental

---

## ✅ Funcionalidades Implementadas ##

## 🟢 Boot System ##

- Inicialização da Engine
- Logo ASCII
- Barra de carregamento
- Sequência de Boot
- Sistema de Logs
- Tela "Pure3XEngine Ready"

## 🧠 Core ##

- Arquitetura modular
- Organização da Engine
- Controle da execução
- Base para expansão

## 📦 Version Core (Novo na v0.1.4) ##

- Centralização das informações da Engine
- Nome da Engine
- Versão
- Build
- Desenvolvedor
- Plataforma
- Idioma

Agora todas essas informações são controladas em um único local:
```text
core/
└── version/
    ├── version.h
    ├── version.cpp
    └── changelog.h
```
Isso elimina a necessidade de alterar diversos arquivos sempre que uma nova versão for lançada.

## 🖥️ System Manager ##

- Status do sistema
- Informações da Engine
- Verificação dos componentes
- Leitura automática do Version Core

## ⚙️ Config Manager ##

- Estrutura modular
- Configuração de Boot
- Configuração de Rede
- Configuração de Logs
- Preparação para múltiplos idiomas

## 🌐 Network System ##

- Teste de conexão
- Endereço IP
- Portas
- Base preparada para futuras melhorias

## 📄 Log System ##

- Registro da inicialização
- Registro do Boot
- Registro do encerramento

## 🎮 Interface Terminal ##

- Menu principal
- Navegação por opções
- Interface organizada
- Estrutura modular

---

## 📁 Estrutura do Projeto ##
```md
Pure3XEngine/
├── Config/
├── Core/
│   ├── Boot/
│   ├── Config/
│   ├── Logger/
│   ├── Platform/
│   ├── System/
│   └── Version/
├── Docs/
├── GameModules/
├── include/
├── src/
├── build/
├── CMakeLists.txt
├── README.md
└── LICENSE
```
---

## ⭐ Características ##

- Arquitetura Modular
- C++17
- CMake
- Boot System
- Version Core
- Config Manager
- Network Manager
- Log System
- Interface Terminal
- Estrutura preparada para expansão

---

## ⚙️ Tecnologias ##

- C++
- CMake
- Git
- GitHub
- Termux
- Android NDK (Experimental)

---

## 📚 Documentação ##

Toda a documentação oficial encontra-se na pasta Docs.

- OfficialDocumentation.md
- DevelopmentRoadmap.md
- DevelopmentNotes.md

---

## 🔮 Roadmap ##

🚧 v0.1.4 Alpha Update

- Melhorias no Boot
- Melhorias no Version Core
- Organização do Core
- Correções internas
- Expansão da documentação

## 🚧 v0.1.5 Alpha ##

- GameModules
- Language Manager
- Configurações avançadas
- Melhorias na arquitetura

## 🚀 Futuro ##

- Plugin System
- Graphics Engine
- Audio Engine
- Native Code Execution (NCE)
- Time Manager
- Ferramentas para Desenvolvedores
- Integração completa com Android

---

## 👨‍💻 Autor ##

Lhuis

Projeto desenvolvido para pesquisa, aprendizado e evolução de uma engine experimental escrita em C++.

---

## 📜 Licença ##

Distribuído sob a MIT License.

Você pode estudar, modificar e contribuir com o projeto, respeitando os termos da licença e mantendo os créditos do autor original.

O Pure3XEngine continuará recebendo atualizações frequentes. As versões oficiais serão sempre publicadas neste repositório.
