# 📊 Análise Exploratória da Base Churn

Este projeto tem como objetivo aplicar técnicas de **Análise Exploratória de Dados (EDA)** utilizando a linguagem **R**, com uma interface de visualização construída em **PHP**.

Foi desenvolvido como parte da disciplina **Análise Exploratória de Dados** do **Mestrado Profissional em Computação Aplicada (UNIVALI)**.

---

## 🧪 Tecnologias Utilizadas

- 💻 **R** para análise de dados e geração de gráficos
- 🧩 **Pacotes R**: `ggplot2`, `DataExplorer`, `dplyr`, `caret`, `xgboost`, `isofor`, entre outros
- 🌐 **PHP** para integração e exibição dinâmica dos resultados
- 🐳 **Docker** para ambiente isolado e replicável (opcional)
- 🐍 Scripts auxiliares em **Python** para geração de PDF (via `matplotlib`)

---

## 📁 Estrutura do Projeto
```plaintext
Atividade R
├── config/ # Configurações do nginx e PHP 
├── public/
│ ├── graphics/ # Gráficos gerados pelo R
│ └── style/ # CSS da interface
├── scripts/ 
│ ├── analise_churn.R # Script principal em R
│ └── gerar_graficos.py # (Opcional) Script Python auxiliar
├── Bases_de_dados_ver00/ 
│ └── Churn_ver00.csv # Base de dados utilizada
├── index.php # Interface principal
├── docker-compose.yml # Ambiente Docker (opcional)
└── README.md
```

---

## 📊 Gráficos Gerados

- Distribuição de **Churn por Tipo de Plano**
- Distribuição de **Churn por Dispositivo**
- **Boxplot de Uso vs Churn**
- **Boxplot de Duração vs Churn**
- Detecção de **Outliers com Boxplot, Z-Score e Isolation Forest**
- Estatísticas e estruturas da base com `DataExplorer`

---

## 🔎 Principais Insights

- **Churn**: ~35.8% dos usuários cancelaram.
- **Planos Promo** apresentaram maior taxa de churn.
- **Usuários que recebem newsletter** tendem a permanecer mais.
- **Dispositivos móveis (Phone)** concentram mais cancelamentos.
- A variável **usage** apresenta dispersão significativa e outliers.
- Duração média dos usuários: **50 dias**.

---

## 🚀 Como Executar

### Requisitos

- R instalado com os pacotes descritos no script
- PHP + servidor local (ex: XAMPP ou Docker)
- Base de dados `Churn_ver00.csv` no caminho correto

### Passos

1. Clone o repositório:

```bash
git clone https://github.com/seuusuario/analise-exploratoria-base-churn.git
cd analise-exploratoria-base-churn
```

2. Execute o script R manualmente ou pelo PHP:

```bash
Rscript scripts/analise_churn.R
```

3. Acesse o projeto localmente:

```bash
http://localhost:8080/public/index.php
```

---

## 📄 Licença
Distribuído sob licença Creative Commons 4.0 - CC BY-NC-SA.
Você pode compartilhar e adaptar, mas não para fins comerciais e sempre mantendo os créditos.

---

## 👩‍💻 Autoria
Daiane Wan-Dall Splitter da Silva
Disciplina: Análise Exploratória de Dados
Professor: Rodrigo Sant'Ana
Mestrado Profissional em Computação Aplicada - UNIVALI

