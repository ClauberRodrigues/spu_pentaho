DROP TABLE IF EXISTS siapa.siapa_t_imovel_valor;

CREATE TABLE siapa.siapa_t_imovel_valor AS
SELECT * FROM (
-- Testada principal definida no imovel
(
	SELECT 
	    imv.nu_rip
	  , (case when imv.op_fracao_ideal_decimal > 0.00 then
                      trunc(imv.mq_area_terreno_uniao * pvg.va_generico_m2_terreno * imv.op_fracao_ideal_decimal * imv.op_fator_corretivo_total,2)
                 when imv.op_fracao_ideal_numerador > 0.00 and imv.op_fracao_ideal_denominador > 0.00 then
                      trunc(imv.mq_area_terreno_uniao * pvg.va_generico_m2_terreno * (imv.op_fracao_ideal_numerador / imv.op_fracao_ideal_denominador) * imv.op_fator_corretivo_total,2)
                 when imv.op_fracao_ideal_percentual > 0.00 then imv.op_fracao_ideal_percentual
                 end) AS valor_imovel
	  , da_inicio_avaliacao_pvg
	FROM siapa.siapa_a_imovel AS imv
	    INNER JOIN siapa.siapa_t_pvg_avaliacao_current  pvg
	        ON imv.nu_logr_trecho_calculo != '00000000'
	           AND imv.ed_mun = pvg.nu_mun_pvg_avaliacao
	           AND SUBSTRING(imv.nu_logr_trecho_calculo,1,6) = pvg.nu_logr_pvg_avaliacao
	           AND SUBSTRING(imv.nu_logr_trecho_calculo,7,9) = pvg.nu_trecho_pvg_avaliacao
)
UNION ALL
-- Busca de testada de maior valor
(
	SELECT 
	    imv.nu_rip
	  , max(trunc(imv.mq_area_terreno_uniao * pvg.va_generico_m2_terreno * 
	        (case when imv.op_fracao_ideal_decimal > 0.00 then imv.op_fracao_ideal_decimal
	              when imv.op_fracao_ideal_numerador > 0.00 and imv.op_fracao_ideal_denominador > 0.00 then
	                   (imv.op_fracao_ideal_numerador / imv.op_fracao_ideal_denominador)
                      when imv.op_fracao_ideal_percentual > 0.00 then imv.op_fracao_ideal_percentual
	              end) * imv.op_fator_corretivo_total,2)) AS valor_imovel
	  , max(da_inicio_avaliacao_pvg) as da_inicio_avaliacao_pvg
	FROM siapa.siapa_a_imovel AS imv
	    INNER JOIN siapa.siapa_t_pvg_avaliacao_current as pvg
	        ON imv.nu_logr_trecho_calculo = '00000000'
	           AND imv.ed_mun = pvg.nu_mun_pvg_avaliacao
	           AND (
	           
	               (    SUBSTRING(imv.nu_logr_trecho_testada1,1,6) = pvg.nu_logr_pvg_avaliacao
	                AND SUBSTRING(imv.nu_logr_trecho_testada1,7,9) = pvg.nu_trecho_pvg_avaliacao)
	               OR
	               (    SUBSTRING(imv.nu_logr_trecho_testada2,1,6) = pvg.nu_logr_pvg_avaliacao
	                AND SUBSTRING(imv.nu_logr_trecho_testada2,7,9) = pvg.nu_trecho_pvg_avaliacao)
	               OR
	               (    SUBSTRING(imv.nu_logr_trecho_testada3,1,6) = pvg.nu_logr_pvg_avaliacao
	                AND SUBSTRING(imv.nu_logr_trecho_testada3,7,9) = pvg.nu_trecho_pvg_avaliacao)
	               OR
	               (    SUBSTRING(imv.nu_logr_trecho_testada4,1,6) = pvg.nu_logr_pvg_avaliacao
	                AND SUBSTRING(imv.nu_logr_trecho_testada4,7,9) = pvg.nu_trecho_pvg_avaliacao)
	                
	           )
	GROUP BY nu_rip
)
) as tb
;

CREATE INDEX idx_siapa_t_imovel_valor_nu_rip ON siapa.siapa_t_imovel_valor(nu_rip);
