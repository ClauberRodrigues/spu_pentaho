select *
  from ODS.ods_arrecadacao
  
  select ods.consolida_ods_arrecadacao();
  
 
 select sg_uf, to_char(da_arrecadacao_cred,'YYYY-MM') mes_arrecadacao, 
        co_receita, rtrim(nm_receita) receita, sum(va_receita) vl_arrecadado 
   from ods.ods_arrecadacao_consolidado
  where co_receita is not null  --da_arrecadacao_cred between '2019-01-01' and '2019-12-31'
  group by sg_uf, to_char(da_arrecadacao_cred,'YYYY-MM'), co_receita, rtrim(nm_receita)
  order by sg_uf, to_char(da_arrecadacao_cred,'YYYY-MM'), co_receita
