drop table siapa.siapa_t_imovel_testada_valor_corrente; 
CREATE TABLE siapa.siapa_t_imovel_testada_valor_corrente AS
SELECT * 
  FROM (-- Testada principal definida no imovel
       (       SELECT m.sg_uf, m.nu_mun
	     , m.no_mun
	     , imv.nu_rip
	     , imv.nu_logr_trecho_calculo nu_logr_trecho_calculo
	     , case when da_inicio_avaliacao_pvg is null then 'Sem Avaliacao'::text else da_inicio_avaliacao_pvg::text end da_inicio_avaliacao_pvg
	     , imv.mq_area_terreno_uniao
	     , imv.op_fator_corretivo_total
	     , case when pvg.va_generico_m2_terreno is null then 0.00 else pvg.va_generico_m2_terreno end va_generico_m2_terreno
	     , imv.op_fracao_ideal_decimal
	     , imv.op_fracao_ideal_numerador
	     , imv.op_fracao_ideal_denominador

	     , (case when imv.op_fracao_ideal_decimal > 0.00 then
                      trunc(imv.mq_area_terreno_uniao * pvg.va_generico_m2_terreno * imv.op_fracao_ideal_decimal * imv.op_fator_corretivo_total,2)
                     when imv.op_fracao_ideal_numerador > 0.00 and imv.op_fracao_ideal_denominador > 0.00 then
                      trunc(imv.mq_area_terreno_uniao * pvg.va_generico_m2_terreno * (imv.op_fracao_ideal_numerador / imv.op_fracao_ideal_denominador) * imv.op_fator_corretivo_total,2)
                     when imv.op_fracao_ideal_percentual > 0.00 then    
                      trunc(imv.mq_area_terreno_uniao * pvg.va_generico_m2_terreno * (imv.op_fracao_ideal_percentual / 100)  * imv.op_fator_corretivo_total,2)
                  end) AS valor_imovel
              , id_pgv
	FROM siapa.siapa_a_imovel AS imv
	     INNER JOIN siapa.siapa_t_municipio m on m.nu_mun = imv.ed_mun
	     LEFT  JOIN siapa.siapa_t_pvg_avaliacao_current  pvg
	             ON imv.ed_mun = pvg.nu_mun_pvg_avaliacao
	            AND SUBSTRING(imv.nu_logr_trecho_calculo,1,6) = pvg.nu_logr_pvg_avaliacao
	            AND SUBSTRING(imv.nu_logr_trecho_calculo,7,2) = pvg.nu_trecho_pvg_avaliacao
     WHERE imv.nu_logr_trecho_calculo != '00000000' and imv.co_situacao_imov = '1'
)
UNION ALL
-- Busca de testada de maior valor
(SELECT m.sg_uf, m.nu_mun, m.no_mun, imv.nu_rip, 
       --imv.nu_logr_trecho_calculo nu_logr_trecho_calculo, 
       (select distinct p1.nu_logr_pvg_avaliacao||p1.nu_trecho_pvg_avaliacao from siapa.siapa_t_pvg_avaliacao_current p1 where p1.id_pgv = pvg.id_pgv) nu_logr_trecho_calculo,
       case when da_inicio_avaliacao_pvg is null then 'Sem Avalia??o'::text else da_inicio_avaliacao_pvg::text end da_inicio_avaliacao_pvg, 
       imv.mq_area_terreno_uniao, imv.op_fator_corretivo_total, 
       case when pvg.va_generico_m2_terreno is null then 0.00 else pvg.va_generico_m2_terreno end va_generico_m2_terreno, 
       imv.op_fracao_ideal_decimal, imv.op_fracao_ideal_numerador, imv.op_fracao_ideal_denominador 
       , (trunc(imv.mq_area_terreno_uniao * pvg.va_generico_m2_terreno * 
             (case when imv.op_fracao_ideal_decimal > 0.00 then imv.op_fracao_ideal_decimal
                   when imv.op_fracao_ideal_numerador > 0.00 and imv.op_fracao_ideal_denominador > 0.00 then
                        (imv.op_fracao_ideal_numerador / imv.op_fracao_ideal_denominador)
                   when imv.op_fracao_ideal_percentual > 0.00 then (imv.op_fracao_ideal_percentual / 100)      
              end) * imv.op_fator_corretivo_total,2)) AS valor_imovel
        , id_pgv
   FROM siapa.siapa_a_imovel AS imv
        INNER JOIN siapa.siapa_t_municipio m on m.nu_mun = imv.ed_mun
	LEFT  JOIN siapa.siapa_t_pvg_avaliacao_current as pvg
	        ON  imv.ed_mun = pvg.nu_mun_pvg_avaliacao
	       AND ((SUBSTRING(imv.nu_logr_trecho_testada1,1,6) = pvg.nu_logr_pvg_avaliacao 
	       AND SUBSTRING(imv.nu_logr_trecho_testada1,7,2) = pvg.nu_trecho_pvg_avaliacao)
	       OR  (SUBSTRING(imv.nu_logr_trecho_testada2,1,6) = pvg.nu_logr_pvg_avaliacao
	       AND SUBSTRING(imv.nu_logr_trecho_testada2,7,2) = pvg.nu_trecho_pvg_avaliacao)
	       OR  (SUBSTRING(imv.nu_logr_trecho_testada3,1,6) = pvg.nu_logr_pvg_avaliacao
	       AND SUBSTRING(imv.nu_logr_trecho_testada3,7,2) = pvg.nu_trecho_pvg_avaliacao)
	       OR  (SUBSTRING(imv.nu_logr_trecho_testada4,1,6) = pvg.nu_logr_pvg_avaliacao
	       AND SUBSTRING(imv.nu_logr_trecho_testada4,7,2) = pvg.nu_trecho_pvg_avaliacao))
    WHERE imv.nu_logr_trecho_calculo = '00000000'
    and   imv.co_situacao_imov = '1'
    and       (trunc(imv.mq_area_terreno_uniao * pvg.va_generico_m2_terreno * 
              (case when imv.op_fracao_ideal_decimal > 0.00 then imv.op_fracao_ideal_decimal
                    when imv.op_fracao_ideal_numerador > 0.00 and imv.op_fracao_ideal_denominador > 0.00 then
                        (imv.op_fracao_ideal_numerador / imv.op_fracao_ideal_denominador)
                    when imv.op_fracao_ideal_percentual > 0.00 then (imv.op_fracao_ideal_percentual / 100) 
              end) * imv.op_fator_corretivo_total,2)) = (
              SELECT max(trunc(i.mq_area_terreno_uniao * pvg.va_generico_m2_terreno * 
                    (case when i.op_fracao_ideal_decimal > 0.00 then i.op_fracao_ideal_decimal
                          when i.op_fracao_ideal_numerador > 0.00 and i.op_fracao_ideal_denominador > 0.00 then
                               (i.op_fracao_ideal_numerador / i.op_fracao_ideal_denominador)
                          when i.op_fracao_ideal_percentual > 0.00 then (i.op_fracao_ideal_percentual / 100)     
                     end) * i.op_fator_corretivo_total,2)) AS valor_imovel
                FROM siapa.siapa_a_imovel AS i INNER JOIN siapa.siapa_t_municipio m on m.nu_mun = i.ed_mun
	                                       INNER JOIN siapa.siapa_t_pvg_avaliacao_current as pvg
	                                               ON i.nu_logr_trecho_calculo = '00000000'
	                                              AND i.ed_mun = pvg.nu_mun_pvg_avaliacao
	                                              AND ((SUBSTRING(i.nu_logr_trecho_testada1,1,6) = pvg.nu_logr_pvg_avaliacao 
	                                              AND SUBSTRING(i.nu_logr_trecho_testada1,7,2) = pvg.nu_trecho_pvg_avaliacao)
	                                               OR (SUBSTRING(i.nu_logr_trecho_testada2,1,6) = pvg.nu_logr_pvg_avaliacao
	                                                   AND SUBSTRING(i.nu_logr_trecho_testada2,7,2) = pvg.nu_trecho_pvg_avaliacao)
	                                               OR (SUBSTRING(imv.nu_logr_trecho_testada3,1,6) = pvg.nu_logr_pvg_avaliacao
	                                                   AND SUBSTRING(i.nu_logr_trecho_testada3,7,2) = pvg.nu_trecho_pvg_avaliacao)
	                                               OR (SUBSTRING(imv.nu_logr_trecho_testada4,1,6) = pvg.nu_logr_pvg_avaliacao
	                                                   AND SUBSTRING(i.nu_logr_trecho_testada4,7,2) = pvg.nu_trecho_pvg_avaliacao))
               WHERE i.nu_rip = imv.nu_rip
GROUP BY i.nu_rip))) as tb;

CREATE INDEX idx_siapa_t_imovel_valor_testada_nu_rip ON siapa.siapa_t_imovel_testada_valor_corrente(nu_rip);