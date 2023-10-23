-- enero-febrero


-- inserciones 
INSERT INTO `pysop`.`ordenpago` (`periodoRegistrado`, `lecturaActual`, `lecturaAnterior`, `consumoPeriodoM3`, `valorReconexion`, `totalOrdenPago`, `fechaPagoOportuno`, `idContratoFK`, `nitAcueductoFk`) VALUES ('enero-febrero', '3002', '2994', '25', '0', '25000', '2023-11-02', '1', '9000215353');
INSERT INTO `pysop`.`ordenpago` (`periodoRegistrado`, `lecturaActual`, `lecturaAnterior`, `consumoPeriodoM3`, `valorReconexion`, `totalOrdenPago`, `fechaPagoOportuno`, `idContratoFK`, `nitAcueductoFk`) VALUES ('marzo-abril', '4250', '4000', '250', '0', '250000', '2023-11-05', '2', '9000215353');
INSERT INTO `pysop`.`ordenpago` (`periodoRegistrado`, `lecturaActual`, `lecturaAnterior`, `consumoPeriodoM3`, `valorReconexion`, `totalOrdenPago`, `fechaPagoOportuno`, `idContratoFK`, `nitAcueductoFk`) VALUES ('mayo-junio', '2500', '2100', '100', '0', '100000', '2023-12-05', '2', '9000215353');


-- consultas vistas 
create view buscarOrdenesPago 
(ConsecutivoOrdenPago, NombreUsuario, NumDocumento, PeriodoRegistrado, ConsumoPeriodoM3, TotalOrdenPago, PagoRegistrado) as 
select op.consecutivoOrdenPago, concat(u.nombreUsuario, ' ', u.apellidoUsuario), u.numDocumento, op.periodoRegistrado,
op.consumoPeriodoM3, op.totalOrdenPago, (select idPago from pago where consecutivoOrdenPagoFk = op.consecutivoOrdenPago ) as pagoRegistrado
from ordenpago as op inner join contrato as c on op.idContratoFK = c.idContrato
inner join usuario as u on c.numDocumentoFK = u.numDocumento;
select * from buscarOrdenesPago;




