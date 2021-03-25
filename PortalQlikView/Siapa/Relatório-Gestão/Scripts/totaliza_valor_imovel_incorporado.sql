select sg_uf "UF", count(nu_rip) "Quantidade", sum(valor_imovel) "Total"
from (select distinct 
             i.nu_rip, m.sg_uf, m.nu_mun, m.no_mun, iv.valor_imovel, iv.da_inicio_avaliacao_pvg,
             i.nu_logr_trecho_testada1, i.nu_logr_trecho_testada2, i.nu_logr_trecho_testada3, i.nu_logr_trecho_testada4, i.nu_logr_trecho_calculo
        from siapa.tmp_siapa_a_imovel i 
             LEFT JOIN siapa.siapa_t_imovel_valor iv on iv.nu_rip = i.nu_rip
             INNER JOIN siapa.siapa_t_municipio m on m.nu_mun = i.ed_mun
       where da_inclusao_cad_imov between '2014-01-01' and '2014-12-31'
         and nu_rip_primitivo = '00000000000') as vb
group by sg_uf
order by sg_uf         