# Procedimento para construçãod a base principal
# bases auxiliares são necessárias (ver pasta bases auxiliares)

# Código dos municípios e Anos --------------------------------------------

## packages
require(tidyverse)

## relação de parques tecnológicos
PT <- read.csv2("https://raw.githubusercontent.com/RodrigoAnderle/Tese/master/ParquesGeral2016-%20Vers%C3%A3o%20Editada.csv", 
                header = T, encoding = "Latin-1")

### Extraindo código dos municípios
MUN <- PT %>% 
  group_by(MUN) %>% 
  summarise(n()) %>% 
  select(MUN) %>% 
  filter(!is.na(MUN)) 

### Iniciando Base de dados pinricpal
BASE <- data.frame(MUN = NA, ANO = NA)

#### adicionando período de análise de 1985 à 2016
for(i in 1:nrow(MUN)){
  temp <- cbind(MUN = rep(MUN[[1]][i], 32), ANO = 1985:2016)
  BASE <- rbind(BASE, temp)
} 
rm(temp, i, MUN) 

BASE <- BASE[-1,] #removendo NA's da 1ª linha



# Parques Tecnológicos ----------------------------------------------------

##Adicionando Fase de Instalação
### Ordenando estágios
PT$Fase <- factor(PT$Fase, levels = c("Operação", "Implantação", 
                                      "Projeto", "Indefinido"))

### Agrupando fases por municípios (sobrepondo fases de municípioc com mais de 1 parque)
PT1 <- PT %>% 
  group_by(MUN) %>% 
  summarise(Pqs = n(), Fase = min(as.integer(Fase))) %>% 
  mutate(Fase = factor(Fase, labels = c("Operação", "Implantação", 
                                        "Projeto", "Indefinido")))

### Adicionando fase do município na base principal
BASE$Fase <- NA
for( i in 1:nrow(PT1)){
  BASE$Fase[BASE$MUN == PT1$MUN[i]] <- as.character(PT1$Fase[i])
}


## Criando dummy para parques operacionais por ano de fundação
PT2 <- PT %>% 
  filter(Fase == "Operação") %>% 
  group_by(MUN, Cidade, Ano) %>% 
  summarise(Pqs = n()) %>% 
  arrange(Ano)  

### Adicionando dummy à Base Principal
BASE$Operacional <- 0
for(i in 1:nrow(PT2)){ # condição para parques sem ano de fundação (NA)
  if(is.na(PT2$Ano[i])){
    BASE$Operacional[BASE$MUN == PT2$MUN[i]] <- NA
    next 
  }
  if(any(BASE$MUN == PT2$MUN[i])){ 
    BASE$Operacional[BASE$MUN == PT2$MUN[i] & BASE$ANO >= PT2$Ano[i]] <- 1
  } # Adiciona a dummy a partir do ano de fundação do parque
}
rm(i)  

### Adicionando Idade do parque (soma cumulativa das dummies)
BASE$Idade_Parq_Ope <- ave(BASE$Operacional, BASE$MUN, FUN = cumsum)

### Adicionando idade descontinuada (não foi utilizada)
BASE$Disc_Parq_Ope <- 0
for(i in 1:nrow(PT2)){
  if(is.na(PT2$Ano[i])){
    BASE$Disc_Parq_Ope[BASE$MUN == PT2$MUN[i]] <- NA
    next # if there is no park move to next
  }
  if(any(BASE$MUN == PT2$MUN[i])){
    for(j in 1:32) # 32 = 2016 - 1985
      BASE$Disc_Parq_Ope[BASE$MUN == PT2$MUN[i] & BASE$ANO[j]] <- 
        BASE$ANO[BASE$MUN == PT2$MUN[i] & BASE$ANO[j]] - PT2$Ano[i]
  } # decresce o tempo negatiovamente até a fundação, depois cresce.
}
rm(i,j, PT1, PT2)

## Criando dummy para parques em implantação
PT2 <- PT %>% 
  filter(Fase == "Implantação") %>% 
  group_by(MUN, Cidade, Ano) %>% 
  summarise(Pqs = n()) %>% 
  arrange(Ano)  

### Adicionando à Base Principal
BASE$Implement <- 0
for(i in 1:nrow(PT2)){
  if(is.na(PT2$Ano[i])){
    BASE$Implement[BASE$MUN == PT2$MUN[i]] <- NA
    next # if there is no park move to next
  }
  if(any(BASE$MUN == PT2$MUN[i])){
    BASE$Implement[BASE$MUN == PT2$MUN[i] & BASE$ANO >= PT2$Ano[i]] <- 1
  } 
}
rm(i, PT2)  

### Adicionando idade do parque em implantação
BASE$Idade_Parq_Imp <- ave(BASE$Implement, BASE$MUN, FUN = cumsum)


## Criand dummy para parques em projeto
PT2 <- PT %>% 
  filter(Fase == "Projeto") %>% 
  group_by(MUN, Cidade, Ano) %>% 
  summarise(Pqs = n()) %>% 
  arrange(Ano)  # Municipalities with Parks in Project by year

### Adicionando dummy para parque em projeto
BASE$Project <- 0
for(i in 1:nrow(PT2)){
  if(is.na(PT2$Ano[i])){
    BASE$Project[BASE$MUN == PT2$MUN[i]] <- NA
    next # if there is no park move to next
  }
  if(any(BASE$MUN == PT2$MUN[i])){
    BASE$Project[BASE$MUN == PT2$MUN[i] & BASE$ANO >= PT2$Ano[i]] <- 1
  } # if there is a park in project set the dummy from the first 
  # year till the end
}
rm(i, PT2)  

### Adicionando idade do parque em projeto
BASE$Idade_Parq_Proj <- ave(BASE$Project, BASE$MUN, FUN = cumsum)

##Encerrando procedimento
rm(PT)


# Controles para Estados e Municípios -------------------------------------

## Estados
UF <- as.data.frame(rbind(
  c(11,"Rondônia","RO"),
  c(12,"Acre","AC" ),
  c(13,"Amazonas","AM"),
  c(14,"Roraima","RR" ),
  c(15,"Pará","PA" ),
  c(16,"Amapá","AP" ),
  c(17,"Tocantins","TO" ),
  c(21,"Maranhão","MA"),
  c(22,"Piauí","PI"),
  c(23,"Ceará","CE"),
  c(24,"Rio Grande do Norte","RN"),
  c(25,"Paraíba","PB"),
  c(26,"Pernambuco","PE" ),
  c(27,"Alagoas","AL"),
  c(28,"Sergipe","SE"),
  c(29,"Bahia","BA"),
  c(31,"Minas Gerais","MG"),
  c(32,"Espírito Santo","ES"),
  c(33,"Rio de Janeiro","RJ"),
  c(35,"São Paulo","SP"),
  c(41,"Paraná","PR"),
  c(42,"Santa Catarina","SC"),
  c(43,"Rio Grande do Sul","RS"),
  c(50,"Mato Grosso do Sul","MS"),
  c(51,"Mato Grosso","MT"),
  c(52,"Goiás","GO"),
  c(53,"Distrito Federal","DF")))
names(UF) <- c("Cod", "Estado", "UF")
UF$Cod <- as.integer(as.character(UF$Cod))

BASE$UF <- NA
for(i in 1:nrow(UF)){
  BASE$UF[BASE$MUN %/% 100000 == UF$Cod[i]] <- as.character(UF$UF[i])
}
rm(UF, i)

## Cidade de São Paulo
BASE$c_SP <- 0
BASE$c_SP[BASE$MUN == 3550308] <- 1

## Cidade do Rio de Janeiro
BASE$c_RJ <- 0
BASE$c_RJ[BASE$MUN == 3304557] <- 1

## Capitais
BASE$Capitais <- 0
BASE$Capitais[BASE$MUN %in%  c(1100205,1302603,1200401,5002704,1600303,5300108,
                               1400100,5103403,1721000,2211001,3550308,3304557,
                               1501402,2111300,5208707,2927408,2704302,4314902,
                               4106902,4205407,3106200,2304400,2611606,2507507,
                               2800308,2408102,3205309)] <- 1

# SISTEMA CIENTÍICO ------------------------------------------------------

# Universidades -----------------------------------------------------------

## Packages
require(tidyverse)
require(tm)
require(qdapRegex)

## Função para remover acentos
### baseada em: http://www.thomazrossito.com.br/retirar-acentos-de-um-data-frame-com-a-linguagem-r/
rm_accent <- function(str,pattern="all") {
  if(!is.character(str))
    str <- as.character(str)
  pattern <- unique(pattern)
  if(any(pattern=="Ç"))
    pattern[pattern=="Ç"] <- "ç"
  symbols <- c(
    acute = "áéíóúÁÉÍÓÚýÝ",
    grave = "àèìòùÀÈÌÒÙ",
    circunflex = "âêîôûÂÊÎÔÛ",
    tilde = "ãõÃÕñÑ",
    umlaut = "äëïöüÄËÏÖÜÿ",
    cedil = "çÇ"
  )
  nudeSymbols <- c(
    acute = "aeiouAEIOUyY",
    grave = "aeiouAEIOU",
    circunflex = "aeiouAEIOU",
    tilde = "aoAOnN",
    umlaut = "aeiouAEIOUy",
    cedil = "cC"
  )
  accentTypes <- c("´","`","^","~","¨","ç")
  if(any(c("all","al","a","todos","t","to","tod","todo")%in%pattern)) # opcao retirar todos
    return(chartr(paste(symbols, collapse=""), paste(nudeSymbols, collapse=""), str))
  for(i in which(accentTypes%in%pattern))
    str <- chartr(symbols[i],nudeSymbols[i], str)
  return(str)
} 

## Censos do Ensino superior de 1995 a 2016
UNIV <- read.csv2("Variáveis da Produção Científica/Universidades.csv", 
                  header = T) # base muito pesada para ser disponibilizada
UNIV$Nome <- as.character(UNIV$Nome)
UNIV$NO_AREA_CONHE <- as.character(UNIV$NO_AREA_CONHE)
UNIV$Ano <- UNIV$Ano - 1 # the data is in respect to the year before
BASE$Município <- BASE$MUN %/% 10 # added variable for codification reasons

### Universidades por municípios

Universities <- UNIV %>% 
  rename(ANO = Ano) %>% 
  group_by(Município, ID, ANO) %>% 
  summarise(Cursos = n()) %>% 
  group_by(Município, ANO) %>% 
  summarise(Universidades = n())

BASE <- merge(BASE, Universities,by = c("Município", "ANO"), all.x = T)
rm(Universities)

### Quantidade de cursos disponíveis por municípios
Courses <- UNIV %>% 
  rename(ANO = Ano) %>% 
  group_by(Município, CD_CURSO, ANO) %>% 
  summarise(Freq = n()) %>% 
  group_by(Município, ANO) %>% 
  summarise(Cursos = n())

BASE <- merge(BASE, Courses,by = c("Município", "ANO"), all.x = T)
rm(Courses)

### Quantidade de alunos graduados
Graduates <- UNIV %>% 
  rename(ANO = Ano) %>% 
  group_by(Município, ANO) %>% 
  summarise(Graduated = sum(Diplomados))#verificar

BASE <- merge(BASE, Graduates,by = c("Município", "ANO"), all.x = T)
rm(Graduates)

### Graduações específicas

#### Limpeza de texto
#####  baseado em: https://anderlerv.netlify.com/web-scraping-das-contribui%C3%A7%C3%B5es-dos-vencedores-do-nobel-em-economia/10/2019/
UNIV$NO_CURSO <- rm_accent(UNIV$NO_CURSO) 
UNIV$NO_CURSO <- rm_non_words(UNIV$NO_CURSO) 
UNIV$NO_CURSO <- removePunctuation(UNIV$NO_CURSO)
UNIV$NO_CURSO <- removeNumbers(UNIV$NO_CURSO)
UNIV$NO_CURSO <- stripWhitespace(UNIV$NO_CURSO)
UNIV$NO_CURSO <- tolower(UNIV$NO_CURSO)


#### Engenharia
Engineering <- UNIV %>% 
  filter(str_detect(NO_CURSO, "engenharia")) %>% 
  rename(ANO = Ano) %>% 
  group_by(Município, ANO) %>% 
  summarise(Engenheiros_Grad = sum(Diplomados), Cursos_Eng = n())

BASE <- merge(BASE, Engineering,by = c("Município", "ANO"), all.x = T)
rm(Engineering)

#### Saúde
HEALTH <- UNIV %>% 
  filter(str_detect(NO_CURSO, c("saude"))) %>% 
  rename(ANO = Ano) %>% 
  group_by(Município, ANO) %>% 
  summarise(Saude_Grad = sum(Diplomados), Cursos_Saude = n())

BASE <- merge(BASE,HEALTH,by = c("Município", "ANO"), all.x = T)
rm(HEALTH)

#### Medicina
DOCTOR <- UNIV %>% 
  filter(str_detect(NO_CURSO, "^medicina$")) %>% 
  rename(ANO = Ano) %>% 
  group_by(Município, ANO) %>% 
  summarise(Medicos_Grad = sum(Diplomados), Cursos_Med = n())

BASE <- merge(BASE,DOCTOR,by = c("Município", "ANO"), all.x = T)
rm(DOCTOR)

#### Ciências da Computação
COMPSCIENC <- UNIV %>% 
  filter(str_detect(NO_CURSO, "computacao") |
           str_detect(NO_CURSO, "informacao")|
           str_detect(NO_CURSO, "informatica")) %>% 
  rename(ANO = Ano) %>% 
  group_by(Município, ANO) %>% 
  summarise(CompScience_Grad = sum(Diplomados), Cursos_CS = n())

BASE <- merge(BASE,COMPSCIENC,by = c("Município", "ANO"), all.x = T)
rm(COMPSCIENC)

#### Tecnologia
TECHNOLOGY <- UNIV %>% 
  filter(str_detect(NO_CURSO, "tecnologia")) %>% 
  rename(ANO = Ano) %>% 
  group_by(Município, ANO) %>% 
  summarise(Tecnologia_Grad = sum(Diplomados), Cursos_Tec = n())

BASE <- merge(BASE,TECHNOLOGY,by = c("Município", "ANO"), all.x = T)
rm(TECHNOLOGY)
#Obs.: several courses are overlapping. Technology and computer science
#are very similar in several cases.

##encerrando etapa
rm(UNIV, rm_accent)


# Número de Publicações ------------------------------------------------------------

## Lista de Municípios
PT <- read.csv2("https://raw.githubusercontent.com/RodrigoAnderle/Tese/master/ParquesGeral2016-%20Vers%C3%A3o%20Editada.csv", 
                header = T, encoding = "Latin-1")
PT2 <- PT %>% 
  select(MUN) %>%
  mutate(MUN = MUN %/% 10) %>% 
  group_by(MUN) %>% 
  summarise(Qtd = n()) %>% 
  filter(!is.na(MUN)) 
PT2 <- as.vector(PT2$MUN)

## Rotina para leitura de arquivos
# ver README Bases Auxiliares
Folder <- "Variáveis da Produção Científica/WoS/"  # Caminho para pasta com arquivos
Temp <- data.frame(Município = NA, ANO = NA, PUB = NA, PUB.Prop.Tot = NA)

for(i in 1:length(PT2)){
  File <- paste(Folder, PT2[i], "/Production.txt", sep = "")
  Temp2 <- read.table(File,head = F, sep = "", skip = 1,
                      nrows = length(readLines(File))-2)
  colnames(Temp2) <- c("ANO", "PUB", "PUB.Prop.Tot")
  Temp2$"Município" <- PT2[i] #Adicionando Municípios
  Temp <- rbind(Temp, Temp2)
  rm(Temp2)
}

BASE <- merge(BASE,Temp,by = c("Município", "ANO"), all.x = T)
rm(Temp,i,PT,PT2)

# SISTEMA PRODUTIVO -------------------------------------------------------

# Quocientes Locacionais --------------------------------------------------
#Grupos CNAE: https://concla.ibge.gov.br/busca-online-cnae.html?view=estrutura

## Carregando e limpando base de dados
QL <- read.csv2("Variáveis Produtivas/InformaçõesLocacionais.csv",
                header = T)
QL <- QL[-1,]
QL <- filter(QL,!is.na(Grupo))
QL$CNAE_G <- paste("CNAE_G-",QL$Grupo, sep = "")

## Quociente Locacional de cada município para cada grupo CNAE
QLCNAE <- QL %>% 
  select(Município,Ano, CNAE_G, QL) %>% 
  rename(ANO = Ano) %>% 
  mutate(CNAE_G = paste("QL_", CNAE_G, sep = "")) %>% 
  spread(CNAE_G, QL) 

BASE <- merge(BASE,QLCNAE,by = c("Município", "ANO"), all.x = T)
rm(QLCNAE)

## Gini Locacional
GINILCNAE <- QL %>% 
  select(Município,Ano, CNAE_G, Gini) %>%
  rename(ANO = Ano) %>%
  mutate(CNAE_G = paste("GiniL_", CNAE_G, sep = "")) %>% 
  spread(CNAE_G, Gini)

BASE <- merge(BASE,GINILCNAE,by = c("Município", "ANO"), all.x = T)
rm(GINILCNAE)

## Quantidade de firmas por grupo CNAE
EmpCNAE <- QL %>% 
  select(Município,Ano, CNAE_G, N.Empresas) %>%
  rename(ANO = Ano) %>%
  mutate(CNAE_G = paste("Emp_", CNAE_G, sep = "")) %>% 
  spread(CNAE_G, N.Empresas) 

BASE <- merge(BASE,EmpCNAE,by = c("Município", "ANO"), all.x = T)
rm(EmpCNAE)

##End
rm(QL)

# SETOR EXTERNO -----------------------------------------------------------

## Pacotes
require(deflateBR) # pacote para deflacionar série
require(blscrapeR) # pacote para carregar taxas de inflação

## Bases
### Taxa média de câmbio
CAMBIO <- read.csv2(
  "Variáveis Produtivas/Setor Externo/Câmbio - Preço Médio.csv",
  header = T)
names(CAMBIO) <- c("ANO", "TaxaCambio")
CAMBIO <- CAMBIO[CAMBIO$ANO >= 1997 & CAMBIO$ANO <= 2016,]
#### Deflator em dólar
US <- inflation_adjust(2016)
US <- US[US$year >= 1997 & US$year <= 2016,]
#### Deflacionando taxa de câmbio em dólar
CAMBIO$TaxaCambio_Def <- CAMBIO$TaxaCambio / US$adj_value

### Deflacionando taxa de câmbio em reais
Anos <- as.Date(as.character( paste(CAMBIO$ANO,"/12/31", sep = "")))
CAMBIO$TaxaCambio_Def <- ipca(CAMBIO$TaxaCambio_Def, Anos, "12/2016")
rm(Anos)

### Municípios IBGE (para identificação por nome)
MUN <- read.csv2(
  "Variáveis Produtivas/Setor Externo/RELATORIO_DTB_BRASIL_MUNICIPIO.csv",
  header = T)
MUN <- MUN[,-(10:15)]

### Estados
UF <- as.data.frame(rbind(
  c(11,"Rondônia","RO"),
  c(12,"Acre","AC" ),
  c(13,"Amazonas","AM"),
  c(14,"Roraima","RR" ),
  c(15,"Pará","PA" ),
  c(16,"Amapá","AP" ),
  c(17,"Tocantins","TO" ),
  c(21,"Maranhão","MA"),
  c(22,"Piauí","PI"),
  c(23,"Ceará","CE"),
  c(24,"Rio Grande do Norte","RN"),
  c(25,"Paraíba","PB"),
  c(26,"Pernambuco","PE" ),
  c(27,"Alagoas","AL"),
  c(28,"Sergipe","SE"),
  c(29,"Bahia","BA"),
  c(31,"Minas Gerais","MG"),
  c(32,"Espírito Santo","ES"),
  c(33,"Rio de Janeiro","RJ"),
  c(35,"São Paulo","SP"),
  c(41,"Paraná","PR"),
  c(42,"Santa Catarina","SC"),
  c(43,"Rio Grande do Sul","RS"),
  c(50,"Mato Grosso do Sul","MS"),
  c(51,"Mato Grosso","MT"),
  c(52,"Goiás","GO"),
  c(53,"Distrito Federal","DF")))
names(UF) <- c("Cod", "Estado", "UF")
UF$Cod <- as.integer(as.character(UF$Cod))

# Exportações -------------------------------------------------------------
EXP <- read.csv2(
  "Variáveis Produtivas/Setor Externo/EXP_1997_2016_20200303.csv",
  header = T, encoding = "UTF-8")
EXP$Município <- as.character(EXP$Município)

## Separando nome do Município e UF
EXP$uf <- NA
EXP$uf <- matrix(unlist(strsplit(EXP$Município, " - ", fixed = T)), 
                 ncol = 2, byrow = T)[,2]
EXP$UF <- NA
for(i in 1:nrow(EXP)){
  if(!any(EXP$uf[i] == UF$UF)) next
  EXP$UF[i] <- UF[EXP$uf[i] == UF$UF,1] #Adicionando código do UF
}
EXP$Município <- matrix(unlist(strsplit(EXP$Município, " - ", fixed = T)), 
                        ncol = 2, byrow = T)[,1]
if(any(EXP$Município == "Mogi-Mirim")){
  EXP$Município[EXP$Município == "Mogi-Mirim"] <- "Mogi Mirim"
}

## Inserindo Códigos dos municípios
EXP$MUN <- NA
for(i in 1:nrow(EXP)){
  if(!any(EXP$Município[i] == MUN$Nome_Município)) next
  EXP$MUN[i] <- MUN$Código.Município.Completo[
    EXP$Município[i] == MUN$Nome_Município & EXP$UF[i] == MUN$UF]
}
rm(i)

## Convertendo valores em Reais
Anos <- 1997:2016
EXP$Exp_FOB_BR <- NA
for(i in 1:length(Anos)){
  EXP$Exp_FOB_BR[EXP$X.U.FEFF.Ano == Anos[i]] <-
    EXP$Valor.FOB..US..[EXP$X.U.FEFF.Ano == Anos[i]] *
    CAMBIO$TaxaCambio_Def[CAMBIO$ANO == Anos[i]]
}
rm(i, Anos)

## Valor médio das exportações por quilo
EXP$Exp_Kg <- EXP$Exp_FOB_BR / EXP$Quilograma.Líquido

##Ajustes finais da Base
EXP <- EXP %>% 
  rename(ANO = X.U.FEFF.Ano, Cidade = Município,
         Exp_Peso = Quilograma.Líquido) %>% 
  select(MUN, ANO, Exp_FOB_BR, Exp_Kg, Exp_Peso)

## Agrupando à Base
BASE <- merge(BASE, EXP, by = c("MUN", "ANO"), all.x = T)
rm(EXP)


# Importações -------------------------------------------------------------

IMP <- read.csv2(
  "Variáveis Produtivas/Setor Externo/IMP_1997_2016_20200303.csv",
  header = T, encoding = "UTF-8")
IMP$Município <- as.character(IMP$Município)

## Separando nome do Município e UF
IMP$uf <- NA
IMP$uf <- matrix(unlist(strsplit(IMP$Município, " - ", fixed = T)), 
                 ncol = 2, byrow = T)[,2]
IMP$UF <- NA
for(i in 1:nrow(IMP)){
  if(!any(IMP$uf[i] == UF$UF)) next
  IMP$UF[i] <- UF[IMP$uf[i] == UF$UF,1] #Adicionando código do UF
}
IMP$Município <- matrix(unlist(strsplit(IMP$Município, " - ", fixed = T)), 
                        ncol = 2, byrow = T)[,1]

## Inserindo Códigos dos municípios
IMP$MUN <- NA
for(i in 1:nrow(IMP)){
  if(!any(IMP$Município[i] == MUN$Nome_Município)) next
  IMP$MUN[i] <- MUN$Código.Município.Completo[
    IMP$Município[i] == MUN$Nome_Município & IMP$UF[i] == MUN$UF]
}
rm(i)

## Convertendo valores em Reais
Anos <- 1997:2016
IMP$IMP_FOB_BR <- NA
for(i in 1:length(Anos)){
  IMP$IMP_FOB_BR[IMP$X.U.FEFF.Ano == Anos[i]] <-
    IMP$Valor.FOB..US..[IMP$X.U.FEFF.Ano == Anos[i]] *
    CAMBIO$TaxaCambio_Def[CAMBIO$ANO == Anos[i]]
}
rm(i, Anos)

## Valor médio das exportações por quilo
IMP$IMP_Kg <- IMP$IMP_FOB_BR / IMP$Quilograma.Líquido

##Ajustes finais da Base
IMP <- IMP %>% 
  rename(ANO = X.U.FEFF.Ano, Cidade = Município,
         IMP_Peso = Quilograma.Líquido) %>% 
  select(ANO, MUN, IMP_FOB_BR, IMP_Kg, IMP_Peso) 

## Agrupando à Base
BASE <- merge(BASE,IMP,by = c("MUN", "ANO"), all.x = T)
rm(IMP)

# CNAES específicas (P&D) -------------------------------------------------

## Consultorias e Diversidade de CNAES
CNAE <- read.csv2("Variáveis Produtivas/CNAE.Específicas.csv", 
                  header = T)
CNAE <- CNAE %>% 
  rename(CNAE.Divers = Diversidade) %>% 
  mutate(MUN = MUN %/% 10, ) %>% 
  rename(Município = MUN, ANO = Ano)

BASE <- merge(BASE,CNAE,by = c("Município", "ANO"), all.x = T)
rm(CNAE)

# RAIS Vínculos -----------------------------------------------------------

##packages
require(deflateBR)

##Configurações para o FOR
PATH <- "Variáveis Sócio-econômicas/RAIS_B/"
Anos <- 2002:2016
VINC <- data.frame()

## For para leitura da Massa Salarial (arquivos independentes - muito pesado)
VINC <- data.frame()
for(i in 1:length(Anos)){
  FILE <- paste(PATH,"RAIS_MASSA_SALARIAL_", Anos[i],".csv", sep = "")
  Temp <- read.csv2(FILE, header = T, nrows = length(readLines(FILE))-7)
  Temp$ANO <- Anos[i]
  VINC <- rbind(VINC, Temp)
  rm(Temp)
}
names(VINC) <- c("Município", "Massa_Salarial","ANO")

### Corrigindo Inflação   (deflateBR)
Anos2 <- as.Date(as.character( paste(VINC$ANO,"/12/31", sep = "")))
VINC$Massa_Salarial <- ipca(VINC$Massa_Salarial, Anos2, "12/2016")

### merge
BASE <- merge(BASE,VINC,by = c("Município", "ANO"), all.x = T)
rm(VINC, Anos2)

## For para CBOs (Ocupações por Grande Grupo)
VINC <- data.frame(Município = NA, CBO_GG1 = NA, CBO_GG2 = NA, CBO_GG3 = NA,
                   CBO_GG4 = NA, CBO_GG5 = NA, CBO_GG6 = NA, CBO_GG7 = NA,
                   CBO_GG8 = NA, CBO_GG9 = NA, CBO_GGNC = NA, ANO = NA)
for(i in 1:length(Anos)){
  FILE <- paste(PATH,"RAIS_GG_CBO_", Anos[i],".csv", sep = "")
  Temp <- read.csv2(FILE, header = T, nrows = length(readLines(FILE))-18,
                    skip = 1 )
  if(Anos[i] == 2002){
    Temp <- Temp[,-3]
    colnames(Temp) <- c("Município", "CBO_GGNC")
    Temp$CBO_GG1 <- Temp$CBO_GG2 <- 
      Temp$CBO_GG3 <- Temp$CBO_GG4 <- Temp$CBO_GG5 <- Temp$CBO_GG6 <- 
      Temp$CBO_GG7 <- Temp$CBO_GG8 <- Temp$CBO_GG9 <- NA
  } else {
    Temp <- Temp[,-12]
    colnames(Temp) <- c("Município", "CBO_GG1", "CBO_GG2", "CBO_GG3",
                        "CBO_GG4", "CBO_GG5", "CBO_GG6", "CBO_GG7",
                        "CBO_GG8", "CBO_GG9", "CBO_GGNC")
  }
  Temp$ANO <- Anos[i]
  VINC <- rbind(VINC, Temp)
  rm(Temp)
}

## merge
BASE <- merge(BASE,VINC,by = c("Município", "ANO"), all.x = T)
rm(VINC, FILE, i, PATH)


# SISTEMA TÉCNICO ---------------------------------------------------------

##packages
require(tidyverse)

# Engenheiros e responsáveis por P&D trabalhando --------------------------
# (CBOs específicas)
## Lista de Municípios com Parques
PT <- read.csv2("https://raw.githubusercontent.com/RodrigoAnderle/Tese/master/ParquesGeral2016-%20Vers%C3%A3o%20Editada.csv", 
                header = T, encoding = "Latin-1")
PT2 <- PT %>% 
  select(MUN) %>%
  mutate(MUN = MUN %/% 10) %>% 
  group_by(MUN) %>% 
  summarise(Qtd = n()) %>% 
  filter(!is.na(MUN)) 
PT2 <- as.vector(PT2$MUN)
rm(PT)

## Rotina para leitura de Arquivos
Folder <- "Variáveis Produtivas/CBOs/"
Ano <- 1985:2016
Temp <- data.frame(Município = NA, ANO = NA, PeD.94 = NA, 
                   PeD = NA, Engenheiros = NA)
### For para leitura das bases
for(i in 1:length(Ano)){
  File <- paste(Folder,"R&D_CBOs_",Ano[i], ".csv", sep = "")
  
  if(Ano[i] < 2003){
    Temp2 <- read.table(File,head = T, sep = ";", skip = 1,
                        nrows = length(readLines(File))-20)
    Temp2 <- Temp2 %>% 
      rename(PeD.94 = 
               Gerentes.de.produção..de.planejamento.e.de.pesquisa.e.desenvolvimento) %>% 
      mutate(ANO = Ano[i], Engenheiros = (Total - PeD.94), PeD = NA) %>% 
      select(Município, ANO, PeD.94,PeD, Engenheiros)
  }
  
  if (Ano[i] > 2002) {
    Temp2 <- read.table(File, head = T, sep = ";", skip = 1,
                        nrows = length(readLines(File))-24)
    Temp2 <- Temp2 %>% 
      mutate(Engenheiros =  ENGENHEIROS.MECATRONICOS + 
               ENGENHEIROS.EM.COMPUTACAO + ENGENHEIROS.CIVIS.E.AFINS +                     
               ENGENHEIROS.ELETROELETRONICOS.E.AFINS +         
               ENGENHEIROS.MECANICOS +  ENGENHEIROS.QUIMICOS +                          
               ENGENHEIROS.METALURGISTAS.E.DE.MATERIAIS +      
               ENGENHEIROS.DE.MINAS +                          
               ENGENHEIROS.AGRIMENSORES.E.ENGENHEIROS.CARTOGRAFOS +
               ENGENHEIROS.INDUSTRIAIS..DE.PRODUCAO.E.SEGURANCA +
               ENGENHEIROS.AGROSSILVIPECUARIOS,
             PeD = TECNICOS.DE.APOIO.EM.PESQUISA.E.DESENVOLVIMENTO +
               DIRETORES.DE.PESQUISA.E.DESENVOLVIMENTO + 
               GERENTES.DE.PESQUISA.E.DESENVOLVIMENTO,
             ANO = Ano[i], PeD.94 = NA) %>% 
      select(Município, ANO, PeD.94, PeD,  Engenheiros)
  }
  
  
  ### Filtrando municípios com Parques
  Temp2 <- Temp2[PT2 %in% Temp2$Município,]
  
  ### Juntando anos
  Temp <- rbind(Temp, Temp2)
  
} #fim do For
rm(Temp2, i, PT2, File, Folder, Ano)

## Juntando à base principal
BASE <- merge(BASE,Temp,by = c("Município", "ANO"), all.x = T)
rm(Temp)
gc(verbose = F)

# PIB e PIBpc -------------------------------------------------------------

##packages
require(deflateBR)
require(tidyverse)

## Lista de Municípios com Parques
PT <- read.csv2("ParquesGeral2016- Versão Editada.csv", header = T)
PT2 <- PT %>% 
  select(MUN) %>%
  mutate(MUN = MUN %/% 10) %>% 
  group_by(MUN) %>% 
  summarise(Qtd = n()) %>% 
  filter(!is.na(MUN)) 
PT2 <- as.vector(PT2$MUN)
rm(PT)

## Leitura dados

### 1999 - 2001
Temp <- read.csv2("Variáveis Produtivas/PIB_Municipal/PIB_1999-2001.csv",
                  head = T)

Temp <- Temp %>% 
  rename(ANO = ï..ano, Município = cod_munic) %>% 
  select(Município, ANO, pib, pib_pcap) %>% 
  mutate(Município = Município %/% 10)

Temp <- Temp[Temp$Município %in% PT2, ]

### 2002 - 2009 
Temp1 <- read.csv2("Variáveis Produtivas/PIB_Municipal/PIB_2002-2009.csv",
                   head = T)

Temp1 <- Temp1 %>% 
  rename(ANO = ï..Ano, Município = CÃ³digo.do.MunicÃ.pio,
         pib = Produto.Interno.Bruto...a.preÃ.os.correntes..R..1.000.,
         pib_pcap = Produto.Interno.Bruto.per.capita...a.preÃ.os.correntes..R..1.00.) %>% 
  select(Município, ANO, pib, pib_pcap) %>% 
  mutate(Município = Município %/% 10)

Temp1 <- Temp1[Temp1$Município %in% PT2, ]

### 2010 - 2017
Temp2 <- read.csv2("Variáveis Produtivas/PIB_Municipal/PIB_2010-2017.csv",
                   head = T)

Temp2 <- Temp2 %>% 
  rename(ANO = ï..Ano, Município = CÃ³digo.do.MunicÃ.pio,
         pib = Produto.Interno.Bruto...a.preÃ.os.correntes..R..1.000.,
         pib_pcap = Produto.Interno.Bruto.per.capita...a.preÃ.os.correntes..R..1.00.) %>% 
  filter(ANO < 2017) %>% 
  select(Município, ANO, pib, pib_pcap) %>% 
  mutate(Município = Município %/% 10)

Temp2 <- Temp2[Temp2$Município %in% PT2, ]

Temp3 <- rbind(Temp1, Temp2)
Temp <- rbind(Temp, Temp3)
rm(Temp1, Temp2, Temp3)

## Corrigindo Inflação   
Anos <- as.Date(as.character( paste(Temp$ANO,"/12/31", sep = "")))
Temp$pib <- ipca(Temp$pib, Anos, "12/2016")
Temp$pib_pcap <- ipca(Temp$pib_pcap, Anos, "12/2016")

BASE <- merge(BASE,Temp,by = c("Município", "ANO"), all.x = T)
rm(Temp, Anos)
gc(verbose = F)


# DEMANDA E ESTRUTURA SOCIAL ----------------------------------------------

# População ---------------------------------------------------------------

BASE$População <- as.integer((BASE$pib * 1000) / BASE$pib_pcap)
## É possível utilizar expandir para mais anos

# Salvando Base de Dados --------------------------------------------------

write.csv2(BASE, "Base_PT.csv", row.names = F)
rm(list = ls())
gc()
