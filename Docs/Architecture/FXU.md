# Fixed-Point Integer Unit (FXU)

## Status

🚧 Planejado para a v0.1.6 Alpha

---

# O que é a FXU?

A Fixed-Point Integer Unit (FXU) é a unidade da PPU responsável pela execução de operações com números inteiros.

No processador Cell Broadband Engine, a FXU é utilizada para processar grande parte da lógica do sistema operacional e dos jogos.

---

# Responsabilidades

- Soma
- Subtração
- Multiplicação inteira
- Divisão inteira
- Operações lógicas
- Rotação de bits
- Comparações
- Manipulação de registradores

---

# Pipeline

ELF Loader
↓
Instruction Cache
↓
FIFO Buffer
↓
Instruction Decoder
↓
FXU
↓
Memory Manager
↓
RAM Emulada

---

# Integração com o Pure3XEngine

Estrutura planejada:

```text
core/
└── ppu/
    ├── FXU.h
    └── FXU.cpp
```

---

# Objetivos

- Executar instruções inteiras da PPU.
- Melhorar a eficiência do pipeline.
- Integrar com o FIFO Scheduler.
- Trabalhar em conjunto com o Memory Manager.
- Preparar a Engine para execução nativa da arquitetura Cell.

---

# Roadmap

## v0.1.6 Alpha

- Estrutura inicial da FXU.
- Interface da unidade.
- Planejamento das instruções.

## Futuro

- Implementação completa das operações inteiras.
- Integração com o Scheduler.
- Otimizações de desempenho.
- Execução paralela da PPU.
