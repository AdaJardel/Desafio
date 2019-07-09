# Desafio
SEMANTIX: 
Data  Science - Big Data & Analytics

09/07/2019


O referido repositório está relacionado ao desafio avaliativo para a vaga de cientista de dados na empresa Semantix. Para viabilidade dessa avaliação foi utilizado os dados da campanha de marketing de uma instituição bancária Portuguesa. Para maiores informações acessar a página https://archive.ics.uci.edu/ml/datasets/bank+marketing.

# Perguntas e Respostas
1) Qual profissão tem mais tendência a fazer um empréstimo? De qual tipo?
Resposta: O profissional da categoria operário (blue-collar) apresentou uma maior tendência à obtenção de algum tipo de empréstimo. Além disso, o empréstimo mais propenso a adesão da classe operária será referente à imóvel, em que 72% desses trabalhadores tem o empréstimo imobiliário e 17% tem o empréstimo pessoal.

2) Fazendo uma relação entre número de contatos e sucesso da campanha. Quais são os pontos relevantes a serem observados?
Resposta: De acordo com os resultados encontrados, teve-se uma relação exponencial decrescente entre o número de cliente que aderiu à proposta e a quantidade de ligações recebidas. Notou-se pelo grafico da curva que quanto mais ligacoes forem realizadas, menor será as chances de aceite da proposta pela campanha. Além disso, verificou-se que a partir de nove ligações houve uma similararidade quanto ao número de aceitação, e que esta tende a um, ou seja, não será necessário quantidades excessivas de ligações para conseguir à adesão do cliente. Adicionalmente, baseado na anàlise de variância e adequação do ajuste, se concluiu com 5% de significância, que houve indícios de influência da quantidade de contatos no sucesso da campanha. Em outras palavras, é necessário realizar ligações para se obter à adesão do cliente. 

3) Baseando-se nos resultados de adesão desta campanha qual o número médio e o máximo de ligações que você indica para otimizar a adesão?
Resposta: Segundo a descritiva dos dados apresentados, o mais indicado seria realizar, em média, duas ligações por cliente. Para a quantidade máxima de ligações, o mais indicado seria o total de 5 ligações por cliente, visto que esse número consegue retornar, com 5% de significância, uma boa aceitação dessa campanha de marketing. 

4) O resultado da campanha anterior tem relevância na campanha atual?
Resposta: Logo, obtido o p-valor < 0.05, pode-se dizer que rejeita-se a hipótese de nulidade ao nível de 5% de significância. Em outras palavras, há uma relação de dependência entre os resultados das campanhas atual e anterior, estatisticamente. Assim, procedimentos, ou condições oferecidas anteriormente, induzirão no resultado da campanha atual.

5) Qual o fator determinante para que o banco exija um seguro de crédito?
Resposta: Foi considerado como variável de interesse para avaliar se o cliente será bom pagador, ou não, o saldo médio anual (balance), visto que esse consegue explicar a movimentação financeira do cliente. Dessa forma, observou-se que para a exigência de um seguro de crédito bancário é necessário que se leve em consideração a idade desse.

6) Quais são as características mais proeminentes de um cliente que possua empréstimo imobiliário?
Resposta: Baseados na árvore de decisão, pode-se concluir com 5% de significância, que o perfil de uma pessoa com empréstimo imobiliário é um cliente que possue uma faixa etária inferior a 55 anos, é da categoria operária e tem um saldo médio anual negativo de 66 euros.

# Observações Relevantes
Para elaboração da análise foi utilizado o software R, o qual se fez uso dos pacotes ROC, hnp, lme4, latticeExtra, gridExtra, dplyr, caret e rattle. Apenas foi analisado os dados cedidos pela empresa a qual se destina esse relatório. 
Foram anexados desse repositório os seguintes documentos:
1)	O relatório técnico em PDF, o qual contém perguntas e respostas desse desafio.
2)	O banco de dados fornecido pela empresa Semantix, os quais foram nomeados na forma: bank.csv, bank-full.csv, bank-names.txt.
3)	Script em linguagem R para que possa ser reproduzido a quem interessar.

# Referências
[Moro et al., 2011] S. Moro, R. Laureano and P. Cortez. Using Data Mining for Bank Direct Marketing: An Application of the CRISP-DM Methodology. 
In P. Novais et al. (Eds.), Proceedings of the European Simulation and Modelling Conference - ESM'2011, pp. 117-121, Guimarães, Portugal, October, 2011. EUROSIS.
