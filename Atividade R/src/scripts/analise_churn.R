########################################################################
## Description: Análise Exploratória de Dados com Base Churn
##
## Maintainer: UNIVALI / EP / MCA - Análise Exploratória de Dados
## Author: Daiane Wan-Dall Splitter da Silva
## Baseado em base de dados de: Rodrigo Sant'Ana
## Created: qui abr 10 2025 
## Version: 0.0.1
########################################################################

########################################################################
######@> 01. Instalando e Carregando pacotes / bibliotecas R...

######@> Instalação de novos pacotes / bibliotecas [Instalação de
######@> Pacotes precisa se executada apenas uma vez]...
install.packages(c("dplyr", "tidyr", "lubridate", "readxl", "ggplot2",
                   "patchwork", "sf", "ggcorrplot", "ggmap", "leaflet",
                   "Hmisc", "imputeTS", "stringr", "DataExplorer",
                   "explore", "mlbench", "caret", "e1071", "naniar",
                   "VIM", "corrplot", "FactoMineR", "factoextra",
                   "randomForest", "xgboost", "ROCR", "ggvis",
                   "missForest", "MASS", "ROSE", "polycor", "DescTools",
                   "DataExplorer", "remotes", "mice"),
                 dependencies = TRUE)


install.packages(c("readr"), dependencies = TRUE)

######@> Instalando pacotes do github...
remotes::install_github("Zelazny7/isofor")

######@> Carregando os pacotes para uso [Carregamento dos pacotes
######@> precisa ser feito sempre que quiser usar o mesmo]...
library(Hmisc)
library(dplyr)
library(tidyr)
library(lubridate)
library(stringr)
library(DataExplorer)
library(readxl)
library(ggplot2)
library(patchwork)
library(sf)
library(ggcorrplot)
library(ggmap)
library(leaflet)
library(imputeTS)
library(explore)
library(mlbench)
library(caret)
library(e1071)
library(naniar)
library(VIM)
library(corrplot)
library(FactoMineR)
library(factoextra)
library(randomForest)
library(xgboost)
library(ROCR)
library(missForest)
library(rpart)
library(MASS)
library(ROSE)
library(DescTools)
library(polycor)
library(DataExplorer)
library(isofor)
library(mice)

library(readr)

########################################################################
######@> 02. Importando a base de dados...

######@> Base de dados...
dados <- read_csv2("/home/dwandall/Documentos/Estudos/Análise Exploratória de Dados/Bases_de_dados_ver00/Churn_ver00.csv")

######@> Corringindo uso do decimal na coluna 'usage'
dados$usage <- as.numeric(gsub(",", ".", dados$usage))

######@> Verificando o carregamento dos dados...
View(dados)

######@> Descrevendo os dados importados...
describe_tbl(dados)

######@> Descrevendo os dados em função das suas métricas gerais...
plot_intro(dados)

######@> Visualizando a estrutura dos dados importados...
str(dados)

######@> Compreendendo os casos de dados perdidos...
plot_missing(dados)

######@> Procurando problemas de estrutura de digitação textual das
######@> variáveis categóricas - qualitativas...
dados %>%
    select_if(is.character) %>%
    Hmisc::describe()

######@> variáveis (verificando quantidade e diferenciação)
unique(dados$language)

summary(dados$price)
########################################################################
######@> 03. Faxinando os dados - Categóricos...

######@> Corrigindo os problemas de alguma variável com problema...Porém não foi encontrado nenhum # nolint

########################################################################
######@> 04. Imputando dados perdidos...

######@>----------------------------------------------------------------
######@> Detectando valores extremos (outliers)...

######@> [Método 01] Detecção de Outliers usando Boxplot...

#####@> Criando uma função para isto...
outliers_boxplot <- function(x) {
    Q1 <- quantile(x, 0.25, na.rm = TRUE)
    Q3 <- quantile(x, 0.75, na.rm = TRUE)
    IQR <- Q3 - Q1
    lower_bound <- Q1 - 1.5 * IQR
    upper_bound <- Q3 + 1.5 * IQR
    return(which(x < lower_bound | x > upper_bound))
}

#####@> Aplicando o método Boxplot...
outliers_bp <- outliers_boxplot(dados$usage)

####@> Visualizandos os outliers...
cat("Outliers detectados pelo método do Boxplot:", outliers_bp, "\n")

####@> Visualizando os outliers usando Boxplot [Gráfico]...
g_out <- ggplot(dados, aes(x = "", y = usage )) +
    geom_boxplot(outliers = FALSE) +
    geom_jitter(color = "red", width = 0.2,
                aes(color = usage %in%
                    usage [outliers_bp])) +
    labs(title = "Detecção de Outliers com Boxplot",
         x = "", y = "Uso",
         color = "Outlier")

ggsave("../src/public/graphics/outliers_boxplot.png", g_out, width = 8, height = 5)

######@> [Método 02] Detecção de Outliers usando Z-Score...

#####@> Função para aplicar o método...
outliers_zscore <- function(x) {
    z_scores <- (x - mean(x, na.rm = TRUE)) / sd(x, na.rm = TRUE)
    return(which(abs(z_scores) > 3))
}

#####@> Aplicando o método Z-Score...
outliers_zs <- outliers_zscore(dados$usage)

####@> Visualizandos os outliers...
cat("Outliers detectados pelo método Z-Score:", outliers_zs, "\n")

####@> Visualizando os outliers usando Z-Score [Gráfico]...
g_out <- ggplot(dados, aes(x = usage )) +
    geom_histogram(binwidth = 20, boundary = 20, fill = "blue",
                   alpha = 0.7, colour = "black",
                   closed = "right") +
    geom_vline(aes(xintercept = min(usage [outliers_zs])),
               color = "red", linetype = "dashed") +
    labs(title = "Detecção de Outliers com Z-Score",
         x = "", y = "Uso")

ggsave("src/public/graphics/outliers_boxplot.png", g_out, width = 8, height = 5)

######@> [Método 03] Detecção de Outliers usando Isolation Forest...

#####@> Selecionando somente os dados numéricos...
dados.num <- dados %>%
    select_if(is.numeric)

#####@> Aplicando o método Isolation Forest...
iso_forest <- iForest(dados.num, nt = 100)
iso_scores <- predict(iso_forest, dados.num)

####@> Considerando como outliers scores acima de 0.6...
outliers_iforest <- which(iso_scores > 0.6)

####@> Visualizandos os outliers...
cat("Outliers detectados pelo método Isolation Forest:", outliers_iforest, "\n")

####@> Visualizando os outliers usando Isolation Forest...
ggplot(dados, aes(x = usage , y = iso_scores)) +
    geom_point(aes(color = iso_scores > 0.6)) +
    labs(title = "Detecção de Outliers com Isolation Forest",
         x = "", y = "Isolation Score") +
    scale_color_manual(values = c("black", "red"),
                       name = "Outliers", labels = c("No", "Yes"))

######@>----------------------------------------------------------------
######@> Imputação de dados...

######@> Verificando os dados perdidos...
plot_missing(dados)

######@> [Método 01] Imputação pela média...

####@> visualizando...
dados$usage

####@> calculando a média...
mean(dados$usage, na.rm = TRUE)

####@> imputando...
dados$usage.imp01 <- na_mean(dados$usage)

####@> visualizando...
dados$usage[63]
dados$usage.imp01[63]

######@> [Método 02] Imputação pela mediana...

####@> visualizando...
dados$usage

####@> calculando a média...
mean(dados$usage, na.rm = TRUE)

####@> imputando...
dados$usage.imp02 <- ifelse(is.na(dados$usage),
                         median(dados$usage, na.rm = TRUE),
                         dados$usage)

####@> visualizando...
dados$usage[63]
dados$usage.imp01[63]
dados$usage.imp02[63]

########################################################################
######@> 05. Visualização Gráfica - Explorando Churn
########################################################################

# Criar pasta se não existir
if (!dir.exists("src/public/graphics")) dir.create("src/public/graphics", recursive = TRUE)

# Gráfico 1 - Boxplot de usage por churn
g1 <- ggplot(dados, aes(x = factor(churn), y = usage)) +
  geom_boxplot(fill = "skyblue") +
  labs(title = "Uso vs Churn", x = "Churn", y = "Uso")
ggsave("src/public/graphics/boxplot_usage_churn.png", g1, width = 8, height = 5)

# Gráfico 2 - Barras de churn por tipo
g2 <- ggplot(dados, aes(x = type, fill = factor(churn))) +
  geom_bar(position = "dodge") +
  labs(title = "Churn por Tipo de Plano", x = "Tipo de Plano", fill = "Churn")
ggsave("src/public/graphics/barplot_churn_type.png", g2, width = 8, height = 5)

# Gráfico 3 - Barras de churn por dispositivo
g3 <- ggplot(dados, aes(x = device, fill = factor(churn))) +
  geom_bar(position = "dodge") +
  labs(title = "Churn por Tipo de Dispositivo", x = "Dispositivo", fill = "Churn")
ggsave("src/public/graphics/barplot_churn_device.png", g3, width = 8, height = 5)

g4 <- ggplot(dados, aes(x = as.factor(churn), y = duration, fill = as.factor(churn))) +
  geom_boxplot() +
  scale_fill_manual(values = c("tomato", "turquoise")) +
  labs(
    title = "Duração por Churn",
    x = "Churn (0 = Não Cancelou, 1 = Cancelou)",
    y = "Duração (dias)"
  ) +
  theme_minimal()
ggsave("../graphics/boxplot_duration_churn.png", width = 8, height = 6)

########################################################################
######@> 06. Explorando a base de dados - Utilizando novas
######@> possibilidades...

######@> Vamos brincar com um pacote que otimiza nosso trabalho...
explore(dados)

######@> Podemos fazer um report completo da nossa base de dados...
dados %>% report(output_file = "report.html",
                 output_dir = tempdir())

######@> Descrevendo a base a partir de resumos estatísticos
######@> completos...
dados %>%
    describe() %>%
    as.data.frame()

g_out <- ggplot(dados, aes(x = factor(0), y = usage)) +
  geom_boxplot(outliers = FALSE) +
  geom_jitter(color = "red", width = 0.2,
              aes(alpha = usage %in% usage[outliers_bp])) +
  labs(title = "Detecção de Outliers com Boxplot", x = "", y = "Uso", alpha = "Outlier")
ggsave("src/public/graphics/outliers_boxplot.png", g_out, width = 8, height = 5)

ggplot(dados, aes(x = factor(newsletter), fill = factor(churn))) +
  geom_bar(position = "fill") +
  labs(title = "Churn por Newsletter", x = "Recebeu Newsletter?", fill = "Churn") +
  scale_x_discrete(labels = c("0" = "Não", "1" = "Sim"))

  g_dens <- ggplot(dados, aes(x = duration, fill = as.factor(churn))) +
  geom_density(alpha = 0.5) +
  scale_fill_manual(values = c("tomato", "turquoise"), 
                    name = "Churn", 
                    labels = c("0 = Não Cancelou", "1 = Cancelou")) +
  labs(title = "Distribuição de Duração por Status de Churn",
       x = "Duração (dias)", y = "Densidade") +
  theme_minimal()

ggsave("src/public/graphics/density_duration_churn.png", g_dens, width = 8, height = 5)

########################################################################
##
##                  Creative Commons License 4.0
##                       (CC BY-NC-SA 4.0)
##
##  This is a humam-readable summary of (and not a substitute for) the
##  license (https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode)
##
##  You are free to:
##
##  Share - copy and redistribute the material in any medium or format.
##
##  The licensor cannot revoke these freedoms as long as you follow the
##  license terms.
##
##  Under the following terms:
##
##  Attribution - You must give appropriate credit, provide a link to
##  license, and indicate if changes were made. You may do so in any
##  reasonable manner, but not in any way that suggests the licensor
##  endorses you or your use.
##
##  NonCommercial - You may not use the material for commercial
##  purposes.
##
##  ShareAlike - If you remix, transform, or build upon the material,
##  you must distributive your contributions under the same license
##  as the  original.
##
##  No additional restrictions — You may not apply legal terms or
##  technological measures that legally restrict others from doing
##  anything the license permits.
##
########################################################################