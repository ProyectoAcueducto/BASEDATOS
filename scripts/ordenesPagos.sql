-- 
-- inserciones 
INSERT INTO `pysop`.`ordenpago` (`periodoRegistrado`, `lecturaActual`, `lecturaAnterior`, `consumoPeriodoM3`, `valorReconexion`, `totalOrdenPago`, `fechaPagoOportuno`, `idContratoFK`, `nitAcueductoFk`) VALUES ('enero-febrero', '3002', '2994', '25', '0', '25000', '2023-11-02', '2', '9000215353');
INSERT INTO `pysop`.`ordenpago` (`periodoRegistrado`, `lecturaActual`, `lecturaAnterior`, `consumoPeriodoM3`, `valorReconexion`, `totalOrdenPago`, `fechaPagoOportuno`, `idContratoFK`, `nitAcueductoFk`) VALUES ('marzo-abril', '4250', '4000', '250', '0', '250000', '2023-11-05', '3', '9000215353');
INSERT INTO `pysop`.`ordenpago` (`periodoRegistrado`, `lecturaActual`, `lecturaAnterior`, `consumoPeriodoM3`, `valorReconexion`, `totalOrdenPago`, `fechaPagoOportuno`, `idContratoFK`, `nitAcueductoFk`) VALUES ('mayo-junio', '2500', '2100', '100', '0', '100000', '2023-12-05', '3', '9000215353');


-- CONSULTAS (VIEWS)
create view buscarOrdenesPago -- get all op
(ConsecutivoOrdenPago, NombreUsuario, NumDocumento, PeriodoRegistrado, ConsumoPeriodoM3, TotalOrdenPago, PagoRegistrado) as 
select op.consecutivoOrdenPago, concat(u.nombreUsuario, ' ', u.apellidoUsuario), u.numDocumento, op.periodoRegistrado,
op.consumoPeriodoM3, op.totalOrdenPago, (select idPago from pago where consecutivoOrdenPagoFk = op.consecutivoOrdenPago ) as pagoRegistrado
from ordenpago as op inner join contrato as c on op.idContratoFK = c.idContrato
inner join usuario as u on c.numDocumentoFK = u.numDocumento;
select * from buscarOrdenesPago;

-- STORES PROCEDURES --  

-- buscar una orden de pago por el id
delimiter //
create procedure psBuscarOrdenePagoById (in consecutivo int) -- get by id
begin
	select op.consecutivoOrdenPago, u.numDocumento, op.lecturaAnterior, op.lecturaActual, op.valorReconexion, op.periodoRegistrado, op.fechaPagoOportuno, op.fechaSuspencion,
	op.consumoPeriodoM3, op.totalOrdenPago
	from ordenpago as op inner join contrato as c on op.idContratoFK = c.idContrato
	inner join usuario as u on c.numDocumentoFK = u.numDocumento
	where op.consecutivoOrdenPago = consecutivo;
end;//
-- call psBuscarOrdenePagoById(5);

-- actualizar una orden de pago
delimiter //
create procedure psActualizarOrdenPago (consecutivo int, lecAnterior int, lecActual int, reconexion double, periodo varchar(50), pagoOportuno date,
fechaCorte date, consumoM3 double, totalOrden double) -- update
begin
	-- consumom3 * valorm3 + reconexion
    set @valorM3 = (select valorMetroCubico from acueducto);
    set @total = (consumoM3 * @valorM3) + reconexion;
    UPDATE ordenpago SET consecutivoOrdenPago = consecutivo, periodoRegistrado = periodo, lecturaActual = lecActual, lecturaAnterior = lecAnterior,
    consumoPeriodoM3 = consumoM3, valorReconexion = reconexion, totalOrdenPago = @total, fechaSuspencion = fechaCorte, fechaPagoOportuno = pagoOportuno, correcionOrdenPago = 1
	WHERE consecutivoOrdenPago = consecutivo;
end;//
-- call psActualizarOrdenPago(5,2100,2600,3000,'mayo-junio','2023-12-05','2023-12-10',80,100000);

select correcionOrdenPago from ordenpago where consecutivoOrdenPago = 1;
-- agregar una orden de pago
delimiter //
create procedure psAgregarOrdenPago (idContrato int, lecActual int, lecAnterior int, periodo varchar(50), consumoM3 double,
reconexion double, totalOrden double, fechaCorte date, pagoOportuno date) 
begin
    set @numNit = (select nitAcueducto from acueducto);
	insert into ordenpago (periodoRegistrado, lecturaActual, lecturaAnterior, consumoPeriodoM3, valorReconexion, totalOrdenPago, 
	fechaSuspencion, fechaPagoOportuno, idContratoFK, nitAcueductoFk)
	values (periodo, lecActual, lecAnterior, consumoM3, reconexion, totalOrden, nullif(fechaCorte,null), pagoOportuno, idContrato,@numNit);
end;//

-- call psAgregarOrdenPago(3,2500,2250,'enero-febrero',90,0,90000,null,'2023-12-21');
-- call psAgregarOrdenPago(3,2500,2250,'octubre-noviembre',90,2500,92500,'2023-12-30','2023-12-21');

   
