## Arquitetura da Engine ##

## Estrutura Atual ##
```text
Pure3XEngine/
├── Core/
├── Config/
├── Docs/
├── GameModules/
├── include/
├── src/
│   └── main.cpp
└── CMakeLists.txt
```
---

## Estrutura Planejada ##
```text
Pure3XEngine/
├── src/
│   ├── main.cpp        # Entrada da Engine
│   ├── Games.cpp       # Gerenciamento dos jogos (futuro)
│   ├── Games.h
│   ├── Emulator.cpp    # Núcleo da emulação (futuro)
│   └── Emulator.h
│
├── Core/
├── Config/
├── Docs/
├── GameModules/
├── include/
└── CMakeLists.txt
```
---

## Objetivo ##

- Separar a Engine da lógica de emulação.
- Criar um gerenciador de jogos (`Games`).
- Implementar o núcleo de emulação (`Emulator`).
- Facilitar a expansão para novos módulos.
- Manter uma arquitetura modular e organizada.
