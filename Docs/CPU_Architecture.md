# 🧠 Pure3XEngine - CPU Architecture

## Status

Planejado para a versão v0.1.6 Alpha.

---

# Pipeline de Execução

O carregamento e execução das instruções seguirão uma arquitetura modular.

```
ELF Loader
      │
      ▼
Instruction Cache
      │
      ▼
FIFO Buffer
      │
      ▼
Instruction Decoder
      │
      ▼
PPU Execution
```

---

# Gerenciamento de Memória

```
Memory Manager
      │
      ▼
Cache L1
      │
      ▼
FIFO de Acesso
      │
      ▼
RAM Emulada
```

---

# Scheduler

Será criado um novo módulo responsável pelo agendamento das instruções.

```
core/
└── scheduler/
    ├── FIFOQueue.h
    ├── FIFOQueue.cpp
    ├── InstructionScheduler.h
    └── InstructionScheduler.cpp
```

---

# Objetivos

- Implementar FIFO para organização das instruções.
- Criar Cache de Instruções.
- Implementar Decoder PowerPC.
- Desenvolver o Scheduler da CPU.
- Integrar o Memory Manager.
- Preparar a execução do PPE (Power Processing Element).
- Base para futura implementação das SPUs.

---

# Roadmap v0.1.6 Alpha

- [ ] Instruction Cache
- [ ] FIFO Buffer
- [ ] Instruction Scheduler
- [ ] PowerPC Decoder
- [ ] PPE Core
- [ ] Cache L1
- [ ] Memory Access FIFO
- [ ] Integração com ELF Loader

---

## Observação

A implementação será baseada no estudo da arquitetura do Cell Broadband Engine, priorizando uma estrutura modular e organizada para facilitar futuras otimizações.
