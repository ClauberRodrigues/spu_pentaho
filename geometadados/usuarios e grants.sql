select * from pg_catalog.pg_user;

create user cgcig WITH password 'cgcig2021';

UPDATE pg_catalog.pg_user
	SET usesuper=true
	WHERE usename='zago' AND usesysid=378160 AND usecreatedb=false AND usesuper=false AND usecatupd=false AND userepl=false AND passwd='********' AND valuntil IS NULL AND useconfig IS NULL;



usuários já criados
spu 
zago
spin
edgv
geoserver

usuário internos da sede SPU
select * from pg_catalog.pg_group;
create role cgcig with password 'cgcig2021' SUPERUSER 

dominio, log, externo
create group spu_sede;
create user cgipa with password 'cgipa2021';
create user cgcav with password 'cgcav2021';
create user cgfis with password 'cgfis2021';

alter group spu_sede add user cgipa, cgfis, cgcav;

select distinct 'grant select, update on all tables in schema '|| schemaname ||' to spu_sede;' FROM pg_stat_user_tables;

grant select, update on all tables in schema ide_spu."log" to cgipa, cgcav, cgfis WITH GRANT OPTION;
grant select, update on all tables in schema topology to cgipa, cgcav, cgfis;
grant select, update on all tables in schema externo to cgipa, cgcav, cgfis;
grant select, update on all tables in schema public to cgipa, cgcav, cgfis;
grant select, update on all tables in schema dominio to cgipa, cgcav, cgfis WITH GRANT OPTION;

commit;


create user nugeoam with password '1nugeoam2021';
 --SELECT, UPDATE, INSERT, DELETE
create user nugeoba with password '2nugeoba2021';
create user nugeoce with password '3nugeoce2021';
create user nugeoes with password '4nugeoes2021';
create user nugeomg with password '5nugeomg2021';
create user nugeorj with password '6nugeorj2021';
create user nugeorn with password '7nugeorn2021';
create user nugeosc with password '8nugeosc2021';
create user nugeosp with password '9nugeosp2021';
create user nugeors with password '0nugeors2021';

create group spu_nugeo;
alter group spu_sede add user nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;

select distinct 'grant select, update, delete on all tables in schema '|| schemaname ||' to spu_nugeo;' FROM pg_stat_user_tables;

grant insert, select, update, delete on all tables in schema topology to spu_nugeo;
grant insert, select, update, delete on all tables in schema externo to spu_nugeo;
grant insert, select, update, delete on all tables in schema "log" to spu_nugeo;
grant insert, select, update, delete on all tables in schema public to spu_nugeo;
grant insert, select on all tables in schema dominio to spu_nugeo;
grant insert, select, update on all tables in schema dominio to spu_nugeo;
commit;

grant select, update, delete on all tables in schema topology to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
grant select, update, delete on all tables in schema externo to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
grant select, update, delete on all tables in schema "log" to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
grant select, update, delete on all tables in schema public to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
grant select on all tables in schema dominio to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
grant select, update on all tables in schema dominio to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;

commit;

GRANT insert, SELECT, UPDATE ON log.log TO cgipa, cgcav, cgfis;
grant insert, select, update on LOG.LOG to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;



select 'GRANT INSERT, SELECT, UPDATE ON '|| schemaname||'.'||tablename || ' to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;'  
from pg_tables where schemaname = 'public' in ('topology','externo','log','public','dominio');

GRANT INSERT, SELECT, UPDATE ON public.localidade to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.municipio to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.ponto_cotado_altimetrico to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.ponto_cotado_batimetrico to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.ponto_energia_comunic to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.pto_geod_topo_controle to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.setor_censitario to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.terreno_cadastral to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.terreno_cartorial to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.terreno_exposto to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.terreno_sujeito_inundacao to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.trecho_arruamento_a to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.trecho_arruamento_l to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.trecho_drenagem to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.trecho_ferroviario to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.trecho_lltm to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.trecho_lpm to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.trecho_ltm to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.trecho_rodoviario_a to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.trecho_terreno_acrescido_marinha to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.trecho_terreno_marginal to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.trecho_terreno_marinha to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.unidade_federacao to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.utilizacao_a to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.utilizacao_p to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.vegetacao to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.elemento_fisiografico_natural_a to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.elemento_fisiografico_natural_l to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.elemento_fisiografico_natural_p to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.elemento_fisiografico_p to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.pais to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.trecho_duto to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.trecho_energia_comunic to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.geometria_observacao to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.spatial_ref_sys to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.localizacao_rffsa to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.alteracao_fisiografica_antropica_l to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.alteracao_fisiografica_antropica_p to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.area_especial to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.area_identificacao_direta to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.assentamento_precario to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.bairro to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.canal_vala_a to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.delimitacao_fisica to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.estrut_apoio_transporte_l to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.mar_territorial to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.massa_dagua to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.trecho_rodoviario_l to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.trecho_tagp to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.est_gerad_energia_l to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.alteracao_fisiografica_antropica_a to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.trecho_lmeo to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.trecho_terreno_acrescido_marginal to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.linha_praia to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.localizacao_imovel to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.mobiliario_urbano to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.metadado_produto_cartografico to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.canal_vala_l to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.complementar_a to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.complementar_p to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.curva_batimetrica to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.curva_nivel to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.distrito to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.edificacao_a to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.edificacao_p to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.elemento_fisiografico_a to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.elemento_fisiografico_l to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.estacao_ferroviaria to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.est_gerad_energia_a to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.est_gerad_energia_p to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.estrut_apoio_transporte_a to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.estrut_apoio_transporte_p to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.faixa_dominio to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.faixa_fronteira to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.faixa_seguranca to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.ilha to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.limite_mar_territorial to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
GRANT INSERT, SELECT, UPDATE ON public.linha_costa to nugeoam, nugeoba, nugeoce, nugeoes, nugeomg, nugeorj, nugeorn, nugeosc, nugeosp, nugeors;
commit;

ALTER ROLE spu_sede NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT NOLOGIN;

drop user zago cascade;
DROP ROLE zago CASCADE;

create user zago with password 'zago&2021' SUPERUSER;

alter user cgcig with password 's_cgcig_@';
alter user zago with password ' zago&2021';
alter user geoserver with password '@cesso_geo';