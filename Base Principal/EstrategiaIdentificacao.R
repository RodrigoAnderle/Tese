
# Estratégia de Identificação ---------------------------------------------

## Pacotes
require(plm)
require(tidyverse)
require(stargazer)


# Ajustes na base de dados ------------------------------------------------

## Base de dados
BASE <- read.csv2(
  "https://raw.githubusercontent.com/RodrigoAnderle/Tese/master/Base%20Principal/Base_PT.csv", 
  header = T,
  encoding = "Latin-1")

### Criando Idade Parques
BASE$Idade_p <- 0
for(i in 1:nrow(BASE)){
  BASE$Idade_p[i] <- ifelse(BASE$Idade_Parq_Ope[i] > 0, BASE$Idade_Parq_Ope[i],
                            BASE$Idade_Parq_Imp[i])
}
rm(i)

### Base com anos acima de 2003 e todos os parques
BASE1 <- BASE %>% 
  filter(ANO >= 2003)
BASE1$Graduated[BASE1$Graduated == 0] <- 1 #para logaritmizar sem dar problema
BASE1$PeD[BASE1$PeD == 0] <- 1 #para logaritmizar sem dar problema
BASE1$Consultorias[BASE1$Consultorias == 0] <- 1 #para logaritmizar sem dar problema
BASE1$Operacional <- as.integer(BASE1$Fase == "Operação")
Parques <- BASE1$MUN[BASE1$ANO == 2016]
BASE$B1 <- as.integer(BASE$MUN %in% Parques)
rm(Parques)

## Base com filtro diferenciado para parques
Parques <- BASE$MUN[BASE$ANO == 1997 & 
                      (BASE$Operacional == 0 & BASE$Implement == 0) &
                      BASE$Fase %in% c("Operação","Implantação")] 

Parques <- Parques[!is.na(Parques)]
BASE2 <- BASE[BASE$MUN %in% Parques & BASE$ANO >= 2003,]  
BASE2$Graduated[BASE2$Graduated == 0] <- 1 #para logaritmizar sem dar problema
BASE2$PeD[BASE2$PeD == 0] <- 1 #para logaritmizar sem dar problema
BASE2$Consultorias[BASE2$Consultorias == 0] <- 1 #para logaritmizar sem dar problema
BASE2$Operacional <- as.integer(BASE2$Fase %in% "Operação")

BASE$B2 <- as.integer(BASE$MUN %in% Parques)
rm(Parques)


# Matching ---------------------------------------------------------

## Logit
Match <- glm(Operacional ~  pib_pcap +
               Graduated + PUB +
               Consultorias +
               Idade_p +
               Capitais,
             family=binomial(link="logit"), data = BASE2[BASE2$ANO == 2003,])
summary(Match)

## Distribuição das probabilidades
data.frame(Probabilidade = predict(Match, type = "response")) %>% 
  ggplot(aes(Probabilidade)) +
  geom_histogram(binwidth = .05, alpha = .5, color = "black") +
  theme_bw() +
  geom_vline(xintercept = c(.25,.40), color = "grey", linetype = "dashed")
ggsave("Figuras/Ident_Hist_Prob.png")

## Seleção de municípios
a <- (BASE2$MUN[BASE2$ANO == 2016][predict(Match, type = "response") > .25 &
                                     predict(Match, type = "response") < .4])
table(BASE2$Fase[BASE2$ANO == 2016 & BASE2$MUN %in% a ])

### Inserindo dummy in base principal
BASE$B3 <- as.integer(BASE$MUN %in% a)
write.csv2(BASE, "Base Principal/Base_PT.csv", row.names = F)


## Gerando tabela para texto
stargazer(Match, 
          #ci = T,
          dep.var.caption = "Logit (dados de 2003)", 
          covariate.labels = c("PIBpc",
                               "Graduados", "Publicações", 
                               "Consultorias"),
          decimal.mark = ",",
          digit.separator = ".",
          type = "html",
          out = "Figuras/Tabela-Identificação_VariáveisCríticas.html")

## Criando BASE3
BASE3 <- BASE[BASE$MUN %in% a & BASE$ANO >= 2003,] 
BASE3$Operacional <- as.integer(BASE3$Fase == "Operação")
BASE3$Graduated[BASE3$Graduated == 0] <- 1 #para logaritmizar sem dar problema
BASE3$PeD[BASE3$PeD == 0] <- 1 #para logaritmizar sem dar problema
rm(a, BASE)


# Teste de diferença estatística em Regressão -----------------------------

## População
Pop1 <- plm(log(População) ~ Operacional*lag(log(População)) + lag(log(População)), 
            model = "within", 
            index = c("Município", "ANO"), data = BASE1)
summary(Pop1)

Pop2 <- plm(log(População) ~ Operacional*lag(log(População))+ lag(log(População)), 
            model = "within",
            index = c("Município", "ANO"), data = BASE2)
summary(Pop2)

Pop3 <- plm(log(População) ~ Operacional*lag(log(População))+ lag(log(População)), 
            model = "within",
            index = c("Município", "ANO"), data = BASE3)
summary(Pop3)

## PIB
PIB1 <- plm(log(pib) ~ Operacional*lag(log(pib)) + lag(log(pib)),
            model = "within",
            index = c("Município", "ANO"), data = BASE1)
summary(PIB1)

PIB2 <- plm(log(pib) ~ Operacional*lag(log(pib)) + lag(log(pib)),
            model = "within",
            index = c("Município", "ANO"), data = BASE2)
summary(PIB2)

PIB3 <- plm(log(pib) ~ Operacional*lag(log(pib)) + lag(log(pib)),
            model = "within",
            index = c("Município", "ANO"), data = BASE3)
summary(PIB3)

##PIBpc
PIBpc1 <- plm(log(pib_pcap) ~ Operacional*lag(log(pib_pcap)),
              model = "within",
              index = c("Município", "ANO"), data = BASE1)
summary(PIBpc1)

PIBpc2 <- plm(log(pib_pcap) ~ Operacional*lag(log(pib_pcap)),
              model = "within",
              index = c("Município", "ANO"), data = BASE2)
summary(PIBpc2)

PIBpc3 <- plm(log(pib_pcap) ~ Operacional*lag(log(pib_pcap)),
              model = "within",
              index = c("Município", "ANO"), data = BASE3)
summary(PIBpc3)

## Universiades
Univ1 <- plm(log(Universidades) ~ Operacional*lag(log(Universidades)), 
             model = "within",
             index = c("Município", "ANO"), data = BASE1)
summary(Univ1)

Univ2 <- plm(log(Universidades) ~ Operacional*lag(log(Universidades)), 
             model = "within",
             index = c("Município", "ANO"), data = BASE2)
summary(Univ2)

Univ3 <- plm(log(Universidades) ~ Operacional*lag(log(Universidades)), 
             model = "within",
             index = c("Município", "ANO"), data = BASE3)
summary(Univ3)

## Graduados --- problema com NaN/Inf
Grad1 <- plm(log(Graduated) ~ Operacional*lag(log(Graduated)), 
             model = "within", 
             index = c("Município", "ANO"), data = BASE1)
summary(Grad1)

Grad2 <- plm(log(Graduated) ~ Operacional*lag(log(Graduated)), 
             model = "within", 
             index = c("Município", "ANO"), data = BASE2)
summary(Grad2)

Grad3 <- plm(log(Graduated) ~ Operacional*lag(log(Graduated)), 
             model = "within", 
             index = c("Município", "ANO"), data = BASE3)
summary(Grad3)

## Engenheiros
Eng1 <- plm(log(Engenheiros) ~ Operacional*lag(log(Engenheiros)), 
            model = "within", 
            index = c("Município", "ANO"), data = BASE1)
summary(Eng1)

Eng2 <- plm(log(Engenheiros) ~ Operacional*lag(log(Engenheiros)), 
            model = "within", 
            index = c("Município", "ANO"), data = BASE2)
summary(Eng2)

Eng3 <- plm(log(Engenheiros) ~ Operacional*lag(log(Engenheiros)), 
            model = "within", 
            index = c("Município", "ANO"), data = BASE3)
summary(Eng3)

## P&D
PED1 <- plm(log(PeD) ~ Operacional*lag(log(PeD)), 
            model = "within", 
            index = c("Município", "ANO"), data = BASE1)
summary(PED1)

PED2 <- plm(log(PeD) ~ Operacional*lag(log(PeD)), 
            model = "within", 
            index = c("Município", "ANO"), data = BASE2)
summary(PED2)

PED3 <- plm(log(PeD) ~ Operacional*lag(log(PeD)), 
            model = "within", 
            index = c("Município", "ANO"), data = BASE3)
summary(PED3)

## Consultorias
Cons1 <- plm(log(Consultorias) ~ Operacional*lag(log(Consultorias)), 
             model = "within", 
             index = c("Município", "ANO"), data = BASE1)
summary(Cons1)

Cons2 <- plm(log(Consultorias) ~ Operacional*lag(log(Consultorias)), 
             model = "within", 
             index = c("Município", "ANO"), data = BASE2)
summary(Cons2)

Cons3 <- plm(log(Consultorias) ~ Operacional*lag(log(Consultorias)), 
             model = "within", 
             index = c("Município", "ANO"), data = BASE3)
summary(Cons3)

## Massa Salarial
Mass1 <- plm(log(Massa_Salarial) ~ Operacional*lag(log(Massa_Salarial)), 
             model = "within", 
             index = c("Município", "ANO"), data = BASE1)
summary(Mass1)

Mass2 <- plm(log(Massa_Salarial) ~ Operacional*lag(log(Massa_Salarial)), 
             model = "within", 
             index = c("Município", "ANO"), data = BASE2)
summary(Mass2)

Mass3 <- plm(log(Massa_Salarial) ~ Operacional*lag(log(Massa_Salarial)), 
             model = "within", 
             index = c("Município", "ANO"), data = BASE3)
summary(Mass3)

## Publicações
Pub1 <- plm(log(PUB) ~ Operacional*lag(log(PUB)), 
            model = "within", 
            index = c("Município", "ANO"), data = BASE1)
summary(Pub1)

Pub2 <- plm(log(PUB) ~ Operacional*lag(log(PUB)), 
            model = "within", 
            index = c("Município", "ANO"), data = BASE2)
summary(Pub2)

Pub3 <- plm(log(PUB) ~ Operacional*lag(log(PUB)), 
            model = "within", 
            index = c("Município", "ANO"), data = BASE3)
summary(Pub3)


# Tabela de Resultados ----------------------------------------------------

## Estrutura dos Municípios
stargazer(Pop1, Pop2, Pop3, PIB1, PIB2, PIB3, PIBpc1, PIBpc2, PIBpc3,
          Mass1, Mass2, Mass3,
          model.numbers = T,
          model.names = F,
          dep.var.labels.include = T,
          keep = "Operacional", 
          dep.var.caption = "Estrutura do Município", 
          covariate.labels = c("Operacional*População","Operacional*PIB",
                               "Operacional*PIBpc", 
                               "Operacional*Massa Salarial"),
          keep.stat = "n",
          decimal.mark = ",",
          digit.separator = ".",
          type = "html")


## Sistema Científico
stargazer(Univ1, Univ2, Univ3, Grad1, Grad2, Grad3, Pub1, Pub2, Pub3,
          model.numbers = T,
          model.names = F,
          dep.var.labels.include = T,
          keep = "Operacional", 
          dep.var.caption = "Sistema Científico",
          covariate.labels = c("Operacional*Universidades",
                               "Operacional*Graduados",
                               "Operacional*Publicações"),
          keep.stat = "n",
          decimal.mark = ",",
          digit.separator = ".",
          type = "html")

## Sistema Técnico
stargazer(Eng1, Eng2, Eng3, PED1, PED2, PED3, Cons1, Cons2, Cons3,
          model.numbers = T,
          model.names = F,
          dep.var.labels.include = T,
          keep = "Operacional", 
          dep.var.caption = "Sistema Técnico",
          covariate.labels = c("Operacional*Engenheiros",
                               "Operacional*P&D",
                               "Operacional*Consultorias"),
          flip = T,
          keep.stat = "n",
          decimal.mark = ",",
          digit.separator = ".",
          type = "html")



