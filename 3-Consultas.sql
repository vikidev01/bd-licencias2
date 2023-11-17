----------------------------------------------------------------------------
------1. Cantidad total de actores, agrupados y ordenados por tipo.---------
----------------------------------------------------------------------------
create type tipo
			as (p_fisica int,
			p_juridica int);

create or replace function total_actores()
	returns setof tipo 
	as
	$$
	declare salida tipo;
	begin
		salida.p_fisica := (select count(*) from actor.actor a
			right join actor.persona_fisica pf
			on a.id = pf.id_actor);
		
		salida.p_juridica := (select count(*) from actor.actor a
			right join actor.persona_juridica pj
			on a.id = pj.id_actor);
		
		return next salida;
	end;
	$$
	language plpgsql;
	
	select total_actores();
	
----------------------------------------------------------------------------
-----------2. Clasificación de personas por ocupación:----------------------
-------informar total(personas) por ocupación, ordenado por ocupación.------
----------------------------------------------------------------------------

select o.nombre_ocupacion, count(*) from actor.persona_fisica pf 
	inner join actor.ocupacion o 
	on pf.id_ocupacion = o.id
	group by o.nombre_ocupacion
	order by o.nombre_ocupacion
	
----------------------------------------------------------------------------
--3. Cantidad de solicitudes presentadas por período (año/mes). 
--Codificar una función que permita pasar como parámetros “año-mes desde” y 
--“año-mes hasta”. La función debe retornar una fila para cada año-mes 
--dentro del rango pasado como parámetros.
----------------------------------------------------------------------------

create or replace function solicitudes_por_periodo(
    desde_periodo varchar(7),
    hasta_periodo varchar(7)
) 
returns table (periodo varchar(7), cantidad int)
as 
$$ 
declare 
    vFechaInicio date;
    vFechaFin date;
begin
    for vFechaInicio in select generate_series(
            to_date(desde_periodo || '-01', 'YYYY-MM-DD'), 
            to_date(hasta_periodo || '-01', 'YYYY-MM-DD'), 
            '1 month'::interval
        )::DATE
    loop
        vFechaFin := vFechaInicio + INTERVAL '1 month' - INTERVAL '1 day';

        select 
            to_char(vFechaInicio, 'YYYY-MM') as periodo,
            count(*) as cantidad
        into 
            periodo, cantidad
        from solicitud.solicitud_licencia_conducir
        where fecha between vFechaInicio and vFechaFin;

        return next;
    end loop;
end; 
$$ 
language plpgsql;


	
-- Llamar a la función procesar_paises para procesar los datos
select * from solicitudes_por_periodo( '2015-10','2016-11');



----------------------------------------------------------------------------
--4-Clasificación de las solicitudes por estado. Codificar una función que permita pasar como
--parámetros “año-mes desde” y “año-mes hasta”. La función debe retornar una fila para cada
--año-mes dentro del rango pasado como parámetros. La salida debe incluir para cada mes,
--una columna para cada estado distinto, donde se muestre la cantidad total de solicitudes que
--se encuentran en cada estado. Considerar unicamente el estado actual.

CREATE OR REPLACE FUNCTION clasificacion_solicitudes_por_estado(
    desde_periodo VARCHAR(7),
    hasta_periodo VARCHAR(7)
) 
RETURNS TABLE (
    periodo VARCHAR(7), 
    EXAMEN_PSIQUIATRICO_NO_APTO INT, 
    EXAMEN_PRACTICO_APROBADO INT, 
    PRESENTADA INT, 
    EXAMEN_PRACTICO_PARCIALMENTE_APROBADO INT,
    APROBADA_SIMUCO INT,
    EXAMEN_PSICO_FISICO_INTERCONSULTA INT,
    EXAMEN_PRACTICO_REPROBADO_N_VECES INT,
    RECHAZADA INT,
    EXAMEN_PSIQUIATRICO_APTO_PRACTICO_N_VECES INT,
    EXAMEN_TEORICO_REPROBADO_N_VECES INT,
    EXAMEN_PRACTICO_REPROBADO INT,
    EXAMEN_PSIQUIATRICO_APTO_TEORICO_N_VECES INT,
    EXAMEN_PSICO_FISICO_NO_APTO INT,
    EXAMEN_PSICO_FISICO_APTO_CON_RESTRICCIONES INT,
    EXAMEN_PSICO_FISICO_APTO INT,
    APROBADA INT,
    EXAMEN_PSIQUIATRICO_APTO INT,
    EXAMEN_TEORICO_APROBADO INT,
    PARCIALMENTE_APROBADA INT,
    EXAMEN_TEORICO_REPROBADO INT,
    otras_situaciones INT
)
AS 
$$ 
DECLARE
    current_period  VARCHAR(7);
    estado_cursor   CURSOR FOR
        SELECT DISTINCT to_char(slc.fecha, 'YYYY-MM') AS periodo
        FROM solicitud.solicitud_licencia_conducir slc
        INNER JOIN solicitud.estado_solicitud es ON slc.id = es.id_solicitud
        WHERE slc.fecha BETWEEN 
            to_date(desde_periodo || '-01', 'YYYY-MM-DD') AND 
            to_date(hasta_periodo || '-01', 'YYYY-MM-DD') + interval '1 month' - interval '1 day';

    estado_record   RECORD;
BEGIN
    OPEN estado_cursor;

    LOOP
        FETCH estado_cursor INTO current_period;

        EXIT WHEN NOT FOUND;

        RETURN QUERY
        SELECT 
            current_period AS periodo,
            count(*) FILTER (WHERE es.tipo = 'EXAMEN_PSIQUIATRICO_NO_APTO')::INT AS EXAMEN_PSIQUIATRICO_NO_APTO,
            count(*) FILTER (WHERE es.tipo = 'EXAMEN_PRACTICO_APROBADO')::INT AS EXAMEN_PRACTICO_APROBADO,
            count(*) FILTER (WHERE es.tipo = 'PRESENTADA')::INT AS PRESENTADA,
            count(*) FILTER (WHERE es.tipo = 'EXAMEN_PRACTICO_PARCIALMENTE_APROBADO')::INT AS EXAMEN_PRACTICO_PARCIALMENTE_APROBADO,
            count(*) FILTER (WHERE es.tipo = 'APROBADA_SIMUCO')::INT as APROBADA_SIMUCO,
            count(*) FILTER (WHERE es.tipo = 'EXAMEN_PSICO_FISICO_INTERCONSULTA')::INT AS EXAMEN_PSICO_FISICO_INTERCONSULTA,
            count(*) FILTER (WHERE es.tipo = 'EXAMEN_PRACTICO_REPROBADO_N_VECES')::INT AS EXAMEN_PRACTICO_REPROBADO_N_VECES,
            count(*) FILTER (WHERE es.tipo = 'RECHAZADA')::INT AS RECHAZADA,
            count(*) FILTER (WHERE es.tipo = 'EXAMEN_PSIQUIATRICO_APTO_PRACTICO_N_VECES')::INT AS EXAMEN_PSIQUIATRICO_APTO_PRACTICO_N_VECES,
            count(*) FILTER (WHERE es.tipo = 'EXAMEN_TEORICO_REPROBADO_N_VECES')::INT AS EXAMEN_TEORICO_REPROBADO_N_VECES,
            count(*) FILTER (WHERE es.tipo = 'EXAMEN_PRACTICO_REPROBADO')::INT AS EXAMEN_PRACTICO_REPROBADO,
            count(*) FILTER (WHERE es.tipo = 'EXAMEN_PSIQUIATRICO_APTO_TEORICO_N_VECES')::INT AS EXAMEN_PSIQUIATRICO_APTO_TEORICO_N_VECES,
            count(*) FILTER (WHERE es.tipo = 'EXAMEN_PSICO_FISICO_NO_APTO')::INT AS EXAMEN_PSICO_FISICO_NO_APTO,
            count(*) FILTER (WHERE es.tipo = 'EXAMEN_PSICO_FISICO_APTO_CON_RESTRICCIONES')::INT AS EXAMEN_PSICO_FISICO_APTO_CON_RESTRICCIONES,
            count(*) FILTER (WHERE es.tipo = 'EXAMEN_PSICO_FISICO_APTO')::INT AS EXAMEN_PSICO_FISICO_APTO,
            count(*) FILTER (WHERE es.tipo = 'APROBADA')::INT AS APROBADA,
            count(*) FILTER (WHERE es.tipo = 'EXAMEN_PSIQUIATRICO_APTO')::INT AS EXAMEN_PSIQUIATRICO_APTO,
            count(*) FILTER (WHERE es.tipo = 'EXAMEN_TEORICO_APROBADO')::INT AS EXAMEN_TEORICO_APROBADO,
            count(*) FILTER (WHERE es.tipo = 'PARCIALMENTE_APROBADA')::INT AS PARCIALMENTE_APROBADA,
            count(*) FILTER (WHERE es.tipo = 'EXAMEN_TEORICO_REPROBADO')::INT AS EXAMEN_TEORICO_REPROBADO,
            count(*) FILTER (WHERE es.tipo NOT IN ('EXAMEN_PSIQUIATRICO_NO_APTO', 'EXAMEN_PRACTICO_APROBADO', 'PRESENTADA',
                'EXAMEN_PRACTICO_PARCIALMENTE_APROBADO', 'APROBADA_SIMUCO', 'EXAMEN_PSICO_FISICO_INTERCONSULTA',
                'EXAMEN_PRACTICO_REPROBADO_N_VECES', 'RECHAZADA', 'EXAMEN_PSIQUIATRICO_APTO_PRACTICO_N_VECES',
                'EXAMEN_TEORICO_REPROBADO_N_VECES', 'EXAMEN_PRACTICO_REPROBADO', 'EXAMEN_PSIQUIATRICO_APTO_TEORICO_N_VECES',
                'EXAMEN_PSICO_FISICO_NO_APTO', 'EXAMEN_PSICO_FISICO_APTO_CON_RESTRICCIONES', 'EXAMEN_PSICO_FISICO_APTO', 'APROBADA',
                'EXAMEN_PSIQUIATRICO_APTO', 'EXAMEN_TEORICO_APROBADO', 'PARCIALMENTE_APROBADA', 'EXAMEN_TEORICO_REPROBADO'
            ))::INT AS otras_situaciones
        FROM solicitud.estado_solicitud es
        INNER JOIN solicitud.solicitud_licencia_conducir slc ON es.id_solicitud = slc.id
        WHERE to_char(es.fecha, 'YYYY-MM') = current_period;
       END LOOP;

CLOSE estado_cursor;

RETURN;
END;
$$
language plpgsql;
---------------------------Pruebo funcion---------------------------------------------------------
SELECT * FROM clasificacion_solicitudes_por_estado('2016-07', '2016-08');
	