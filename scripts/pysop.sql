-- restablecer base de datos --
drop database if exists pysop;

-- creacion y uso de la base de datos --
create database pysop;
use pysop;

-- creacion de tablas relacionales --
-- Acueducto --
create table acueducto (
nitAcueducto bigint unsigned primary key,
nombreAcueducto varchar(80) not null, 
direccionAcueducto varchar(255) not null, 
correoAcueducto varchar(255) not null, 
telefonoAcueducto varchar(20) not null,
idRups int unsigned unique not null,
consumoBasicoM3 double not null, 
valorConsumoBasico double not null, 
valorMetroCubico double not null
);

-- rol -- 
create table rol (
idRol int unsigned auto_increment primary key, 
descripcionRol varchar(50) not null
);

-- Usuario --
create table usuario (
numDocumento bigint unsigned primary key,
nombreUsuario varchar(80) not null, 
apellidoUsuario varchar(80) not null, 
direccionUsuario varchar(255) not null, 
correoUsuario varchar(255) not null, 
telefonoUsuario varchar(20) not null, 
claveUsuario varchar(50) not null,
estadoUsuario varchar(30) not null, 
idRolFK int unsigned, 
foreign key (idRolFK) references rol (idRol) on delete set null on update cascade
);

-- Novedad --
create table novedad(
idNovedad int unsigned auto_increment primary key,
fechaRegistro date not null, 
descripcionNovedad varchar(255) not null,
estadoNovedad varchar(30) not null, 
tipoNovedad varchar(50) not null,
detalleDeLaSolucion varchar(500),
numDocumentoFK bigint unsigned,
foreign key (numDocumentoFK) references usuario(numDocumento) on delete set null on update cascade
);

-- Contrato --
create table contrato (
idContrato int unsigned auto_increment primary key,
fechaCreacion date not null, 
fechaFinalizacion date, 
numDocumentoFK bigint unsigned unique,
foreign key (numDocumentoFK) references usuario(numDocumento) on delete cascade on update cascade
);

-- Contador -- 
create table medidor (
idMedidor int unsigned auto_increment primary key,
numeroMedidor bigint unsigned not null unique,
idContratoFK int unsigned,
foreign key (idContratoFK) references contrato(idContrato) on delete cascade on update cascade
);

-- Orden de pago --
create table ordenPago (
consecutivoOrdenPago int unsigned auto_increment primary key,
periodoRegistrado varchar(50) not null, 
lecturaActual int not null, 
lecturaAnterior int not null, 
consumoPeriodoM3 double not null,
valorReconexion double default 0.0,
totalOrdenPago double not null,
fechaSuspencion date,
fechaPagoOportuno date not null,
correcionOrdenPago bit,
idContratoFK int unsigned,
nitAcueductoFk bigint unsigned,
foreign key (idContratoFK) references contrato(idContrato) on delete cascade on update cascade,
foreign key (nitAcueductoFK) references acueducto(nitAcueducto) on delete cascade on update cascade
);

-- Pago --
create table pago (
idPago int unsigned auto_increment primary key,
bancoEntidad varchar(80) not null, 
formaPago varchar(50) not null, 
fechaConsignacion date not null,
numDocumentoFK bigint unsigned,
consecutivoOrdenPagoFk int unsigned unique,
foreign key (numDocumentoFK) references usuario(numDocumento) on delete cascade on update cascade,
foreign key (consecutivoOrdenPagoFK) references ordenPago(consecutivoOrdenPago) on delete cascade on update cascade
);


-- STORED PROCEDURE
delimiter //
create procedure psCrearContrato (creacion date, finalizacion date, numDocumento bigint, medidor bigint)
begin
	insert into contrato (fechaCreacion,fechaFinalizacion,numDocumentoFK) values (creacion,finalizacion,numDocumento);
	set @numContrato = (select idContrato from contrato where numDocumentoFK = numDocumento limit 1);
	insert into medidor (numeroMedidor,idContratoFK) values(medidor,@numContrato);
end;
//
-- call psCrearContrato("2023-09-10","2024-09-10", 1022341908,123456789);

-- get contracts
select c.idContrato, u.numDocumento, concat(u.nombreUsuario,' ',u.apellidoUsuario) as 'Nombre usuario' from contrato as c
inner join usuario as u on c.numDocumentoFK = u.numDocumento;
//
-- get contract by id 
SELECT c.fechaCreacion, c.fechaFinalizacion, m.numeroMedidor FROM contrato AS c LEFT JOIN medidor AS m ON c.idContrato = m.idContratoFK WHERE idContratoFK = 1;
//
select * from contrato;
select * from medidor;

