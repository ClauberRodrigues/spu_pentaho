drop table siapa.tmp_debito_nao_gerado;

create table siapa.tmp_debito_nao_gerado as
select distinct 
       m.no_mun, m.sg_uf, gd.nu_rip, i.co_situacao_imov, i.co_classe_imov, ci.no_classe_imov,
       i.co_conceituacao_terreno, ct.no_conceituacao_terreno, i.da_cancelamento_imov, deb.cpf_cgc, 
       deb.no_resp, deb.nu_debito, deb.no_situacao_debito, deb.co_receita, deb.pe_taxa_ocupacao,
       deb.va_debito_total 
  from (select distinct nu_rip from siapa.tmp_importa_rip_debito_sem_geracao_debito) gd 
       inner join  siapa.tmp_siapa_a_imovel i 
             inner join siapa.siapa_t_municipio m on m.nu_mun = i.ed_mun
             inner join siapa.siapa_t_classe_imovel ci on ci.co_classe_imov = i.co_classe_imov
             inner join siapa.siapa_t_conceituacao_terreno ct on ct.co_conceituacao_terreno = i.co_conceituacao_terreno
       on i.nu_rip = gd.nu_rip
       Left join (select distinct 
                         d.nu_rip,
                         (case when in_cpf_cgc = '1' then siapa.fn_calcula_dv_cpf(nu_basico_cpf_cgc)
                               when in_cpf_cgc = '2' then siapa.fn_calcula_dv_cnpj(nu_basico_cpf_cgc||nu_ordem_cgc)
                               else 'Sem Informacao' end)::varchar(20) as cpf_cgc,
                         r.no_resp, d.nu_debito, d.co_situacao_debito, sd.no_situacao_debito, d.co_receita, u.pe_taxa_ocupacao, d.va_debito_total
                         --siapa.calc_saldo(da_base_calculo::date, va_debito_total, '2015-02-28'::date, true)
                    from siapa.siapa_a_debito d inner join siapa.tmp_siapa_a_responsavel r on r.nu_resp = d.nu_resp_contraiu_debito
                                                inner join siapa.tmp_siapa_a_utilizacao u on u.nu_rip = d.nu_rip and u.nu_utiliz = d.nu_utiliz
                                                inner join siapa.siapa_t_situacao_debito sd on sd.co_situacao_debito = d.co_situacao_debito
                   where da_base_calculo between '2005-01-01' and '2005-12-31') deb on deb.nu_rip = gd.nu_rip


SELECT sg_uf  "UF",
       no_mun "Município",  
       nu_rip "RIP", 
       (case when co_situacao_imov = '1' then 'Ativo'
             else 'Cancelado' end) "Situação Imóvel", 
       no_classe_imov "Classe Imóvel", 
       no_conceituacao_terreno "Conceituação do Terreno", 
       (case when da_cancelamento_imov = '0002-11-30 00:00:00 BC' then ''
             else to_char(da_cancelamento_imov,'DD/MM/YYYY') end) "Dt. Cancelamento", 
       cpf_cgc "CPF/CGC Responsável", 
       no_resp "Nome", 
       nu_debito "Nr. Débito", 
       no_situacao_debito "Situação do Débito", 
       co_receita "Cd. da Receita", 
       pe_taxa_ocupacao "% Taxa Ocupação", 
       to_char(va_debito_total,'999G999G999G990D00') "Vlr. Débito Original"
  FROM siapa.tmp_debito_nao_gerado



create table siapa.tmp_siapa_a_benfeitoria as
select * from siapa.siapa_a_benfeitoria
where dh_data_hora_backup = (select max(dh_data_hora_backup) from siapa.siapa_a_benfeitoria)


