/*
 * Consulta SQL Avançado
 * Prof. Gustavo Dias
 * 2026-11-16
 * Consulta orientada à análise
 */

-- ============================================================================
-- 1. CRIAÇÃO DO BANCO DE DADOS E DAS TABELAS
-- ============================================================================

-- Cadastro das empresas
CREATE TABLE empresa (
    id INT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);

-- Registro dos itens comprados.
-- Uma mesma nota fiscal pode possuir mais de um produto.
CREATE TABLE compra (
    id_compra INT AUTO_INCREMENT PRIMARY KEY,
    nf INT NOT NULL,
    id_produto INT NOT NULL,
    id_empresa INT NULL,
    data_compra DATE NOT NULL,
    quantidade INT NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    CONSTRAINT fk_compra_empresa
        FOREIGN KEY (id_empresa) REFERENCES empresa(id)
);

-- Conferência da estrutura
DESCRIBE empresa;
DESCRIBE compra;


-- ============================================================================
-- 2. INSERÇÃO DOS DADOS
-- ============================================================================

INSERT INTO empresa (id, nome) VALUES
(1, 'Empresa 1'),
(2, 'Empresa 2'),
(3, 'Empresa 3');

INSERT INTO compra
(nf, id_produto, id_empresa, data_compra, quantidade, valor_unitario, status)
VALUES
(1001, 1, 1, '2026-09-02', 2, 150.00, 'Concluída'),
(1001, 2, 1, '2026-09-02', 1,  80.00, 'Concluída'),
(1002, 1, 1, '2026-09-08', 3, 150.00, 'Concluída'),
(1003, 3, 1, '2026-09-15', 2, 300.00, 'Pendente'),
(1004, 4, 1, '2026-10-03', 1, 500.00, 'Cancelada'),
(2001, 2, 2, '2026-09-04', 5,  80.00, 'Concluída'),
(2001, 3, 2, '2026-09-04', 1, 300.00, 'Concluída'),
(2002, 4, 2, '2026-09-12', 2, 500.00, 'Concluída'),
(2003, 1, 2, '2026-10-05', 1, 150.00, 'Pendente'),
(3001, 3, 3, '2026-09-10', 4, 300.00, 'Concluída'),
(3002, 4, 3, '2026-10-08', 1, 500.00, 'Concluída'),
(9001, 5, NULL, '2026-10-10', 2, 120.00, 'Pendente');



-- ============================================================================
-- 3. CONFERÊNCIA INICIAL DOS DADOS
-- ============================================================================

SELECT * FROM empresa ORDER BY id;
SELECT * FROM compra ORDER BY nf, id_produto;


-- ============================================================================
-- 4. QUESTIONAMENTOS E RESOLUÇÕES
-- ============================================================================

/*
QUESTÃO 1
Apresente todas as compras, exibindo o número da nota fiscal, o código do
produto e o nome da empresa responsável pela compra.

CONTEÚDOS: INNER JOIN e aliases.
*/

select c.nf as "NF", c.id_produto as "Código Produto", e.nome as "Empresa" from compra as c
inner join empresa e 
on c.id_empresa = e.id
order by c.nf, c.id_produto;



/*
QUESTÃO 2
Apresente o número da nota fiscal, o produto e a quantidade de empresas
cadastradas no banco de dados.

Utilize uma subquery como campo da consulta.

CONTEÚDOS: subquery escalar no SELECT.

Observação: a subquery retorna um único valor, pois utiliza COUNT(*).
*/

select c.nf, c.id_produto, (select count(*) from empresa) as "Número de empresas" from compra c order by c.nf, c.id_produto;



/*
QUESTÃO 3
Apresente os códigos dos produtos que possuem compras vinculadas a empresas
cadastradas cujo nome começa com "Empresa".

Utilize uma subquery no filtro da consulta.

CONTEÚDOS: IN e subquery no WHERE.
*/

select c.id_produto
from compra c
where c.id_empresa in(
	select e.id
	from empresa e
	where e.nome like "Empresa%"
)
order by c.id_produto;


/*
QUESTÃO 4
Apresente o número da nota fiscal, o código da empresa e o nome da empresa
relacionada a cada compra.

O nome da empresa deve ser obtido por uma subquery correlacionada.

CONTEÚDOS: subquery correlacionada.
*/

select c.nf, c.id_produto, c.id_empresa, 
(select e.nome from empresa e 
where c.id_empresa = e.id) as "Empresa" 
from compra c 
order by c.nf, c.id_empresa;


/*
QUESTÃO 5
Apresente todas as compras com o valor total de cada item (quantidade
multiplicada pelo preço unitário).

Classifique cada item:
  - "Alto valor": valor igual ou superior a R$ 800,00;
  - "Médio valor": valor igual ou superior a R$ 300,00;
  - "Baixo valor": abaixo de R$ 300,00.

CONTEÚDOS: CASE e cálculo em consulta.
*/

select c.nf, c.id_produto, c.quantidade, c.valor_unitario, c.quantidade * c.valor_unitario as "Valor Total",
case 
	when c.quantidade * c.valor_unitario >= 800
		then "Alto valor"
	when c.quantidade * c.valor_unitario >= 300
		then "Médio valor"
	else "Baixo valor"
end as "Classificação"
from compra c
order by `Valor Total` desc;



/*
QUESTÃO 6
Apresente todas as compras e o nome da empresa correspondente.
Quando a empresa não estiver identificada, exiba "Empresa não identificada".

CONTEÚDOS: LEFT JOIN e COALESCE.
*/

select c.nf, c.id_produto, coalesce(e.nome, "Empresa não identificada") as empresa
from compra c
left join empresa e
on e.id = c.id_empresa 
order by c.nf, c.id_produto;


/*
QUESTÃO 7
Apresente a quantidade de itens registrados e o valor total comprado por
empresa, considerando apenas compras concluídas.

Mantenha no resultado todas as empresas cadastradas, inclusive aquelas que
eventualmente não possuam compras concluídas.

CONTEÚDOS: LEFT JOIN, SUM, COUNT, GROUP BY e COALESCE.

A condição de status fica no ON para não eliminar empresas sem compras
concluídas.
*/




/*
QUESTÃO 8
Apresente o faturamento por empresa, considerando somente compras concluídas
e agrupando os resultados por empresa.

Exiba apenas empresas cujo valor total seja superior a R$ 500,00.

CONTEÚDOS: JOIN, SUM, WHERE, GROUP BY e HAVING.
*/




/*
QUESTÃO 9
Apresente os produtos cujo valor total comprado seja superior à média dos
valores totais por produto, considerando apenas compras concluídas.

Utilize uma CTE para organizar o cálculo.

CONTEÚDOS: CTE, agregação e subquery.
*/




/*
QUESTÃO 10
Crie uma consulta que apresente, por empresa:
  - quantidade de notas fiscais distintas;
  - valor total das compras concluídas;
  - classificação do volume comprado.

Classificação:
  - "Grande volume": a partir de R$ 1.500,00;
  - "Médio volume": a partir de R$ 500,00;
  - "Pequeno volume": abaixo de R$ 500,00.

Mantenha empresas sem compras concluídas no resultado.

CONTEÚDOS: JOIN, COUNT DISTINCT, SUM, COALESCE, CASE e GROUP BY.
*/




/*
QUESTÃO 11
Crie uma VIEW para disponibilizar um resumo das compras concluídas por empresa,
contendo:
  - nome da empresa;
  - quantidade de notas fiscais;
  - valor total comprado.

Depois, consulte a VIEW apresentando somente empresas com valor total superior
a R$ 500,00.

CONTEÚDOS: CREATE VIEW e consulta sobre VIEW.
*/

create or replace view vw_resumo_compras_empresa as
	select e.id as id_empresa, e.nome as empresa, 
	count(distinct c.nf) as quantidade_notas, 
	coalesce(
	sum(c.quantidade * c.valor_unitario), 0) as valor_total
	from empresa e
	left join compra c
	on c.id_empresa = e.id
	and c.status = "Concluída"
	group by e.id, e.nome;

select id_empresa, empresa, quantidade_notas, valor_total 
from vw_resumo_compras_empresa order by valor_total desc;


-- Consulta da VIEW



/*
QUESTÃO 12 - DESAFIO DE BOAS PRÁTICAS
Reescreva a consulta abaixo, organizando a formatação, explicitando as colunas,
utilizando aliases consistentes e corrigindo o agrupamento.

Consulta a ser revisada:

SELECT * FROM empresa e
INNER JOIN compra c ON e.id=c.id_empresa
WHERE c.status='Concluída'
GROUP BY e.id;

RESOLUÇÃO:
*/




-- ============================================================================
-- 5. CONSULTAS EXPLORATÓRIAS ADICIONAIS
-- ============================================================================

-- Compras realizadas em setembro de 2026


-- Quantidade de compras por status


-- Produtos com valor total comprado acima de R$ 500,00



-- ============================================================================
-- 6. ENCERRAMENTO
-- ============================================================================

/*
TÓPICOS CONCEITUAIS COMPLEMENTARES (sem implementação neste script):

1. STORED PROCEDURE
   Conjunto de instruções SQL armazenado no banco de dados e executado
   explicitamente por uma chamada. Exemplo de aplicação: rotina para gerar
   relatório de compras de um período informado.

2. TRIGGER
   Conjunto de instruções executado automaticamente em resposta a um evento
   de INSERT, UPDATE ou DELETE em uma tabela. Exemplo de aplicação: registrar
   em uma tabela de auditoria as alterações realizadas nos dados de compra.

DIFERENÇA CENTRAL:
   Procedure: execução solicitada explicitamente.
   Trigger: execução automática, disparada por um evento.

BOAS PRÁTICAS RETOMADAS:
   - Evitar SELECT * em consultas destinadas a relatórios.
   - Utilizar aliases claros e consistentes.
   - Organizar a consulta em blocos: SELECT, FROM, JOIN, WHERE, GROUP BY,
     HAVING e ORDER BY.
   - Utilizar WHERE para filtrar registros antes do agrupamento.
   - Utilizar HAVING para filtrar resultados agrupados.
   - Observar o efeito de condições no ON e no WHERE, especialmente com
     LEFT JOIN.
   - Utilizar subqueries e CTEs para organizar consultas.
   - Recuperar somente as colunas necessárias.
*/
