--DROP TABLE IF EXISTS siapa.siapa_t_pvg_avaliacao_current CASCADE;

DELETE FROM siapa.siapa_t_pvg_avaliacao_current;

--CREATE TABLE siapa.siapa_t_pvg_avaliacao_current AS

INSERT INTO siapa.siapa_t_pvg_avaliacao_current
SELECT 
    pvg.da_inicio_avaliacao_pvg
  , pvg.da_fim_avaliacao_pvg
  
  , pvg.nu_logr_pvg_avaliacao
  , pvg.nu_trecho_pvg_avaliacao
  , pvg.nu_mun_pvg_avaliacao  
  , pvg.nu_avaliacao
  
  , pvg.va_generico_m2_terreno
  , pvg_emissao.va_m2_terreno_emissao
  , pvg.co_unid_valor_generico_m2_terr
  , pvg.co_origem_valor
  
  , pvg.nu_cpf_usuario_pvg_incl
  , pvg.da_pvg_incl
  , pvg.ho_pvg_incl
  , pvg.nu_crea_pvg_incl
  , pvg.id_pgv

from siapa.siapa_a_pgv pvg
    INNER JOIN (SELECT nu_logr_pvg_avaliacao, nu_trecho_pvg_avaliacao, nu_mun_pvg_avaliacao , max(nu_avaliacao) AS nu_avaliacao
                  FROM siapa.siapa_a_pgv
                 WHERE nu_avaliacao <> '000' AND co_situacao_pvg_avaliacao = 'O'
                 GROUP BY nu_logr_pvg_avaliacao, nu_trecho_pvg_avaliacao, nu_mun_pvg_avaliacao
               ) pvg_last ON pvg_last.nu_logr_pvg_avaliacao = pvg.nu_logr_pvg_avaliacao
                         AND pvg_last.nu_trecho_pvg_avaliacao = pvg.nu_trecho_pvg_avaliacao
                         AND pvg_last.nu_mun_pvg_avaliacao = pvg.nu_mun_pvg_avaliacao
                         AND pvg_last.nu_avaliacao = pvg.nu_avaliacao
                         AND pvg.co_situacao_pvg_avaliacao = 'O'

    LEFT JOIN (SELECT pvg.da_inicio_avaliacao_pvg, pvg.da_fim_avaliacao_pvg, pvg.nu_logr_pvg_emissao, pvg.nu_trecho_pvg_emissao, pvg.nu_mun_pvg_emissao 
                    , pvg.nu_avaliacao, 0 va_generico_m2_terreno, pvg.va_m2_terreno_emissao, pvg.co_unid_valor_generico_m2_terr, pvg.co_origem_valor
                    , pvg.nu_cpf_usuario_pvg_incl, pvg.da_pvg_incl, pvg.ho_pvg_incl, pvg.nu_crea_pvg_incl, pvg.id_pgv, pvg.an_referencia_valor_emissao
                 FROM siapa.siapa_a_pgv pvg     
                      INNER JOIN (SELECT nu_logr_pvg_emissao, nu_trecho_pvg_emissao, nu_mun_pvg_emissao, 
                                         max(an_referencia_valor_emissao) AS an_referencia_valor_emissao
                                    FROM siapa.siapa_a_pgv
                                   WHERE an_referencia_valor_emissao <> '0000' --AND co_situacao_pvg_avaliacao = 'O'
                                   GROUP BY nu_logr_pvg_emissao, nu_trecho_pvg_emissao, nu_mun_pvg_emissao
                                 ) pvg_emissao_last ON pvg.nu_logr_pvg_emissao         = pvg_emissao_last.nu_logr_pvg_emissao
                                                   AND pvg.nu_trecho_pvg_emissao       = pvg_emissao_last.nu_trecho_pvg_emissao
                                                   AND pvg.nu_mun_pvg_emissao          = pvg_emissao_last.nu_mun_pvg_emissao
                                                   AND pvg.an_referencia_valor_emissao = pvg_emissao_last.an_referencia_valor_emissao) pvg_emissao
     ON pvg_emissao.nu_logr_pvg_emissao   = pvg.nu_logr_pvg_avaliacao
    AND pvg_emissao.nu_trecho_pvg_emissao = pvg.nu_trecho_pvg_avaliacao
    AND pvg_emissao.nu_mun_pvg_emissao    = pvg.nu_mun_pvg_avaliacao;

--CREATE INDEX idx_siapa_t_imovel_avaliacao_corrente ON siapa.siapa_t_pvg_avaliacao_current(nu_mun_pvg_avaliacao,nu_logr_pvg_avaliacao,nu_trecho_pvg_avaliacao);
