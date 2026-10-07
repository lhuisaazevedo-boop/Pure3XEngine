# Progresso da análise de firmware PS3 / XMB

**Atualizado em:** 2026-10-07
**Estado geral:** Stage 13 — XMB Discovery / Structural Analysis em andamento; Stage 13.0.3 fechado; próximo: 13.0.4.
**Linha do projeto:** P3XE 0.2.7 Alpha. Observação: o `CMakeLists.txt` raiz ainda declara `VERSION 0.2.6`.

Este painel é o índice de continuidade da análise. Cada stage fechado tem um registro próprio em [`stages/`](stages/), para que os próximos passos possam seguir a evidência sem depender do histórico da conversa.

> **Disponibilidade dos artefatos:** este clone não contém `firmware/spkg_analysis/` nem os manifests mencionados abaixo. Os nomes são referências aos resultados informados e os arquivos correspondentes permanecem apenas localmente; não estão versionados neste repositório. Nenhum conteúdo de firmware foi copiado.

## Stages e manifests

| Stage | Descrição | Status | Manifest |
|---|---|---|---|
| [12.9.2](stages/12.9.2.md) | Cadeia dos três fragmentos ENC → DEC → descomprimido → TAR | OK | Local: `stage_12_9_2_three_fragment_chain_audit.json` |
| [12.9.3](stages/12.9.3.md) | Consistência entre certificação e artefato | OK | Local: `stage_12_9_3_cert_chain_consistency.json` |
| [12.9.4](stages/12.9.4.md) | Auditoria do conteúdo TAR | OK | Local: `stage_12_9_4_tar_content_audit.json` |
| [12.9.5](stages/12.9.5.md) | Inventário mestre dos três fragmentos | OK | Local: `stage_12_9_5_three_fragment_master_inventory.json` |
| [12.9.6](stages/12.9.6.md) | Auditoria da árvore de caminhos | OK | Local: `stage_12_9_6_path_tree_audit.json` |
| [12.9.7](stages/12.9.7.md) | Auditoria de propriedade dos fragmentos | OK | Local: `stage_12_9_7_fragment_ownership_audit.json` |
| [12.9.8](stages/12.9.8.md) | Consolidação de SHA-256 dos conteúdos | OK | Local: `stage_12_9_8_content_hash_consolidation.json` |
| [12.9.9](stages/12.9.9.md) | Fechamento final VSH/dev_flash | OK | Local: `stage_12_9_9_vsh_final_closure.json` |
| [13.0.0](stages/13.0.0.md) | Avaliação estrutural inicial do XMB | OK | Local: `stage_13_0_0_xmb_structure_evaluation.json` |
| [13.0.1](stages/13.0.1.md) | Descoberta de caminhos candidatos a XMB | OK | Local: `stage_13_0_1_xmb_source_discovery.json` |
| [13.0.2](stages/13.0.2.md) | Classificação estrutural dos caminhos XMB | OK | Local: `stage_13_0_2_xmb_path_classification.json` |
| [13.0.3](stages/13.0.3.md) | Descoberta de arquivos XMB | OK / FECHADO | Local: `stage_13_0_3_xmb_file_discovery.json` |
| 13.0.4 | Mapeamento da origem dos fragmentos XMB | PLANEJADO | Ainda não produzido |
| 13.1.x–13.6.x | Árvore VSH/XMB, módulos, recursos, formatos, relações, runtime e consolidação | PLANEJADO | Ainda não produzido |
| 13.6.9 | XMB STRUCTURE CLOSED | PLANEJADO | Ainda não produzido |
| Stage 14 | Engenharia reversa do XMB, somente após 13.6.9 | BLOQUEADO | Ainda não produzido |

O bloco 12.9.2–12.9.9 foi fechado com todos os stages OK e 0 erros.

## Onde estamos agora

O Stage 13.0.3 está fechado: foram analisadas 3 fontes e 26 arquivos; todos os 26 são fontes TrueType. Nenhum arquivo XMB direto foi encontrado e houve 0 erros.

O próximo passo é o **13.0.4 — XMB Fragment Source Mapping**: localizar, entre os fragmentos restantes (dev_flash_003 em diante), qual contém o conteúdo real de `vsh/resource/explore/xmb`, `module`, `theme` e possíveis RCO/XML. Esses fragmentos foram validados estruturalmente, mas ainda não passaram pela cadeia de descriptografia/descompressão.

Depois, os stages 13.1.x a 13.6.x devem mapear árvore VSH/XMB, módulos e recursos, formatos, relações, runtime e consolidação. O Stage 13.6.9 continua planejado; o Stage 14 não começa antes do seu fechamento.

## Limites conhecidos

- `dev_flash_000` contém somente a árvore de diretórios: 70 diretórios e 0 arquivos. Entre os caminhos existentes estão `dev_flash/vsh`, `vsh/module`, `vsh/resource`, `vsh/resource/explore/xmb`, `vsh/resource/theme`, `vsh/resource/silk`, `vsh/resource/sysconf`, `pspemu`, `ps1emu` e `ps2emu`.
- `dev_flash_001` e `dev_flash_002` contêm somente fontes TTF em `data/font/`: 14 e 12 arquivos, respectivamente.
- Até agora, nenhum arquivo XMB real (RCO, XML ou módulo) foi recuperado. `vsh/resource/explore/xmb` existe como estrutura de diretórios, sem conteúdo.
- O `structure_state` atual do XMB é **PARTIAL**. Os dados atuais não demonstram estrutura XMB completa nem runtime mapeado.
- O futuro P3XE Firmware Mount deverá manter `firmware/dev_flash/.p3xe_status.json` como `PARTIAL`, sem preencher conteúdo ausente.

## Regras do projeto

1. Firmware original → evidência recuperada → manifest → análise → estrutura XMB real → só então engenharia reversa.
2. Não criar arquivos sintéticos nem inferir conteúdo a partir de diretórios vazios ou nomes de caminhos.
3. Preservar manifests e FAILs históricos; correções e novas descobertas não apagam evidência anterior.
4. Começar o Stage 14 somente após o fechamento do Stage 13.6.9.
