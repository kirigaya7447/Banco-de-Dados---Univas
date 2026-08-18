create table vendas(
	nf int not null primary key,
	cod_produto int,
	nome_produto varchar(50),
	qtd_vendida int,
	vlr_desconto numeric(12,2),
	vlr_total numeric(12,2)
);

insert into vendas values
	(1, 101, 'camisa', 2, 40, 260),
	(2, 102, 'calça', 3, 90, 699),
	(3, 103, 'jaqueta', 1, 40, 499),
	(4, 104, 'sapato', 1, 30, 389);

select nome_produto as nome, 
qtd_vendida, 
vlr_total as "Maior valor de venda" 
from vendas 
where vlr_total = (select MAX(vlr_total) from vendas);

select MAX(qtd_vendida) as "Maior quantidade vendida" from vendas;

select MAX(vlr_desconto) as "Maior valor de desconto" from vendas;

########################################################################

select min(vlr_total) as "Menor valor de venda" 
from vendas;

select min(qtd_vendida) as "Menor quantidade vendida" 
from vendas;

select min(vlr_desconto) as "Menor desconto" 
from vendas;

########################################################################

select sum(vlr_total) as "Valor total de vendas" 
from vendas;

select sum(qtd_vendida) as "Total de quantidades vendidas" 
from vendas;

select sum(vlr_desconto) as "Somatória de descontos" 
from vendas;

########################################################################

select avg(vlr_total) as "Valor médio das vendas" 
from vendas;

select avg(qtd_vendida) as "Valor médio vendido" 
from vendas;

select avg(vlr_desconto) as "Valor médio de desconto" 
from vendas;

########################################################################

select count(*) as "Contagem de linhas" 
from vendas;

insert into vendas values
	(5, null, 'camisinha', 2, 40, 260);

select count(cod_produto) as "Contagem de linhas" 
from vendas;

########################################################################

select nome_produto as nome, vlr_total / qtd_vendida  as "valor unitário" from vendas;

select (sum(vlr_total) / sum(qtd_vendida)) as "Valor Médio" from vendas;

########################################################################

select nome_produto, 
sum(vlr_total) as "Valor Total p/ Produto" 
from vendas group by 1;

select nome_produto, 
sum(vlr_total) as "Valor Total p/ Produto", 
sum(qtd_vendida) as "Quantidade total do produto" 
from vendas group by 1;

select nome_produto, 
sum(vlr_total) as "Valor Total p/ Produto", 
sum(qtd_vendida) as "Quantidade total do produto", 
sum(vlr_desconto) as "Valor Total de Descontos" 
from vendas group by 1;

########################################################################