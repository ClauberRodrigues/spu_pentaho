select case fonte when 'SIAPA' then 'Dominial'
                  else 'Uso Especial' end "Fonte", 
       sg_uf "UF", 
       ds_natureza "Natureza", 
       count(distinct nu_rip) "Quantidade",
       sum(mq_area)::numeric(25,2) "Área (m2)",
       sum(valor_imovel)::numeric(25,2) "Valor (R$)"
  from bispu.dw_siapa.ods_unificado s
 where ds_natureza is not null 
   and nu_rip <> '217000195003'
 group by fonte, sg_uf, ds_natureza 
 order by 1,2,3