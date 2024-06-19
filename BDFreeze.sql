drop database Freeze;
create database Freeze;
use Freeze;

create table users
(
id int auto_increment,
email varchar(100) not null,
passwd varchar(300) not null,
constraint pk_users primary key (id)
);

create table productos_escaneados
(
id int auto_increment,
codigo_barra varchar(100),
nombre varchar(300),
imagen longblob,
constraint pk_producto_escaneados primary key (id)
);

create table inventario
(
id int auto_increment,
cantidad int,
usuario int,
producto int,
constraint pk_inventario primary key (id),
constraint fk_inventario_user foreign key (usuario) references users(id),
constraint fk_inventario_product foreign key (producto) references productos_escaneados(id)
);

create table lista_compra
(
id int auto_increment,
cantidad int,
usuario int,
producto int,
constraint pk_lista_compra primary key (id),
constraint fk_lista_compra_user foreign key (usuario) references users(id),
constraint fk_lista_compra_product foreign key (producto) references productos_escaneados(id)
);

create table productos_comprados
(
id int auto_increment,
cantidad int,
usuario int,
producto int,
constraint pk_productos_comprados primary key (id),
constraint fk_productos_comprados_user foreign key (usuario) references users(id),
constraint fk_productos_comprados_product foreign key (producto) references productos_escaneados(id)
);

