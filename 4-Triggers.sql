create schema auditoria;

-- Creamos la tabla de auditoria
create table auditoria.log_auditoria(
	id serial primary key,
	tabla_afectada varchar(255),
	id_afectado int, 
	usuario varchar(255), 
	fecha timestamp, 
	tipo_dml char(6), 
	valor_previo jsonb,
	valor_nuevo jsonb,
	constraint chk_tipo_dml check (tipo_dml in ('UPDATE', 'INSERT', 'DELETE'))
);

-- Funcion que se encarga de auditar los inserts
create or replace function auditar_insert()
returns trigger as $$
begin 
	insert into auditoria.log_auditoria(tabla_afectada, id_afectado, usuario, fecha, tipo_dml, valor_nuevo)
	values (TG_TABLE_NAME, new.id, current_user, now(), 'INSERT', to_jsonb(new.*));
	return new; 
end;
$$ language plpgsql;


-- Funcion que se encarga de auditar los updates
create or replace function auditar_update()
returns trigger as $$
begin 
	insert into auditoria.log_auditoria(tabla_Afectada, id_afectado, usuario, fecha, tipo_dml, valor_previo, valor_nuevo)
	values (TG_TABLE_NAME, new.id, current_user, now(), 'UPDATE', to_jsonb(old.*), to_jsonb(new.*));
	return new;
end;
$$ language plpgsql;


-- Funcion que se encarga de auditor los delete
create or replace function auditar_delete()
returns trigger as $$
begin 
	insert into auditoria.log_auditoria(tabla_afectada, id_afectado, usuario, fecha, tipo_dml, valor_previo)
	values (TG_TABLE_NAME, old.id, current_user, now(), 'DELETE', to_jsonb(old.*));
	return old;
end;
$$ language plpgsql;


-- Triggers para tabla localidad
create trigger auditar_localidad_insert_trigger
after insert on actor.localidad 
for each row execute function auditar_insert();

create trigger auditar_localidad_delete_trigger
after delete on actor.localidad 
for each row execute function auditar_delete();

create trigger auditar_update_trigger
after update on actor.localidad 
for each row execute function auditar_update();

-- Triggers para tabla solicitud_licencia_conducir
create trigger auditar_solicitud_insert_trigger
after insert on solicitud.solicitud_licencia_conducir  
for each row execute function auditar_insert();

create trigger auditar_solicitud_delete_trigger
after delete on solicitud.solicitud_licencia_conducir  
for each row execute function auditar_delete();

create trigger auditar_solicitud_update_trigger
after update on solicitud.solicitud_licencia_conducir  
for each row execute function auditar_update();

-- Triggers para tabla persona_fisica
create trigger auditar_persona_fisica_insert_trigger
after insert on actor.persona_fisica  
for each row execute function auditar_insert();

create trigger auditar_persona_fisica_delete_trigger
after delete on actor.persona_fisica 
for each row execute function auditar_delete();

create trigger auditar_persona_fisica_trigger
after update on actor.persona_fisica  
for each row execute function auditar_update();




