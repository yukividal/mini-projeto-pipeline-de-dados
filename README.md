# mini-projeto-pipeline-de-dados
mini projeto de pipeline de dados do Programa Desenvolve da Boticário 
-- Por que uma planilha não é ideal para uma empresa que quer analisar suas vendas a fundo?
-- Resposta: uma planilha não é ideal, pois tem uma capacidade de armazenamento menor e limitado, escalabilidade menor e flexibilidade.   
-- Que tipo de perguntas vocês acham que o dono da livraria gostaria de responder com esses dados?
-- Resposta: Obter analise de faturamento diario, estoque, produtos mais vendidos, os não vendidos e padrão do consumidor.

-- Com base nos dados brutos, quais outras duas tabelas precisamos criar? Que colunas e tipos de dados elas teriam?
-- As tabelas de vendas e produtos.

-- Se o BigQuery não tem chaves estrangeiras, como garantimos que um ID_Cliente na tabela de vendas realmente existe na tabela de clientes?
-- Resposta: A responsabilidade é nossa, na hora de construir a consulta com o JOIN

-- Por que é uma boa prática inserir os clientes e produtos em suas próprias tabelas antes de inserir os dados de vendas?
-- Respostas: É uma boa pratica para evitar repetições e manter os dados organizados.

-- Em um cenário com milhões de vendas por dia, o INSERT INTO seria a melhor abordagem?
-- Resposta: Não, pode ser usado o carregamento em lote (Batch Load) e o Streaming.

-- Qual é a principal vantagem de usar uma VIEW em vez de simplesmente salvar o código em um arquivo de texto?
-- Resposta: Criar uma view para simplificar o acesso e automação. Uma VIEW no BigQuery é como salvar uma consulta complexa com um nome simples. 

-- Se o preço de um produto mudar na tabela Produtos, o Valor_Total na VIEW será atualizado automaticamente na próxima vez que a consultarmos?
-- Resposta: Sim, pois a View esta automatizada.



-- Este script cria a estrutura do schema no Google BigQuery.
-- Tabelas são criadas com `CREATE OR REPLACE TABLE` para permitir a execução repetida do script.
-- Lembre-se de substituir `seu-projeto.seu_dataset` pelo nome do seu projeto e dataset.

-- Tabela de Clientes
-- Armazena informações únicas de cada cliente.
-- No BigQuery, chaves primárias não são impostas, mas ID_Cliente serve como identificador lógico.
CREATE OR REPLACE TABLE `t1engenhariadados.Livraria_DevSaber_Grupo_3_9.Clientes` (
    ID_Cliente INT64,
    Nome_Cliente STRING,
    Email_Cliente STRING,
    Estado_Cliente STRING
);

-- Tabela de Produtos
-- Armazena informações únicas de cada produto.
CREATE OR REPLACE TABLE `t1engenhariadados.Livraria_DevSaber_Grupo_3_9.Produtos` (
    ID_Produto INT64,
    Nome_Produto STRING,
    Categoria_Produto STRING,
    Preco_Produto NUMERIC
);

-- Tabela de Vendas
-- Tabela de fatos que relaciona clientes e produtos, registrando cada transação.
-- As relações com Clientes e Produtos são lógicas, mantidas pelos campos de ID.
CREATE OR REPLACE TABLE `t1engenhariadados.Livraria_DevSaber_Grupo_3_9.Vendas` (
    ID_Venda INT64,
    ID_Cliente INT64,
    ID_Produto INT64,
    Data_Venda DATE,
    Quantidade INT64
);

-- Este script popula as tabelas criadas no BigQuery.
-- A cláusula VALUES é usada para inserir múltiplas linhas de uma vez.

-- Inserção de dados na tabela Clientes (sem duplicatas)
INSERT INTO `t1engenhariadados.Livraria_DevSaber_Grupo_3_9.Clientes` (ID_Cliente, Nome_Cliente, Email_Cliente, Estado_Cliente)
VALUES
    (1, 'Ana Silva', 'ana.s@email.com', 'SP'),
    (2, 'Bruno Costa', 'b.costa@email.com', 'RJ'),
    (3, 'Carla Dias', 'carla.d@email.com', 'SP'),
    (4, 'Daniel Souza', 'daniel.s@email.com', 'MG');

-- Inserção de dados na tabela Produtos (sem duplicatas)
INSERT INTO `t1engenhariadados.Livraria_DevSaber_Grupo_3_9.Produtos` (ID_Produto, Nome_Produto, Categoria_Produto, Preco_Produto)
VALUES
    (101, 'Fundamentos de SQL', 'Dados', 60.00),
    (102, 'Duna', 'Ficção Científica', 80.50),
    (103, 'Python para Dados', 'Programação', 75.00),
    (104, 'O Guia do Mochileiro', 'Ficção Científica', 42.00);

-- Inserção de dados na tabela Vendas
INSERT INTO `t1engenhariadados.Livraria_DevSaber_Grupo_3_9.Vendas` (ID_Venda, ID_Cliente, ID_Produto, Data_Venda, Quantidade)
VALUES
    (1, 1, 101, '2024-01-15', 1),
    (2, 2, 102, '2024-01-18', 1),
    (3, 3, 103, '2024-02-02', 2),
    (4, 1, 102, '2024-02-10', 1),
    (5, 4, 101, '2024-02-20', 1),
    (6, 2, 104, '2024-03-05', 1);

-- Este script contém as consultas para análise e a criação da VIEW.
-- Lembre-se de substituir `seu-projeto.seu_dataset` pelo nome do seu projeto e dataset.

-- ANÁLISE DE DADOS --

-- Pergunta 1: Qual o nome dos clientes que moram no estado de 'SP'?
SELECT Nome_Cliente, Estado_Cliente
FROM `t1engenhariadados.Livraria_DevSaber_Grupo_3_9.Clientes`
WHERE Estado_Cliente = 'SP';

-- Pergunta 2: Quais produtos pertencem à categoria 'Ficção Científica'?
SELECT Nome_Produto
FROM `t1engenhariadados.Livraria_DevSaber_Grupo_3_9.Produtos`
WHERE Categoria_Produto = 'Ficção Científica';

-- Pergunta 3: Listar todas as vendas, mostrando o nome do cliente, o nome do produto e a data da venda. Ordene pela data.
SELECT
    C.Nome_Cliente,
    P.Nome_Produto,
    V.Data_Venda
FROM `t1engenhariadados.Livraria_DevSaber_Grupo_3_9.Vendas` AS V
JOIN `t1engenhariadados.Livraria_DevSaber_Grupo_3_9.Clientes` AS C ON V.ID_Cliente = C.ID_Cliente
JOIN `t1engenhariadados.Livraria_DevSaber_Grupo_3_9.Produtos` AS P ON V.ID_Produto = P.ID_Produto
ORDER BY V.Data_Venda DESC;

-- Pergunta 4: Qual o valor total de cada venda? (quantidade * preço)
SELECT
    V.ID_Venda, P.Nome_Produto,
    (V.Quantidade * P.Preco_Produto) AS Valor_Total
FROM `t1engenhariadados.Livraria_DevSaber_Grupo_3_9.Vendas` AS V
JOIN `t1engenhariadados.Livraria_DevSaber_Grupo_3_9.Produtos` AS P ON V.ID_Produto = P.ID_Produto;


-- Pergunta 5: Qual o produto mais vendido em termos de quantidade?
SELECT
    P.Nome_Produto,
    SUM(V.Quantidade) AS Total_Quantidade_Vendida
FROM `t1engenhariadados.Livraria_DevSaber_Grupo_3_9.Vendas` AS V
JOIN `t1engenhariadados.Livraria_DevSaber_Grupo_3_9.Produtos` AS P ON V.ID_Produto = P.ID_Produto
GROUP BY P.Nome_Produto
ORDER BY Total_Quantidade_Vendida DESC
LIMIT 1;


-- CRIAÇÃO DA VIEW --
-- Criar uma view para simplificar o acesso a um relatório detalhado de vendas.
CREATE OR REPLACE VIEW `t1engenhariadados.Livraria_DevSaber_Grupo_3_9.v_relatorio_vendas_detalhado_grupo3_9` AS
SELECT
    V.ID_Venda,
    V.Data_Venda,
    C.Nome_Cliente,
    C.Estado_Cliente,
    P.Nome_Produto,
    P.Categoria_Produto,
    V.Quantidade,
    P.Preco_Produto,
    (V.Quantidade * P.Preco_Produto) AS Valor_Total
FROM `t1engenhariadados.Livraria_DevSaber_Grupo_3_9.Vendas` AS V
JOIN `t1engenhariadados.Livraria_DevSaber_Grupo_3_9.Clientes` AS C ON V.ID_Cliente = C.ID_Cliente
JOIN `t1engenhariadados.Livraria_DevSaber_Grupo_3_9.Produtos` AS P ON V.ID_Produto = P.ID_Produto;

-- Exemplo de uso da view:
SELECT * FROM `t1engenhariadados.Livraria_DevSaber_Grupo_3_9.v_relatorio_vendas_detalhado_grupo3_9` WHERE Estado_Cliente = 'RJ';
