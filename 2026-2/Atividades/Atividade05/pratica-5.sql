==================================================
- SISTEMAS DE INFORMAÇÃO P4                      -
- CONSULTA SQL AVANÇADO - PRÁTICA 5              -
- PROF. GUSTAVO DIAS luizdias@univas.edu.br      -
==================================================

-- ATIVIDADE PRÁTICA: CONSULTAS ORIENTADAS À ANÁLISE
-- OBJETIVO: desenvolver consultas aplicadas ao cenário de vendas, utilizando
-- CASE, COALESCE e VIEW para organizar e interpretar informações.
-- A atividade deverá ser realizada em grupos com 3 ou 4 integrantes.
-- Para cada questão prática, estruture o script SQL necessário para obter
-- a informação solicitada.
-- Ao término da aula, encaminhe o script SQL completo ao professor por e-mail.
-- A entrega deverá conter as consultas, as VIEWs solicitadas e a identificação
-- dos integrantes.
-- As questões práticas devem ser resolvidas com os recursos indicados no enunciado.
-- As questões 6 e 7 são dissertativas: responda por meio de comentários SQL,
-- explicando o funcionamento, a aplicação e os cuidados necessários.
--
-- IDENTIFICAÇÃO:
-- - ALUNO (A) 1: Ana Paula
-- - ALUNO (A) 2: Giulia Guimarães
-- - ALUNO (A) 3: João Henrique
-- - ALUNO (A) 4: Pedro Henrique Silva Moreira

-- PREPARAÇÃO DO AMBIENTE
-- UTILIZE O MESMO MODELO DE DADOS DA PRÁTICA 4, COM AS MESMAS TABELAS E REGISTROS.

-- ==================================================
-- QUESTÃO 1 - CASE: CLASSIFICAÇÃO DO VALOR DOS PEDIDOS
-- OBJETIVO: utilizar CASE para transformar valores calculados em categorias
-- que facilitem a análise comercial.
--
-- CONTEXTO:
-- A gerência deseja identificar pedidos de diferentes faixas de valor.
-- Considere o valor do pedido como a soma de quantidade * preco_unitario
-- de seus itens.
--
-- TAREFA:
-- Escreva uma consulta que apresente:
--   - número do pedido;
--   - nome do cliente;
--   - valor total do pedido;
--   - classificação do pedido, conforme as regras:
--       * valor igual ou superior a R$ 3.000,00: 'Alto valor';
--       * valor igual ou superior a R$ 1.000,00: 'Médio valor';
--       * abaixo de R$ 1.000,00: 'Baixo valor'.
-- Utilize CASE na classificação. Garanta que cada pedido apareça uma única vez.
-- Considere a ordem das condições para evitar classificações incorretas.

select p.id as num_pedido,
c.nome as nome_cliente,
sum(ip.quantidade * ip.preco_unitario) as valor_total,
case 
when coalesce(sum(ip.quantidade * ip.preco_unitario), 0) >= 3000
then 'Alto valor'
when coalesce(sum(ip.quantidade * ip.preco_unitario), 0) >= 1000
then 'Médio valor'
else 'Baixo Valor'
end as classificacao
from pedido p
inner join cliente c 
on p.id_cliente = c.id
left join item_pedido ip 
on p.id = ip.id_pedido
group by p.id, c.nome;


-- ==================================================
-- QUESTÃO 2 - COALESCE: CLIENTES SEM PEDIDOS
-- OBJETIVO: tratar valores NULL em uma análise da carteira de clientes.
--
-- CONTEXTO:
-- A equipe comercial precisa visualizar todos os clientes cadastrados,
-- inclusive aqueles que ainda não realizaram pedidos.
--
-- TAREFA:
-- Escreva uma consulta que apresente o nome e a cidade de cada cliente,
-- a quantidade de pedidos e o valor total comprado.
-- Clientes sem pedidos devem aparecer com quantidade 0 e valor total 0.
-- Utilize LEFT JOIN para preservar todos os clientes e COALESCE para substituir
-- valores NULL nos indicadores. Evite que a junção multiplique indevidamente
-- os valores agregados.

select c.nome AS cliente, c.cidade AS cidade, COALESCE(ped.quantidade_pedidos, 0) AS quantidade_pedidos, COALESCE(ped.valor_total, 0) AS valor_total_comprado
FROM cliente c
LEFT JOIN (
    SELECT
        p.id_cliente,
        COUNT(DISTINCT p.id)                  AS quantidade_pedidos,
        SUM(i.quantidade * i.preco_unitario)  AS valor_total
    FROM pedido p
    JOIN item_pedido i
    ON i.id_pedido = p.id
    GROUP BY p.id_cliente
) ped
ON ped.id_cliente = c.id
ORDER BY valor_total_comprado DESC;


-- ==================================================
-- QUESTÃO 3 - VIEW: VISÃO ANALÍTICA DE PEDIDOS
-- OBJETIVO: criar uma VIEW reutilizável para consultas comerciais.
--
-- CONTEXTO:
-- A gerência deseja consultar frequentemente os pedidos com seus clientes,
-- vendedores e respectivos valores, sem reescrever toda a consulta-base.
--
-- TAREFA:
-- Crie uma VIEW chamada vw_analise_pedidos contendo:
--   - número e data do pedido;
--   - nome do cliente e sua cidade;
--   - nome do vendedor e seu setor;
--   - valor total do pedido.
-- Em seguida, consulte a VIEW para listar somente pedidos com valor total
-- superior a R$ 1.000,00, ordenados do maior para o menor valor.
-- O valor total deve ser calculado a partir dos itens do pedido.

create or replace view vw_analise_pedido as 
 select
 p.id as numero_pedido,
 p.data_pedido,
 c.nome as cliente,
 c.cidade,
 v.nome as vendedor,
 v.setor,
 sum(ip.quantidade * ip.preco_unitario) as valor_total
 from pedido p
 inner join  cliente c
 on p.id_cliente = c.id
 inner join  vendedor v
 on p.id_vendedor = v.id
 inner join item_pedido ip
 on p.id = ip.id_pedido
 group by p.id, 
 p.data_pedido,
 c.nome,
 c.cidade,
 v.nome,
 v.setor;
 
 select * from vw_analise_pedido
 where valor_total > 1000
 order by valor_total desc;

-- ==================================================
-- QUESTÃO 4 - CASE E COALESCE: DESEMPENHO DOS VENDEDORES
-- OBJETIVO: produzir uma classificação gerencial a partir de indicadores.
--
-- CONTEXTO:
-- A coordenação comercial pretende comparar vendedores pelo valor total
-- vendido. Vendedores sem pedidos também devem ser considerados.
--
-- TAREFA:
-- Apresente o nome do vendedor, a quantidade de pedidos, o valor total vendido
-- e uma classificação obtida com CASE:
--   * total igual ou superior a R$ 5.000,00: 'Destaque';
--   * total igual ou superior a R$ 2.000,00: 'Em desenvolvimento';
--   * abaixo de R$ 2.000,00: 'Acompanhar'.
-- Utilize LEFT JOIN para manter todos os vendedores e COALESCE para que
-- quantidade e valor sejam exibidos como zero quando não houver pedidos.
-- Ordene o resultado pelo valor total vendido, em ordem decrescente.

select v.nome AS vendedor, COALESCE(ped.quantidade_pedidos, 0) AS quantidade_pedidos, COALESCE(ped.valor_total, 0) AS valor_total_vendido,
    CASE
        WHEN COALESCE(ped.valor_total, 0) >= 5000 THEN 'Destaque'
        WHEN COALESCE(ped.valor_total, 0) >= 2000 THEN 'Em desenvolvimento'
        ELSE 'Acompanhar'
    END AS classificacao
FROM vendedor v
LEFT JOIN (
    SELECT
	p.id_vendedor,
    COUNT(DISTINCT p.id) AS quantidade_pedidos,
    SUM(i.quantidade * i.preco_unitario) AS valor_total
    FROM pedido p
    JOIN item_pedido i
      ON i.id_pedido = p.id
    GROUP BY p.id_vendedor
) ped
ON ped.id_vendedor = v.id
ORDER BY valor_total_vendido DESC;


-- ==================================================
-- QUESTÃO 5 - VIEW, CASE E COALESCE: ANÁLISE DE PRODUTOS
-- OBJETIVO: consolidar informações do catálogo em uma VIEW analítica.
--
-- CONTEXTO:
-- O setor de estoque deseja acompanhar o valor potencial comercializado
-- por produto, considerando as unidades vendidas e o preço registrado
-- nos itens dos pedidos. Produtos sem vendas devem permanecer no relatório.
--
-- TAREFA:
-- Crie uma VIEW chamada vw_analise_produtos que apresente:
--   - nome do produto e nome da categoria;
--   - quantidade total de unidades vendidas;
--   - valor total vendido por produto;
--   - classificação do produto com CASE:
--       * valor igual ou superior a R$ 3.000,00: 'Maior faturamento';
--       * valor igual ou superior a R$ 500,00: 'Faturamento intermediário';
--       * abaixo de R$ 500,00: 'Menor faturamento'.
-- Utilize LEFT JOIN para incluir produtos sem vendas e COALESCE para substituir
-- por zero os indicadores ausentes.
-- Após criar a VIEW, consulte-a apresentando os produtos classificados como
-- 'Maior faturamento', ordenados pelo valor total vendido.

CREATE OR REPLACE VIEW vw_analise_produtos AS
SELECT
    p.id AS id_produto, p.nome AS produto, c.nome AS categoria, COALESCE(vw.unidades_vendidas, 0) AS unidades_vendidas, COALESCE(vw.valor_total, 0) AS valor_total_vendido,
    CASE
        WHEN COALESCE(vw.valor_total, 0) >= 3000 THEN 'Maior faturamento'
        WHEN COALESCE(vw.valor_total, 0) >= 500  THEN 'Faturamento intermediário'
        ELSE 'Menor faturamento'
    END AS classificacao
FROM produto p
LEFT JOIN categoria c
ON c.id = p.id_categoria
LEFT JOIN (
    SELECT
        id_produto,
        SUM(quantidade)                  AS unidades_vendidas,
        SUM(quantidade * preco_unitario) AS valor_total
    FROM item_pedido
    GROUP BY id_produto
) vw
       ON vw.id_produto = p.id;

select *
from vw_analise_produtos 
order by valor_total_vendido desc;



-- ==================================================
-- QUESTÃO 6 - DISSERTATIVA: PROCEDURES
-- CONTEXTO:
-- A empresa deseja padronizar a geração de um relatório de vendas por período.
--
-- RESPONDA, EM COMENTÁRIOS SQL:
-- a) O que é uma stored procedure e como ela difere de uma consulta SELECT comum?

-- Resposta: É um conjunto de comandos SQL armazenados no banco de dados que executam 
-- uma tarefa específica. Ela se difere do select comum porque ele apenas lê e retorna 
-- dados persistidos, enquanto a procedure pode conter vários comandos
-- como insert, update e delete. Além disso, por estar armazenada no banco, ela pode ser 
-- reutilizada.
	
-- b) Como uma procedure poderia receber data inicial e data final como parâmetros
--    e retornar ou disponibilizar os pedidos desse intervalo?

-- Resposta: Ela declara dois parâmetros de entrada do tipo Date, para a data inicial e final.
-- Dentro dela, um select usa esses parâmetros no where com between, assim disponilizando o resultado.


-- c) Cite uma vantagem e um cuidado relacionado à manutenção ou execução
--    de procedures nesse cenário.

-- Resposta: Uma vantagem é a reutilização, a regra do relatório fica em um único lugar e qualquer ajuste
-- ou alteração é feita uma vez e vale para todos que a chamam.
-- Um cuidado é com o versionamento. A lógica fica dentro do banco, então alterações precisam ser documentadas e testadas.


-- ==================================================
-- QUESTÃO 7 - DISSERTATIVA: TRIGGERS
-- CONTEXTO:
-- A empresa deseja manter um registro de auditoria sempre que o preço unitário
-- de um item de pedido for alterado.
--
-- RESPONDA, EM COMENTÁRIOS SQL:
-- a) O que é um trigger e em que momento ele é executado?

-- Um trigger é um conjunto de instruções executado automaticamente em
-- resposta a eventos como INSERT, UPDATE e DELETE em uma
-- tabela. Ele é executado em momentos específicos: antes da operação
-- alterar os dados (BEFORE), depois da conclusão da operação (AFTER) ou
-- no lugar da operação original (INSTEAD OF).

-- b) Qual evento e qual tabela seriam apropriados para essa auditoria?

-- O evento apropriado é o UPDATE na coluna preco_unitario e a tabela é item_pedido, pois é nela que o preço
-- unitário está armazenado.

-- c) Quais informações do registro antigo e do novo registro deveriam ser
--    armazenadas para permitir rastrear a alteração?

-- Do registro antigo: preço unitário antigo (OLD.preco_unitario).
-- Do registro novo: preço unitário novo (NEW.preco_unitario).
-- Também devem ser gravados o id do item_pedido (e do pedido/produto),
-- a data e hora da alteração e o usuário que a realizou. Assim é
-- possível saber o que mudou, quando e por quem.

-- d) Explique uma diferença prática entre trigger e procedure, considerando
--    a execução automática e a chamada explícita.

--  O trigger é executado automaticamente pelo banco quando o evento
--  ocorre sem que ninguém chame, e não recebe parâmetros diretamente.
--  A procedure só é executada por chamada explícita,
--  pode receber parâmetros e o momento da execução é
--  decidido por quem chama.