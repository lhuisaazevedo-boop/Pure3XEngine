Game Library - Planejamento

Objetivo

Implementar uma biblioteca de jogos para o Pure3XEngine quando a Engine estiver madura.

A biblioteca será responsável por localizar, organizar e exibir todos os jogos instalados pelo usuário.

---

##Estrutura Planejada
```
core/
└── gamelist/
    ├── GameList.cpp
    ├── GameList.h
    ├── GameScanner.cpp
    ├── GameScanner.h
    ├── GameDatabase.cpp
    └── GameDatabase.h
```
---

Responsabilidades

GameList

- Exibir lista de jogos.
- Ordenar por nome.
- Ordenar por último jogado.
- Favoritos.
- Pesquisa.

GameScanner

- Procurar jogos automaticamente.
- Detectar PS3_GAME.
- Detectar PARAM.SFO.
- Detectar EBOOT.BIN.
- Atualizar biblioteca.

GameDatabase

Salvar informações dos jogos:

- Nome
- ID
- Região
- Firmware
- Caminho
- Última execução
- Tempo de jogo
- Favorito

---

Interface Planejada

Biblioteca de Jogos

▶ God of War III
▶ Gran Turismo 6
▶ The Last of Us
▶ Persona 5
▶ Demon's Souls

Total: 5 jogos

---

Integração

Quando implementado, poderá substituir a opção "Iniciar Engine" por uma biblioteca completa de jogos.

Exemplo:

1 - Biblioteca de Jogos
2 - Iniciar Engine
3 - Status do Sistema
4 - Configurações
5 - Rede
6 - Sobre
7 - Sair

---

Roadmap

v0.2.x

- Estrutura inicial da biblioteca.

v0.3.x

- Scanner automático.
- Leitura do PARAM.SFO.

v0.4.x

- Capas dos jogos.
- Busca.
- Favoritos.

v0.5.x

- Biblioteca semelhante ao XMB do PlayStation 3.

---

Observação

Este recurso será implementado somente após a conclusão da base principal da Engine (PPU, SPU, Syscalls, RSX, JIT e Emulator Core).

Prioridade atual: desenvolvimento do núcleo do Pure3XEngine.
