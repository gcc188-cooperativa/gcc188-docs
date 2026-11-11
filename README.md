# Cooperativa de Transportes — Sistema de Gestão

Sistema web de apoio à gestão financeira de uma **cooperativa de transportes**: API REST, interface web (SPA) e ambiente executável em contêineres. Projeto da disciplina GCC188 (UFLA, 2026-2).

> **Este é o repositório âncora do projeto.** O código vive em quatro repositórios desta organização (ver [Estrutura de pastas](#5-estrutura-de-pastas)); aqui ficam o documento de requisitos, o design e o protótipo de interfaces.

## 1. Contexto do problema e da solução

A cooperativa reúne motoristas autônomos (**cooperandos**) que prestam serviços de transporte a **clientes**. O contrato é firmado **entre o cliente e o cooperando**; a cooperativa não é parte dele, mas **intermedeia o fluxo financeiro**: recebe o pagamento do cliente, retém a **taxa** (percentual ou fixa, definida por contrato) e repassa o **valor líquido** ao cooperando. Contratos, aprovações, cronogramas de pagamento, baixas, repasses, despesas e relatórios eram controlados manualmente.

O sistema atende quatro perfis (administrador, financeiro, motorista/cooperando e cliente) e oferece:

- **Autenticação** por e-mail e senha, sessão por _cookie_ e autorização por papel (RF-AUT-01 a 03);
- **CRUD de usuários** — operação sobre uma tabela (RF-USR-01 a 04);
- **Cadastro de cooperandos e clientes**, cada um com seu usuário de acesso vinculado em transação única (RF-COO-01 a 04; RF-CLI-01 a 04);
- **Contratos** com ciclo de aprovação (RASCUNHO → PENDENTE_APROVACAO → ATIVO → ENCERRADO/CANCELADO) e geração automática do cronograma — operação sobre quatro tabelas relacionadas (RF-CTR-01 a 10);
- **Pagamentos** com baixa, repasse e estorno (RF-PAG-01 a 05);
- **Despesas** da cooperativa e dos cooperandos, com totalização (RF-DSP-01 a 05);
- **Relatórios**: extrato do cooperando, resumo financeiro, inadimplência e painéis por perfil (RF-REL-01 a 04);
- **Interface web** por perfil (RF-WEB-01 a 11) — protótipo navegável em https://gcc188-cooperativa.github.io/gcc188-docs/.

A lista completa (≈50 RF, 21 RNF e 15 regras de negócio) está no [documento de requisitos](Requisitos/Levantamento%20de%20Requisitos.pdf).

## 2. Instruções para uso

### Sistema completo (recomendado)

Requisitos: Docker com Compose ≥ 2.24 e `openssl`.

```bash
git clone https://github.com/gcc188-cooperativa/gcc188-infra.git
cd gcc188-infra
scripts/up.sh dev        # gera .env, secrets/ e certificado local e sobe tudo
# Acesse https://localhost:8443
cat secrets/app.bootstrap.admin.email secrets/app.bootstrap.admin.password   # admin inicial (troca obrigatória no 1º acesso)
```

Para encerrar: `scripts/down.sh dev` (preserva os dados) ou `scripts/reset-dev.sh` (destrutivo). Detalhes no [runbook](https://github.com/gcc188-cooperativa/gcc188-infra/blob/master/docs/runbook.md).

### Apenas a API, em desenvolvimento

```bash
git clone https://github.com/gcc188-cooperativa/gcc188-backend.git && cd gcc188-backend
docker run -d --name pg -e POSTGRES_DB=cooperativa -e POSTGRES_USER=cooperativa \
  -e POSTGRES_PASSWORD=cooperativa -p 5432:5432 postgres:17
SPRING_PROFILES_ACTIVE=dev ./gradlew bootRun
```

### Mock da API (sem backend e sem banco)

```bash
git clone https://github.com/gcc188-cooperativa/gcc188-api-contract.git && cd gcc188-api-contract
npm ci && npm run mock     # Prism em http://127.0.0.1:4010
```

## 3. Instruções para devs

| Repositório | Preparo | Verificações | Execução |
|---|---|---|---|
| `gcc188-api-contract` | `npm ci` (instala os ganchos lefthook) | `npm run lint` (Spectral + Redocly + Prettier), `npm run mock:smoke` | `npm run mock` (Prism) |
| `gcc188-backend` | `npm ci` | `./gradlew test` (Testcontainers: exige Docker) | `SPRING_PROFILES_ACTIVE=dev ./gradlew bootRun` |
| `gcc188-front` | reservado para a próxima sprint | — | `npm run dev:mock` (MSW) |
| `gcc188-infra` | `npm ci` | `yamllint`, `shellcheck`, `hadolint` (nos ganchos) | `scripts/up.sh dev` |
| `gcc188-docs` | Typst para recompilar os PDFs | — | — |

**Padrões de contribuição:** _Conventional Commits_ com o módulo como escopo e o requisito entre parênteses — ex.: `feat(contratos): aprovar contrato e gerar pagamentos (RF-CTR-04)`. _Commit_ e _push_ são verificados por ganchos lefthook (lint e commitlint) e pelo CI. Política de ramos e proteções: [Design, cap. 3](Design/Design.pdf).

## 4. Tecnologias

- **backend:** Java 25 (LTS); Spring Boot 4.0 (Spring Framework 7, Jakarta EE 11, Jackson 3); Gradle 9.1 (Kotlin DSL); Spring Data JPA / Hibernate ORM; Flyway (migrações versionadas); Spring Security 7 + Nimbus JOSE (JWT); Jakarta Bean Validation; Testcontainers 2 (testes de integração com PostgreSQL).
- **banco de dados:** PostgreSQL 18 (relacional).
- **frontend:** TypeScript (modo estrito); React 19.2; Mantine 9; Vite; React Router; TanStack Query; React Hook Form + Zod; Orval; MSW; Vitest + Testing Library (`gcc188-front` reservado para a próxima sprint).
- **outras:** Docker Engine + Compose 2.24 (execução reproduzível do sistema completo); Caddy 2.10 (proxy reverso com TLS); Redocly CLI 1.25 (bundle do contrato); Spectral 6.13 (lint do contrato); Prism 5.12 (mock do contrato); Playwright (testes ponta a ponta); k6 (teste de desempenho); Loki + Alloy + Grafana (observabilidade opcional); release-please (versionamento semântico e changelog); Typst (documentação em padrão ABNT).

## 5. Estrutura de pastas

O projeto é uma organização com cinco repositórios (decisão D03/Δ01 do Design):

```text
github.com/gcc188-cooperativa/
├── gcc188-docs/           # ← ESTE REPOSITÓRIO (âncora)
│   ├── README.md
│   ├── Requisitos/         # documento de requisitos (Typst + PDF) e protótipo de telas
│   ├── Design/             # documento de design (Typst + PDF)
│   └── Padrões Adotados/   # índice dos padrões seguidos no projeto
├── gcc188-api-contract/    # contrato OpenAPI 3.1 da API (fonte de verdade; gera pacotes Java/npm)
├── gcc188-backend/         # API REST (Java 25 + Spring Boot 4), migrações e testes
├── gcc188-front/           # interface web (React) — reservado
└── gcc188-infra/           # Docker Compose, Caddy, backup, e2e, observabilidade
```

## 6. Equipe

- [Arthur Valadares Campideli](https://github.com/ArthurValadaresUFLA)
- Júlia Ribeiro Souza

## 7. Desvios de ferramenta (declarados)

| Exigência da planilha | Ferramenta usada | Justificativa |
|---|---|---|
| Diagramas no Astah UML (#11) | Typst + fletcher (mesmos diagramas UML) | diagramas versionáveis em texto, integrados ao documento ABNT; fontes em `Requisitos/` |
| Protótipo no Figma (#10) | HTML próprio por perfil + https://gcc188-cooperativa.github.io/gcc188-docs/ | protótipo navegável real, com as mesmas telas do mapa de navegação do documento |
| Um repositório (#1) | Organização com 5 repositórios (Design, Δ01/D03) | ciclos de vida distintos por componente; este repo âncora concentra o que a disciplina verifica |

## 8. Requisitos não funcionais

Os 21 RNF estão no capítulo 7 do documento de requisitos — mensuráveis e com forma de verificação (ex.: RNF-10 listagens p95 ≤ 500 ms com até 10 mil registros; RNF-11 cobertura ≥ 70% da camada de serviço; RNF-16 interface nas duas versões mais recentes de Chrome, Firefox, Edge e Safari).
