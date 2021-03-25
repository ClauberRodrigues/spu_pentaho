drop table qualificageo.tb_imoveisfederais_spugeo cascade;
create table qualificageo.tb_imoveisfederais_spugeo as
SELECT
j.fonte::varchar(15) sg_fonte, 
j.nu_rip nu_rip,
j.rip_dv::varchar(13) nu_rip_dv,
j.sg_uf::varchar(2) sg_uf,
j.nome_municipio::varchar(100) nm_municipio,
j.situacao_imovel::varchar(10) st_imovel,
j.ano_cadastro::integer nr_ano_cadastro,
j.ed_tipo_logr::varchar(20) sg_tipo_logradouro,
j.btrim::varchar(50) ds_tipo_logradouro, 
j.ed_logr::varchar(100) ds_logradouro,
j.ed_numero nr_logradouro,
j.ed_complemento::varchar(100) ds_complementologradouro,
j.ed_cep::varchar(8) nr_cep,
j.ds_bairro::varchar(50) ds_bairro,
replace(j.no_endereco_completo::text,',','') tx_endereco_completo,
j.ds_natureza::varchar(10) ds_natureza,
j.ds_conceituacao::varchar(50) ds_conceituacao,
j.no_regime::varchar(50) no_regime,
j.tp_proprietario::varchar(50) tp_proprietario,
j.no_resp::varchar(100) no_resp,
j.nu_processo nr_processo,
j.mq_area mq_area_proprietario,
--i.id_nivel_precisao,
CASE
when i.id_nivel_precisao = 1 then 10
when i.id_nivel_precisao = 2 then 20
when i.id_nivel_precisao = 3 then 30
when i.id_nivel_precisao = 4 then 40
when i.id_nivel_precisao = 5 and q.id_precisao_manual=63 then 51
when i.id_nivel_precisao = 5 and (q.id_precisao_manual=64 or q.id_precisao_manual=69) then 52
when i.id_nivel_precisao = 5 and (q.id_precisao_manual=65 or q.id_precisao_manual=71) then 53
when i.id_nivel_precisao = 5 and (q.id_precisao_manual=66 or q.id_precisao_manual=67) then 54
when i.id_nivel_precisao = 5 and q.id_precisao_manual=68 then 55
when i.id_nivel_precisao = 5 and q.id_precisao_manual=72 then 56
when i.id_nivel_precisao = 5 and q.id_precisao_manual=75 then 57
when i.id_nivel_precisao = 5 and q.id_precisao_manual=73 then 58
else i.id_nivel_precisao END nr_nivel_precisao,
d.ds_nivel_precisao_imovel ds_nivel_precisao,
ST_Y(i.geom_imovel) vl_latitude,
ST_X(i.geom_imovel) vl_longitude,
i.geom_imovel,
null::bool flag_cep_qualifica,
j.nu_rip_primitivo, j.nr_iscricao_municipal nu_inscricao_municipal
FROM qualificageo.tb_join_imofed_legado2 j
LEFT JOIN (select distinct q1.cd_identificador_legado, q1.id_precisao_manual
  from qualificageo.tb_qualifica q1
       inner join (select cd_identificador_legado, max(dt_alteracao) dt_alteracao from qualificageo.tb_qualifica group by cd_identificador_legado) q2 
               on q2.cd_identificador_legado = q1.cd_identificador_legado and q2.dt_alteracao = q1.dt_alteracao ) q ON q.cd_identificador_legado = j.nu_rip
LEFT JOIN cartografia.imv_imovel i ON i.cd_rip::bigint = j.nu_rip
left join qualificageo.dominio_nivel_precisao_imovel d on
(CASE
when i.id_nivel_precisao = 1 then 10
when i.id_nivel_precisao = 2 then 20
when i.id_nivel_precisao = 3 then 30
when i.id_nivel_precisao = 4 then 40
when i.id_nivel_precisao = 5 and q.id_precisao_manual=63 then 51
when i.id_nivel_precisao = 5 and (q.id_precisao_manual=64 or q.id_precisao_manual=69) then 52
when i.id_nivel_precisao = 5 and (q.id_precisao_manual=65 or q.id_precisao_manual=71) then 53
when i.id_nivel_precisao = 5 and (q.id_precisao_manual=66 or q.id_precisao_manual=67) then 54
when i.id_nivel_precisao = 5 and q.id_precisao_manual=68 then 55
when i.id_nivel_precisao = 5 and q.id_precisao_manual=72 then 56
when i.id_nivel_precisao = 5 and q.id_precisao_manual=75 then 57
when i.id_nivel_precisao = 5 and q.id_precisao_manual=73 then 58
else i.id_nivel_precisao end) = d.cd_nivel_precisao_imovel::bigint
ORDER BY j.sg_uf, j.nome_municipio, j.nu_rip;





select cd_identificador_legado, count(*) from (
select distinct q1.cd_identificador_legado, q1.id_precisao_manual
  from qualificageo.tb_qualifica q1
       inner join (select cd_identificador_legado, max(dt_alteracao) dt_alteracao from qualificageo.tb_qualifica group by cd_identificador_legado) q2 
               on q2.cd_identificador_legado = q1.cd_identificador_legado and q2.dt_alteracao = q1.dt_alteracao 
) as tb group by 1 having count(*)>1               


select * from qualificageo.tb_qualifica where cd_rip = '1130100290'