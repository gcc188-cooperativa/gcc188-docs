#import "@local/abntyp-ufla:0.1.0": *

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

// ───────────────────────── Dados do documento (preencher) ─────────────────────────
#let titulo-doc = "Especificação de Requisitos de Software"
#let subtitulo-doc = "API REST e interface web para controle de contratos, pagamentos, cooperandos e despesas de uma cooperativa de transportes"
#let projeto-doc = "Projeto de disciplina: API REST e interface web para cooperativa de transportes"
#let instituicao-doc = "Universidade Federal de Lavras"
#let autores-doc = ((name: "Arthur Valadares Campideli", qualification: "Discente"),
(name: "Júlia Ribeiro Souza", qualification: "Discente"),)
#let local-doc = "Lavras"
#let ano-doc = 2026

// ───────────────────────── Formatação ABNT (NBR 10719, 14724, 6024, 6027, 6028) ─────────────────────────
// O modelo `relatorio` aplica: A4; margens 3/2/3/2 cm; Times New Roman 12; entrelinhas 1,5;
// recuo de 1,25 cm; títulos numerados (primários em caixa-alta e negrito).
#show: relatorio.with(
  titulo: titulo-doc,
  subtitulo: subtitulo-doc,
  titulo-projeto: projeto-doc,
  instituicao: instituicao-doc,
  autores: autores-doc,
  local: local-doc,
  ano: ano-doc,
  fonte: "Times New Roman",
)

// Ajustes complementares de ilustrações e tabelas (NBR 14724 e IBGE)
#set figure.caption(position: top, separator: [ – ])
#show figure.caption: set text(size: 10pt)
#show figure.where(kind: table): set figure(supplement: [Quadro]) // conteúdo textual = quadro
#show figure.where(kind: table): set block(breakable: true)
#show figure: it => {
  it
  align(center, text(size: 10pt)[Fonte: Elaborado pelos autores.])
  v(0.8em)
}
#show heading: it => if it.level == 1 { it } else { block(sticky: true, it) } // subtítulo não fica sozinho no fim da página
#show raw: set text(size: 10pt)
#show table: set par(first-line-indent: 0pt, leading: 0.55em, justify: false)
#show table: it => { show raw: set text(size: 8.5pt); it }
#set table(stroke: 0.4pt + luma(130), inset: 5pt, align: left)
#set list(spacing: 0.9em)

#let soft = luma(232)
#let ink = luma(20)
#let accent = rgb("#1f4e79")
#let nstyle = (node-stroke: 0.6pt, edge-stroke: 0.6pt, node-inset: 5pt)
// Diagrama padrão: fonte reduzida. Obs.: `spacing` do fletcher é o vão entre células.
#let dg(..args) = {
  show raw: set text(size: 7pt)
  set par(justify: false, first-line-indent: 0pt, leading: 0.55em)
  text(size: 8pt, hyphenate: false, diagram(..nstyle, ..args))
}
#let head-fill = (_, y) => if y == 0 { soft }
#let tt(body) = text(size: 9pt, body)

// Tabela de requisitos: (id, descrição, prioridade, atores, regras)
#let rf(id, desc, prio, ator, rn) = (raw(id), desc, prio, ator, rn)
#let reqs(..rows) = {
  set text(size: 9pt)
  table(
    columns: (auto, 1fr, auto, auto, auto),
    align: (left, left, center, left, left),
    fill: head-fill,
    table.header[*ID*][*Requisito*][*Prio.*][*Ator(es)*][*Regras*],
    ..rows.pos().flatten(),
  )
}

// ───────────────────────── Elementos pré-textuais ─────────────────────────
#report-cover(
  // a logo entra acima do nome da instituição
  instituicao: [#logo-ufla(largura: 4cm) \ #v(0.4cm) #instituicao-doc],
  titulo: titulo-doc,
  subtitulo: subtitulo-doc,
  ano: ano-doc,
)
#report-title-page(
  instituicao: instituicao-doc,
  titulo-projeto: projeto-doc,
  titulo: titulo-doc,
  subtitulo: subtitulo-doc,
  autores: autores-doc,
  local: local-doc,
  ano: ano-doc,
)

#resumo-relatorio(
  palavras-chave: ("Engenharia de requisitos", "API REST", "Interface web", "Cooperativa de transportes", "Contratos", "Git Flow"),
)[
  Este relatório formaliza os requisitos de um sistema composto por uma API REST e uma interface web para apoiar a gestão de uma cooperativa de transportes, cujo contrato de prestação de serviço é firmado entre cliente e cooperando, cabendo à cooperativa intermediar a cobrança, reter uma taxa configurável por contrato e repassar o valor líquido ao cooperando. O levantamento foi conduzido por entrevistas estruturadas com perguntas de múltipla escolha, em três rodadas, e resultou em regras de negócio, requisitos funcionais e não funcionais, casos de uso, modelo de dados com seis tabelas, contrato de recursos da API, requisitos da interface web, matriz de permissões por perfil (administrador, financeiro, motorista e cliente) e critérios de aceitação. O desenvolvimento adota o modelo em cascata, com controle de versão segundo o Git Flow. O documento serve de referência única para projeto, implementação e testes, atendendo às exigências acadêmicas de um CRUD de uma tabela e de CRUDs que relacionam ao menos três tabelas.
]

#lista-ilustracoes()

#align(center, text(weight: "bold", size: 12pt)[LISTA DE QUADROS])
#v(1.5em)
#outline(title: none, target: figure.where(kind: table))
#pagebreak()

#lista-siglas((
  "ABNT": "Associação Brasileira de Normas Técnicas",
  "API": "Application Programming Interface",
  "CORS": "Cross-Origin Resource Sharing",
  "CRUD": "Create, Read, Update, Delete",
  "DER": "Diagrama Entidade-Relacionamento",
  "HTTP": "Hypertext Transfer Protocol",
  "JSON": "JavaScript Object Notation",
  "RBAC": "Role-Based Access Control",
  "REST": "Representational State Transfer",
  "RF": "Requisito Funcional",
  "RN": "Regra de Negócio",
  "RNF": "Requisito Não Funcional",
  "SPA": "Single-Page Application",
  "SQL": "Structured Query Language",
  "UC": "Caso de Uso (Use Case)",
))

// Sumário (NBR 6027): indicativos numéricos, seções primárias em caixa-alta e negrito.
// Definido aqui porque o `sumario()` do pacote omite a numeração nas versões recentes do Typst.
#let sumario-abnt() = {
  align(center, text(weight: "bold", size: 12pt)[SUMÁRIO])
  v(1.5em)
  set par(first-line-indent: 0pt, justify: false, leading: 0.65em)
  show outline.entry: it => {
    let lvl = it.level
    let pref = if it.prefix() != none { [#it.prefix()#h(0.6em)] } else { [] }
    let txt = [#pref#it.body()]
    let shown = if lvl == 1 { text(weight: "bold", upper(txt)) }
      else if lvl == 2 { upper(txt) }
      else if lvl == 3 { text(weight: "bold", txt) }
      else { txt }
    if lvl == 1 { v(0.5em) }
    block(link(it.element.location(), [#h((lvl - 1) * 1em)#shown#box(width: 1fr, it.fill)#it.page()]))
  }
  outline(title: none, depth: 3, indent: 0pt)
  pagebreak()
}
#sumario-abnt()

// Numeração arábica a partir da introdução (NBR 14724)
#counter(page).update(1)
#set page(numbering: "1", number-align: top + right)

// ───────────────────────── 1. Introdução ─────────────────────────
= Introdução

== Propósito e escopo
Este documento formaliza os requisitos do sistema de apoio à gestão de uma cooperativa de transportes, composto por uma *API REST* e por uma *interface web* que a consome, desenvolvido como projeto da disciplina de banco de dados/desenvolvimento de APIs. Ele é a referência única para projeto, implementação e testes (modelo em cascata, @sec-processo) e é o artefato de saída da fase de levantamento. A organização dos requisitos segue as recomendações de engenharia de requisitos da norma ISO/IEC/IEEE 29148 (ISO/IEC/IEEE, 2018).

O sistema cobre: cadastro e controle de acesso de usuários; cadastro de cooperandos e clientes; contratos entre cliente e cooperando com ciclo de aprovação; pagamentos programados com baixa e repasse manuais; despesas da cooperativa e dos cooperandos; e consultas/relatórios financeiros. A interface web oferece a cada perfil as telas de acesso a essas funções.

== Minimundo
A cooperativa reúne motoristas autônomos (*cooperandos*) que prestam serviços de transporte a *clientes*. O contrato de prestação é firmado *entre o cliente e o cooperando*; a cooperativa não é parte do contrato, mas intermedeia o fluxo financeiro: recebe o pagamento do cliente, retém a *taxa da cooperativa* e repassa o *valor líquido* ao cooperando. A taxa é definida por contrato, em percentual ou em valor fixo.

A cooperativa *não administra os veículos* dos cooperandos; portanto, veículos não são modelados. Quatro perfis interagem com o sistema: administrador da cooperativa, financeiro, motorista (cooperando) e cliente (somente consulta).

== Fora de escopo
- Cadastro e gestão de veículos, manutenção ou rotas.
- Integração com meios de pagamento, bancos ou emissão fiscal: toda baixa e todo repasse são registrados manualmente.
- Aplicativo móvel nativo e projeto visual (identidade visual, protótipos de alta fidelidade); a interface web é especificada por requisitos funcionais e de qualidade, não por padrão estético.
- Abatimento automático de despesas do cooperando no repasse (despesas são informativas, ver RN09).

== Glossário
#figure(
  table(
    columns: (auto, 1fr),
    fill: head-fill,
    table.header[*Termo*][*Definição*],
    [Cooperativa], [Entidade que intermedeia cobrança e coleta de taxa; é o "dono" do sistema.],
    [Cooperando], [Motorista associado; prestador do serviço e parte do contrato.],
    [Cliente], [Contratante do serviço de transporte; parte do contrato.],
    [Contrato], [Acordo entre um cliente e um cooperando, com valor, modalidade de pagamento e taxa.],
    [Taxa], [Valor retido pela cooperativa; percentual sobre o pagamento ou valor fixo por pagamento.],
    [Baixa], [Registro manual de que o cliente pagou uma parcela à cooperativa.],
    [Repasse], [Registro manual de que a cooperativa transferiu o valor líquido ao cooperando.],
    [Valor bruto / líquido], [Bruto: valor cobrado do cliente. Líquido: bruto menos a taxa.],
    [RBAC], [_Role-Based Access Control_: autorização por papel do usuário.],
    [Interface web], [Aplicação executada no navegador (SPA) que consome a API e apresenta as funções a cada perfil.],
  ),
  caption: [Glossário do domínio.],
)

// ───────────────────────── 2. Processo ─────────────────────────
= Processo de desenvolvimento <sec-processo>

== Modelo em cascata
Adota-se o modelo *cascata* (_waterfall_) com fases bem definidas e marcos de aprovação ao fim de cada uma. Como o escopo é pequeno, estável e acadêmico, as fases são sequenciais; admite-se retorno controlado à fase anterior quando uma inconsistência é detectada (realimentação de Royce) (ROYCE, 1970; PRESSMAN; MAXIM, 2016), sempre registrando a mudança neste documento.

#figure(
  dg(
    spacing: (0.35cm, 0.5cm),
    node((0,0), [*1. Requisitos*\ levantamento e\ especificação], name: <f1>, width: 2.9cm),
    node((1,1), [*2. Projeto*\ DER, arquitetura,\ contrato da API], name: <f2>, width: 2.9cm),
    node((2,2), [*3. Implementação*\ código em\ _feature branches_], name: <f3>, width: 2.9cm),
    node((3,3), [*4. Verificação*\ testes e\ homologação], name: <f4>, width: 2.9cm),
    node((4,4), [*5. Entrega*\ _release_, tag e\ documentação], name: <f5>, width: 2.9cm),
    edge(<f1>, (0,1), <f2>, "-|>"),
    edge(<f2>, (1,2), <f3>, "-|>"),
    edge(<f3>, (2,3), <f4>, "-|>"),
    edge(<f4>, (3,4), <f5>, "-|>"),
    edge(<f2>, (1,0), <f1>, "--|>", stroke: 0.5pt + luma(110)),
    edge(<f3>, (2,1), <f2>, "--|>", stroke: 0.5pt + luma(110)),
    edge(<f4>, (3,2), <f3>, "--|>", stroke: 0.5pt + luma(110)),
    edge(<f5>, (4,3), <f4>, "--|>", stroke: 0.5pt + luma(110)),
  ),
  caption: [Modelo em cascata; setas tracejadas indicam realimentação para a fase anterior.],
)

#figure(
  table(
    columns: (auto, 1fr, 1fr, 1fr),
    fill: head-fill,
    align: left,
    table.header[*Fase*][*Artefatos de saída*][*Onde vive no Git*][*Critério de saída (marco)*],
    [1\. Requisitos], [Este documento; glossário; regras de negócio; casos de uso.], [`docs/` em `develop` (PR revisado).], [Documento aprovado pelo stakeholder.],
    [2\. Projeto], [DER e dicionário de dados; arquitetura em camadas; esboço OpenAPI; matriz de permissões.], [`docs/` e `openapi.yaml` em `develop`.], [Modelo e contrato da API revisados.],
    [3\. Implementação], [Código-fonte da API e da interface web, _migrations_, testes unitários.], [`feature/*` mesclado em `develop`.], [Todos os RF essenciais implementados.],
    [4\. Verificação], [Testes de integração por endpoint; correções.], [`release/x.y.z` a partir de `develop`.], [Critérios de aceitação cumpridos.],
    [5\. Entrega], [Versão estável, _tag_ semântica, README e coleção de requisições.], [Merge em `main` + tag `vX.Y.Z`.], [Entrega e demonstração.],
  ),
  caption: [Fases, artefatos e relação com o controle de versão.],
)

== Fluxo de ramificação (Git Flow)
O Git Flow (DRIESSEN, 2010) organiza o trabalho em ramos de vida longa (`main`, `develop`) e de vida curta (`feature/*`, `release/*`, `hotfix/*`). Cada ramo `feature` implementa um ou mais requisitos rastreáveis (ID do RF no nome do ramo).

#let lane(y, label) = node((-1, y), text(size: 7.5pt, weight: "bold")[#label], stroke: none, inset: 0pt)
#let cm(pos, name) = node(pos, [], name: name, shape: circle, radius: 3.4pt, inset: 0pt, fill: ink, stroke: none)
#let tag(pos, name, label) = node(pos, text(size: 6.5pt)[#label], name: name, shape: fletcher.shapes.pill, inset: 3pt, fill: white)
#let ln = 1.1pt
#let br = 0.6pt

#figure(
  dg(
    spacing: (0.8cm, 0.45cm),
    lane(0, [main]), lane(1, [hotfix/\*]), lane(2, [release/1.0.0]),
    lane(3, [develop]), lane(4, [feature/\ usuarios]), lane(5, [feature/\ contratos]),
    // main
    cm((0,0), <m0>), tag((10,0), <m1>, [v1.0.0]), tag((12,0), <m2>, [v1.0.1]),
    edge(<m0>, <m1>, "-", stroke: ln), edge(<m1>, <m2>, "-", stroke: ln),
    // develop
    cm((0,3), <d0>), cm((3,3), <d1>), cm((6,3), <d2>), cm((10,3), <d3>), cm((12,3), <d4>),
    edge(<d0>, <d1>, "-", stroke: ln), edge(<d1>, <d2>, "-", stroke: ln),
    edge(<d2>, <d3>, "-", stroke: ln), edge(<d3>, <d4>, "-", stroke: ln),
    // feature usuarios
    cm((1,4), <fa0>), cm((2,4), <fa1>),
    edge(<fa0>, <fa1>, "-", stroke: ln),
    edge(<d0>, <fa0>, "-|>", stroke: br), edge(<fa1>, <d1>, "-|>", stroke: br),
    // feature contratos
    cm((4,5), <fb0>), cm((5,5), <fb1>),
    edge(<fb0>, <fb1>, "-", stroke: ln),
    edge(<d1>, <fb0>, "-|>", stroke: br), edge(<fb1>, <d2>, "-|>", stroke: br),
    // release
    cm((7,2), <r0>), cm((9,2), <r1>),
    edge(<r0>, <r1>, "-", stroke: ln),
    edge(<d2>, <r0>, "-|>", stroke: br),
    edge(<r1>, <m1>, "-|>", stroke: br), edge(<r1>, <d3>, "-|>", stroke: br),
    // hotfix
    cm((11,1), <h0>),
    edge(<m1>, <h0>, "-|>", stroke: br),
    edge(<h0>, <m2>, "-|>", stroke: br), edge(<h0>, <d4>, "-|>", stroke: br),
  ),
  caption: [Git Flow aplicado ao projeto: ramos, ciclo de _release_ e _hotfix_ (setas = criação de ramo ou _merge_).],
)

#figure(
  table(
    columns: (auto, auto, auto, 1fr),
    fill: head-fill, align: left,
    table.header[*Ramo*][*Origem → Destino*][*Nome*][*Regras*],
    [`feature`], [`develop` → `develop`], [`feature/RF-CTR-04`], [Um ramo por requisito (ou grupo coeso). Merge via _pull request_ com `--no-ff` e revisão de outro membro.],
    [`release`], [`develop` → `main` e `develop`], [`release/1.0.0`], [Somente correções e documentação. Congela o escopo; ao fim, merge em `main` com tag.],
    [`hotfix`], [`main` → `main` e `develop`], [`hotfix/1.0.1`], [Defeito crítico em versão entregue; incrementa o _patch_.],
    [`main`], [—], [—], [Sempre estável e etiquetado por versionamento semântico (PRESTON-WERNER, 2013). Sem _commits_ diretos.],
    [`develop`], [—], [—], [Integração contínua do trabalho; sempre compila e passa nos testes.],
  ),
  caption: [Convenções de ramificação.],
)

*Mensagens de _commit_* seguem o padrão _Conventional Commits_ (CONVENTIONAL COMMITS, [s. d.]): `tipo(escopo): descrição (ID-do-requisito)`, por exemplo `feat(contrato): aprovar contrato e gerar pagamentos (RF-CTR-04)`. Tipos: `feat`, `fix`, `docs`, `test`, `refactor`, `chore`. O código da API e o da interface ficam no mesmo repositório (pastas `api/` e `web/`), e o escopo do _commit_ indica a parte alterada (por exemplo `api` ou `web`).

*Definição de pronto* de um requisito: implementado, com teste automatizado das regras de negócio associadas, documentado no OpenAPI e mesclado em `develop` por _pull request_ aprovado.

// ───────────────────────── 3. Levantamento ─────────────────────────
= Levantamento de requisitos

== Técnica e ciclo
A elicitação foi feita por *entrevista estruturada com perguntas fechadas de múltipla escolha*, aplicadas em rodadas. A técnica é adequada ao porte do projeto, pois reduz ambiguidade, acelera a decisão e produz registro direto das escolhas (SOMMERVILLE, 2018; WIEGERS; BEATTY, 2013). O ciclo clássico de engenharia de requisitos (elicitação, análise, especificação e validação) foi percorrido em três rodadas: (1) núcleo do modelo, atores e taxa; (2) fluxo do dinheiro, despesas e ciclo do contrato; (3) cliente, pagamento/repasse e processo.

#figure(
  dg(
    spacing: (0.55cm, 0.6cm),
    node((0,0), [*Elicitação*\ questionários de\ múltipla escolha], name: <e>, width: 2.9cm),
    node((1,0), [*Análise*\ conflitos, lacunas,\ viabilidade], name: <a>, width: 2.9cm),
    node((2,0), [*Especificação*\ este documento\ (RF, RNF, RN)], name: <s>, width: 2.9cm),
    node((3,0), [*Validação*\ revisão com o\ stakeholder], name: <v>, width: 2.9cm),
    edge(<e>, <a>, "-|>"), edge(<a>, <s>, "-|>"), edge(<s>, <v>, "-|>"),
    edge(<v>, (3,1), (0,1), <e>, "--|>", label: [novas rodadas / ajustes], label-side: right),
  ),
  caption: [Ciclo de engenharia de requisitos aplicado.],
)

== Partes interessadas
#figure(
  table(
    columns: (auto, 1fr, 1fr),
    fill: head-fill, align: left,
    table.header[*Papel*][*Interesse*][*Capacidade no sistema*],
    [Administrador], [Governança: cadastros, aprovação de contratos, visão geral.], [Gerencia usuários, cooperandos e clientes; aprova, encerra e cancela contratos; vê tudo.],
    [Financeiro], [Cobrança, baixa, repasse, despesas e saldo.], [Registra baixas e repasses; lança despesas da cooperativa; emite relatórios.],
    [Motorista (cooperando)], [Seus contratos, o que receber e suas despesas.], [Elabora e submete contratos; registra suas despesas; consulta apenas seus dados.],
    [Cliente], [Acompanhar o que contratou e pagou.], [Consulta (somente leitura) seus contratos e pagamentos.],
    [Equipe de desenvolvimento / docente], [Atender à restrição acadêmica e avaliar.], [Não é ator do sistema.],
  ),
  caption: [Partes interessadas e atores.],
)

== Rastreabilidade das decisões
#figure(
  table(
    columns: (auto, 1fr, 1fr, 1fr),
    fill: head-fill, align: left,
    table.header[*Rod.*][*Pergunta*][*Decisão do stakeholder*][*Efeito na especificação*],
    [1], [Tabelas do CRUD principal.], [Cooperando, Contrato, Pagamento, Despesa e controle de usuário/acesso.], [Seis tabelas no DER (inclui Cliente, por decisão da rodada 3).],
    [1], [Perfis de usuário.], [Administrador, Motorista, Financeiro e Cliente (consulta).], [Quatro papéis RBAC; matriz de permissões (@sec-perm).],
    [1], [Cobrança da taxa.], [Configurável: percentual ou fixo, por contrato.], [Campos `taxa_tipo` e `taxa_valor` no contrato; RN02 e RN03.],
    [2], [Fluxo do dinheiro.], [Cliente paga à cooperativa, que repassa o líquido ao cooperando.], [Pagamento com baixa e repasse; RN04 e RN07.],
    [2], [Origem das despesas.], [Ambas, distinguidas por tipo/origem.], [Campo `origem` em Despesa; RN08.],
    [2], [Ciclo do contrato.], [Rascunho → pendente de aprovação → ativo → encerrado/cancelado.], [Máquina de estados do contrato; RN12.],
    [3], [Representação do cliente.], [Tabela própria (nome, documento, contato) vinculada a um usuário e aos contratos.], [Entidade Cliente 1:1 com Usuário; RN14.],
    [3], [Pagamentos e repasses.], [Pagamento único ou mensal programado; baixa manual; sem integração de pagamento.], [Modalidade ÚNICO/MENSAL; parcelas geradas na aprovação; RN05.],
    [3], [Processo de desenvolvimento.], [Cascata com fases bem definidas e Git Flow.], [@sec-processo.],
    [4], [Interface web.], [Necessária; faz parte do escopo do projeto.], [Requisitos RF-WEB-01 a 11 e RNF-16 a 21; premissas P6 a P8.],
  ),
  caption: [Decisões registradas nas rodadas de elicitação.],
)

*Premissas adotadas pela equipe* (a validar com o stakeholder; ver também a seção de riscos): (P1) cooperandos e clientes são cadastrados pelo administrador juntamente com seu usuário de acesso; (P2) taxa fixa incide por pagamento (parcela); (P3) despesas do cooperando não abatem o repasse; (P4) autenticação por _token_ com expiração e autorização por papel (RBAC); (P5) a situação "em atraso" é derivada da data de vencimento, não armazenada; (P6) a interface web é uma aplicação de página única (SPA), mantida no mesmo repositório da API, que acessa dados exclusivamente por ela; (P7) há um só _front-end_, cujos menus e telas se adaptam ao papel do usuário; (P8) o uso é em navegador (computador e celular), sem aplicativo nativo.

// ───────────────────────── 4. Visão geral e casos de uso ─────────────────────────
= Visão geral e casos de uso

== Contexto do sistema
O sistema é formado pela *interface web*, executada no navegador, e pela *API REST*, que persiste os dados em um banco relacional. A interface é o único cliente previsto da API e não acessa o banco diretamente; ferramentas de teste podem consumir a API do mesmo modo. Não há integrações externas.

#figure(
  dg(
    spacing: (1.7cm, 0.35cm),
    node((0,0), [«ator»\ *Administrador*], name: <adm>),
    node((0,1), [«ator»\ *Financeiro*], name: <fin>),
    node((0,2), [«ator»\ *Motorista*], name: <mot>),
    node((0,3), [«ator»\ *Cliente*], name: <cli>),
    node((1,1.5), [*Interface web*\ SPA no navegador\ telas por perfil], name: <web>, width: 2.6cm, inset: 8pt, stroke: 1.1pt),
    node((2,1.5), [*API REST*\ autenticação · cadastros\ contratos · pagamentos\ despesas · relatórios], name: <api>, width: 3.4cm, inset: 8pt, stroke: 1.1pt),
    node((3,1.5), [*Banco de dados*\ relacional (SQL)], name: <bd>, shape: fletcher.shapes.cylinder, width: 2.3cm),
    edge(<adm>, <web>, "<|-|>"), edge(<fin>, <web>, "<|-|>"),
    edge(<mot>, <web>, "<|-|>"), edge(<cli>, <web>, "<|-|>"),
    edge(<web>, <api>, "<|-|>", label: [HTTP/JSON], label-side: left),
    edge(<api>, <bd>, "<|-|>", label: [SQL], label-side: left),
  ),
  caption: [Diagrama de contexto.],
)

== Casos de uso
Os casos de uso estão agrupados em três módulos. Todos os perfis são especializações de _Usuário_ autenticado (herdam UC01 e UC05). Todos os casos de uso são realizados por meio da interface web.

#let actor(pos, name, label) = node(pos, [«ator»\ *#label*], name: name)
#let uc(pos, name, label) = node(pos, text(size: 7.5pt, label), name: name, shape: fletcher.shapes.pill, inset: 6pt, fill: white, width: 4.6cm)
#let bound(names) = node(enclose: names, stroke: 0.7pt + luma(90), inset: 10pt, snap: false, fill: luma(250))
#let sysname = node((1,-1), box(inset: (bottom: 14pt), text(size: 7.5pt, weight: "bold")[Sistema: API da Cooperativa]), stroke: none, inset: 0pt)
#let uspacing = (2.2cm, 0.28cm)

#block(sticky: true)[#set par(first-line-indent: 0pt)
*Módulo A — acesso e cadastros* (inclui o CRUD de uma tabela: Usuário).]
#figure(
  dg(
    spacing: uspacing,
    actor((0,0.5), <u>, [Usuário]),
    actor((2,3), <a>, [Administrador]),
    uc((1,0), <u1>, [UC01 Autenticar-se]),
    uc((1,1), <u2>, [UC05 Alterar própria senha]),
    uc((1,2), <u3>, [UC02 Gerenciar usuários]),
    uc((1,3), <u4>, [UC03 Gerenciar cooperandos]),
    uc((1,4), <u5>, [UC04 Gerenciar clientes]),
    bound((<u1>, <u2>, <u3>, <u4>, <u5>)), sysname,
    edge(<u>, <u1>, "-"), edge(<u>, <u2>, "-"),
    edge(<a>, <u3>, "-"), edge(<a>, <u4>, "-"), edge(<a>, <u5>, "-"),
  ),
  caption: [Casos de uso do módulo de acesso e cadastros.],
)

#block(sticky: true)[#set par(first-line-indent: 0pt)
*Módulo B — contratos* (CRUD relacionando Contrato, Cooperando, Cliente e Pagamento).]
#figure(
  dg(
    spacing: uspacing,
    actor((0,1), <m>, [Motorista]),
    actor((0,3), <c>, [Cliente]),
    actor((2,3), <a>, [Administrador]),
    uc((1,0), <b1>, [UC06 Elaborar contrato (rascunho)]),
    uc((1,1), <b2>, [UC07 Submeter à aprovação]),
    uc((1,2), <b5>, [UC10 Consultar contratos]),
    uc((1,3), <b4>, [UC09 Encerrar ou cancelar contrato]),
    uc((1,4), <b3>, [UC08 Aprovar ou reprovar contrato]),
    uc((1,5), <b6>, [UC11 Gerar pagamentos programados]),
    bound((<b1>, <b2>, <b3>, <b4>, <b5>, <b6>)), sysname,
    edge(<m>, <b1>, "-"), edge(<m>, <b2>, "-"), edge(<m>, <b5>, "-"),
    edge(<c>, <b5>, "-"),
    edge(<a>, <b1>, "-"), edge(<a>, <b3>, "-"), edge(<a>, <b4>, "-"),
    edge(<b3>, <b6>, "--|>", label: [«include»], label-side: right),
  ),
  caption: [Casos de uso do módulo de contratos. O administrador também atua em UC06 e UC07.],
)

#block(sticky: true)[#set par(first-line-indent: 0pt)
*Módulo C — financeiro* (pagamentos, repasses, despesas e relatórios).]
#figure(
  dg(
    spacing: uspacing,
    actor((0,1), <c>, [Cliente]),
    actor((0,4), <m>, [Motorista]),
    actor((2,2), <f>, [Financeiro]),
    actor((2,4.5), <a>, [Administrador]),
    uc((1,0), <c1>, [UC12 Registrar baixa de pagamento]),
    uc((1,1), <c2>, [UC13 Registrar repasse ao cooperando]),
    uc((1,2), <c3>, [UC14 Consultar pagamentos]),
    uc((1,3), <c4>, [UC15 Registrar despesa]),
    uc((1,4), <c5>, [UC16 Consultar despesas]),
    uc((1,5), <c6>, [UC17 Emitir relatórios financeiros]),
    bound((<c1>, <c2>, <c3>, <c4>, <c5>, <c6>)), sysname,
    edge(<f>, <c1>, "-"), edge(<f>, <c2>, "-"), edge(<f>, <c3>, "-"), edge(<f>, <c4>, "-"),
    edge(<f>, <c5>, "-"), edge(<f>, <c6>, "-"),
    edge(<a>, <c3>, "-"), edge(<a>, <c5>, "-"), edge(<a>, <c6>, "-"),
    edge(<m>, <c3>, "-"), edge(<m>, <c4>, "-"), edge(<m>, <c6>, "-"),
    edge(<c>, <c3>, "-"),
  ),
  caption: [Casos de uso do módulo financeiro. O motorista só enxerga e lança dados próprios (RN10).],
)

// ───────────────────────── 5. Regras de negócio ─────────────────────────
= Regras de negócio <sec-rn>

#let rn(id, body) = (raw(id), body)
#figure(
  {
    set text(size: 9pt)
    table(
      columns: (auto, 1fr),
      fill: head-fill, align: left,
      table.header[*ID*][*Regra*],
      ..(
        rn("RN01", [Todo contrato vincula exatamente um cliente e um cooperando. A cooperativa não é parte do contrato; seu papel é controlar o fluxo financeiro e coletar a taxa.]),
        rn("RN02", [A taxa é definida por contrato: `taxa_tipo` ∈ {PERCENTUAL, FIXO}. PERCENTUAL exige `taxa_valor` maior que 0 e menor ou igual a 100; FIXO exige `taxa_valor` > 0 (valor em reais por pagamento). A taxa só pode ser alterada enquanto o contrato estiver em RASCUNHO.]),
        rn("RN03", [`valor_taxa` = `valor_bruto` × `taxa_valor` ÷ 100 (percentual) ou `taxa_valor` (fixo), arredondado a 2 casas; `valor_liquido` = `valor_bruto` − `valor_taxa`. A taxa nunca pode exceder o valor bruto. Os três valores são gravados no pagamento na aprovação e congelados.]),
        rn("RN04", [O cliente paga à cooperativa. Cada pagamento tem dois eventos manuais e sequenciais: _baixa_ (recebimento do cliente) e _repasse_ (transferência do líquido ao cooperando).]),
        rn("RN05", [A modalidade do contrato é ÚNICO (1 pagamento, vencimento em `data_inicio`) ou MENSAL (N parcelas mensais, N ≥ 2, com `dia_vencimento` entre 1 e 28, a primeira na primeira ocorrência do dia em ou após `data_inicio`). Os pagamentos são gerados na aprovação, e a soma dos brutos é igual ao `valor_total` (resíduo de arredondamento na última parcela).]),
        rn("RN06", [Só contratos ATIVOS aceitam baixa. O encerramento exige que nenhum pagamento esteja PREVISTO ou PAGO sem repasse. O cancelamento muda para CANCELADO os pagamentos PREVISTO; pagamentos já PAGO ou REPASSADO são preservados.]),
        rn("RN07", [O repasse só é permitido sobre pagamento PAGO. Ao repassar, o valor transferido é o `valor_liquido` registrado.]),
        rn("RN08", [Toda despesa tem `origem`: COOPERATIVA (sem cooperando e sem contrato) ou COOPERANDO (cooperando obrigatório; contrato opcional, e, se informado, deve pertencer ao cooperando). Valor > 0; categoria pertence a um conjunto fixo (combustível, pedágio, manutenção, administrativa, tributos, outros).]),
        rn("RN09", [Despesas de cooperando são informativas: não reduzem o valor repassado.]),
        rn("RN10", [Escopo de dados: o motorista acessa apenas seus contratos, pagamentos e despesas; o cliente acessa apenas seus contratos e pagamentos (leitura); o motorista também consulta os dados de identificação dos clientes para elaborar contratos; administrador e financeiro acessam todos os dados conforme @sec-perm. Recurso fora do escopo responde 404.]),
        rn("RN11", [Não há exclusão física de registros referenciados. Usuários, cooperandos e clientes são inativados; contratos só são excluídos em RASCUNHO; pagamentos nunca são excluídos.]),
        rn("RN12", [Ciclo do contrato: RASCUNHO → PENDENTE_APROVACAO → ATIVO → ENCERRADO; CANCELADO a partir de qualquer estado não final. Reprovar devolve a RASCUNHO com `motivo_reprovacao`. Somente RASCUNHO é editável. Somente o administrador aprova, reprova, encerra ou cancela. Quem elabora o contrato não aprova o próprio.]),
        rn("RN13", [Cooperando ou cliente inativo não pode ser vinculado a novo contrato.]),
        rn("RN14", [Usuário de papel MOTORISTA está vinculado a exatamente um cooperando e o de papel CLIENTE a exatamente um cliente (relação 1:1); ADMINISTRADOR e FINANCEIRO não têm vínculo. E-mail é único.]),
        rn("RN15", [Aprovação, baixa e repasse registram o usuário responsável e o instante da ação.]),
      ).flatten(),
    )
  },
  caption: [Regras de negócio.],
)

// ───────────────────────── 6. Requisitos funcionais ─────────────────────────
= Requisitos funcionais
Prioridade: *E* = essencial, *I* = importante, *D* = desejável (escala em três níveis derivada de MoSCoW). Atores: ADM = administrador, FIN = financeiro, MOT = motorista, CLI = cliente.

== Autenticação e acesso
#reqs(
  rf("RF-AUT-01", [Autenticar por e-mail e senha, emitindo _token_ de acesso com expiração.], "E", "Todos", "RN14"),
  rf("RF-AUT-02", [Autorizar cada requisição conforme o papel e a propriedade do recurso (@sec-perm).], "E", "Todos", "RN10"),
  rf("RF-AUT-03", [Permitir que o usuário altere a própria senha informando a senha atual.], "I", "Todos", "—"),
)

== Usuários — _CRUD de uma tabela_
#reqs(
  rf("RF-USR-01", [Criar usuário (nome, e-mail único, senha, papel).], "E", "ADM", "RN14"),
  rf("RF-USR-02", [Listar e consultar usuários, com filtro por papel e situação, paginados.], "E", "ADM", "—"),
  rf("RF-USR-03", [Atualizar dados e papel de um usuário.], "E", "ADM", "RN14"),
  rf("RF-USR-04", [Inativar e reativar usuário; remoção física apenas sem vínculos.], "E", "ADM", "RN11"),
)

== Cooperandos e clientes
#reqs(
  rf("RF-COO-01", [Cadastrar cooperando (matrícula, nome, CPF, telefone, data de ingresso) junto com seu usuário MOTORISTA, em uma única transação.], "E", "ADM", "RN14"),
  rf("RF-COO-02", [Listar e consultar cooperandos por nome, matrícula e situação.], "E", "ADM, FIN", "—"),
  rf("RF-COO-03", [Atualizar dados do cooperando.], "E", "ADM", "—"),
  rf("RF-COO-04", [Inativar cooperando, bloqueando novos contratos.], "E", "ADM", "RN11, RN13"),
  rf("RF-CLI-01", [Cadastrar cliente (nome, CPF/CNPJ, telefone, e-mail) junto com seu usuário CLIENTE, em uma única transação.], "E", "ADM", "RN14"),
  rf("RF-CLI-02", [Listar e consultar clientes por nome, documento e situação (ao motorista, apenas identificação).], "E", "ADM, FIN, MOT", "—"),
  rf("RF-CLI-03", [Atualizar dados do cliente.], "E", "ADM", "—"),
  rf("RF-CLI-04", [Inativar cliente, bloqueando novos contratos.], "E", "ADM", "RN11, RN13"),
)

== Contratos — _CRUD relacionado (Contrato, Cooperando, Cliente, Pagamento)_
#reqs(
  rf("RF-CTR-01", [Criar contrato em RASCUNHO informando cooperando, cliente, descrição do serviço, valor total, modalidade, parcelas, dia de vencimento, vigência e taxa (tipo e valor).], "E", "MOT, ADM", "RN01–03, RN05, RN13"),
  rf("RF-CTR-02", [Editar contrato em RASCUNHO.], "E", "MOT, ADM", "RN02, RN12"),
  rf("RF-CTR-03", [Submeter à aprovação (RASCUNHO → PENDENTE_APROVACAO), validando a completude dos dados.], "E", "MOT, ADM", "RN12"),
  rf("RF-CTR-04", [Aprovar contrato (→ ATIVO), gerar o cronograma de pagamentos na mesma transação e registrar o aprovador.], "E", "ADM", "RN03, RN05, RN12, RN15"),
  rf("RF-CTR-05", [Reprovar contrato com motivo (→ RASCUNHO).], "E", "ADM", "RN12"),
  rf("RF-CTR-06", [Encerrar contrato ATIVO (→ ENCERRADO).], "E", "ADM", "RN06"),
  rf("RF-CTR-07", [Cancelar contrato (→ CANCELADO), cancelando os pagamentos PREVISTO.], "E", "ADM", "RN06"),
  rf("RF-CTR-08", [Listar contratos com filtros (situação, cooperando, cliente, período), paginados e limitados ao escopo do papel.], "E", "Todos", "RN10"),
  rf("RF-CTR-09", [Detalhar contrato com dados do cooperando, do cliente e lista de pagamentos.], "E", "Todos", "RN10"),
  rf("RF-CTR-10", [Excluir contrato em RASCUNHO.], "I", "MOT, ADM", "RN11"),
)

== Pagamentos e repasses
#reqs(
  rf("RF-PAG-01", [Listar pagamentos com filtros (contrato, situação, vencimento, em atraso), limitados ao escopo do papel.], "E", "Todos", "RN10"),
  rf("RF-PAG-02", [Registrar baixa (PREVISTO → PAGO) com data de recebimento e observação.], "E", "FIN", "RN04, RN06, RN15"),
  rf("RF-PAG-03", [Registrar repasse ao cooperando (PAGO → REPASSADO) com data.], "E", "FIN", "RN07, RN15"),
  rf("RF-PAG-04", [Estornar baixa ainda não repassada (PAGO → PREVISTO), com justificativa.], "D", "ADM, FIN", "RN15"),
  rf("RF-PAG-05", [Consultar pagamentos em atraso (vencimento anterior a hoje e situação PREVISTO).], "I", "ADM, FIN", "—"),
)

== Despesas — _CRUD relacionado (Despesa, Cooperando, Contrato, Usuário)_
#reqs(
  rf("RF-DSP-01", [Registrar despesa (origem, categoria, descrição, valor, data; cooperando e contrato quando aplicável). Financeiro e administrador lançam as da cooperativa; o motorista lança as próprias.], "E", "FIN, ADM, MOT", "RN08"),
  rf("RF-DSP-02", [Listar despesas com filtros (origem, categoria, cooperando, período), limitadas ao escopo do papel.], "E", "ADM, FIN, MOT", "RN10"),
  rf("RF-DSP-03", [Atualizar despesa (o motorista, apenas as suas).], "E", "ADM, FIN, MOT", "RN08, RN10"),
  rf("RF-DSP-04", [Excluir despesa (o motorista, apenas as suas).], "I", "ADM, FIN, MOT", "RN10"),
  rf("RF-DSP-05", [Totalizar despesas por categoria e período.], "I", "ADM, FIN, MOT", "RN10"),
)

== Relatórios
#reqs(
  rf("RF-REL-01", [Extrato do cooperando no período: pagamentos (bruto, taxa, líquido, situação do repasse) e despesas.], "I", "MOT, ADM, FIN", "RN09, RN10"),
  rf("RF-REL-02", [Resumo financeiro da cooperativa no período: taxas arrecadadas, valores a repassar e repassados, despesas da cooperativa e saldo.], "I", "ADM, FIN", "RN03, RN09"),
  rf("RF-REL-03", [Inadimplência: pagamentos em atraso agrupados por cliente e por cooperando.], "D", "ADM, FIN", "—"),
  rf("RF-REL-04", [Indicadores do painel inicial conforme o papel: contratos pendentes de aprovação, pagamentos a receber, em atraso e a repassar, contratos ativos e próximos vencimentos.], "I", "Todos", "RN10"),
)

== Interface web <sec-web>
A interface é uma aplicação de página única que consome exclusivamente a API (P6) e reflete a matriz de permissões (@sec-perm). Os requisitos abaixo descrevem funções e comportamentos, e não a aparência.
#reqs(
  rf("RF-WEB-01", [Oferecer tela de _login_ e opção de _logout_; manter a sessão enquanto o _token_ for válido e redirecionar ao _login_ quando a API responder 401.], "E", "Todos", "RF-AUT-01"),
  rf("RF-WEB-02", [Exibir menus, telas e botões apenas para as funções permitidas ao papel do usuário.], "E", "Todos", "RN10, RN12"),
  rf("RF-WEB-03", [Fornecer listagens de usuários, cooperandos, clientes, contratos, pagamentos e despesas com paginação, filtros e ordenação.], "E", "Conforme papel", "RNF-08"),
  rf("RF-WEB-04", [Fornecer formulários de cadastro e edição com validação prévia no navegador e exibição, junto ao campo, dos erros devolvidos pela API.], "E", "ADM, FIN, MOT", "RN02–RN08, RNF-07"),
  rf("RF-WEB-05", [Exibir o detalhe do contrato (cooperando, cliente e cronograma de pagamentos) com as ações de transição disponíveis para o status e o papel: submeter, aprovar, reprovar (com motivo), encerrar e cancelar.], "E", "Todos", "RN12"),
  rf("RF-WEB-06", [Permitir ao financeiro registrar baixa e repasse a partir da lista de pagamentos, destacando os pagamentos em atraso.], "E", "FIN", "RN04, RN07"),
  rf("RF-WEB-07", [Permitir lançar, editar e excluir despesas, com campos que se adaptam à origem (cooperativa ou cooperando).], "E", "ADM, FIN, MOT", "RN08"),
  rf("RF-WEB-08", [Apresentar painel inicial com os indicadores de RF-REL-04 próprios do papel.], "I", "Todos", "RF-REL-04"),
  rf("RF-WEB-09", [Apresentar telas de extrato do cooperando, resumo financeiro e inadimplência, com seleção de período.], "I", "MOT, ADM, FIN", "RF-REL-01 a 03"),
  rf("RF-WEB-10", [Pedir confirmação antes de ações irreversíveis (cancelar, excluir, estornar) e informar o resultado de cada operação.], "E", "Todos", "—"),
  rf("RF-WEB-11", [Apresentar ao cliente apenas consulta, sem controles de criação ou edição.], "E", "CLI", "RN10"),
)

// ───────────────────────── 7. RNF ─────────────────────────
= Requisitos não funcionais
#let rnf(id, cat, body, ver) = (raw(id), cat, body, ver)
#figure(
  {
    set text(size: 9pt)
    table(
      columns: (auto, auto, 1fr, auto),
      fill: head-fill, align: left,
      table.header[*ID*][*Categoria*][*Requisito*][*Verificação*],
      ..(
        rnf("RNF-01", [Segurança], [Senhas armazenadas com _hash_ adaptativo (bcrypt ou Argon2) e nunca retornadas pela API.], [Inspeção e teste]),
        rnf("RNF-02", [Segurança], [_Token_ com expiração máxima de 60 min; HTTPS na implantação.], [Teste]),
        rnf("RNF-03", [Segurança], [401 para requisição não autenticada; 403 para papel sem permissão; 404 para recurso fora do escopo.], [Teste de integração]),
        rnf("RNF-04", [Integridade], [Valores monetários em `DECIMAL(12,2)` (nunca ponto flutuante); chaves estrangeiras, unicidade e `CHECK` no banco.], [Inspeção do esquema]),
        rnf("RNF-05", [Integridade], [Operações compostas (aprovação, cadastro de cooperando/cliente com usuário) em transação atômica.], [Teste de integração]),
        rnf("RNF-06", [Padrão REST], [Recursos como substantivos no plural; verbos HTTP semânticos; _status_ 200, 201, 204, 400, 401, 403, 404, 409 e 422; JSON em UTF-8, conforme o estilo REST (FIELDING, 2000).], [Revisão do OpenAPI]),
        rnf("RNF-07", [Erros], [Corpo de erro padronizado conforme a RFC 9457 (NOTTINGHAM; WILDE; DALAL, 2023), com lista de campos inválidos.], [Teste]),
        rnf("RNF-08", [Usabilidade da API], [Listagens paginadas (`page`, `size`, máximo 100) e ordenáveis.], [Teste]),
        rnf("RNF-09", [Documentação], [Especificação OpenAPI 3.x atualizada a cada entrega, com exemplos.], [Revisão]),
        rnf("RNF-10", [Desempenho], [Meta proposta: listagens com p95 ≤ 500 ms para até 10 mil registros, em ambiente local.], [Medição simples]),
        rnf("RNF-11", [Testabilidade], [Meta proposta: toda regra RN coberta por teste automatizado; cobertura ≥ 70% da camada de serviço.], [Relatório de cobertura]),
        rnf("RNF-12", [Manutenibilidade], [Arquitetura em camadas (controlador, serviço, repositório); regras de negócio somente na camada de serviço; migrações versionadas do esquema.], [Revisão de código]),
        rnf("RNF-13", [Auditoria], [Todas as tabelas com `criado_em` e `atualizado_em`; baixa, repasse e aprovação gravam usuário e instante.], [Inspeção]),
        rnf("RNF-14", [Interoperabilidade], [Datas e instantes em ISO 8601 (instantes em UTC; vencimentos como data simples).], [Teste]),
        rnf("RNF-15", [Portabilidade], [Banco SQL relacional; execução reproduzível via README e variáveis de ambiente.], [Execução limpa]),
        rnf("RNF-16", [Compatibilidade], [Interface web funcional nas duas versões mais recentes de Chrome, Firefox, Edge e Safari.], [Teste manual]),
        rnf("RNF-17", [Usabilidade], [Interface utilizável em telas de 360 px de largura até computador (layout responsivo), com indicação de carregamento e de erro.], [Teste manual]),
        rnf("RNF-18", [Acessibilidade], [Meta proposta: formulários com rótulos associados, contraste adequado e uso completo por teclado (nível básico do WCAG 2.1 AA).], [Verificação com ferramenta]),
        rnf("RNF-19", [Segurança da interface], [_Token_ guardado de forma que reduza exposição a XSS; saídas escapadas; CORS da API restrito à origem do _front-end_; HTTPS na implantação.], [Revisão e teste]),
        rnf("RNF-20", [Desempenho percebido], [Meta proposta: tela inicial utilizável em até 3 s em rede local; retorno visual a cada requisição.], [Medição simples]),
        rnf("RNF-21", [Localização], [Textos em português do Brasil; datas no formato dd/mm/aaaa e valores em reais na exibição (a API mantém ISO 8601 e decimais).], [Inspeção]),
      ).flatten(),
    )
  },
  caption: [Requisitos não funcionais, com categorias de qualidade conforme a ISO/IEC 25010 (ISO/IEC, 2011).],
)

// ───────────────────────── 8. Restrições ─────────────────────────
= Restrições e atendimento ao escopo acadêmico

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    fill: head-fill, align: left,
    table.header[*Exigência da disciplina*][*Como é atendida*][*Requisitos*],
    [CRUD de uma tabela], [Módulo de Usuários, tabela independente (papel como enumeração).], [RF-USR-01 a 04],
    [CRUD relacionando ao menos 3 tabelas], [Contratos: `contrato` + `cooperando` + `cliente` + `pagamento` (4 tabelas). Despesas: `despesa` + `cooperando` + `contrato` + `usuario` (4 tabelas).], [RF-CTR-01 a 10; RF-DSP-01 a 05],
    [Sem gestão de veículos], [Nenhuma entidade de veículo; dados do serviço ficam na descrição do contrato.], [@sec-rn (RN01)],
    [Sem integrações externas], [Baixa e repasse manuais.], [RF-PAG-02, RF-PAG-03],
    [Interface web], [Aplicação de página única que consome a API e exibe as funções por papel.], [RF-WEB-01 a 11; RNF-16 a 21],
  ),
  caption: [Mapeamento entre a restrição da disciplina e a especificação.],
)

// ───────────────────────── 9. Modelagem ─────────────────────────
= Modelagem e projeto preliminar

== Arquitetura em camadas <sec-arq>
O sistema tem duas partes: a interface web e a API em camadas, ambas independentes de linguagem ou _framework_; a interface comunica-se com a API somente por HTTP/JSON. Na API, as regras de negócio (@sec-rn) residem exclusivamente na camada de serviço, o que as torna testáveis sem HTTP nem banco.

#let layer(y, name, title, desc) = (
  node((0,y), [*#title*], name: name, width: 4.0cm),
  node((1,y), text(size: 7.5pt, align(left, desc)), stroke: none, width: 9.5cm, inset: 0pt),
)
#figure(
  dg(
    spacing: (0.5cm, 0.55cm),
    ..layer(0, <l0>, [Interface web], [telas por perfil, formulários e sessão; consome a API por HTTP/JSON (CORS restrito)]),
    ..layer(1, <l1>, [Segurança], [autenticação por _token_ e autorização por papel (RBAC) e por propriedade do recurso]),
    ..layer(2, <l2>, [Controladores], [rotas REST, validação de entrada, DTOs, mapeamento de erros para RFC 9457]),
    ..layer(3, <l3>, [Serviços], [regras de negócio RN, máquina de estados, cálculo de taxa, transações]),
    ..layer(4, <l4>, [Repositórios], [consultas SQL, paginação e mapeamento objeto-relacional]),
    node((0,5), [*Banco de dados*], name: <l5>, shape: fletcher.shapes.cylinder, width: 4.0cm),
    node((1,5), text(size: 7.5pt, align(left)[esquema relacional com restrições `CHECK`, `UNIQUE` e chaves estrangeiras]), stroke: none, width: 9.5cm, inset: 0pt),
    edge(<l0>, <l1>, "-|>"), edge(<l1>, <l2>, "-|>"), edge(<l2>, <l3>, "-|>"),
    edge(<l3>, <l4>, "-|>"), edge(<l4>, <l5>, "<|-|>"),
  ),
  caption: [Arquitetura em camadas e fluxo de uma requisição. Aspectos transversais: auditoria (`criado_em`, usuário), _logs_ e configuração por ambiente.],
)

== Modelo de dados
O modelo segue a abordagem entidade-relacionamento e o mapeamento relacional descritos em Elmasri e Navathe (2018). O esquema é definido uma única vez abaixo e reutilizado no diagrama entidade-relacionamento e no dicionário de dados. Colunas de auditoria que referenciam `usuario` (`criado_por_id`, `aprovado_por_id`, `baixado_por_id`, `repassado_por_id`, `registrado_por_id`) não são desenhadas no DER para preservar a legibilidade.

#let T = (
  usuario: (
    ("id", "BIGINT", "PK, auto-incremento"),
    ("nome", "VARCHAR(120)", "NN"),
    ("email", "VARCHAR(160)", "UK, NN"),
    ("senha_hash", "VARCHAR(255)", "NN"),
    ("papel", "ENUM", "NN: ADMINISTRADOR, FINANCEIRO, MOTORISTA, CLIENTE"),
    ("ativo", "BOOLEAN", "NN, padrão verdadeiro"),
    ("criado_em", "TIMESTAMP", "NN"),
    ("atualizado_em", "TIMESTAMP", "NN"),
  ),
  cooperando: (
    ("id", "BIGINT", "PK, auto-incremento"),
    ("usuario_id", "BIGINT", "FK → usuario, UK, NN (relação 1:1)"),
    ("matricula", "VARCHAR(20)", "UK, NN"),
    ("nome", "VARCHAR(120)", "NN"),
    ("cpf", "CHAR(11)", "UK, NN"),
    ("telefone", "VARCHAR(20)", "—"),
    ("data_ingresso", "DATE", "NN"),
    ("ativo", "BOOLEAN", "NN, padrão verdadeiro"),
    ("criado_em", "TIMESTAMP", "NN"),
    ("atualizado_em", "TIMESTAMP", "NN"),
  ),
  cliente: (
    ("id", "BIGINT", "PK, auto-incremento"),
    ("usuario_id", "BIGINT", "FK → usuario, UK, NN (relação 1:1)"),
    ("nome", "VARCHAR(120)", "NN"),
    ("documento", "VARCHAR(14)", "UK, NN (CPF ou CNPJ, só dígitos)"),
    ("telefone", "VARCHAR(20)", "—"),
    ("email_contato", "VARCHAR(160)", "—"),
    ("ativo", "BOOLEAN", "NN, padrão verdadeiro"),
    ("criado_em", "TIMESTAMP", "NN"),
    ("atualizado_em", "TIMESTAMP", "NN"),
  ),
  contrato: (
    ("id", "BIGINT", "PK, auto-incremento"),
    ("cooperando_id", "BIGINT", "FK → cooperando, NN"),
    ("cliente_id", "BIGINT", "FK → cliente, NN"),
    ("descricao", "VARCHAR(500)", "NN"),
    ("valor_total", "DECIMAL(12,2)", "NN, CHECK > 0"),
    ("modalidade", "ENUM", "NN: UNICO, MENSAL"),
    ("num_parcelas", "SMALLINT", "NN, CHECK ≥ 1 (1 se UNICO)"),
    ("dia_vencimento", "SMALLINT", "CHECK entre 1 e 28; obrigatório se MENSAL"),
    ("data_inicio", "DATE", "NN"),
    ("data_fim", "DATE", "CHECK ≥ data_inicio"),
    ("taxa_tipo", "ENUM", "NN: PERCENTUAL, FIXO"),
    ("taxa_valor", "DECIMAL(12,2)", "NN, CHECK > 0 (≤ 100 se PERCENTUAL)"),
    ("status", "ENUM", "NN: RASCUNHO, PENDENTE_APROVACAO, ATIVO, ENCERRADO, CANCELADO"),
    ("motivo_reprovacao", "VARCHAR(300)", "—"),
    ("criado_por_id", "BIGINT", "FK → usuario, NN"),
    ("aprovado_por_id", "BIGINT", "FK → usuario"),
    ("aprovado_em", "TIMESTAMP", "—"),
    ("criado_em", "TIMESTAMP", "NN"),
    ("atualizado_em", "TIMESTAMP", "NN"),
  ),
  pagamento: (
    ("id", "BIGINT", "PK, auto-incremento"),
    ("contrato_id", "BIGINT", "FK → contrato, NN; UK com numero_parcela"),
    ("numero_parcela", "SMALLINT", "NN, CHECK ≥ 1"),
    ("data_vencimento", "DATE", "NN"),
    ("valor_bruto", "DECIMAL(12,2)", "NN, CHECK > 0"),
    ("valor_taxa", "DECIMAL(12,2)", "NN, CHECK ≥ 0 e ≤ valor_bruto"),
    ("valor_liquido", "DECIMAL(12,2)", "NN, = valor_bruto − valor_taxa"),
    ("status", "ENUM", "NN: PREVISTO, PAGO, REPASSADO, CANCELADO"),
    ("data_baixa", "DATE", "obrigatório se PAGO ou REPASSADO"),
    ("baixado_por_id", "BIGINT", "FK → usuario"),
    ("data_repasse", "DATE", "obrigatório se REPASSADO"),
    ("repassado_por_id", "BIGINT", "FK → usuario"),
    ("observacao", "VARCHAR(300)", "—"),
    ("criado_em", "TIMESTAMP", "NN"),
    ("atualizado_em", "TIMESTAMP", "NN"),
  ),
  despesa: (
    ("id", "BIGINT", "PK, auto-incremento"),
    ("origem", "ENUM", "NN: COOPERATIVA, COOPERANDO"),
    ("categoria", "ENUM", "NN: COMBUSTIVEL, PEDAGIO, MANUTENCAO, ADMINISTRATIVA, TRIBUTOS, OUTROS"),
    ("descricao", "VARCHAR(300)", "NN"),
    ("valor", "DECIMAL(12,2)", "NN, CHECK > 0"),
    ("data_despesa", "DATE", "NN"),
    ("cooperando_id", "BIGINT", "FK → cooperando; NN se origem = COOPERANDO, nulo se COOPERATIVA"),
    ("contrato_id", "BIGINT", "FK → contrato; nulo se COOPERATIVA; do mesmo cooperando se informado"),
    ("registrado_por_id", "BIGINT", "FK → usuario, NN"),
    ("criado_em", "TIMESTAMP", "NN"),
    ("atualizado_em", "TIMESTAMP", "NN"),
  ),
)

#let tags(c) = {
  let t = ()
  if c.starts-with("PK") { t.push("PK") }
  if c.contains("FK") { t.push("FK") }
  if c.contains("UK") { t.push("UK") }
  t.join(" ")
}
#let ent(nome) = {
  let cols = T.at(nome)
  box(width: 3.9cm, {
    set block(spacing: 0pt)
    block(width: 100%, fill: soft, inset: 4pt, align(center, text(size: 8pt, weight: "bold", raw(nome))))
    line(length: 100%, stroke: 0.5pt)
    show raw: set text(size: 6.6pt)
    grid(
      columns: (1fr, auto), inset: (x: 4pt, y: 1.5pt), align: left,
      ..cols.map(c => (raw(c.at(0)), text(size: 5.8pt, weight: "bold", fill: accent, tags(c.at(2))))).flatten(),
    )
  })
}
#let en(pos, nome) = node(pos, ent(nome), name: label(nome), shape: fletcher.shapes.rect, stroke: 0.7pt, fill: white, inset: 0pt)
#let rel(a, b, ca, cb, lbl) = (
  edge(a, b, "-", stroke: 0.8pt, label: text(size: 7pt, style: "italic", lbl), label-fill: true),
  edge(a, b, "-", stroke: none, label: text(size: 7.5pt, weight: "bold", ca), label-pos: 0.1, label-side: left, label-sep: 3pt),
  edge(a, b, "-", stroke: none, label: text(size: 7.5pt, weight: "bold", cb), label-pos: 0.9, label-side: left, label-sep: 3pt),
)

#figure(
  diagram(
    ..nstyle, spacing: (2.1cm, 1.0cm),
    en((1,0), "usuario"), en((0,0), "cliente"), en((2,0), "cooperando"),
    en((1,1), "contrato"), en((1,2), "pagamento"), en((2,2), "despesa"),
    ..rel(<usuario>, <cliente>, "1", "1", "acessa"),
    ..rel(<usuario>, <cooperando>, "1", "1", "acessa"),
    ..rel(<cliente>, <contrato>, "1", "N", "contrata"),
    ..rel(<cooperando>, <contrato>, "1", "N", "executa"),
    ..rel(<contrato>, <pagamento>, "1", "N", "gera"),
    ..rel(<cooperando>, <despesa>, "0..1", "N", "origina"),
    ..rel(<contrato>, <despesa>, "0..1", "N", "associa"),
  ),
  caption: [Diagrama entidade-relacionamento (PK = chave primária, FK = estrangeira, UK = única). Veículos não são modelados.],
)

#for (nome, cols) in T {
  figure(
    {
      set text(size: 9pt)
      show raw: set text(size: 8.5pt)
      table(
        columns: (auto, auto, 1fr),
        fill: head-fill, align: left, inset: 3.5pt,
        table.header[*Coluna*][*Tipo*][*Restrições*],
        ..cols.map(c => (raw(c.at(0)), c.at(1), c.at(2))).flatten(),
      )
    },
    caption: [Dicionário de dados: entidade #raw(nome)],
  )
}

*Restrições entre colunas* (implementadas como `CHECK` ou verificadas na camada de serviço): `despesa.origem = 'COOPERATIVA'` implica `cooperando_id` e `contrato_id` nulos; `origem = 'COOPERANDO'` implica `cooperando_id` não nulo; a soma de `pagamento.valor_bruto` por contrato é igual a `contrato.valor_total` (RN05).

== Estados do contrato e do pagamento
#figure(
  dg(
    spacing: (1.3cm, 2.0cm),
    node((0,0), [], shape: circle, radius: 3.5pt, fill: ink, stroke: none, inset: 0pt, name: <ini>),
    node((1,0), [RASCUNHO], name: <rasc>, shape: fletcher.shapes.pill, width: 2.3cm),
    node((2,0), [PENDENTE\_APROVACAO], name: <pend>, shape: fletcher.shapes.pill, width: 3.0cm),
    node((3,0), [ATIVO], name: <ativo>, shape: fletcher.shapes.pill, width: 1.8cm),
    node((4,0), [ENCERRADO], name: <enc>, shape: fletcher.shapes.pill, width: 2.3cm, stroke: 1.2pt),
    node((2,1), [CANCELADO], name: <canc>, shape: fletcher.shapes.pill, width: 2.3cm, stroke: 1.2pt),
    edge(<ini>, <rasc>, "-|>"),
    edge(<rasc>, <pend>, "-|>", bend: 25deg, label: [submeter], label-side: left),
    edge(<pend>, <rasc>, "--|>", bend: 25deg, label: [reprovar (motivo)], label-side: left),
    edge(<pend>, <ativo>, "-|>", label: [aprovar], label-side: left),
    edge(<ativo>, <enc>, "-|>", label: [encerrar], label-side: left),
    edge(<rasc>, (1,1), <canc>, "-|>", label: [cancelar], label-side: left),
    edge(<pend>, <canc>, "-|>", label: [cancelar], label-side: left),
    edge(<ativo>, (3,1), <canc>, "-|>", label: [cancelar], label-side: right),
  ),
  caption: [Máquina de estados do contrato (RN12). Aprovar gera os pagamentos na mesma transação. ENCERRADO e CANCELADO são finais.],
)

#figure(
  dg(
    spacing: (1.7cm, 1.3cm),
    node((0,0), [], shape: circle, radius: 3.5pt, fill: ink, stroke: none, inset: 0pt, name: <ini>),
    node((1,0), [PREVISTO], name: <prev>, shape: fletcher.shapes.pill, width: 2.2cm),
    node((2,0), [PAGO], name: <pago>, shape: fletcher.shapes.pill, width: 2.0cm),
    node((3,0), [REPASSADO], name: <rep>, shape: fletcher.shapes.pill, width: 2.4cm, stroke: 1.2pt),
    node((1,1), [CANCELADO], name: <canc>, shape: fletcher.shapes.pill, width: 2.4cm, stroke: 1.2pt),
    edge(<ini>, <prev>, "-|>", label: [aprovação do\ contrato], label-side: left),
    edge(<prev>, <pago>, "-|>", bend: 25deg, label: [baixa (FIN)], label-side: left),
    edge(<pago>, <prev>, "--|>", bend: 25deg, label: [estorno], label-side: left),
    edge(<pago>, <rep>, "-|>", label: [repasse (FIN)], label-side: left),
    edge(<prev>, <canc>, "-|>", label: [cancelamento do contrato], label-side: right),
  ),
  caption: [Máquina de estados do pagamento (RN04, RN06, RN07). _Em atraso_ é derivado: situação PREVISTO com vencimento anterior à data atual (P5).],
)

== Fluxo financeiro
#figure(
  dg(
    spacing: (2.4cm, 1.0cm),
    node((1,0), [`valor_liquido = valor_bruto − valor_taxa` (RN03)], stroke: none, inset: 0pt),
    node((0,1), [*Cliente*\ paga o valor bruto], name: <c>, width: 2.7cm),
    node((1,1), [*Cooperativa*\ recebe, dá baixa e retém a taxa], name: <k>, width: 3.2cm, stroke: 1.1pt),
    node((2,1), [*Cooperando*\ recebe o valor líquido], name: <o>, width: 2.7cm),
    node((1,2), [*Receita da cooperativa*\ taxa (percentual ou fixa)], name: <r>, width: 3.4cm),
    edge(<c>, <k>, "-|>", label: [① baixa\ PREVISTO → PAGO], label-side: left),
    edge(<k>, <o>, "-|>", label: [② repasse\ PAGO → REPASSADO], label-side: left),
    edge(<k>, <r>, "-|>", label: [taxa retida], label-side: right),
  ),
  caption: [Fluxo do dinheiro: o contrato é entre cliente e cooperando; a cooperativa intermedeia.],
)

== Sequência do ciclo de vida de um contrato
#let seq-msg(x1, x2, y, body, dashed: false) = edge((x1, y), (x2, y), if dashed { "--|>" } else { "-|>" }, label: text(size: 6.8pt, body), label-side: left, label-sep: 2pt)
#let life = (stroke: 0.5pt + luma(150))
#figure(
  dg(
    spacing: (0.9cm, 0.85cm),
    node((0,0), [*Motorista*], width: 2.1cm), node((1,0), [*Administrador*], width: 2.3cm),
    node((2,0), [*Financeiro*], width: 2.1cm), node((3,0), [*API*], width: 2.0cm),
    node((4,0), [*Banco*], width: 2.0cm),
    edge((0,0), (0,11), "--", ..life), edge((1,0), (1,11), "--", ..life),
    edge((2,0), (2,11), "--", ..life), edge((3,0), (3,11), "--", ..life),
    edge((4,0), (4,11), "--", ..life),
    seq-msg(0, 3, 1, [1\. `POST /contratos` (rascunho)]),
    seq-msg(3, 4, 2, [valida RN01–03; INSERT contrato]),
    seq-msg(3, 0, 3, [201 Created], dashed: true),
    seq-msg(0, 3, 4, [2\. `POST /contratos/{id}/submissao`]),
    seq-msg(3, 4, 5, [status = PENDENTE]),
    seq-msg(1, 3, 6, [3\. `POST /contratos/{id}/aprovacao`]),
    seq-msg(3, 4, 7, [transação: ATIVO + INSERT pagamentos]),
    seq-msg(3, 1, 8, [200 OK (contrato ativo)], dashed: true),
    seq-msg(2, 3, 9, [4\. `POST /pagamentos/{id}/baixa`]),
    seq-msg(2, 3, 10, [5\. `POST /pagamentos/{id}/repasse`]),
  ),
  caption: [Sequência: da elaboração do contrato ao repasse (as chamadas partem da interface web e cada passo valida papel, escopo e estado).],
)

== Mapa de navegação da interface web
#block(sticky: true)[O mapa mostra a estrutura de telas e o acesso por papel. Telas de listagem seguem o mesmo padrão (RF-WEB-03), e as de cadastro usam um formulário comum de criação e edição (RF-WEB-04).]
#figure(
  dg(
    spacing: (1.0cm, 0.3cm),
    node((0,3), [*Login*], name: <login>, width: 1.6cm),
    node((1,3), [*Painel inicial*\ indicadores\ por papel], name: <painel>, width: 2.4cm),
    node((2,0), [*Usuários*\ ADM], name: <m0>, width: 3.0cm),
    node((2,1), [*Cooperandos*\ ADM, FIN; MOT: próprio], name: <m1>, width: 3.0cm),
    node((2,2), [*Clientes*\ ADM, FIN, MOT; CLI: próprio], name: <m2>, width: 3.0cm),
    node((2,3), [*Contratos*\ todos os papéis], name: <m3>, width: 3.0cm),
    node((2,4), [*Pagamentos*\ todos os papéis], name: <m4>, width: 3.0cm),
    node((2,5), [*Despesas*\ ADM, FIN, MOT], name: <m5>, width: 3.0cm),
    node((2,6), [*Relatórios*\ ADM, FIN, MOT], name: <m6>, width: 3.0cm),
    node((3,1), [*Formulário*\ criar e editar], name: <form>, width: 2.5cm),
    node((3,3), [*Detalhe do contrato*\ cronograma e transições], name: <det>, width: 2.5cm),
    node((3,4), [*Baixa e repasse*\ somente FIN], name: <br>, width: 2.5cm),
    edge(<login>, <painel>, "-|>"),
    edge(<painel>, <m0>, "-|>"), edge(<painel>, <m1>, "-|>"), edge(<painel>, <m2>, "-|>"),
    edge(<painel>, <m3>, "-|>"), edge(<painel>, <m4>, "-|>"), edge(<painel>, <m5>, "-|>"),
    edge(<painel>, <m6>, "-|>"),
    edge(<m0>, <form>, "-|>"), edge(<m1>, <form>, "-|>"), edge(<m2>, <form>, "-|>"),
    edge(<m3>, <det>, "-|>"),
    edge(<m4>, <br>, "-|>"),
  ),
  caption: [Mapa de navegação por papel (estrutura de telas, sem projeto visual). As despesas e os contratos em rascunho também usam o formulário.],
)

// ───────────────────────── 10. Contrato da API ─────────────────────────
= Contrato da API (recursos e operações)

== Convenções
Base `/api/v1`; representação JSON (UTF-8); identificadores numéricos; datas ISO 8601. Operações de transição de estado (submeter, aprovar, baixar etc.) são modeladas como _comandos_ por `POST` em sub-recurso, pois não são simples atualizações de campo e carregam regras próprias. Códigos de resposta: `200` (consulta/atualização), `201` (criação, com `Location`), `204` (exclusão), `400` (requisição malformada), `401`, `403`, `404`, `409` (transição inválida ou conflito de estado), `422` (regra de negócio violada). Listagens aceitam `page`, `size`, `sort` e filtros por _query string_. Como a interface web é servida em origem própria, a API habilita CORS somente para a origem configurada do _front-end_.

#let ep(m, path, desc, roles, rfid) = (raw(m), raw(path), desc, roles, raw(rfid))
#figure(
  {
    set text(size: 9pt)
    table(
      columns: (auto, auto, 1fr, auto, auto),
      fill: head-fill, align: left, inset: 3.8pt,
      table.header[*Método*][*Rota*][*Descrição*][*Papéis*][*RF*],
      ..(
        ep("POST", "/auth/login", [Autentica e devolve o _token_.], "Público", "AUT-01"),
        ep("POST", "/auth/alterar-senha", [Altera a própria senha.], "Todos", "AUT-03"),
        ep("POST", "/usuarios", [Cria usuário.], "ADM", "USR-01"),
        ep("GET", "/usuarios", [Lista usuários (filtros: papel, ativo).], "ADM", "USR-02"),
        ep("GET", "/usuarios/{id}", [Consulta usuário.], "ADM", "USR-02"),
        ep("PUT", "/usuarios/{id}", [Atualiza usuário.], "ADM", "USR-03"),
        ep("PATCH", "/usuarios/{id}/situacao", [Inativa ou reativa usuário.], "ADM", "USR-04"),
        ep("POST", "/cooperandos", [Cadastra cooperando e usuário (transação).], "ADM", "COO-01"),
        ep("GET", "/cooperandos", [Lista cooperandos.], "ADM, FIN", "COO-02"),
        ep("GET", "/cooperandos/{id}", [Consulta cooperando (o motorista, apenas o próprio).], "ADM, FIN, MOT", "COO-02"),
        ep("PUT", "/cooperandos/{id}", [Atualiza cooperando.], "ADM", "COO-03"),
        ep("PATCH", "/cooperandos/{id}/situacao", [Inativa ou reativa cooperando.], "ADM", "COO-04"),
        ep("POST", "/clientes", [Cadastra cliente e usuário (transação).], "ADM", "CLI-01"),
        ep("GET", "/clientes", [Lista clientes.], "ADM, FIN, MOT", "CLI-02"),
        ep("GET", "/clientes/{id}", [Consulta cliente (o cliente, apenas o próprio).], "ADM, FIN, MOT, CLI", "CLI-02"),
        ep("PUT", "/clientes/{id}", [Atualiza cliente.], "ADM", "CLI-03"),
        ep("PATCH", "/clientes/{id}/situacao", [Inativa ou reativa cliente.], "ADM", "CLI-04"),
        ep("POST", "/contratos", [Cria contrato em RASCUNHO.], "MOT, ADM", "CTR-01"),
        ep("GET", "/contratos", [Lista contratos (filtros: status, cooperando, cliente, período).], "Todos", "CTR-08"),
        ep("GET", "/contratos/{id}", [Detalha contrato com cooperando, cliente e pagamentos.], "Todos", "CTR-09"),
        ep("PUT", "/contratos/{id}", [Edita contrato em RASCUNHO.], "MOT, ADM", "CTR-02"),
        ep("DELETE", "/contratos/{id}", [Exclui contrato em RASCUNHO.], "MOT, ADM", "CTR-10"),
        ep("POST", "/contratos/{id}/submissao", [RASCUNHO → PENDENTE_APROVACAO.], "MOT, ADM", "CTR-03"),
        ep("POST", "/contratos/{id}/aprovacao", [PENDENTE → ATIVO; gera pagamentos.], "ADM", "CTR-04"),
        ep("POST", "/contratos/{id}/reprovacao", [PENDENTE → RASCUNHO (corpo: motivo).], "ADM", "CTR-05"),
        ep("POST", "/contratos/{id}/encerramento", [ATIVO → ENCERRADO.], "ADM", "CTR-06"),
        ep("POST", "/contratos/{id}/cancelamento", [Estado não final → CANCELADO.], "ADM", "CTR-07"),
        ep("GET", "/contratos/{id}/pagamentos", [Lista pagamentos do contrato.], "Todos", "PAG-01"),
        ep("GET", "/pagamentos", [Lista pagamentos (filtros: situação, vencimento, em_atraso).], "Todos", "PAG-01"),
        ep("GET", "/pagamentos/{id}", [Consulta pagamento.], "Todos", "PAG-01"),
        ep("POST", "/pagamentos/{id}/baixa", [PREVISTO → PAGO.], "FIN", "PAG-02"),
        ep("POST", "/pagamentos/{id}/repasse", [PAGO → REPASSADO.], "FIN", "PAG-03"),
        ep("POST", "/pagamentos/{id}/estorno", [PAGO → PREVISTO (corpo: justificativa).], "ADM, FIN", "PAG-04"),
        ep("POST", "/despesas", [Registra despesa.], "ADM, FIN, MOT", "DSP-01"),
        ep("GET", "/despesas", [Lista despesas (filtros: origem, categoria, cooperando, período).], "ADM, FIN, MOT", "DSP-02"),
        ep("GET", "/despesas/{id}", [Consulta despesa.], "ADM, FIN, MOT", "DSP-02"),
        ep("PUT", "/despesas/{id}", [Atualiza despesa.], "ADM, FIN, MOT", "DSP-03"),
        ep("DELETE", "/despesas/{id}", [Exclui despesa.], "ADM, FIN, MOT", "DSP-04"),
        ep("GET", "/despesas/totais", [Totais por categoria e período.], "ADM, FIN, MOT", "DSP-05"),
        ep("GET", "/cooperandos/{id}/extrato", [Extrato do cooperando no período.], "ADM, FIN, MOT", "REL-01"),
        ep("GET", "/relatorios/resumo-financeiro", [Resumo financeiro da cooperativa.], "ADM, FIN", "REL-02"),
        ep("GET", "/relatorios/inadimplencia", [Pagamentos em atraso agrupados.], "ADM, FIN", "REL-03"),
        ep("GET", "/painel/indicadores", [Indicadores do painel conforme o papel.], "Todos", "REL-04"),
      ).flatten(),
    )
  },
  caption: [Recursos da API. O prefixo `RF-` foi omitido na última coluna.],
)

// ───────────────────────── 11. Permissões ─────────────────────────
= Matriz de permissões <sec-perm>
*T* = todos os registros; *P* = somente registros próprios (RN10); *—* = sem acesso. A interface web oculta os controles não permitidos (RF-WEB-02), mas a API é a autoridade final de autorização (RNF-03).

#let perm(a, adm, fin, mot, cli) = (a, adm, fin, mot, cli)
#figure(
  {
    set text(size: 9pt)
    table(
      columns: (1fr, auto, auto, auto, auto),
      fill: (x, y) => if y == 0 { soft },
      align: (left, center, center, center, center),
      table.header[*Recurso / operação*][*ADM*][*FIN*][*MOT*][*CLI*],
      ..(
        perm([Usuários: criar, listar, editar, inativar], "T", "—", "—", "—"),
        perm([Alterar a própria senha], "P", "P", "P", "P"),
        perm([Cooperandos: criar, editar, inativar], "T", "—", "—", "—"),
        perm([Cooperandos: consultar], "T", "T", "P", "—"),
        perm([Clientes: criar, editar, inativar], "T", "—", "—", "—"),
        perm([Clientes: consultar], "T", "T", "T (identificação)", "P"),
        perm([Contratos: criar, editar e excluir rascunho; submeter], "T", "—", "P", "—"),
        perm([Contratos: aprovar, reprovar, encerrar, cancelar], "T", "—", "—", "—"),
        perm([Contratos: consultar], "T", "T", "P", "P"),
        perm([Pagamentos: consultar], "T", "T", "P", "P"),
        perm([Pagamentos: baixa e repasse], "—", "T", "—", "—"),
        perm([Pagamentos: estorno de baixa], "T", "T", "—", "—"),
        perm([Despesas: registrar, editar, excluir], "T", "T", "P (origem COOPERANDO)", "—"),
        perm([Despesas: consultar e totalizar], "T", "T", "P", "—"),
        perm([Relatório: extrato do cooperando], "T", "T", "P", "—"),
        perm([Relatórios: resumo financeiro e inadimplência], "T", "T", "—", "—"),
      ).flatten(),
    )
  },
  caption: [Autorização por papel (RBAC) com restrição por propriedade do recurso.],
)

// ───────────────────────── 12. Aceitação ─────────────────────────
= Critérios de aceitação
Cenários mínimos, no formato _dado–quando–então_, que servirão de base aos testes de integração. Os demais requisitos são verificados conforme as colunas "Verificação" e as regras de negócio associadas.

#figure(
  {
    set text(size: 9pt)
    table(
      columns: (auto, 1fr, 1fr, 1.2fr),
      fill: head-fill, align: left, inset: 4.5pt,
      table.header[*ID*][*Dado*][*Quando*][*Então*],
      [CA-01], [Contrato PENDENTE, MENSAL, valor total 6000,00, 3 parcelas, taxa PERCENTUAL de 10.], [O administrador aprova.], [Status ATIVO; 3 pagamentos PREVISTO com bruto 2000,00, taxa 200,00 e líquido 1800,00 (RF-CTR-04; RN03, RN05).],
      [CA-02], [Contrato em RASCUNHO com taxa FIXA de 500,00 e parcela de 400,00.], [O motorista submete.], [`422` com o campo `taxa_valor` indicado (RN03).],
      [CA-03], [Pagamento PREVISTO.], [O financeiro tenta registrar repasse.], [`409`; situação permanece PREVISTO (RN07).],
      [CA-04], [Contrato do motorista B.], [O motorista A consulta esse contrato.], [`404` (RN10, RNF-03).],
      [CA-05], [Contrato PENDENTE.], [O motorista tenta aprovar.], [`403`; contrato permanece PENDENTE (RN12).],
      [CA-06], [Despesa de origem COOPERATIVA.], [Informa-se `cooperando_id`.], [`422` (RN08).],
      [CA-07], [Contrato ATIVO com pagamento PAGO e sem repasse.], [O administrador tenta encerrar.], [`409` (RN06).],
      [CA-08], [Motorista autenticado na interface.], [Abre o detalhe de um contrato PENDENTE.], [Nenhuma ação de aprovar ou reprovar é exibida (RF-WEB-02; RN12).],
      [CA-09], [Formulário de contrato com taxa fixa maior que a parcela.], [O usuário envia e a API responde `422`.], [A mensagem aparece junto ao campo `taxa_valor` (RF-WEB-04).],
      [CA-10], [Sessão com _token_ expirado.], [O usuário aciona qualquer tela e a API responde `401`.], [A interface redireciona ao _login_ (RF-WEB-01).],
    )
  },
  caption: [Cenários de aceitação.],
)

// ───────────────────────── 13. Riscos ─────────────────────────
= Riscos e gestão de mudanças

#figure(
  {
    set text(size: 9pt)
    table(
      columns: (auto, 1fr, 1fr),
      fill: head-fill, align: left,
      table.header[*Risco*][*Descrição*][*Mitigação*],
      [R1], [Premissas P1–P5 não confirmadas pelo stakeholder geram retrabalho.], [Validar as premissas no marco da fase 1 e registrar a resposta neste documento.],
      [R2], [Crescimento de escopo (veículos, pagamento online, front-end).], [Escopo fechado na seção 1.3; mudanças somente por solicitação registrada e nova versão do documento.],
      [R3], [Ambiguidade da taxa fixa em contratos mensais.], [Regra explícita em RN02 (por pagamento) e cenário de teste CA-02.],
      [R4], [Erros de arredondamento monetário.], [`DECIMAL`, resíduo na última parcela (RN05) e testes de soma.],
      [R5], [Tempo insuficiente para todos os requisitos.], [Priorização E/I/D; entrega incremental por módulo com testes junto de cada _feature_.],
      [R6], [Conflitos de integração no Git.], [Ramos curtos, _pull requests_ pequenos e revisão cruzada.],
      [R7], [A interface web amplia o esforço e ameaça o prazo.], [Telas padronizadas e reutilizáveis (listagem, formulário, detalhe); entrega vertical por módulo; priorização E/I/D.],
    )
  },
  caption: [Registro de riscos.],
)

*Gestão de mudanças.* Qualquer alteração de requisito após a aprovação do documento segue o fluxo: solicitação registrada → análise de impacto (RF, RN, DER, API, testes) → aprovação → atualização desta especificação em ramo `docs/*` e incremento da versão.

#heading(numbering: none)[Referências]
#set par(first-line-indent: 0pt, justify: false, leading: 0.65em)

CONVENTIONAL COMMITS. *Conventional Commits 1.0.0*. [S. l.]: [s. n.], [s. d.]. Disponível em: https://www.conventionalcommits.org/. Acesso em: 31 out. 2026.

DRIESSEN, Vincent. *A successful Git branching model*. [S. l.]: [s. n.], 2010. Disponível em: https://nvie.com/posts/a-successful-git-branching-model/. Acesso em: 31 out. 2026.

ELMASRI, Ramez; NAVATHE, Shamkant B. *Sistemas de banco de dados*. 7. ed. São Paulo: Pearson, 2018.

FIELDING, Roy Thomas. *Architectural styles and the design of network-based software architectures*. 2000. Tese (Doutorado em Informação e Ciência da Computação) – University of California, Irvine, 2000.

ISO/IEC. *ISO/IEC 25010:2011*: systems and software engineering – systems and software Quality Requirements and Evaluation (SQuaRE) – system and software quality models. Geneva: ISO, 2011.

ISO/IEC/IEEE. *ISO/IEC/IEEE 29148:2018*: systems and software engineering – life cycle processes – requirements engineering. Geneva: ISO, 2018.

NOTTINGHAM, Mark; WILDE, Erik; DALAL, Sanjay. *RFC 9457*: problem details for HTTP APIs. [S. l.]: Internet Engineering Task Force, 2023. Disponível em: https://www.rfc-editor.org/rfc/rfc9457. Acesso em: 31 out. 2026.

PRESSMAN, Roger S.; MAXIM, Bruce R. *Engenharia de software*: uma abordagem profissional. 8. ed. Porto Alegre: AMGH, 2016.

PRESTON-WERNER, Tom. *Semantic Versioning 2.0.0*. [S. l.]: [s. n.], 2013. Disponível em: https://semver.org/. Acesso em: 31 out. 2026.

ROYCE, Winston W. Managing the development of large software systems. In: IEEE WESCON, 1970. *Proceedings* [...]. [S. l.]: IEEE, 1970.

SOMMERVILLE, Ian. *Engenharia de software*. 10. ed. São Paulo: Pearson, 2018.

WIEGERS, Karl; BEATTY, Joy. *Software requirements*. 3. ed. Redmond: Microsoft Press, 2013.
