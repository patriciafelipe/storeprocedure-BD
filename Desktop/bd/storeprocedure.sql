use master;
go

drop database Lojainfo
go

create database Lojainfo 
go 

use Lojainfo
GO

create table tb_clientes(
       id_cliente int PRIMARY KEY IDENTITY(1,1),
       nome nvarchar(50) not null,
       endereco nvarchar(100),
       idade int NOT NULL,
       sexo char(1) NOT NULL,
       fone nvarchar(15),
       email nvarchar(70),
)
GO

create table tb_hardware(
       id_hardware int PRIMARY KEY IDENTITY(1,1),
       descricao nvarchar(50) not null,
       preco_unit decimal NOT NULL,
       qtde_atual int NOT NULL, --0 caso nao tenha no estoque
       qtde_minima int,
       img image DEFAULT NULL
)
GO

create table tb_vendas(
       id_venda int primary key IDENTITY(1,1),
       id_cliente int not null,
       data date not null,
       desconto decimal(2,2)
)
GO

create table tb_vendas_itens(
       id_item int PRIMARY KEY identity(1,1),
       id_venda int not null,
       id_hardware int not null,
       qtde_item int not null,
       pco_vda decimal(8,2) not null
)
GO

create table tb_venda_canc(
	id_venda_canc int Primary key identity(1,1),
	id_venda int unique not null
	)
	Go

alter table tb_vendas
      ADD CONSTRAINT fk_vda_cli
      FOREIGN KEY (id_cliente) REFERENCES tb_clientes(id_cliente)
      go 

alter table tb_vendas_itens
	ADD CONSTRAINT fk_vda_venda 
	FOREIGN KEY (id_venda) REFERENCES tb_vendas(id_venda)
	go
	
alter table tb_hardware
	ADD CONSTRAINT fk_vda_hardware
	FOREIGN KEY (id_hardware) REFERENCES tb_hardware(id_hardware)
	go
	
alter table tb_vendas_itens
	ADD CONSTRAINT fk_vda_hardware2
	FOREIGN KEY (id_hardware) REFERENCES tb_hardware(id_hardware)
	go
	
alter table tb_venda_canc
ADD CONSTRAINT fk_venda_canceladas
FOREIGN KEY (id_venda) REFERENCES tb_vendas (id_venda)
go
	
insert into tb_clientes (nome,idade,sexo,email,endereco,fone) VALUES ('Patrícia',24,'F','patricia@hotmail.com','Rua torta, 32', 24789632),
																					('José',25,'M','jose@yahoo.com','Rua coberta, 41', 26987425),
																					('Thiago',32,'M','thiago@gmail.com','Rua das hortências, 87', 23541485),
																					('Thaís',26,'F','thaisinha@hotmail.com','Rua flamingos, 74', 54545454),
																					('Juliana',23,'F','ju@yahoo.com','Rua reta, 48', 70707070),
																					('Gabriel', 15,'M', 'gabriel@gmail.com','aguia de haia',80808080)
go
 insert into tb_hardware (descricao,preco_unit,qtde_atual,qtde_minima) VALUES ('Placa Mãe', 799.00, 10,5),
																			  ('Mouse', 10.00, 40, 5),
																			  ('Computador completo', 999.00, 10,5),
																			  ('Caixa de som', 149.99, 20,5),
																			  ('Estabilizador', 199.00, 10,5)
go

insert into tb_vendas (id_cliente,data) VALUES (1,'16/08/2019'),
											 (2,'17/08/2019'),
											 (1,'18/08/2019'),
											 (4,'19/08/2019'),
											 (1,'20/08/2019'),
											 (1,'12/09/2019')
go

insert into tb_vendas_itens (id_venda,id_hardware,pco_vda,qtde_item) VALUES 
														(1,1,564.00,1),
														(4,1,999.00,5),
														(3,1,749.00,2),
														(2,1,999.00,4),
														(1,1,199.00,3),
														(3,1,399.00,3)
														
														
														
go

insert into tb_venda_canc (id_venda) VALUES
	(1),
	(1)
	
	 go
																			  
select * from tb_hardware
go
select * from tb_vendas
go
select * from tb_vendas_itens
go

--Listar vendas mostrando o nome do cliente que comprou cada uma delas
select c.nome, v.id_venda from tb_vendas as v 
join tb_clientes as c 
on v.id_cliente = c.id_cliente
go

--Clientes que nao fizeram compra nenhuma 
select c.nome from tb_clientes as c 
join tb_vendas as v 
on c.id_cliente = v.id_cliente
where v.id_cliente is null

--Produtos que nao foram vendidos
select * from tb_vendas_itens as c
right join tb_hardware as v
on c.id_hardware = v.id_hardware
where c.id_venda is null

select * from tb_clientes 
select * from tb_vendas
select * from tb_vendas_itens
select * from tb_venda_canc
Go

--Criando storeprocedure
 
create procedure aplica_desconto_no_preco(
	@id_do_cliente as decimal(10),
	@_preco as decimal(10, 2),
	@_percentual_desconto as decimal(10, 2) = 0.0,
	@_preco_com_desconto as decimal(10, 2) output,
	@nome_do_produto as varchar(15) output
)
as
	begin
		select @_preco_com_desconto = @_preco - (@_preco * @_percentual_desconto)
		select @_preco_com_desconto as "Preco com desconto"
	end
go

declare @NomeProduto varchar(20);
declare @IdCliente int;
declare @Preco decimal(5,2);
declare @PercentualDeDesconto decimal(5,2);
declare @PrecoComDesconto decimal(5,2);
set @NomeProduto = 'Mouse';
set @IdCliente = 1;
set @Preco =10.00;
set @PercentualDeDesconto = 0.7;

exec aplica_desconto_no_preco @IdCliente, @Preco, @PercentualDeDesconto, @PrecoComDesconto output, @NomeProduto output
--print 'resultado da procedure:'
--print 'valor atribuido para @precoComDesconto'
select @PrecoComDesconto as "Valor da variavel: @PrecoComDesconto"
select @NomeProduto as "Nome do produto q houve desconto:"
select @IdCliente as "Id do cliente que comprou:"

drop procedure aplica_desconto_no_preco
go
