-- criar banco de dados para o cenário E-commerce
create database ecommerce;
use ecommerce;

-- criar tabela cliente
create table clients(
		idClient int auto_increment primary key,
		Fname varchar(10),
		Minit char(3),
		Lname varchar(20),
		CPF char(11) not null,
		Address varchar(30),
		constraint unique_cpf_client unique (CPF)
);

-- criar tabela produto
create table product(
		idProduct int auto_increment primary key,
        Pname varchar(10),
        classification_kids bool default false,
        category enum('Eletrôico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') not null,
        avaliação float default 0,
        size varchar(10)
);

-- criar tabela pagamento
create table payments(
		idclient int,
        id_payment int,
        typePayment enum('Boleto', 'Dois cartões'), 
        limitAvailable float,
        primary key(idClient, id_payment)
);

-- criar tabela pedido
create table orders(
		idOrder int auto_increment primary key,
        idOrderClient int,
        orderStatus enum('Cancelado', 'Confirmado', 'Em processamento') default 'Em processamento',
        orderDescription varchar(255),
        sendValue float default 10,
        paymentCash bool default false,
        constraint fk_orders_client foreign key(idOrderClient) references clients(idClient)
);

-- criar tabela estoque
create table productStorage(
		idProdStorage int auto_increment primary key,
        storageLocation varchar(255),
        quantity int default 0
);
-- criar tabela fornecedor
create table supplier(
		idSupplier int auto_increment primary key,
        SocialName varchar(255) not null,
        CNPJ char(15) not null,
        contact char(11) not null,
        constraint unique_supplier unique (CNPJ)
);

-- criar tabela vendedor
create table seller(
		idSeller int auto_increment primary key,
        SocialName varchar(255) not null,
        AbstName varchar(255),
        CNPJ char(15),
        CPF char(9),
        location varchar(255),
        contact char(11) not null,
        constraint unique_cnpj_seller unique (CNPJ),
        constraint unique_cpf_seller unique (CPF)
);

create table productSeller(
		idPseller int,
		idPproduct int,
		prodQuantity int default 1,
		primary key (idPseller, idPproduct),
		constraint fk_productorder_seller foreign key (idPseller) references seller(idSeller),
		constraint fk_productorder_product foreign key (idPproduct) references product(idProduct)
	);
    
create table productOrder(
		idPOproduct int,
        idPOorder int,
        poQuantity int default 1,
        poStatus enum('Disponível', 'Sem estoque') default 'Disponível',
        primary key (idPOproduct, idPOorder),
        constraint fk_product_seller foreign key (idPOproduct) references product(idProduct),
        constraint fk_product_product foreign key (idPOorder) references orders(idOrder)
);

create table storageLocation(
		idLproduct int,
        idLstorage int,
        location varchar (500) not null,
        primary key (idLproduct, idLstorage),
        constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
		constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProdStorage)
);

create table productSupplier(
		idPsSupplier int,
        idPsProduct int,
        quantity int not null,
        primary key (idPsSupplier, idPsProduct),
        constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
		constraint fk_product_supplier_product foreign key (idPsProduct) references product(idProduct)

);

show tables;

insert into Clientes (Fname, Minit, Lname, CPF, Address)
		values('Maria', 'M', 'Silva', 12346789, 'rua silva de prata 29, Carangola - Cidade das flores'),
			  ('Matheus', 'O', 'Pimentel', 987654321, 'rua alameda 289, Centro - Cidade das flores'),
              ('Ricardo', 'F', 'Silva', 45678913, 'avenida alameda vinha 1009, Centro - Cidade das flores'),
              ('Julia', 'S', 'França', 789123456, 'rua lareijras 861, Centro - Cidade das flores'),
              ('Roberta', 'G', 'Assis', 98745631, 'avenida koller 19, Centro - Cidade das flores'),
              ('Isabela', 'M', 'Cruz', 654789123, 'rua alameda das flores 28, Centro - Cidade das flores');

insert into product (Pname, classification_kids, category, avaliação, size) values
					('Fone de ouvido', false, 'Eletrônico', '4', null),
                    ('Barbie Elsa', true, 'Brinquedos', '3', null),
                    ('Body Carters', true, 'Vestimenta', '5', null),
                    ('Microfone', false, 'Eletrônico', '4', null),
                    ('Sofá retrátil', false, 'Móveis', '3', '3x57x80'),
                    ('Farinha de arroz', false, 'Alimentos', '2', null),
                    ('Fire Stick Amazon', false, 'Eletrônico', '3', null);
                    
select * from clients;
select * from product;

delete from orders where idOrderClient in (1,2,3,4);
insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) values
			(1, default, 'compra via aplicativo', null, 1),
            (2, default, 'compra via aplicativo', 50, 0),
            (3, 'Confirmado', null, null, 1),
            (4, default, 'compra via web site', 150, 0);

select * from orders;

insert into productOrder (idPOorder, poQuantity, poStatus) values
			(1,5,2, null),
            (2,5,1, null),
            (3,6,1, null);

insert into productStorage (storageLocation, quantity) values
			('Rio de Janeiro', 1000),
            ('Rio de Janeiro', 500),
            ('São Paulo', 10),
            ('São Paulo', 100),
            ('São Paulo', 10),
            ('Brasília', 60);

insert into storageLocation (idLproduct, idLstorage, location) values
			(1,2, 'RJ'),
            (2,6, 'GO');

insert into supplier (SocialName, CNPJ, contact) values
			('Almeida e filhos', 123456789123456, '21985474'),
            ('Eletrônicos Silva', 85451964914357, '21985484'),
            ('Eletrônicos Valma', 93456789393469, '21975745');

select * from supplier;

insert into productSupplier (idPsSupplier, idPsProduct, quantity) values
			(1,1,500),
            (1,2,400),
            (2,4,633),
            (3,3,5),
            (2,5,10);

insert into seller (SocialName, AbstName, CNPJ, CPF, location, contact) values
			('Tech eletronics', null, 123456789456321, null, 'Rio de Janeiro', 219567895),
            ('Botique Durgas', null,null, 123456783, 'Rio de Janeiro', 219567895),
            ('Kids world', null, 456789123654485, null, 'São Paulo', 1198657484);

select * from seller;

insert into productSeller (idPseller, idPproduct, prodQuantity) values
			(1,6,80),
            (2,7,10);
            
select * from productSeller;

select count(*) from clients;
select * from clients c, orders o where c.idClient = idOrderClient;
select concat(Fname, ' ', Lname) as Client, idOrder as Request, orderStatus as Status  from clients c, orders o where c.idClient = idOrderClient;