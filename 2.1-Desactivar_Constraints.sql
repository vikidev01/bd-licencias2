
alter table actor.integra_organismo drop constraint fk_integra_organismo_organismo;
alter table actor.integra_organismo drop constraint fk_integra_organismo_funcion;
alter table actor.integra_organismo drop constraint fk_integra_organismo_persona_fisica;
alter table actor.integra_organismo drop constraint unq_integra_organismo;
alter table actor.integra_organismo drop constraint chk_integra_organismo_fecha_baja;
alter table actor.integra_organismo drop constraint pk_integra_organismo;

alter table actor.organismo drop constraint fk_organismo_actor;
alter table actor.organismo drop constraint unq_organismo;
alter table actor.organismo drop constraint pk_organismo;

alter table actor.integra_persona_juridica drop constraint fk_integra_persona_juridica_persona_juridica;
alter table actor.integra_persona_juridica drop constraint fk_integra_persona_juridica_persona_fisica;
alter table actor.integra_persona_juridica drop constraint fk_integra_persona_juridica_funcion;
alter table actor.integra_persona_juridica drop constraint unq_integra_persona_juridica;
alter table actor.integra_persona_juridica drop constraint chk_integra_persona_juridica_fecha_baja;
alter table actor.integra_persona_juridica drop constraint pk_integra_persona_juridica;

alter table actor.persona_juridica drop constraint fk_persona_juridica_actor;
alter table actor.persona_juridica drop constraint fk_persona_juridica_tipo;
alter table actor.persona_juridica drop constraint unq_persona_juridica;
alter table actor.persona_juridica drop constraint pk_persona_juridica;

alter table actor.direccion_actor drop constraint fk_direccion_actor_actor;
alter table actor.direccion_actor drop constraint fk_direccion_actor_localidad;
alter table actor.direccion_actor drop constraint unq_direccion_actor;
alter table actor.direccion_actor drop constraint pk_direccion_actor;
alter table actor.direccion_actor drop constraint chk_direccion_actor_numero_postal;
alter table actor.direccion_actor drop constraint chk_direccion_actor_tipo_domicilio;

alter table actor.rol drop constraint fk_rol_actor;---------------xq da error?
alter table actor.rol drop constraint unq_rol;
alter table actor.rol drop constraint unq_rol_actor;
alter table actor.rol drop constraint chk_rol;
alter table actor.rol drop constraint pk_rol;

alter table actor.tipo_persona_juridica drop constraint unq_tipo_persona_juridica;
alter table actor.tipo_persona_juridica drop constraint pk_tipo_persona_juridica;

alter table actor.funcion drop constraint unq_funcion;
alter table actor.funcion drop constraint pk_funcion;

alter table  solicitud.detalle_liquidacion_solicitud_licencia_conductor drop constraint fk_concepto_detalle;
alter table  solicitud.detalle_liquidacion_solicitud_licencia_conductor drop constraint fk_subtributo_detalle;
alter table  solicitud.detalle_liquidacion_solicitud_licencia_conductor drop constraint fk_liquidacion_detalle;
alter table  solicitud.detalle_liquidacion_solicitud_licencia_conductor drop constraint unq_liquidacion_detalle;
alter table  solicitud.detalle_liquidacion_solicitud_licencia_conductor drop constraint pk_detalle_liquidacion_solicitud_licencia_conductor;

alter table solicitud.subtributo drop constraint unq_subtributo;
alter table solicitud.subtributo drop constraint pk_subtributo;

alter table solicitud.solicitud_licencia_conductor_clase drop constraint fk_solicitud_clase;
alter table solicitud.solicitud_licencia_conductor_clase drop constraint fk_motivo_solicitud;
alter table solicitud.solicitud_licencia_conductor_clase drop constraint fk_clase_solicitud;
alter table solicitud.solicitud_licencia_conductor_clase drop constraint uniq_secuencia_solicitud_licencia_conductor;
alter table solicitud.solicitud_licencia_conductor_clase drop constraint uniq_id_solicitud_solicitud_licencia_conductor;
alter table solicitud.solicitud_licencia_conductor_clase drop constraint pk_solicitud_licencia_conductor_clase;
alter table solicitud.solicitud_licencia_conductor_clase drop constraint chk_tipo_gestion;

alter table solicitud.estado_solicitud drop constraint fk_estado_solicitud;
alter table solicitud.estado_solicitud drop constraint unq_estado;
alter table solicitud.estado_solicitud drop constraint pk_estado_solicitud cascade;
alter table solicitud.estado_solicitud drop constraint chk_tipo_estado;

alter table solicitud.liquidacion_solicitud_licencia_conducir drop constraint fk_liquidacion_usuario;
alter table solicitud.liquidacion_solicitud_licencia_conducir drop constraint fk_liquidacion_solicitud;
alter table solicitud.liquidacion_solicitud_licencia_conducir drop constraint unq_liquidacion_solicitud;
alter table solicitud.liquidacion_solicitud_licencia_conducir drop constraint pk_liquidacion_solicitud_licencia_conducir;
alter table solicitud.liquidacion_solicitud_licencia_conducir drop constraint chk_liquidacion_tipo_pago;

alter table solicitud.clase_licencia_conducir_requerida drop constraint fk_clase_licencia_conducir_requerida_clase;
alter table solicitud.clase_licencia_conducir_requerida drop constraint fk_clase_licencia_conducir_requerida_claseLic;
alter table solicitud.clase_licencia_conducir_requerida drop constraint unq_clase_licencia_conducir_requerida_secuencia;
alter table solicitud.clase_licencia_conducir_requerida drop constraint unq_clase_licencia_conducir_requerida;  
alter table solicitud.clase_licencia_conducir_requerida drop constraint pk_clase_licencia_conducir_requerida;

alter table solicitud.clase_licencia_conducir drop constraint unq_clase_licencia_conducir;
alter table solicitud.clase_licencia_conducir drop constraint pk_clase_licencia_conducir;
alter table solicitud.clase_licencia_conducir drop constraint chk_clase_licencia_conducir_edad_maxima;
alter table solicitud.clase_licencia_conducir drop constraint chk_clase_licencia_conducir_edad_minima;
alter table solicitud.clase_licencia_conducir drop constraint chk_clase_licencia_conducir_edad;

alter table solicitud.solicitud_licencia_conducir drop constraint fk_solicitud_localidad;
alter table solicitud.solicitud_licencia_conducir drop constraint fk_solicitud_usuario;
alter table solicitud.solicitud_licencia_conducir drop constraint fk_solicitud_motivo;
alter table solicitud.solicitud_licencia_conducir drop constraint fk_solicitud_estado;
alter table solicitud.solicitud_licencia_conducir drop constraint unq_solicitud;
alter table solicitud.solicitud_licencia_conducir drop constraint chk_solicitud_tipo;
alter table solicitud.solicitud_licencia_conducir drop constraint pk_solicitud_licencia_conducir cascade;
alter table solicitud.solicitud_licencia_conducir drop constraint fk_solicitud_persona;

alter table actor.persona_fisica drop constraint fk_persona_fisica_actor;
alter table actor.persona_fisica drop constraint fk_persona_fisica_ocupacion;
alter table actor.persona_fisica drop constraint unq;
alter table actor.persona_fisica drop constraint chk_persona_fisica_fecha_nacimiento;
alter table actor.persona_fisica drop constraint chk_persona_fisica_estado_civil;
alter table actor.persona_fisica drop constraint pk_persona_fisica;

alter table actor.ocupacion drop constraint unq_ocupacion;
alter table actor.ocupacion drop constraint pk_ocupacion;

alter table actor.localidad drop constraint fk_localidad_departamento;
alter table actor.localidad drop constraint fk_localiadad_provincia_estado;
alter table actor.localidad drop constraint unq_localidad;
alter table actor.localidad drop constraint chk_localidad_codigo_postal;
alter table actor.localidad drop constraint pk_localidad;

alter table actor.usuario drop constraint fk_usuario_actor;
alter table actor.usuario drop constraint unq_usuario cascade;
alter table actor.usuario drop constraint unq_usuario_actor cascade;
alter table actor.usuario drop constraint chk_usuario_fecha_baja;
alter table actor.usuario drop constraint pk_usuario;

alter table actor.actor drop constraint fk_actor;
alter table actor.actor drop constraint unq_actor;
alter table actor.actor drop constraint pk_actor;

alter table actor.departamento drop constraint unq_departamento;
alter table actor.departamento drop constraint pk_departamento;
alter table actor.departamento drop constraint fk_departamento_provincia_estado;

alter table actor.provincia_estado drop constraint fk_provincia;
alter table actor.provincia_estado drop constraint unq_provincia;
alter table actor.provincia_estado drop constraint pk_provincia;

alter table actor.pais drop constraint unq_pais;
alter table actor.pais drop constraint pk_pais;

alter table solicitud.concepto_medico drop constraint unq_concepto_medico;
alter table solicitud.concepto_medico drop constraint pk_concepto_medico;

alter table solicitud.motivo_rechazo drop constraint unq_motivo_rechazo;
alter table solicitud.motivo_rechazo drop constraint pk_motivo_rechazo;
alter table solicitud.motivo_rechazo drop constraint chk_motivo_rechazo_codigo;


