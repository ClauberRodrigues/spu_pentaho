SELECT m.sg_uf uf, p.nu_mun_pvg_logr, m.no_mun no_municipio,

       -- PVG Avaliação
       p.sg_tipo_logr, p.nu_logr_pvg_avaliacao, p.no_logr, p.no_bairro_distrito,
       p.co_natureza_logr, nlogr.no_natureza_terreno no_natureza_logre,
       nu_trecho_pvg_avaliacao, no_trecho, co_situacao_pvg_avaliacao,
       co_lado_trecho, nu_inicio_trecho, nu_fim_trecho, nu_avaliacao,
       in_trecho_bloqueado, da_inicio_avaliacao_pvg, da_fim_avaliacao_pvg,
       va_generico_m2_terreno,
       co_unid_valor_generico_m2_terr, t.sg_unid_valor, co_origem_valor, t2.no_oreigem_valor,
       -- Dados Genericos
       nu_cpf_usuario_pvg_incl, 
       da_pvg_incl, ho_pvg_incl, nu_crea_pvg_incl, nu_cpf_usuario_pvg_hist, 
       da_pvg_hist, ho_pvg_hist, nu_crea_pvg_hist

  FROM siapa.siapa_t_ultima_pvg p
       INNER JOIN siapa.siapa_t_municipio m ON m.nu_mun = p.nu_mun_pvg_logr
       LEFT  JOIN siapa.siapa_t_naturezaterreno nlogr ON nlogr.co_natureza_terreno = p.co_natureza_logr
       LEFT  JOIN siapa.siapa_a_tabela t  ON t.co_unid_valor = p.co_unid_valor_generico_m2_terr
       LEFT  JOIN siapa.siapa_a_tabela t2 ON t2.co_origem_valor = p.co_origem_valor

