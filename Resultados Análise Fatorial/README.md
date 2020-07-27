# Metadados Resultados Análise Fatorial

Aqui são descritos os metadados das bases que trazem diferentes recortes dos resultados obtidos pela análise fatorial aplicada com base nas variáveis da base principal.

## Capacidade explicativa do modelo (Explic.csv)

Variável | Coluna | Tipo | Descrição | Fonte
:--------|:------:|:----:|:----------|:-----
ANO | 1 | *Integer* | Ano calculado. | Resultado da análise fatorial aplicada no estudo.
Compnenete | 2 | *Factor* | Nome do componente. A quantidade de componentes varia conforme o tamanho da bases de dados sendo a menor dimensão entre linhas e colunas. Usualmente, será a dimensão das linhas (há menos municípios que variáveis). | Resultado da análise fatorial aplicada no estudo.
P_Explicado | 3 | *Numeric* | Percentual da variação explicada pelo componente | Resultado da análise fatorial aplicada no estudo.
Base | 4 | *Integer* | Identificação da base de dados utilizada no cálculo da análise fatorial. Em que: Base 1 > Base 2 > Base 3. | Resultado da análise fatorial aplicada no estudo.

## *Proxy* do Sistema de Inovação (IS.csv)

Variável | Coluna | Tipo | Descrição | Fonte
:--------|:------:|:----:|:----------|:-----
Município | 1 | *Integer* | Código do município de referência com seis dígitos. | Segue padrão IBGE.
Ano | 2 | *Factor* | Ano de referência para o cálculo na análise fatorial. | Resultado da análise fatorial aplicada no estudo.
Fator1 | 3 | *Numeric* | Resultado do componente principal calculado pela análise fatorial. Utilizado como *proxy* do sistema de inovação na pesquisa. | Resultado da análise fatorial aplicada no estudo.
Fator2 | 4 | *Numeric* | Resultado do segundo componente com maior explicação da variância, calculado pela análise fatorial. Não foi utilizado na pesquisa. | Resultado da análise fatorial aplicada no estudo.
Fator3 | 5 | *Numeric* | Resultado do terceiro componente com maior explicação da variância, calculado pela análise fatorial. Não foi utilizado na pesquisa. | Resultado da análise fatorial aplicada no estudo.
ECV | 6 | *Numeric* | Resultado do teste ECV para unidimensionalidae, sugerido por Ferrando e Lorenzo-Seva (2018). A análise pode ser considerada unidimensional, caso o valor identificado seja maior que 0,95. Não foi o caso em nenhum dos resultados. | Resultado da análise fatorial aplicada no estudo.
IREAL | 7 | *Numeric* | Resultado do teste IREAL para unidimensionalidae, sugerido por Ferrando e Lorenzo-Seva (2018). A análise pode ser considerada unidimensional, caso o valor identificado seja menor que 0,3. Não foi o caso em nenhum dos resultados. | Resultado da análise fatorial aplicada no estudo.
Base | 8 | *Integer* | Identificação da base de dados utilizada no cálculo da análise fatorial. Lembrando que: Base 1 > Base 2 > Base 3. | Resultado da análise fatorial aplicada no estudo.

## Contribuição das Variáveis (Var.csv)

Variável | Coluna | Tipo | Descrição | Fonte
:--------|:------:|:----:|:----------|:-----
Variavel | 1 | *Factor* | 212 variáveis utilizadas no cálculo da análise fatorial. | Base principal, disponível nesse repositório.
Ano | 2 | *Intger* | Ano de referência utilizado no cálculo da análise fatorial. | Recorte selecionado durante o estudo.
Fator1 | 3 | *Numeric* | Contribuições de cada variável para a composição do Fator1 (Componente Principal), utilizado como *proxy* do sistemas de inovações no estudo. Valores entre -1 e 1. | Recorte selecionado durante o estudo.
Fator2 | 4 | *Numeric* | Contribuições de cada variável para a composição do Fator2, não utilizada no estudo. Valores entre -1 e 1. | Recorte selecionado durante o estudo.
Fator3 | 5 | *Numeric* | Contribuições de cada variável para a composição do Fator3, não utilizada no estudo. Valores entre -1 e 1. | Recorte selecionado durante o estudo.
Base | 8 | *Integer* | Identificação da base de dados utilizada no cálculo da análise fatorial. Lembrando que: Base 1 > Base 2 > Base 3. | Resultado da análise fatorial aplicada no estudo.
