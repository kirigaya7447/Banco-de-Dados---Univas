create table produto(
	cod int primary key,
	nome varchar(50),
	qtde int,
	cod_categoria int,
	vlr_unitario numeric(12,2)
);

create table categoria(
	cod int primary key,
	nome varchar(20)
);

insert into categoria
	values (1, "Mercearia"),
	(2, "Bebidas"),
	(4, "Açougue");

insert into produto
	values(1, "Arroz tipo 1 5kg", 150, 1, 22.50),
	(2, "Feijão Carioca 2kg", 120, 1, 6.50),
	(3, "Sabão em Pó Omo 1kg", 110, 3, 19.50),
	(4, "Pepsi Black 2l", 340, 2, 5.99);

alter table produto add constraint fk_categoria
	foreign key(cod_categoria)
	references categoria(cod)
	on delete cascade 
	on update cascade;

alter table produto drop constraint fk_categoria;

select * from produto;
select * from categoria;

#JOINS

select p.nome as produto, 
c.nome as categoria 
from produto as p
inner join categoria as c
on p.cod_categoria = c.cod;

select p.nome as produto, 
c.nome as categoria 
from produto as p
left join categoria as c
on p.cod_categoria = c.cod;

select p.nome as produto, 
c.nome as categoria 
from produto as p
right join categoria as c
on p.cod_categoria = c.cod;

select c.nome as categoria, count(p.cod)
from produto as p
inner join categoria as c on p.cod_categoria = c.cod
group by 1
order by 1;