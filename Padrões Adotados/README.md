# Padrões Adotados

Índice dos padrões seguidos no projeto. **Todo o conteúdo já existe** nos documentos de referência — esta pasta o organiza e aponta onde cada padrão vive (nada é duplicado).

## Especificação e verificação de requisitos (tarefa #5 / #16)

| Padrão | Onde está |
|---|---|
| Organização e nomenclatura: `RF-<módulo>-NN`, `RNF-NN`, `RN-NN`, `CA-NN`; todo requisito iniciado por verbo no infinitivo; prioridade E/I/D; atores e rastreabilidade às regras de negócio (norma ISO/IEC/IEEE 29148) | *Levantamento de Requisitos*, caps. 1, 3, 5–8 e 11 |
| Regras de negócio RN01–RN15 citadas por cada requisito funcional | *Levantamento de Requisitos*, cap. 5 |
| Critérios de aceitação objetivos (dado–quando–então, CA-01–CA-10) | *Levantamento de Requisitos*, cap. 11 |
| Rastreabilidade decisão ↔ requisito ↔ qualidade (registro D## / Q##) | *Levantamento de Requisitos*, cap. 3; *Design*, cap. 2.3 |

## Engenharia e código

| Padrão | Onde está |
|---|---|
| Convenções da API REST (recursos, verbos, códigos, RFC 9457, paginação) | *Levantamento de Requisitos*, cap. 10; *Design*, cap. 4.2 |
| Conventional Commits `tipo(escopo): descrição (RF-xxx-NN)`, política de ramos e proteções | *Design*, cap. 3 |
| Arquitetura em camadas e regras ArchUnit (A1–A6) | *Design*, cap. 5.2 |
| Banco de dados: migrações versionadas e imutáveis (Flyway) | *Design*, cap. 6 |
