drop table saida.tmp_arq_siapa_completo;
create table saida.tmp_arq_siapa_completo as
select -- Imóvel
       i.nu_rip, ie.sg_uf, i.ed_mun cod_municipio, ie.no_mun nome_municipio,
       (case when i.da_inclusao_cad_imov = '1900-01-01 00:00:00' then null
             else to_char(i.da_inclusao_cad_imov,'DD-MM-YYYY') end) da_inclusao_cad_imov, 
       (case when da_informacao_imov = '1900-01-01 00:00:00' then null 
             else to_char(da_informacao_imov,'DD-MM-YYYY') end) da_informacao_imov, 
       i.co_classe_imov, ci.no_classe_imov,
       -- Imóvel Endereco
       i.co_tipo_ocupacao, ito.no_tipo_ocupacao, i.ed_tipo_logr, i.ed_logr, i.ed_numero, i.ed_complemento,
       i.ed_bairro_distrito, i.ed_cep, i.ed_mun, ie.no_mun,
       -- Dados do Terreno --------------------------------------------------
       i.co_natureza_terreno, nt.no_natureza_terreno, 
       i.co_conceituacao_terreno, ct.no_conceituacao_terreno,
       i.co_fundamento_incorporacao, fi.no_fundamento_incorporacao, fi.tx_fundamento_incorporacao,
       i.nu_inscricao_municipal, i.nu_processo_lpm_lmeo, 
       (case when i.da_aprovacao_lpm_lmeo = '0002-11-30 00:00:00 BC' then null 
             else to_char(i.da_aprovacao_lpm_lmeo,'DD-MM-YYYY') end) da_aprovacao_lpm_lmeo, 
       i.co_tipo_fracao_ideal, op_fracao_ideal_decimal, i.op_fracao_ideal_numerador, i.op_fracao_ideal_denominador, i.op_fracao_ideal_percentual,
       i.mq_area_terreno_total, i.mq_area_terreno_uniao,

       -- dados responsavel
       rp.nu_resp, re.cpf_cgc, re.no_resp, rp.sg_pais,
       
       -- Utilização 
       u.nu_utiliz, u.co_regime_utiliz, ru.no_regime_utiliz, u.pe_taxa_ocupacao,
       u.co_situacao_regime, str.no_situacao_regime, mq_area_uniao_utilizada, mq_area_primitiva_utilizada,

       -- Testadas 
       i.co_situacao_testada_terr_total, stt.no_situacao_testada, i.op_fator_testada_multipla, i.op_fator_corretivo_total, 
       i.nu_logr_trecho_calculo, iv.valor_imovel,
          -- Testada 1
       i.nu_logr_trecho_testada1, 
       --pvg1.sg_tipo_logr sg_tipo_logr_testada1, pvg1.no_logr no_logr_testada1, 
       --pvg1.no_bairro_distrito no_bairro_distrito_testada1,
       pvg1.va_generico_m2_terreno va_generico_m2_terreno_testada1,
       to_char(pvg1.da_inicio_avaliacao_pvg,'DD-MM-YYYY') da_inicio_avaliacao_pvg_testada1, 
       to_char(pvg1.da_fim_avaliacao_pvg,'DD-MM-YYYY') da_fim_avaliacao_pvg_testada1, 
       --pvg1.da_base_geracao da_base_geracao_testada1,
          -- Testada 2
       i.nu_logr_trecho_testada2, 
       --pvg2.sg_tipo_logr sg_tipo_logr_testada2, pvg2.no_logr no_logr_testada2, 
       --pvg2.no_bairro_distrito no_bairro_distrito_testada2, 
       pvg2.va_generico_m2_terreno va_generico_m2_terreno_testada2,
       to_char(pvg2.da_inicio_avaliacao_pvg,'DD-MM-YYYY') da_inicio_avaliacao_pvg_testada2, 
       to_char(pvg2.da_fim_avaliacao_pvg,'DD-MM-YYYY') da_fim_avaliacao_pvg_testada2, 
       --pvg2.da_base_geracao da_base_geracao_testada2,
          -- Testada 3
       i.nu_logr_trecho_testada3, 
       --pvg3.sg_tipo_logr sg_tipo_logr_testada3, pvg3.no_logr no_logr_testada3, 
       --pvg3.no_bairro_distrito no_bairro_distrito_testada3, 
       pvg3.va_generico_m2_terreno va_generico_m2_terreno_testada3, 
       to_char(pvg3.da_inicio_avaliacao_pvg,'DD-MM-YYYY') da_inicio_avaliacao_pvg_testada3, 
       to_char(pvg3.da_fim_avaliacao_pvg,'DD-MM-YYYY') da_fim_avaliacao_pvg_testada3, 
       --pvg3.da_base_geracao da_base_geracao_testada3,
          -- Testada 4
       i.nu_logr_trecho_testada4, 
       --pvg4.sg_tipo_logr sg_tipo_logr_testada4, pvg4.no_logr no_logr_testada4, 
       --pvg4.no_bairro_distrito no_bairro_distrito_testada4, 
       pvg4.va_generico_m2_terreno va_generico_m2_terreno_testada4, 
       to_char(pvg4.da_inicio_avaliacao_pvg,'DD-MM-YYYY') da_inicio_avaliacao_pvg_testada4, 
       to_char(pvg4.da_fim_avaliacao_pvg,'DD-MM-YYYY') da_fim_avaliacao_pvg_testada4, 
       --pvg4.da_base_geracao da_base_geracao_testada4,
 
       -- Dados da Benfeitoria
       benf.mq_area_construida, benf.an_habite_se_construcao, benf.co_finalidade_principal, benf.no_finalidade_principal,
       benf.co_genero_benf, benf.no_genero_benf,
       benf.co_tipo_construcao, benf.no_tipo_construcao,
       benf.co_padrao_acabamento, benf.no_padrao_acabamento,
       benf.qt_pavimentos_benfeitoria, benf.qt_quartos_benfeitoria, benf.co_tipo_estrutura, 
       benf.in_benf_em_condominio, benf.co_tipo_benfeitoria
  from siapa.siapa_a_imovel i 
       -- informações sobre o imóvel
       left join siapa.siapa_t_imovel_valor iv on iv.nu_rip = i.nu_rip
       left join (SELECT b.nu_rip, sum(mq_area_construida) mq_area_construida, b.an_habite_se_construcao, b.co_finalidade_principal,
                         fp.no_finalidade_principal, b.co_genero_benf, gb.no_genero_benf,
                         b.co_tipo_construcao, tc.no_tipo_construcao, b.co_padrao_acabamento, pa.no_padrao_acabamento,
                         b.qt_pavimentos_benfeitoria, b.qt_quartos_benfeitoria, b.co_tipo_estrutura, 
                         b.in_benf_em_condominio, b.co_tipo_benfeitoria
                    FROM siapa.siapa_a_benfeitoria b
                         LEFT JOIN siapa.siapa_t_finalidadeprincipal fp on fp.co_finalidade_principal = b.co_finalidade_principal
                         LEFT JOIN siapa.siapa_t_genero_benf gb on gb.co_genero_benf = b.co_genero_benf
                         LEFT JOIN siapa.siapa_t_tipoconstrucao tc on tc.co_tipo_construcao = b.co_tipo_construcao
                         LEFT JOIN siapa.siapa_t_padrao_acab pa on pa.co_padrao_acabamento = b.co_padrao_acabamento
                   WHERE co_situacao_benf = '1' -- Somente Benfeitorias ativas
                   GROUP BY b.nu_rip, b.an_habite_se_construcao, b.co_finalidade_principal,
                         fp.no_finalidade_principal, b.co_genero_benf, gb.no_genero_benf,
                         b.co_tipo_construcao, tc.no_tipo_construcao, b.co_padrao_acabamento, pa.no_padrao_acabamento,
                         b.qt_pavimentos_benfeitoria, b.qt_quartos_benfeitoria, b.co_tipo_estrutura, 
                         b.in_benf_em_condominio, b.co_tipo_benfeitoria) as benf on benf.nu_rip = i.nu_rip
       left  join siapa.siapa_t_municipio ie on i.ed_mun = ie.nu_mun
       left  join siapa.siapa_t_classe_imovel ci on i.co_classe_imov = ci.co_classe_imov
       left  join siapa.siapa_t_tipoocupacao ito on i.co_tipo_ocupacao = ito.co_tipo_ocupacao --tabela vazia ver com Marcelo
       left  join siapa.siapa_t_naturezaterreno nt on i.co_natureza_terreno = nt.co_natureza_terreno
       left  join siapa.siapa_t_conceituacao_terreno ct on i.co_conceituacao_terreno = ct.co_conceituacao_terreno
       left  join siapa.siapa_t_fundamento_incorporacao fi on i.co_fundamento_incorporacao = fi.co_fundamento_incorporacao
       left  join siapa.siapa_v_situacao_testada stt on stt.co_situacao_testada = i.co_situacao_testada_terr_total
       -- Testadas 
       -- T1
       left  join siapa.siapa_t_pvg_avaliacao_current /*siapa.siapa_t_ultima_pvg*/ pvg1 ON i.ed_mun = pvg1.nu_mun_pvg_avaliacao
             AND SUBSTRING(i.nu_logr_trecho_testada1,1,6) = pvg1.nu_logr_pvg_avaliacao AND SUBSTRING(i.nu_logr_trecho_testada1,7,2) = pvg1.nu_trecho_pvg_avaliacao   
       -- T2 
       left  join siapa.siapa_t_pvg_avaliacao_current /*siapa.siapa_t_ultima_pvg*/ pvg2 ON i.ed_mun = pvg2.nu_mun_pvg_avaliacao
             AND SUBSTRING(i.nu_logr_trecho_testada2,1,6) = pvg2.nu_logr_pvg_avaliacao AND SUBSTRING(i.nu_logr_trecho_testada2,7,2) = pvg2.nu_trecho_pvg_avaliacao   
       -- T3 
       left  join siapa.siapa_t_pvg_avaliacao_current /*siapa.siapa_t_ultima_pvg*/ pvg3 ON i.ed_mun = pvg3.nu_mun_pvg_avaliacao
             AND SUBSTRING(i.nu_logr_trecho_testada3,1,6) = pvg3.nu_logr_pvg_avaliacao AND SUBSTRING(i.nu_logr_trecho_testada3,7,2) = pvg3.nu_trecho_pvg_avaliacao   
       -- T4 
       left  join siapa.siapa_t_pvg_avaliacao_current /*siapa.siapa_t_ultima_pvg*/ pvg4 ON i.ed_mun = pvg4.nu_mun_pvg_avaliacao
             AND SUBSTRING(i.nu_logr_trecho_testada4,1,6) = pvg4.nu_logr_pvg_avaliacao AND SUBSTRING(i.nu_logr_trecho_testada4,7,2) = pvg4.nu_trecho_pvg_avaliacao   


       -- informações sobre utilização
       left join  siapa.siapa_a_utilizacao u 
            left  join siapa.siapa_t_situacao_regime str on str.co_situacao_regime = u.co_situacao_regime
            inner join siapa.siapa_t_regime_utilizacao ru on u.co_regime_utiliz = ru.co_regime_utiliz
            inner join siapa.siapa_a_responsavel rp 
                  inner join siapa.siapa_v_endereco_responsavel re on rp.nu_resp = re.nu_resp
            on u.nu_resp = rp.nu_resp
       on i.nu_rip = u.nu_rip and u.co_estado_utiliz = '1' --somente utilizações ativas
 WHERE i.co_situacao_imov = '1'  -- somente imoveis ativos


select distinct * from saida.tmp_arq_siapa_completo

create or replace view siapa.siapa_v_situacao_testada as
select co_situacao_testada, no_situacao_testada
  from siapa.siapa_a_tabela
 where co_situacao_testada <> '0' or (co_situacao_testada = '0' and no_situacao_testada is not null)

CREATE OR REPLACE VIEW siapa.siapa_v_endereco_responsavel AS 
 SELECT r.nu_resp, r.in_cpf_cgc, 
        CASE
            WHEN r.in_cpf_cgc = '2'::text THEN siapa.fn_calcula_dv_cnpj(substr(r.nu_basico_cpf_cgc, 2, 8) || r.nu_ordem_cgc)
            WHEN r.in_cpf_cgc = '1'::text THEN siapa.fn_calcula_dv_cpf(r.nu_basico_cpf_cgc)
            ELSE NULL::text
        END AS cpf_cgc, r.no_resp, (((r.ed_tipo_logr || ' '::text) || btrim(r.ed_logr)) || COALESCE(' - '::text || btrim(r.ed_complemento), '  '::text)) || COALESCE(' - '::text || btrim(r.ed_bairro_distrito), '  '::text) AS endereco_logrador, (((r.ed_cep || ' - '::text) || btrim(m.no_mun::text)) || ' - '::text) || m.sg_uf::text AS endereco_complemento
   FROM siapa.siapa_a_responsavel r
   JOIN siapa.siapa_t_municipio m ON m.nu_mun::text = r.ed_mun;

ALTER TABLE siapa.siapa_v_endereco_responsavel
  OWNER TO oltp;

 
