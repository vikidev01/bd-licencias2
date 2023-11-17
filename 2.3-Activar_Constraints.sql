alter table solicitud.motivo_rechazo add constraint unq_motivo_rechazo unique (codigo_motivo_rechazo);
alter table solicitud.motivo_rechazo add constraint pk_motivo_rechazo primary key (id);
alter table solicitud.motivo_rechazo add constraint chk_motivo_rechazo_codigo check (codigo_motivo_rechazo >= 0);

alter table solicitud.concepto_medico add constraint unq_concepto_medico unique (codigo_concepto_medico);
alter table solicitud.concepto_medico add constraint pk_concepto_medico primary key (id);

alter table actor.pais add constraint unq_pais unique (codigo_pais);
alter table actor.pais add constraint pk_pais primary key (id);

alter table actor.provincia_estado add constraint fk_provincia foreign key (id_pais)	references actor.pais (id);
alter table actor.provincia_estado add constraint unq_provincia unique (id_pais, codigo_provincia);
alter table actor.provincia_estado add constraint pk_provincia primary key (id);

alter table actor.departamento add constraint unq_departamento unique (id_provincia_estado, secuencia) ;
alter table actor.departamento add constraint pk_departamento primary key (id);
alter table actor.departamento add constraint fk_departamento_provincia_estado foreign key (id_provincia_estado) references actor.provincia_estado (id);

alter table actor.actor add constraint fk_actor foreign key (id_pais)	references actor.pais (id);
alter table actor.actor add constraint unq_actor unique (codigo_actor);
alter table actor.actor add constraint pk_actor primary key (id);


alter table actor.usuario add constraint fk_usuario_actor foreign key (id_actor) references actor.actor (id);
alter table actor.usuario add constraint unq_usuario_actor  unique (id_actor);
alter table actor.usuario add constraint unq_usuario unique (id_usuario);
alter table actor.usuario add constraint chk_usuario_fecha_baja check (fecha_baja >= fecha_alta);
alter table actor.usuario add constraint pk_usuario primary key (id);

alter table actor.localidad add constraint fk_localidad_departamento foreign key (id_departamento) 		references actor.departamento (id);
alter table actor.localidad add constraint fk_localiadad_provincia_estado foreign key (id_provincia_estado) 	references actor.provincia_estado (id);
alter table actor.localidad add constraint unq_localidad unique (id_departamento, codigo_localidad);
alter table actor.localidad add constraint chk_localidad_codigo_postal check (codigo_postal >= 0);
alter table actor.localidad add constraint pk_localidad primary key (id);

alter table actor.ocupacion add constraint unq_ocupacion unique (codigo_ocupacion);
alter table actor.ocupacion add constraint pk_ocupacion  primary key (id);

alter table actor.persona_fisica add constraint fk_persona_fisica_actor foreign key (id_actor)	 	references actor.actor (id);
alter table actor.persona_fisica add constraint fk_persona_fisica_ocupacion foreign key (id_ocupacion) 	references actor.ocupacion (id);
alter table actor.persona_fisica add constraint unq unique (id_actor, documento_identidad_tipo, documento_identidad_numero);
alter table actor.persona_fisica add constraint chk_persona_fisica_fecha_nacimiento check (fechaNacimiento <= current_date);
alter table actor.persona_fisica add constraint chk_persona_fisica_estado_civil check (estado_civil in ('S', 'C', 'E','D', 'V', 'N'));
alter table actor.persona_fisica add constraint pk_persona_fisica primary key (id);



alter table solicitud.solicitud_licencia_conducir add constraint fk_solicitud_localidad foreign key (id_localidad) 		references actor.localidad (id);
alter table solicitud.solicitud_licencia_conducir add constraint fk_solicitud_usuario foreign key (id_usuario) 		references actor.usuario (id);
alter table solicitud.solicitud_licencia_conducir add constraint fk_solicitud_motivo foreign key (id_motivo) 		references solicitud.motivo_rechazo (id);
alter table solicitud.solicitud_licencia_conducir add constraint unq_solicitud unique (numero);
alter table solicitud.solicitud_licencia_conducir add constraint chk_solicitud_tipo check (tipo in ('PROFESIONAL', 'COMUN'));
alter table solicitud.solicitud_licencia_conducir add constraint pk_solicitud_licencia_conducir primary key (id);
alter table solicitud.solicitud_licencia_conducir add constraint fk_solicitud_persona foreign key (id_persona) 		references actor.persona_fisica (id);

alter table solicitud.clase_licencia_conducir add constraint unq_clase_licencia_conducir unique (clase);
alter table solicitud.clase_licencia_conducir add constraint pk_clase_licencia_conducir primary key (id);
alter table solicitud.clase_licencia_conducir add constraint chk_clase_licencia_conducir_edad_maxima check (edad_maxima >= 0);
alter table solicitud.clase_licencia_conducir add constraint chk_clase_licencia_conducir_edad_minima check (edad_minima >= 0);
alter table solicitud.clase_licencia_conducir add constraint chk_clase_licencia_conducir_edad check (edad_maxima >= edad_minima);

alter table solicitud.clase_licencia_conducir_requerida add constraint fk_clase_licencia_conducir_requerida_clase foreign key (id_clase) 		references solicitud.clase_licencia_conducir (id);
alter table solicitud.clase_licencia_conducir_requerida add constraint fk_clase_licencia_conducir_requerida_claseLic foreign key (id_claseLic) 	references solicitud.clase_licencia_conducir (id);
alter table solicitud.clase_licencia_conducir_requerida add constraint unq_clase_licencia_conducir_requerida unique (id_clase); 
alter table solicitud.clase_licencia_conducir_requerida ADD constraint unq_clase_licencia_conducir_requerida_secuencia 	unique (secuencia);
alter table solicitud.clase_licencia_conducir_requerida add constraint pk_clase_licencia_conducir_requerida primary key (id);

alter table solicitud.liquidacion_solicitud_licencia_conducir add constraint fk_liquidacion_usuario foreign key (id_usuario) 		references actor.usuario (id);
alter table solicitud.liquidacion_solicitud_licencia_conducir add constraint fk_liquidacion_solicitud foreign key (id_solicitud) 		references solicitud.solicitud_licencia_conducir (id);
alter table solicitud.liquidacion_solicitud_licencia_conducir add constraint unq_liquidacion_solicitud unique (numero);
alter table solicitud.liquidacion_solicitud_licencia_conducir add constraint pk_liquidacion_solicitud_licencia_conducir primary key (id);
alter table solicitud.liquidacion_solicitud_licencia_conducir add constraint chk_liquidacion_tipo_pago check (tipo_pago in ('NO_INFORMADO','USUARIO', 'COMUN'));

alter table solicitud.estado_solicitud add constraint fk_estado_solicitud foreign key (id_solicitud) 		references solicitud.solicitud_licencia_conducir (id);
alter table solicitud.estado_solicitud add constraint unq_estado unique (id_solicitud, item);
alter table solicitud.estado_solicitud add constraint pk_estado_solicitud primary key (id);
alter table solicitud.estado_solicitud add constraint chk_tipo_estadocheck (tipo in ('EXAMEN_PSIQUIATRICO_NO_APTO',
													'EXAMEN_PRACTICO_APROBADO',
													'PRESENTADA',
													'EXAMEN_PRACTICO_PARCIALMENTE_APROBADO',
													'APROBADA_SIMUCO',
													'EXAMEN_PSICO_FISICO_INTERCONSULTA',
													'EXAMEN_PRACTICO_REPROBADO_N_VECES',
													'RECHAZADA',
 													'EXAMEN_PSIQUIATRICO_APTO_PRACTICO_N_VECES',
													'EXAMEN_TEORICO_REPROBADO_N_VECES',
													'EXAMEN_PRACTICO_REPROBADO',
													'EXAMEN_PSIQUIATRICO_APTO_TEORICO_N_VECES',
													'EXAMEN_PSICO_FISICO_NO_APTO',
													'EXAMEN_PSICO_FISICO_APTO_CON_RESTRICCIONES',
													'EXAMEN_PSICO_FISICO_APTO',
													'APROBADA',
													'EXAMEN_PSIQUIATRICO_APTO',
													'EXAMEN_TEORICO_APROBADO',
													'PARCIALMENTE_APROBADA',
													'EXAMEN_TEORICO_REPROBADO'));


alter table solicitud.solicitud_licencia_conductor_clase add constraint fk_solicitud_clase foreign key (id_solicitud) 	references solicitud.solicitud_licencia_conducir (id);
alter table solicitud.solicitud_licencia_conductor_clase add constraint fk_motivo_solicitud foreign key (id_motivo)	 	references solicitud.motivo_rechazo (id);
alter table solicitud.solicitud_licencia_conductor_clase add constraint fk_clase_solicitud foreign key (id_clase) 		references solicitud.clase_licencia_conducir (id);
alter table solicitud.solicitud_licencia_conductor_clase add constraint uniq_secuencia_solicitud_licencia_conductor unique (secuencia);
alter table solicitud.solicitud_licencia_conductor_clase add constraint uniq_id_solicitud_solicitud_licencia_conductor unique (id_solicitud);
alter table solicitud.solicitud_licencia_conductor_clase add constraint pk_solicitud_licencia_conductor_clase primary key (id);
alter table solicitud.solicitud_licencia_conductor_clase add constraint chk_tipo_gestion check (tipo_gestion in ('REVALIDA_ANUAL', 
																			 'EXTRAVIO', 
																			 'RENOVACION', 
																			 'AMPLIACION', 
																			 'NUEVO', 
																			 'PROVINCIAL_A_NACIONAL', 
																			 'CAMBIO_DATOS'));

alter table solicitud.subtributo add constraint unq_subtributo unique (codigo_subtributo);
alter table solicitud.subtributo add constraint pk_subtributo primary key (id);


alter table  solicitud.detalle_liquidacion_solicitud_licencia_conductor add constraint fk_concepto_detalle foreign key (id_concepto) 			references solicitud.concepto_medico (id);
alter table  solicitud.detalle_liquidacion_solicitud_licencia_conductor add constraint fk_subtributo_detalle foreign key (id_subtributo) 		references solicitud.subtributo (id);
alter table  solicitud.detalle_liquidacion_solicitud_licencia_conductor add constraint fk_liquidacion_detalle foreign key (id_liquidacion) 		references solicitud.liquidacion_solicitud_licencia_conducir (id);
alter table  solicitud.detalle_liquidacion_solicitud_licencia_conductor add constraint unq_liquidacion_detalle unique (id_liquidacion, secuencia);
alter table  solicitud.detalle_liquidacion_solicitud_licencia_conductor add constraint pk_detalle_liquidacion_solicitud_licencia_conductor primary key (id);

alter table actor.funcion add constraint unq_funcion unique (codigo_funcion);
alter table actor.funcion add constraint pk_funcion primary key (id);

alter table actor.tipo_persona_juridica add constraint unq_tipo_persona_juridica unique (codigo_tipo_persona_juridica);
alter table actor.tipo_persona_juridica add constraint pk_tipo_persona_juridica primary key (id);


alter table actor.rol add constraint fk_rol_actor foreign key (id_actor) references actor.actor (id);
alter table actor.rol add constraint unq_rol unique (tipo_rol, codigo_rol);
alter table actor.rol add constraint unq_rol_actor unique (id_actor);
alter table actor.rol add constraint chk_rol check (tipo_rol in ('INSPECTOR_TRANSITO', 'MEDICO'));
alter table actor.rol add constraint pk_rol primary key (id);


alter table actor.direccion_actor add constraint fk_direccion_actor_actor 	foreign key (id_actor) 		references actor.actor (id);
alter table actor.direccion_actor add constraint fk_direccion_actor_localidad  foreign key (id_localidad) 	references actor.localidad (id);
alter table actor.direccion_actor add constraint unq_direccion_actor unique (id_actor, secuencia);
alter table actor.direccion_actor add constraint pk_direccion_actor primary key (id);
alter table actor.direccion_actor add constraint chk_direccion_actor_numero_postal check (numero_postal >= 0);
alter table actor.direccion_actor add constraint chk_direccion_actor_tipo_domicilio check (tipo_domicilio in ('SUCURSAL', 'LABORAL', 'CASA_CENTRAL', 'FISCAL', 'OTRO', 'PARTICULAR'));

alter table actor.persona_juridica add constraint fk_persona_juridica_actor foreign key (id_actor) references actor.actor(id);
alter table actor.persona_juridica add constraint fk_persona_juridica_tipo foreign key (id_tipo_persona_juridica) references actor.tipo_persona_juridica (id);
alter table actor.persona_juridica add constraint unq_persona_juridica unique (id_actor);
alter table actor.persona_juridica add constraint pk_persona_juridica primary key (id);

alter table actor.integra_persona_juridica add constraint fk_integra_persona_juridica_persona_juridica foreign key (id_persona_juridica) 	references actor.persona_juridica (id);
alter table actor.integra_persona_juridica add constraint fk_integra_persona_juridica_persona_fisica foreign key (id_persona_fisica) 	references actor.persona_fisica (id);
alter table actor.integra_persona_juridica add constraint fk_integra_persona_juridica_funcion foreign key (id_funcion) 			references actor.funcion (id);
alter table actor.integra_persona_juridica add constraint unq_integra_persona_juridica unique (id_persona_juridica, secuencia);
alter table actor.integra_persona_juridica add constraint chk_integra_persona_juridica_fecha_baja check (fecha_baja >= fecha_alta);
alter table actor.integra_persona_juridica add constraint pk_integra_persona_juridica primary key (id);


alter table actor.organismo add constraint fk_organismo_actor foreign key (id_actor) references actor.actor (id);
alter table actor.organismo add constraint unq_organismo unique (id_actor);
alter table actor.organismo add constraint pk_organismo primary key (id);



alter table actor.integra_organismo add constraint fk_integra_organismo_organismo foreign key (id_organismo) 		references actor.organismo (id);
alter table actor.integra_organismo add constraint fk_integra_organismo_funcion foreign key (id_funcion) 		references actor.funcion (id);
alter table actor.integra_organismo add constraint fk_integra_organismo_persona_fisica foreign key (id_persona_fisica) references actor.persona_fisica (id);
alter table actor.integra_organismo add constraint unq_integra_organismo unique (id_organismo, secuencia);
alter table actor.integra_organismo add constraint chk_integra_organismo_fecha_baja check (fecha_baja >= fecha_alta);
alter table actor.integra_organismo add constraint pk_integra_organismo primary key (id);










