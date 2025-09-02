-- Este script contém as consultas para análise e a criação da VIEW.
-- Lembre-se de substituir `seu-projeto.seu_dataset` pelo nome do seu projeto e dataset.

-- ANÁLISE DE DADOS --

-- Pergunta 1: Qual o nome dos clientes que moram no estado de 'SP'?
SELECT Nome_Cliente
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
ORDER BY V.Data_Venda;

-- Pergunta 4: Qual o valor total de cada venda? (quantidade * preço)
SELECT
    V.ID_Venda,
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
CREATE OR REPLACE VIEW `t1engenhariadados.Livraria_DevSaber_Grupo_3_9.v_relatorio_vendas_detalhado` AS
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
JOIN `seu-projeto.seu_dataset.Clientes` AS C ON V.ID_Cliente = C.ID_Cliente
JOIN `seu-projeto.seu_dataset.Produtos` AS P ON V.ID_Produto = P.ID_Produto;

-- Exemplo de uso da view:
SELECT * FROM `seu-projeto.seu_dataset.v_relatorio_vendas_detalhado` WHERE Estado_Cliente = 'RJ';
