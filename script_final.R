###########################################################################
## Análise técnica - Semantix
## Desafio Data Science - Cientista de Dados
###########################################################################
rm(list=ls(all=TRUE))

###########################################################################
## Lendo o conjunto de dados
setwd("C:/Users/adaja/Desktop/Nova pasta/analise")
dados <- read.csv("bank_full.csv", header = T, sep = ";")
dados <- na.omit(dados)

dados$Y <- ifelse(dados$y=="no", 0, 1)
dados$Y <- as.numeric(dados$Y) 

dim(dados)
#View(dados)

###########################################################################
## Biblioteca utilizada
library(ggplot2)
library(ROCR)
library(hnp)
library(lme4)
library(latticeExtra)
library(ggpubr)
library(cowplot)
library(gridExtra) 
library(grid)
library(dplyr)
library(readr)
library(rpart)
library(rpart.plot)
library(rpartScore)
library(caret)
library(rattle)
library(ROCR)

###########################################################################
summary(dados)

###########################################################################
## Questao 1: Qual profissao tem mais tendencia a fazer um 
# emprestimo? De qual tipo?
###########################################################################
## Construindo e organizando as observacoes no conjunto novo
dad1 <- 
  dados[,] %>%  
  group_by(job,housing) %>%
  summarise(total_housing = length(housing))

dad2 <- 
  dados[,] %>%  
  group_by(job,loan) %>%
  summarise(total_loan = length(loan))

(resumo1 <- data.frame(dad1))
(resumo2 <- data.frame(dad2))

resumo1$housing <-  ifelse(resumo1$housing == "yes", "housing.yes",
                        "housing.no")
colnames(resumo1) <- c("job","type", "total")

resumo2$loan <- ifelse(resumo2$loan == "yes", "loan.yes", "loan.no")
colnames(resumo2) <-  c("job", "type", "total" )

# Novo conjunto de dados com os totais para cada classe
resumo <- rbind.data.frame(resumo1, resumo2)

## Fazendo o grafico
ggplot(data = resumo, aes(x = job, y = total, fill = type)) +
  geom_bar(stat = "identity", position = position_dodge())+
  geom_text(aes(label = total), vjust = 1.6, color = "black",
            position = position_dodge(0.9), size = 3.5)+
  scale_fill_manual(name = "Tipo",
    values = c("#CC3366", "#006699", "#999999",
                               "#00AFBB")) +
  theme_grey() +
  theme(legend.position="bottom") +
  labs(title = "Frequências entre o número de pessoas e profissões",
       subtitle="Considerando o tipo de empréstimo",
       y = "Totais",
       x = "Profissões")


## Confirmando os resultados pela arvore de classificacao
Mod1<- train(job ~ housing + loan, data = dados, method = "rpart")
fancyRpartPlot(Mod1$finalModel)


###########################################################################
## Questao 2: Fazendo uma relação entre número de contatos e 
# sucesso da campanha. Quais são os pontos relevantes a serem 
# observados?
###########################################################################
## Selecionando as observacoes que contem apenas resposta considerada
# sucesso, ou seja, Y = 1 (aderiu a proposta)
dad <- 
  dados[dados$Y==1,] %>%  
  group_by(campaign) %>%
  summarise(resp=sum(Y))

# Novo conjunto de dados 
(resumo2 <- data.frame(dad))

## Fazendo o grafico
ggplot(resumo2, aes(x = campaign, y = resp, group = 1)) +
  geom_point() +
  geom_smooth(method = loess, se = T) +
  geom_vline(xintercept = 9, linetype = "dashed", col = "red") +
  theme(legend.position = "right", legend.direction = "vertical") +
  labs(title="Gráfico entre número de contatos e número de clientes",
       subtitle = "Considerando o sucesso Y = 1",
       y = "Número de Clientes",
       x = "Número de Ligações") +
  theme_gray()

## Ajustando o modelo para saber se há influencia do numero de ligacoes
# no sucesso da campanha. Assim, segue-se a modelagem para o número de 
# clientes que aceitaram a proposta
ind <- seq(1:length(resumo2$resp))

# Modelo proposto
Mod2 <- glmer(resp ~ campaign + (1|ind), 
              data = resumo2, family = poisson)
summary(Mod2)

# Qualidade do ajuste para o modelo proposto
hnp(Mod2, verb.sim = T, paint.out = T, print.on = T)


###########################################################################
## Questao 3: Baseando-se nos resultados de adesão desta campanha
# qual o número médio e o máximo de ligações que você indica 
# para otimizar a adesão?
###########################################################################
# Separando apenas os que aderiram a campanha
sucesso <- dados[dados$Y == "1",]

# Resumo dos dados
summary(sucesso$campaign)
df <- data.frame(
  x = mean(sucesso$campaign),
  y0 = min(sucesso$campaign),
  y25 = quantile(sucesso$campaign, 0.25),
  y50 = median(sucesso$campaign),
  y75 = quantile(sucesso$campaign, 0.75),
  y100 = max(sucesso$campaign)
)

# Grafico do resumo
ggplot(df, aes(x)) +
  geom_boxplot(aes(ymin = y0, lower = y25, middle = y50, 
               upper = y75, ymax = y100), stat = "identity",
               fill = "lightblue") +
  theme_grey() 

# Achar os quantis para entender a probabilidade correspondente
quantile(sucesso$campaign, probs = seq(0,1, 0.01))

#Construindo o grafico referente a quantidade ideal para o numero de 
# ligacoes por cliente 
quant <- data.frame(quantile(sucesso$campaign, probs = seq(0,1, 0.01)))
p <- data.frame(NL = quant[,], prop = seq(0, 100, by = 1))

ggplot(p, aes(x = prop, y = NL, color = prop)) +
  geom_point(size = 2) +
  scale_color_gradient(low="red", high="blue") +
  theme(legend.position = "none") +
  geom_vline(xintercept = c(95,99), linetype = "dashed", col = "red") +
  geom_hline(yintercept = 5, linetype = "dashed", col = "red") +
  labs(title="Gráfico da proporção para o numero de ligações ",
       subtitle = "Considerando o sucesso Y = 1",
       y = "Número de Ligações",
       x = "Proporção") +
  geom_text(x = 95, y = 5, label = "95", col = "black", vjust = 1,
            hjust = 0, parse = T) +
  geom_text(x = 99, y = 9, label = "99", col = "black", vjust = -1,
            hjust = -.5, parse = T) +
  theme_gray()


###########################################################################
## Questao 4: O resultado da campanha anterior tem relevancia
# na campanha atual?
###########################################################################
# Construir uma tabela com os dados da campanha atual (CA) e 
# anterior (CP)
dad_camp <- data.frame(CP = dados$poutcome, CA = dados$y)

# Filtrar o data set com as observações inerentes as 
# campanhas estudadas
filtro <- ifelse(dad_camp$CP == "other" | dad_camp$CP == "unknown",
                 F, T)

# Selecionando apenas as campanhas do total  
camp <- dad_camp[filtro,]
camp <- data.frame(CP = factor(camp$CP), CA = factor(camp$CA))

# Constando as ocorrencias
table(camp)

# Realizando o teste do qui-quadrado, o qual tem as seguintes 
# hipoteses:
# 
# H_0: Os dados são independentes 
# H_a: Os dados não são independentes

(X_2<-chisq.test(table(camp)))


###########################################################################
## Questao 5: Qual o fator determinante para que o banco exija
# um seguro de credito?
###########################################################################
# Selecionando as variaveis referentes a possiveis movimentacoes
# bancarias
dadbank <- dados[, c(1:8)]
ind2 <- seq(1:length(dadbank$balance))

Mod5 <- glmer(balance ~ job + marital + age + education + default + housing +
               loan, data = dadbank, family = gaussian)
summary(Mod5)
hnp(Mod5,verb.sim = T,print.on = T,paint.out = T)

# Fazendo pela arvore de regressao
Mod5.1<- train(balance ~ ., data = dadbank, method = "rpart")
fancyRpartPlot(Mod5.1$finalModel)


###########################################################################
## Questao 6: Quais sao as caracteristicas mais proeminentes
# de um cliente que possua emprestimo imobiliario?
###########################################################################
## Fazendo a analise por meio modelo de regressao
# Transformando a variavel resposta em numerica para a modelagem
dados$h <- ifelse(dados$housing == "no", 0, 1)
dados$h <- as.numeric(dados$h) 

# Separando os dados em treino (60%) e teste (40%)
Train <- createDataPartition(dados$h, p=0.6, list=FALSE)
training <- dados[ Train, ]
testing <- dados[ -Train, ]

# Ajustando o modelo para verificar o que influencia um cliente ter 
# emprestimo imobiliario
train_control = trainControl(method="repeatedcv", number=5, repeats=5)
mod_fit <- train(h ~ age + balance + job + marital + education + default, 
                 data=training, method="glm", 
                 family="binomial", trControl=train_control)

# Validacao do modelo de regressao proposto
pred <- as.factor(ifelse(predict(mod_fit, newdata = testing) < 0.5, 0, 1))
ref <- as.factor(testing$h)
confusionMatrix(pred,ref)

# Curva ROC para o modelo de regressao proposto
prob <- predict(mod_fit, newdata = testing)
pred <- prediction(prob, testing$h)
perf <- performance(pred, measure = "tpr", x.measure = "fpr")
(auc <- performance(pred, measure = "auc") @ y.values[[1]])
plot(perf)


## Realizando a analise por meio da arvore de classificacao
Mod6<- train(housing ~ ., data = dadbank, method = "rpart")
fancyRpartPlot(Mod6$finalModel)

# validacao da arvore 
pred2 <- predict(Mod6, dadbank)
obs2 <- dadbank$housing
confusionMatrix(pred2,obs2)


###########################################################################
##           FIM DAS ANALISES DO DESAFIO DA SEMANTIX
# 
###########################################################################
library(rminer)
M <- mining(housing ~ age + balance + job + marital + 
              education + default,
            data = dadbank,
            Runs = 10)
summary(M)
mgraph(M, graph = "ROC", Grid = 10, baseline = F)
names(M)

M$attributes








