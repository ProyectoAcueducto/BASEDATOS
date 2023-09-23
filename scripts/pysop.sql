-- restablecer base de datos --
drop database if exists pysop;

-- creacion y uso de la base de datos --
create database pysop;
use pysop;

-- creacion de tablas relacionales --
-- Acueducto --
create table acueducto (
nitAcueducto int unsigned primary key,
nombreAcueducto varchar(50) not null, 
direccionAcueducto varchar(80) not null, 
correoAcueducto varchar(70) not null, 
telefonoAcueducto varchar(20) not null,
idRups int unsigned unique not null,
consumoBasicoM3 int not null, 
valorConsumoBasico double not null, 
valorMetroCubico double not null
);

-- rol -- 
create table rol (
idRol int unsigned auto_increment primary key, 
descripcionRol varchar(30) not null
);

-- Usuario --
create table usuario (
numDocumento int unsigned primary key,
nombreUsuario varchar(50) not null, 
apellidoUsuario varchar(50) not null, 
direccionUsuario varchar(80) not null, 
correoUsuario varchar(70) not null, 
telefonoUsuario varchar(20) not null, 
claveUsuario varchar(50) not null,
estadoUsuario varchar(30), 
idRolFK int unsigned, 
foreign key (idRolFK) references rol (idRol) on delete set null on update cascade
);

-- Novedad --
create table novedad(
idNovedad int unsigned auto_increment primary key,
fechaRegistro date not null, 
descripcionNovedad varchar(50) not null,
estadoNovedad varchar(30) not null, 
tipoNovedad varchar(30),
numDocumentoFK int unsigned,
foreign key (numDocumentoFK) references usuario(numDocumento) on delete set null on update cascade
);

-- Contrato --
create table contrato (
idContrato int unsigned auto_increment primary key,
fechaCreacion date not null, 
fechaFinalizacion date, 
numDocumentoFK int unsigned,
foreign key (numDocumentoFK) references usuario(numDocumento) on delete cascade on update cascade
);

-- Contador -- 
create table contador (
idContador int unsigned auto_increment primary key,
numeroContador int unsigned not null unique,
idContratoFK int unsigned,
foreign key (idContratoFK) references contrato(idContrato) on delete cascade on update cascade
);

-- Orden de pago --
create table ordenPago (
consecutivoOrdenPago int unsigned auto_increment primary key,
periodoRegistrado varchar(25) not null, 
lecturaActual int not null, 
lecturaAnterior int not null, 
consumoPeriodoM3 int not null,
valorReconexion double,
totalOrdenPago double not null,
fechaSuspencion date,
fechaPagoOportuno date not null,
correcionOrdenPago bit,
idContratoFK int unsigned,
nitAcueductoFk int unsigned,
foreign key (idContratoFK) references contrato(idContrato) on delete cascade on update cascade,
foreign key (nitAcueductoFK) references acueducto(nitAcueducto) on delete cascade on update cascade
);

-- Pago --
create table pago (
idPago int unsigned auto_increment primary key,
bancoEntidad varchar(50) not null, 
formaPago varchar(30) not null, 
fechaConsignacion date not null,
numDocumentoFK int unsigned,
consecutivoOrdenPagoFk int unsigned,
foreign key (numDocumentoFK) references usuario(numDocumento) on delete cascade on update cascade,
foreign key (consecutivoOrdenPagoFK) references ordenPago(consecutivoOrdenPago) on delete cascade on update cascade
);















