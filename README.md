# Tese

Este repositório traz as bases de dados utilizadas no desenvolvimento da tese de doutorado em economia pela UFBA, intitulada **Parques Tecnológicos no Brasil, um exercício de avaliação dos seus impactos nos municípios**. Tese de doutorado defendida em Julho de 2020 e disponibilizada no [repositório UFBA](https://repositorio.ufba.br/ri/handle/ri/32353)
A seguir, há uma breve descrição do que contempla cada uma das bases disponibilizadas aqui.

* **"Base_PT.csv"** - Base de dados com variáveis selecionadas, agregadas a nível municipal para todos os municípios identificados na relação "ParquesGeral2016- Versão Editada.csv".

* **"Explic.csv"** - Base com resultados da capacidade explicativa de cada um dos componentes, calculados na Análise Fatorial aplicada no estudo.

* **"IS.csv"** - Abreviação de *Innovation System*, resultado do componente principal calculado na Análise Fatorial aplicada no estudo que foi utilizada como *proxy* para o sistema local de inovação de cada município identificado na relação "ParquesGeral2016- Versão Editada.csv".

* **"ParquesGeral2016- Versão Editada.csv"** - Relação de parques tecnológicos brasileiros, disponibilizada através de consulta pública segundo lei de acesso à informação. Esta base foi editada conforme desdobramentos da pesquisa, a base original pode ser encontrada no link:  http://www.consultaesic.cgu.gov.br/busca/dados/Lists/Pedido/Attachments/516215/RESPOSTA_PEDIDO_Resposta%20PI%200904-2016%20PARQUES%20TECNOLGICOS-OUT2016%20-%20M%20V%20S.xls

* **"Var.csv"** - Contribuição de cada variável na constituição do componente principal (*proxy* para o sistema local de inovação).

# Metadados

Nesta seção constam apenas os metadados da base "ParquesGeral" que contém a relação de parques tecnológicos utilizada na pesquisa. Os outros metadados foram disponibilizados nas respectivas pastas identificadas na lista de arquivos do repositório.

## Metadados "ParquesGeral2016- Versão Editada.csv"

Variável | Coluna | Tipo | Descrição | Fonte
:-----:|:-----:|:-----:|:-----|:------
MUN | 1 | *Integer* | Código do município com sete dígitos em que o parque tecnológico está instalado. | Segue formato padrão IBGE.
Regiao | 2 | *Factor* | Nome das macroregiões dos municípios | Segue formato padrão IBGE.
UF | 3 | *Factor* | Abreviação do nome da unidade federativa do município | Segue formato padrão IBGE.
Cidade | 4 | *Factor* | Nome do município. | Segue formato padrão IBGE.
Nome | 5 | *Factor* | Nome do parque tecnológico. | Segue descrição dada pela [relação original](http://www.consultaesic.cgu.gov.br/busca/dados/Lists/Pedido/Attachments/516215/RESPOSTA_PEDIDO_Resposta%20PI%200904-2016%20PARQUES%20TECNOLGICOS-OUT2016%20-%20M%20V%20S.xls), complementada por pesquisa em referências e *websites*.
Site | 6 | *Factor* | Endereço do site na internet, quando identificado, do parque tecnológico | Segue descrição dada pela [relação original](http://www.consultaesic.cgu.gov.br/busca/dados/Lists/Pedido/Attachments/516215/RESPOSTA_PEDIDO_Resposta%20PI%200904-2016%20PARQUES%20TECNOLGICOS-OUT2016%20-%20M%20V%20S.xls), complementada por pesquisa.
Fase | 7 | *Factor* | Fase de instalação do parque tecnológico, podendo ser: "Operacional", "Implantação", "Projeto", "Indefinido". Na sequência da mais avançada a menos. | Segue descrição dada pela [relação original](http://www.consultaesic.cgu.gov.br/busca/dados/Lists/Pedido/Attachments/516215/RESPOSTA_PEDIDO_Resposta%20PI%200904-2016%20PARQUES%20TECNOLGICOS-OUT2016%20-%20M%20V%20S.xls), complementada por pesquisa.
Ano | 8 | *Integer* | Ano de fundação do parque tecnológico. | Segue descrição dada pela [relação original](http://www.consultaesic.cgu.gov.br/busca/dados/Lists/Pedido/Attachments/516215/RESPOSTA_PEDIDO_Resposta%20PI%200904-2016%20PARQUES%20TECNOLGICOS-OUT2016%20-%20M%20V%20S.xls), complementada por pesquisa.
Gestora | 9 | *Factor* | Nome da instituição responsável pela gestão do parque. | Segue descrição dada pela [relação original](http://www.consultaesic.cgu.gov.br/busca/dados/Lists/Pedido/Attachments/516215/RESPOSTA_PEDIDO_Resposta%20PI%200904-2016%20PARQUES%20TECNOLGICOS-OUT2016%20-%20M%20V%20S.xls).
Público | 10 | *Integer* | *Dummy* introduzida para identificar se o parque é uma iniciativa pública ou privada. | Essa informação foi baseada na variável Gestora e seu uso não é recomendado.
Universidade | 11 | *Integer* | *Dummy* introduzida para identificar se o parque é associado a uma universidade. | Essa informação foi baseada na variável Gestora e complementada por pesquisa, contudo, uso não é recomendado.
Contato | 12 | *Factor* | Telefones para contado com os parques tecnológicos. | Segue descrição dada pela [relação original](http://www.consultaesic.cgu.gov.br/busca/dados/Lists/Pedido/Attachments/516215/RESPOSTA_PEDIDO_Resposta%20PI%200904-2016%20PARQUES%20TECNOLGICOS-OUT2016%20-%20M%20V%20S.xls).
End | 13 | *Factor*| Endereço do parque tecnológico. | Segue descrição dada pela [relação original](http://www.consultaesic.cgu.gov.br/busca/dados/Lists/Pedido/Attachments/516215/RESPOSTA_PEDIDO_Resposta%20PI%200904-2016%20PARQUES%20TECNOLGICOS-OUT2016%20-%20M%20V%20S.xls).
CEP | 14 | *Integer*| Código postal do endereço em que o parque foi instalado. | Variável criada com base na informação dada pela variável "End".
