alter table actor.usuario
	add constraint unq_usuario_actor
	unique (id_actor);
	
------------------------------------------------
-----------Creacion de indices------------------

------------------Nivel 2 ----------------------

create index idx_actor_pais  on actor.actor (id_pais);

create index idx_clase_lic_cond_req_claseLic  on solicitud.clase_licencia_conducir_requerida (id_claseLic);

------------------Nivel 3 ----------------------

create index idx_perFis_ocupacion  on actor.persona_fisica (id_ocupacion);

create index idx_perJur_tipo  on actor.persona_juridica (id_tipo_persona_juridica);

------------------Nivel 4 ----------------------

create index idx_integra_organismo_func  on actor.integra_organismo (id_funcion);

create index idx_integra_organismo_perFis  on actor.integra_organismo (id_persona_fisica);

create index idx_integra_perJu_fis on actor.integra_persona_juridica (id_persona_fisica);

create index idx_integra_perJu_func on actor.integra_persona_juridica (id_funcion);

create index idx_loca_prov on actor.localidad (id_provincia_estado);

------------------Nivel 5 ----------------------

create index idx_direcc_loca on actor.direccion_actor (id_localidad);

create index idx_sol_lic_cond_per on solicitud.solicitud_licencia_conducir (id_persona);

create index idx_sol_lic_cond_loca on solicitud.solicitud_licencia_conducir (id_localidad);

create index idx_sol_lic_cond_usu on solicitud.solicitud_licencia_conducir (id_usuario);

create index idx_sol_lic_cond_motivo on solicitud.solicitud_licencia_conducir (id_motivo);

------------------Nivel 6 ----------------------

create index idx_liquidacion_solicitud_licencia_conducir_sol on solicitud.liquidacion_solicitud_licencia_conducir (id_solicitud);

create index idx_liquidacion_solicitud_licencia_conducir_usu on solicitud.liquidacion_solicitud_licencia_conducir (id_usuario);

create index idx_solicitud_licencia_conductor_clase_clase on solicitud.solicitud_licencia_conductor_clase (id_clase);

create index idx_solicitud_licencia_conductor_clase_motivo on solicitud.solicitud_licencia_conductor_clase (id_motivo);

------------------Nivel 7 ----------------------

create index idx_detalle_liquidacion_solicitud_licencia_conductor_con on solicitud.detalle_liquidacion_solicitud_licencia_conductor (id_concepto);

create index idx_detalle_liquidacion_solicitud_licencia_conductor_sub on solicitud.detalle_liquidacion_solicitud_licencia_conductor (id_subtributo);

/*==============================================================*/
/* Limpieza                                                     */
/*==============================================================*/

delete from actor.integra_organismo;

delete from actor.organismo;

delete from actor.integra_persona_juridica;

delete from actor.persona_juridica;

delete from actor.direccion_actor;

delete from actor.rol;

delete from actor.tipo_persona_juridica;

delete from actor.funcion;

delete from solicitud.detalle_liquidacion_solicitud_licencia_conductor;

delete from solicitud.subtributo;

delete from solicitud.solicitud_licencia_conductor_clase;

delete from solicitud.estado_solicitud;

delete from solicitud.liquidacion_solicitud_licencia_conducir;

delete from solicitud.clase_licencia_conducir_requerida;

delete from solicitud.clase_licencia_conducir;

delete from solicitud.solicitud_licencia_conducir;

delete from actor.persona_fisica;

delete from actor.ocupacion;

delete from actor.localidad;

delete from actor.departamento;

delete from actor.provincia_estado;

delete from actor.usuario;

delete from actor.actor;

delete from actor.pais;

delete from solicitud.concepto_medico;

delete from solicitud.motivo_rechazo;

/*==============================================================*/  

