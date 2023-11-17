/* Importación de datos
Codificar los scripts necesarios que permitan importar datos en las estructuras creadas a partir
de archivos “.csv” que serán enviados por la cátedra a cada grupo. */

/********************************************************************
*                     IMPORTACIÓN DE DATOS GEOGRAFICOS              *    
********************************************************************/
--Crear un esquema temporal
create schema tmp;
-- Crear una tabla temporal llamada copy_PaisProvinciaDepto con la misma estructura de la tabla actor.pais_provincia_departamento
create table tmp.copy_PaisProvinciaDepto(
    pais_id int,
    codigo_pais varchar(3),
    nombre_pais varchar(80),
    nombre_pais_resumido varchar(80),
    gentilicio varchar(80),
    sin_uso varchar(10),
    provincia_id int,
    codigo_provincia int,
    nombre_provincia varchar(80),
    nombre_provincia_resumido varchar(80),
    provincia_id_pais int,
    departamento_id int,
    codigo_departamento int,
    nombre_departamento varchar(80),
    nombre_departamento_resumido varchar(80),
    departamento_id_provincia int, 
    secuencia int
)

-- Copiar datos desde un archivo CSV a la tabla temporal
copy tmp.copy_PaisProvinciaDepto from 'D:\Facultad\BaseDatos\TP2-v1\csv\PaisProvinciaDepto-1698684570770.csv'
with (format csv, delimiter E'\t', header true, null '');

---------------------------------------------------------------------------------------------------------------------------------------
-- Crear una función llamada procesar_paises que procesa los datos de la tabla temporal y los inserta en la tabla actor.pais
create or replace function procesar_paises()
returns void as 
$$
declare rec_temp record;
begin 
    FOR rec_temp IN SELECT * FROM tmp.copy_PaisProvinciaDepto
    LOOP
        -- Realizar cualquier procesamiento necesario
        -- Puedes aplicar lógica adicional según tus necesidades
        if not exists (select * from actor.pais p where p.id = rec_temp.pais_id ) then 
        
        	if (rec_temp.gentilicio is null) then
	    					rec_temp.gentilicio := 'NO ESPECIFICADO';
	    				end if;	  
            -- Insertar en la tabla de destino
            INSERT INTO actor.pais (id, codigo_pais, nombre_pais, nombre_pais_resumido, gentilicio)
            VALUES (rec_temp.pais_id, rec_temp.codigo_pais, rec_temp.nombre_pais, rec_temp.nombre_pais_resumido, rec_temp.gentilicio);
        end if;
       
       
    END LOOP;
end;
$$
language plpgsql;

-- Llamar a la función procesar_paises para procesar los datos
select procesar_paises();

-- Devuelve los paises que se insertaron
select * from actor.pais p ;

------------------------------------------------------------------------------------------------

-- Crear una función llamada procesar_provincias que procesa los datos de la tabla temporal y los inserta en la tabla actor.provincia
create or replace function procesar_provincias()
returns void as 
$$
declare rec_temp record;
begin 
    FOR rec_temp IN SELECT * FROM tmp.copy_PaisProvinciaDepto
    LOOP
        -- Realizar cualquier procesamiento necesario
        -- Puedes aplicar lógica adicional según tus necesidades
	    
	     
	    
	    if not exists (select * from actor.provincia_estado pe 
	    				where pe.id  = rec_temp.provincia_id 
	    				) and rec_temp.provincia_id is not null then
	    				
 			insert into actor.provincia_estado(id, id_pais, codigo_provincia, nombre_provincia, nombre_provincia_resumido)
 			values (rec_temp.provincia_id, rec_temp.pais_id, rec_temp.codigo_provincia, rec_temp.nombre_provincia, rec_temp.nombre_provincia_resumido);
        end if;
    END LOOP;
end;
$$
language plpgsql;

-- Llama a la función procesar_provincias para procesar los datos
select procesar_provincias();

-- Devuelve las provincias que se insertaron
select  * from actor.provincia_estado pe ;

------------------------------------------------------------------------------------------------

-- Crear una función llamada procesar_departamento que procesa los datos de la tabla temporal y los inserta en la tabla actor.departamento
create or replace function procesar_departamento()
returns void as 
$$
declare rec_temp record;
begin 
    FOR rec_temp IN SELECT * FROM tmp.copy_PaisProvinciaDepto
    LOOP
        -- Realizar cualquier procesamiento necesario
        -- Puedes aplicar lógica adicional según tus necesidades
	    
	    if not exists (select * from actor.departamento d
	    				where d.id = rec_temp.departamento_id) and rec_temp.departamento_id is not null then 
	    				insert into actor.departamento(id, id_provincia_estado, secuencia, codigo_departamento, nombre_departamento, nombre_departamento_resumido)
	    				values (rec_temp.departamento_id, rec_temp.provincia_id, rec_temp.secuencia, rec_temp.codigo_departamento, 
	    						rec_temp.nombre_departamento, rec_temp.nombre_departamento_resumido);
        end if;
    END LOOP;
end;
$$
language plpgsql;

-- Llama a la función procesar_departamento para procesar los datos
select procesar_departamento();

-- Devuelve los departamentos que se insertaron
select * from actor.departamento d  ;
/********************************************************************
*                     IMPORTACIÓN DE DATOS Localidad                *    
********************************************************************/

create table tmp.copy_Localidad(
    id int,
    codigo_localidad int,
    codigo_postal int,
    nombre_localidad varchar(80),
    nombre_localidad_resumido varchar(80),
    id_departamento int,
    id_provincia int,
    ver varchar(20)
);


-- Copiar datos desde un archivo CSV a la tabla temporal
copy tmp.copy_Localidad from 'D:\Facultad\BaseDatos\TP2-v1\csv\Localidad-1698869697208.csv'
with (format csv, delimiter E'\t', header true, null '');


select * from tmp.copy_Localidad;

-- Crear una función llamada procesar_localidad que procesa los datos de la tabla temporal y los inserta en la tabla actor.localidad
create or replace function procesar_localidad()
returns void as 
$$
declare rec_temp record;
begin 
    FOR rec_temp IN SELECT * FROM tmp.copy_Localidad
    LOOP
        -- Realizar cualquier procesamiento necesario
        -- Puedes aplicar lógica adicional según tus necesidades
	    if not exists (select * from actor.localidad l 
	    				where l.id = rec_temp.id) then 
	    		insert into actor.localidad (id, id_departamento,id_provincia_estado, codigo_localidad,nombre_localidad, 
	    									nombre_localidad_resumido, codigo_postal)
	    		values (rec_temp.id, rec_temp.id_departamento, rec_temp.id_provincia, rec_temp.codigo_localidad, rec_temp.nombre_localidad, 
	    				rec_temp.nombre_localidad_resumido, rec_temp.codigo_postal);
	    
        end if;
	    
	    
    END LOOP;
end;
$$
language plpgsql;


select procesar_localidad();

select * from actor.localidad;


/************************************************************************
*                     IMPORTACIÓN DE DATOS ROL                          *
************************************************************************/
-- Crear una tabla temporal llamada copy_rol con la misma estructura de la tabla actor.rol
create table tmp.copy_Rol(
	tipo_rol 	varchar(60),
 	rol_id 		integer,
    codigo_rol	integer, 
    a_id 		integer,
    versi 	 	varchar(2)
);

-- Copiar datos desde un archivo CSV a la tabla temporal
copy tmp.copy_Rol from 'D:\Facultad\BaseDatos\TP2-v1\csv\Rol-1698950878517.csv'
with (format csv, delimiter E'\t', header true, null '');

---------------------------------------------------------------------------------------------------------------------------------------
-- Crear una función llamada procesar_paises que procesa los datos de la tabla temporal y los inserta en la tabla actor.pais
create or replace function procesar_roles()
returns void as 
$$
declare rec_temp record;
begin 
    FOR rec_temp IN SELECT * FROM tmp.copy_Rol
    LOOP
        -- Realizar cualquier procesamiento necesario
        -- Puedes aplicar lógica adicional según tus necesidades
        if not exists (select * from actor.rol r where r.id = rec_temp.rol_id ) then   
            -- Insertar en la tabla de destino
            INSERT INTO actor.rol (id, id_actor, tipo_rol, codigo_rol)
            VALUES (rec_temp.rol_id, rec_temp.a_id, rec_temp.tipo_rol, rec_temp.codigo_rol);
        end if;
       
       
    END LOOP;
end;
$$
language plpgsql;

-- Llamar a la función procesar_roles para procesar los datos
select procesar_roles();

-- Devuelve los roles que se insertaron
select * from actor.rol ;

/*****************************************************************************************************************
*                     IMPORTACIÓN DE DATOS USUARIO                                                               *
******************************************************************************************************************/
--Creamos tabla en el esquema temporal que nos permita 
create table tmp.copy_Usuario 
	(
		id					integer,
		id_usuario_ficticio	varchar(80),
		apellido_nombre		varchar(255),
		fecha_alta			date,
		vers  				varchar(6),	
		a_id 				integer,	
		hash				varchar(255),
		time_hash			bigint,
		chapa_inspector		integer,
		reparticion			varchar(80)
	)
	
--Importamos los datos desde el .csv a la tabla creada mediante el comando copy
copy tmp.copy_usuario from 'D:\Facultad\BaseDatos\TP2-v1\csv\Usuario-1698951976224.csv'
	with (format csv, delimiter E'\t', header true, null '');

--Comprobamos que se hayan cargado los datos
select * from tmp.copy_Usuario; 

-------------------------------------------------------------------------------------------------------------------------
--Creamos la función procesa_usuarios que inserta los datos importados en la tabla tmp.copy_usuarios en la tabla que le corresponda dentro de la base de datos
create or replace function procesa_usuarios()
returns void

as 
$$
declare rec_usuario record;

begin
	for rec_usuario in select * from tmp.copy_Usuario
	--Comenzamos LOOP
	loop
		if not exists (select * from actor.usuario u where u.id = rec_usuario.id) then
			
			--En caso de que el nombre y apellido no este especificado, de momento se deja con la variable en "No especificado"
			if (rec_usuario.apellido_nombre is null) then
				rec_usuario.apellido_nombre := 'No especificado'; 
			end if;
		
			--En caso de que exista mas un un a_id que hacemos?
		
			--Insertamos en la tabla destino de la base de datos
			insert into actor.usuario (id, id_actor, id_usuario, apellido_nombre, fecha_alta, hash, time_hash) 
				values (rec_usuario.id, rec_usuario.a_id, rec_usuario.id_usuario_ficticio, rec_usuario.apellido_nombre, rec_usuario.fecha_alta, rec_usuario.hash,
				rec_usuario.time_hash);
		
		end if;

	end loop;
end;
$$
language plpgsql;


-- Llamamos a procesa_usuarios para procesar e  insertar los datos
select procesa_usuarios();

-- Devuelve los paises que se insertaron
select * from actor.usuario u;

---------------------------------------Arreglos extras-----------------------------------------------------------
--Modificamos la tabla actor.usuarios para que el integer de time_hash entre en un bigint
--ALTER TABLE nombre_tabla ALTER COLUMN nombre_columna SET DATA TYPE tipo_de_dato;
alter table actor.usuario alter column time_hash set data type bigint;

--Modificamos la unique de actor_usuario
alter table actor.usuario drop constraint unq_usuario_actor;

/*******************************************************
*                     IMPORTACIÓN DE DATOS ACTOR        *
********************************************************/



--Creamos dentro del schema, la tabla en la cual se imporataran los datos desde el .csv
create table tmp.copy_Actor (
	tipo								char,	
	id_actor     						integer,
	apellido_per_fisica 				varchar(255),
	codigo_actor						integer,
	cuit_codigo1						integer,	
	cuit_codigo2						integer,
	cuit_codigo3						integer,
	documento_identidad_tipo_per_fisica	varchar(1),
	documento_identidad_numero_per_fisica	integer,
	email_principal						varchar(255),
	estado_civil_per_fisica				char(1),
	fecha_alta							date,
	fecha_baja							date,
	fecha_nacimiento_per_fisica			date,
	movil_principal_per_fisica			varchar(255),
	nombre_per_fisica					varchar(255),	
	nombre_fantasia_per_juridica		varchar(255),
	nombre_organismo					varchar(255),
	razon_social_per_juridica			varchar(255),
	sexo_per_fisica						char(1),
	sigla_organismo						varchar(60),
	telefono_principal					varchar(255),
	id_pais								integer,
	id_tipo_persona_juridica			integer,
	apellido_materno					varchar(255),
	id_ocupacion						integer,
	factor_sanguineo					varchar(255),
	grupo_sanguineo						varchar(255),
	donante_organos						varchar(255),
	email_personal_per_fisica			varchar(255),
	identidad_genero_per_fisica			varchar(255),
	id_incognito_no_pais				integer,
	codigo_pais							varchar(3),
	nombre_pais							varchar(60),
	nombre_pais_resumido				varchar(20),
	gentilicio							varchar(255),
	id_per_juridica						integer,						
	codigo_tipo_persona_juridica		integer,
	nombre_tipo_persona_juridica		varchar(60),
	nombre_tipo_persona_juridica_resumido varchar(20),
	id_incognito2_no_ocupacion			integer,
	codigo_ocupacion					integer,
	nombre_ocupacion					varchar(60),	
	nombre_ocupacion_resumido			varchar(20),
	no_usar								varchar(255)
)


--Comando copy mediante el cual se imporatan los datos a la tabla tmp preparada anteriormente para tal función
copy tmp.copy_Actor from 'D:\Facultad\BaseDatos\TP2-v1\csv\Actor-1698954423477C.csv'
	with (FORMAT csv, delimiter E'\t', header true, null '');

--Verificacion  de que haya datos cargados en dicha tabla tmp
select * from tmp.copy_Actor;

--Debemos cargar en primer lugar los datos de ocupacion que tengamos disponibles y los datos de actores para luego cargar personas fisicas 
--y juridicas y mantener la integridad referencial.

-----------------------------------Procesar datos de Ocupacion-------------------------------------------------------------------------------
--Funcion que procesa los datos importados en la tabla tmp y los ubica en la tabla que corresponda
create or replace function procesa_ocupacion()
	returns void
	
	as
	$$
	declare
		tmp_actores record;
	begin
		for tmp_actores in select * from tmp.copy_actor ca where ca.id_ocupacion is not null
			loop
				if not exists (select * from actor.ocupacion o where o.id = tmp_actores.id_ocupacion) then
					insert into actor.ocupacion (id, codigo_ocupacion, nombre_ocupacion, nombre_ocupacion_resumido) 
						values (tmp_actores.id_ocupacion, tmp_actores.codigo_ocupacion, tmp_actores.nombre_ocupacion, 
						tmp_actores.nombre_ocupacion_resumido);
				end if;
			end loop;
			
	end;
	$$
	language plpgsql;
	
--Llamamos a procesa_actor()
select procesa_ocupacion();

--Consultamos los datos ingresados
select * from actor.ocupacion o;

-----------------------------------Procesar datos de actores-------------------------------------------------------------------------------
--Funcion que procesa los datos importados en la tabla tmp y los ubica en la tabla que corresponda
create or replace function procesa_actor()
	returns void
	
	as
	$$
	declare
		tmp_actores record;
	begin
		for tmp_actores in select * from tmp.copy_Actor 
			loop
				if not exists (select * from actor.actor a where a.id = tmp_actores.id_actor) then 
					insert into actor.actor (id, id_pais, codigo_actor, cuit_codigo1, cuit_codigo2, cuit_codigo3,email_principal, fecha_alta,
					fecha_baja, telefono_ppal) values (tmp_actores.id_actor, tmp_actores.id_pais, tmp_actores.codigo_actor, tmp_actores.cuit_codigo1,
					tmp_actores.cuit_codigo2, tmp_actores.cuit_codigo3, tmp_actores.email_principal, tmp_actores.fecha_alta,
					tmp_actores.fecha_baja, tmp_actores.telefono_principal);
				end if;
			end loop;
			
	end;
	$$
	language plpgsql;
	
--Llamamos a procesa_actor()
select procesa_actor();

--Consultamos los datos ingresados
select * from actor.actor a;

-----------------------------------Procesar datos de tabla Tipo Persona Juridica-------------------------------------------------------------------------------

create or replace function procesa_tipoPers_juridica()
	returns void
	
	as
	$$
	declare tmp_actores record;
	
	begin 
		for tmp_actores in select * from tmp.copy_actor ca where ca.id_tipo_persona_juridica is not null
		loop 
			if not exists (select * from actor.tipo_persona_juridica tpj where tpj.id = tmp_actores.id_tipo_persona_juridica) then
				insert into actor.tipo_persona_juridica (id, codigo_tipo_persona_juridica, nombre_tipo_persona_juridica, nombre_tipo_persona_juridica_resumido)
					values (tmp_actores.id_tipo_persona_juridica, tmp_actores.codigo_tipo_persona_juridica, tmp_actores.nombre_tipo_persona_juridica,
					tmp_actores.nombre_tipo_persona_juridica_resumido);
			end if;
		end loop;
		
	end;
	$$
	language plpgsql;
	
--Llamamos a la función para que procese los datos a insertar
select procesa_tipopers_juridica();

--Comprobamos que es lo que cargo la función 
select * from actor.tipo_persona_juridica tpj;

-----------------------------------Procesar datos de persona juridica-------------------------------------------------------------------------------
--Funcion que procesa los datos importados en la tabla tmp y los ubica en la tabla que corresponda
create or replace function procesa_pers_juridica()
	returns void
	
	as
	$$
	declare
		tmp_actores record;
	begin
		for tmp_actores in select * from tmp.copy_Actor ca where ca.tipo = 'J'
			loop
				if not exists (select * from actor.persona_juridica pj where pj.razon_social  = tmp_actores.razon_social_per_juridica) then 
					
					if tmp_actores.nombre_fantasia_per_juridica is null then 
						tmp_actores.nombre_fantasia_per_juridica := 'No especifica';
					end if;
				
					insert into actor.persona_juridica (id, id_actor, id_tipo_persona_juridica, nombre_fantasia, razon_social) 
						values (tmp_actores.id_per_juridica, tmp_actores.id_actor, tmp_actores.id_tipo_persona_juridica, 
						tmp_actores.nombre_fantasia_per_juridica, tmp_actores.razon_social_per_juridica);
				end if;
			end loop;
			
	end;
	$$
	language plpgsql;
	
--Llamamos a procesa_actor()
select procesa_pers_juridica();

--Consultamos los datos ingresados
select * from actor.persona_juridica pj;

-------------------------------------Procesar datos de la tabla persona física-------------------------------------------------------------------------------
--Funcion que procesa los datos importados en la tabla tmp y los ubica en la tabla que corresponda
create or replace function procesa_pers_fisica()
	returns void
	
	as
	$$
	declare 
		tmp_actores record;
	begin
		
		for tmp_actores in select * from tmp.copy_actor ca where ca.tipo = 'F'
			loop 
				--Se insertan todos los datos de personas fisicas mas alla de si se repiten numero de dni o no... 
				--Por lo tanto pueden existir mas de una persona fisica con el mismo numero de documento...
				
				if tmp_actores.documento_identidad_tipo_per_fisica is null then
					tmp_actores.documento_identidad_tipo_per_fisica := 'D';
				end if;
				
				if tmp_actores.estado_civil_per_fisica is null then
					tmp_actores.estado_civil_per_fisica := 'N';
				end if;
			
				if tmp_actores.documento_identidad_numero_per_fisica is null then
					tmp_actores.documento_identidad_numero_per_fisica := tmp_actores.id_actor;
				end if;
				
				if tmp_actores.fecha_nacimiento_per_fisica is null then
					tmp_actores.fecha_nacimiento_per_fisica := '1900-01-01';
				end if;
			
				if tmp_actores.apellido_per_fisica is null then
					tmp_actores.apellido_per_fisica := 'No especifica';
				end if;
				
				insert into actor.persona_fisica (id, id_actor, id_ocupacion, documento_identidad_tipo, documento_identidad_numero, apellido, fechanacimiento,
				nombre, movil_princiapl, sexo, apellido_materno, donante_organos, email_personal, identidad_genero, estado_civil)
					values (tmp_actores.documento_identidad_numero_per_fisica, tmp_actores.id_actor, tmp_actores.id_ocupacion,
					tmp_actores.documento_identidad_tipo_per_fisica, tmp_actores.documento_identidad_numero_per_fisica,
					tmp_actores.apellido_per_fisica, tmp_actores.fecha_nacimiento_per_fisica, tmp_actores.nombre_per_fisica, 
					tmp_actores.movil_principal_per_fisica, tmp_actores.sexo_per_fisica, tmp_actores.apellido_materno, 
					tmp_actores.donante_organos, tmp_actores.email_personal_per_fisica, tmp_actores.identidad_genero_per_fisica, 
					tmp_actores.estado_civil_per_fisica);
				
			end loop;
		
	end;
	$$
	language plpgsql;
	
--Llamamos a la función para que procese los datos para persona física
select procesa_pers_fisica();

--Corroboramos que es lo que cargo en la tabla del esquema actor en la tabla persona fisica
select * from actor.persona_fisica pf;

select * from tmp.copy_actor ca where ca.documento_identidad_tipo_per_fisica is null and ca.tipo = 'F';
-- esta persona fisica no tiene nro documento ni tip  de doc por lo que se le asigno valores por defecto 
--F	510548	MELIAMARIA 

/********************************************************************************************+
*                     IMPORTACIÓN DE DATOS SOLICITUDES                                       *
*********************************************************************************************/

-- Crear una tabla temporal llamada copy_SolLicCond 
create table tmp.copy_SolLicCond(
    id		 			int,--------Solicitu
    domicilio 			varchar(255),
    fecha 				date,
    libre_multa 		bool,
    numero 				integer,
    id_localidad 		integer,
    id_estado_actual 	integer,
    id_persona 			integer,
    id_usuario_receptor integer,
    corresponde_charla 	varchar(60),
    corresponde_psiquiatrico varchar(60),
    corresponde_teorico varchar(60),
    id_motivo_rechazo 	int,
    corresponde_fisico 	varchar(60),
    tipo 				varchar(60),
    calle 				varchar(255), 
    departamento 		varchar(255),
    numero_portal 		varchar(60),
    piso 				varchar(255),
    fecha_vencimiento	date,
    
    tipo_e				varchar(60),
    id_e				integer,
    fecha_e				date,
    item				integer,
    id_solicitud		integer,
    
    vot					varchar(60),--no se usa
    id_m				integer,
    descripcion_motivo_rechazo varchar(120)
)
-------------------Copio datos a tabla temporal----------------------------------------
copy tmp.copy_SolLicCond from 'D:\Facultad\BaseDatos\TP2-v1\csv\SolLicCond-1698956393176C.csv'
with (format csv, delimiter E'\t', header true, null '');


select * from tmp.copy_SolLicCond;
---------------------------------------------------------------------------------------------------------------------------------------
-- Esta funcion procesa los datos de la tabla temporal y los inserta en las tablas solicitud_licencia_conducir / estado_solicitud / motivo_rechazo
create or replace function procesar_slcesmr()
returns void as 
$$
declare rec_temp record;
declare n_portal int;
begin 
    FOR rec_temp IN SELECT * FROM tmp.copy_SolLicCond
    loop
	    ------------------------------SOLICITUDES-----------------------------------------------------------
        if not exists (select * from solicitud.solicitud_licencia_conducir s 
        				where s.id = rec_temp.id ) and rec_temp.id is not null then 
         if (rec_temp.departamento is null) then
				rec_temp.departamento := '-'; 
			end if;
		if (rec_temp.piso is null) then
				rec_temp.piso := '-'; 
			end if;
		if (rec_temp.calle is null) then
				rec_temp.calle := '-'; 
			end if;
		BEGIN
		  n_portal := rec_temp.numero_portal::int;
		EXCEPTION
		  WHEN others THEN
		    -- Manejar la excepción, asignar -1 si la conversión falla
		    n_portal := -1;
		END;
            -- Insertar en la tabla de destino
            INSERT INTO solicitud.solicitud_licencia_conducir (	id, 
            													numero, 
            													id_persona, 
            													id_localidad, 
            													id_usuario,
            													id_estado, 
            													id_motivo, 
            													domicilio, 
            													fecha, 
            													libre_multa, 
            													corresponde_charla,
            													corresponde_psiqui, 
            													corresponde_teorico, 
            													corresponde_fisico, 
            													tipo,
            													calle, 
            													departamento, 
            													numero_portal, 
            													piso, 
            													fecha_vencimiento)
            VALUES (rec_temp.id, 
           			rec_temp.numero,
				    rec_temp.id_persona,
					rec_temp.id_localidad,
				    rec_temp.id_usuario_receptor,
				    rec_temp.id_estado_actual,
				    rec_temp.id_motivo_rechazo,
           			rec_temp.domicilio, 
           			rec_temp.fecha, 
           			rec_temp.libre_multa, 
				    rec_temp.corresponde_charla,
				    rec_temp.corresponde_psiquiatrico,
				    rec_temp.corresponde_teorico,
				    rec_temp.corresponde_fisico,
				    rec_temp.tipo,
				    rec_temp.calle, 
				    rec_temp.departamento,
				    n_portal,
				    rec_temp.piso,
				    rec_temp.fecha_vencimiento 		
        		 );
        end if;
       -------------------------------ESTADO SOLICITUD--------------------------------------------------
        if not exists (select * from  solicitud.estado_solicitud es
	    				where es.id  = rec_temp.id_e 
	    				) and rec_temp.id_e is not null then
	    				
 			insert into solicitud.estado_solicitud(id, id_solicitud, item, tipo, fecha)
 			values (rec_temp.id_e, rec_temp.id_solicitud, rec_temp.item, rec_temp.tipo_e, rec_temp.fecha_e);
        end if;
       
       ---------------------------------MOTIVO RECHAZO---------------------------------------------------
       
       if not exists (select * from  solicitud.motivo_rechazo 
	    				where solicitud.motivo_rechazo.id = rec_temp.id_m) and rec_temp.id_m is not null then 
	    				insert into solicitud.motivo_rechazo(id, codigo_motivo_rechazo, descripcion_motivo_rechazo)
	    				values (rec_temp.id_m, rec_temp.id_m, rec_temp.descripcion_motivo_rechazo);
        end if;
       
    END LOOP;
end;
$$
language plpgsql;

-- Llamar a la función procesar_slcesmr para procesar los datos
select procesar_slcesmr();

-- Devuelve los paises que se insertaron
select * from solicitud.solicitud_licencia_conducir;
select * from solicitud.estado_solicitud ;
select * from solicitud.motivo_rechazo;
