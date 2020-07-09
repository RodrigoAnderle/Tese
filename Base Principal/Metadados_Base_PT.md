# Metadados Base Principal

Variável | Tipo | Descrição | Fonte
:------|:------:|:-------:|------:
Município | *Integer* | Código dos municípios. | Segue padrão IBGE com seis dígitos.
ANO | *Integer* | Ano de referêcia da informação, contempla os anos de 1985 a 2016. | Conforme identificação de cada base de dados.
MUN | *Integer* | Código dos municípios. | Segue padrão IBGE, este com sete dígitos. 
Fase | *Character* | Fase de instalação dos parques do município em questão. Há sobreposição dessa informação, com municípios com mais de um parque nele, em diferentes fases. Nesses casos é identificado a fase mais avançada, na seguinte ordem: *Operacional, Implantação, Projeto, Indefinido*. Em que a operacional é a mais avançada. | Segue descrição dada pela base [*ParquesGeral2016- Versão Editada.csv*](https://github.com/RodrigoAnderle/Tese/blob/master/ParquesGeral2016-%20Vers%C3%A3o%20Editada.csv)
Operacional | *Integer* | *Dummy* identificando se o município possuía um parque operacional naquele ano. | Segue descrição dada pela base [*ParquesGeral2016- Versão Editada.csv*](https://github.com/RodrigoAnderle/Tese/blob/master/ParquesGeral2016-%20Vers%C3%A3o%20Editada.csv)
Idade_Parq_Ope | *Integer* | Anos de existência do parque operacional naquele município específico | Segue descrição dada pela base [*ParquesGeral2016- Versão Editada.csv*](https://github.com/RodrigoAnderle/Tese/blob/master/ParquesGeral2016-%20Vers%C3%A3o%20Editada.csv)
Disc_Parq_Oper | *Integer* | Análogo a variável anterior, contudo, insere uma discontinuidade, sendo zero no ano de fundação do parque operacional, decrescendo negativamente nos anos anteriores, e, positivamente, nos anos seguintes | Segue descrição dada pela base [*ParquesGeral2016- Versão Editada.csv*](https://github.com/RodrigoAnderle/Tese/blob/master/ParquesGeral2016-%20Vers%C3%A3o%20Editada.csv)
Implement | *Integer* | *Dummy* identificando se o município tem um parque em fase de implantação | Segue descrição dada pela base [*ParquesGeral2016- Versão Editada.csv*](https://github.com/RodrigoAnderle/Tese/blob/master/ParquesGeral2016-%20Vers%C3%A3o%20Editada.csv)
Idade_Parq_Imp | *Integer* | Idade do parque em implantação em município e ano específicos | Segue descrição dada pela base [*ParquesGeral2016- Versão Editada.csv*](https://github.com/RodrigoAnderle/Tese/blob/master/ParquesGeral2016-%20Vers%C3%A3o%20Editada.csv)
Project | *Integer* | *Dummy* identificando se o município tem um parque em fase de projeto. |Segue descrição dada pela base [*ParquesGeral2016- Versão Editada.csv*](https://github.com/RodrigoAnderle/Tese/blob/master/ParquesGeral2016-%20Vers%C3%A3o%20Editada.csv)

Em processo
