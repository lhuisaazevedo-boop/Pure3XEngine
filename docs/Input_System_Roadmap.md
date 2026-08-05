# 🎮 Pure3XEngine
## Input System Roadmap
### Version 0.1.8 Alpha

---

# Introdução

O Pure3XEngine iniciou oficialmente a implementação do novo sistema de entrada (Input System), responsável pela comunicação entre o emulador e os controles físicos.

Esta nova arquitetura foi projetada para ser modular, portátil e escalável, permitindo suporte a diversos tipos de gamepads durante a evolução do projeto.

O objetivo não é apenas suportar o DualShock 3, mas criar uma camada universal de entrada capaz de funcionar em Android, Linux e futuras plataformas.

---

# Objetivos

O novo sistema deverá oferecer:

- Arquitetura modular
- Reconhecimento automático de controles
- Mapeamento configurável
- API unificada
- Baixa latência
- Fácil expansão

---

# Estrutura Atual

```
InputManager
│
├── DualShock3
├── InputState
├── ButtonMap
```

---

# Componentes

## InputManager

Responsável por controlar todos os dispositivos conectados.

Funções:

- Inicialização
- Atualização
- Gerenciamento de dispositivos
- Comunicação com o Emulator Core

---

## DualShock3

Primeira implementação oficial.

Responsabilidades:

- Inicialização
- Leitura dos botões
- Analógicos
- Estado do controle

---

## InputState

Armazena o estado atual do controle.

Informações:

- Botões pressionados
- Analógicos
- Triggers
- D-Pad

---

## ButtonMap

Camada responsável pelo mapeamento dos botões.

Atualmente implementa:

### Face Buttons

- Cross
- Circle
- Square
- Triangle

### D-Pad

- Up
- Down
- Left
- Right

### Shoulder

- L1
- R1
- L2
- R2

### Analógicos

- L3
- R3

### Sistema

- Start
- Select
- PS Button

---

# Arquitetura Planejada

```
InputManager
│
├── DualShock3
├── DualShock4
├── DualSense
├── XboxController
├── Generic HID
├── Android Gamepad API
└── Future Controllers
```

---

# Recursos Planejados

## Hot Plug

Conectar e remover controles sem reiniciar o emulador.

---

## Múltiplos Controles

Suporte para:

Player 1

Player 2

Player 3

Player 4

---

## Vibração

Planejamento para:

- DualShock 3
- DualShock 4
- DualSense
- Xbox Controller

---

## Sensores

Suporte futuro para:

- Acelerômetro
- Giroscópio
- Motion Sensors

---

## Configuração

Planejamento de interface para:

- Remapear botões
- Sensibilidade
- Dead Zone
- Perfil personalizado

---

# Compatibilidade Planejada

## PlayStation

✅ DualShock 3

🔄 DualShock 4

🔄 DualSense

---

## Xbox

🔄 Xbox 360

🔄 Xbox One

🔄 Xbox Series

---

## Android

🔄 Bluetooth Controllers

🔄 USB OTG

🔄 HID

---

## Linux

🔄 SDL

🔄 evdev

---

# Integração

O sistema será conectado futuramente ao:

- Emulator Core
- RSX
- UI
- Config Manager
- Save System

---

# Roadmap

## v0.1.8 Alpha

✅ InputManager

✅ DualShock3

✅ InputState

✅ ButtonMap

---

## Próximas versões

- DualShock4
- DualSense
- Generic HID
- Hot Plug
- Vibração
- Configuração
- Analógicos completos
- Android Input Backend

---

# Filosofia

O sistema foi desenvolvido para ser modular.

Novos controles poderão ser adicionados sem alterar o núcleo do emulador.

Isso reduz manutenção, facilita testes e melhora a escalabilidade do projeto.

---

# Status

Projeto em desenvolvimento.

Versão:

Pure3XEngine v0.1.8 Alpha

---

© Pure3XEngine Project

Experimental PlayStation 3 Engine for Android

Built from scratch using C++20.
