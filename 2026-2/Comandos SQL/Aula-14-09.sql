drop table if exists empresa;

create table if not exists empresa(
	id int,
	nome varchar(50)
);

insert into empresa values(1, "Empresa 1");
insert into empresa values(2, "Empresa 2");

alter table compra add column id_empresa int;

update compra set id_empresa = 1 where id_produto < 3;
update compra set id_empresa = 2 where id_produto >= 3;


#SELECTS
select c.nf, 
c.id_produto, 
(select nome from empresa) as empresa
from compra as c
order by 1;

select * from compra order by id_produto;

select c.id_produto
from compra as c
where c.id_empresa in (select id from empresa);

select c.id_produto, 
(select e.nome 
from empresa as e
where e.id = c.id_empresa) as empresa
from compra as c
where c.id_empresa in (select id from empresa);

