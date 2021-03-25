drop table saida.tmp_joao_estudo_spiunet;
-----------------------------------------------------------------------------------------------------------------------------------------
create table saida.tmp_joao_estudo_spiunet as
select -- Dados do Imóvel
       i.imv_sg_uf, i.imv_co_municipio, m.no_municipio, i.imv_nu_rip, i.imv_ed_tipologradouro, i.imv_ed_logradouro, i.imv_ed_numero, 
       i.imv_ed_complemento, i.imv_ed_bairro, i.imv_ed_cep,

       -- Dados do Terreno
       i.imv_co_conceituacaoterreno, ct.no_conceituacaoterreno, i.imv_co_naturezaterreno, nt.no_naturezaterreno, i.imv_mq_areaterreno,
       i.imv_va_metroquadrado, i.imv_op_fracaoideal, i.imv_va_terreno as imv_va_terreno_imovel, 

       -- Dados da Benfeitoria
       b.bnf_mq_areaconstruida, te.co_tipoestrutura, te.no_tipoestrutura, b.bnf_op_fatorkp, b.bnf_qt_pavimento,

       -- Dados do Imóvel
       i.imv_da_cadastro, ti.co_tipoimovel, ti.no_tipoimovel, i.imv_op_fatorcorretivo, i.imv_va_somabenfeitoriautilizacao,
       i.imv_va_imovel, i.imv_da_avaliacao, i.imv_co_tipovocacao, tv.no_tipovocacao, 

       -- Dados Complementares 
       i.imv_co_formaaquisicao, fa.no_formaaquisicao,  i.imv_no_proprietarioanterior,
       i.imv_no_fundamentoincorporacao, imv_no_situacaoincorporacao, i.imv_da_incorporacao,
       
       -- Dados da Utilização
       u.uti_nu_rip, ev.eve_da_evento as data_cadastramento_utilizacao, u.uti_co_ug, ug.no_ug, u.uti_ed_tipologradouro_corr, 
       u.uti_ed_logradouro_corr, u.uti_ed_numero_corr, u.uti_ed_complemento_corr,  

       -- Dados do Terreno da Utilização
       u.uti_mq_areaterreno, u.uti_op_fracaoideal, u.uti_va_metroquadrado, u.uti_va_terreno,
       
       -- Benfeitoria da Utilização
       b.bnf_mq_areaconstruida as bnf_mq_areaconstruida_dadosbenfeitoria, b.bnf_op_cub, b.bnf_va_benfeitoria,
       b.bnf_co_estadoconservacao, ec.no_estadoconservacao, b.bnf_co_tipoestrutura, te.no_tipoestrutura as no_tipoestrutura_dadosbenfeitoria,
       ia.no_idadeaparente, b.bnf_op_fatorkp as bnf_op_fatorkp_dadosbenfeitoria, pa.no_padraoacabamento, 
       b.bnf_qt_pavimento as bnf_qt_pavimento_dadosbenfeitoria, b.bnf_co_uso, ui.no_usoimovel, 
       
       -- Avaliação do Imóvel
       u.uti_co_tipodestinacao, td.no_tipodestinacao, u.uti_no_vocacao, u.uti_op_fatorcorretivo,
       u.uti_co_nivelrigoravaliacao, nr.no_nivelrigoravaliacao, u.uti_va_utilizacao, u.uti_da_avaliacao, u.uti_da_prazovalidadeavaliacao,

       -- Regime da Utilização
       u.uti_co_regime, ru.no_regimeutilizacao, u.uti_da_inicio, u.uti_da_fim,  td.co_classificacaosiafi as cod_destinacao_siafi
         
  from spiunet.imovel i
       left join spiunet.municipio m on m.co_municipio = i.imv_co_municipio
       left join spiunet.conceituacaoterreno ct on ct.co_conceituacaoterreno = i.imv_co_conceituacaoterreno
       left join spiunet.naturezaterreno nt on nt.co_naturezaterreno = i.imv_co_naturezaterreno
       left join spiunet.tipoimovel ti on ti.co_tipoimovel = i.imv_co_tipoimovel
       left join spiunet.tipovocacao tv on tv.co_tipovocacao = i.imv_co_tipovocacao
       left join spiunet.formaaquisicao fa on fa.co_formaaquisicao = i.imv_co_formaaquisicao
       left join spiunet.utilizacao u
                 left join  spiunet.evento ev on ev.eve_nu_rip_utilizacao = u.uti_nu_rip and eve_co_tipo = '7' --Cadastramento de Utilizacao
                 left join  spiunet.nivelrigoravaliacao nr on nr.co_nivelrigoravaliacao = u.uti_co_nivelrigoravaliacao
                 left join  spiunet.tipodestinacao td on td.co_tipodestinacao = u.uti_co_tipodestinacao
                 left join  spiunet.regimeutilizacao ru on ru.co_regimeutilizacao = u.uti_co_regime
                 left join  spiunet.ug ug 
                            inner join (SELECT co_ug, max(co_ugsetorialcontabil) as cdset from spiunet.ug GROUP BY co_ug) as vug 
                            on ug.co_ug = vug.co_ug and ug.co_ugsetorialcontabil = vug.cdset
                 on ug.co_ug = u.uti_co_ug
                 left join spiunet.benfeitoria b 
                           left join spiunet.tipoestrutura te on te.co_tipoestrutura = b.bnf_co_tipoestrutura
                           left join spiunet.estadoconservacao ec on ec.co_estadoconservacao = b.bnf_co_estadoconservacao
                           left join spiunet.idadeaparente ia on ia.co_idadeaparente = b.bnf_co_idadeaparente
                           left join spiunet.padraoacabamento pa on pa.co_padraoacabamento = bnf_co_padraoacabamento
                           left join spiunet.usoimovel ui on ui.co_usoimovel = b.bnf_co_uso
                 on b.bnf_nu_rip_imovel = u.uti_nu_rip_imovel and b.bnf_nu_rip_utilizacao = u.uti_nu_rip           
        on u.uti_nu_rip_imovel = i.imv_nu_rip and u.uti_co_motivocancelamentoutilizacao = '101' --ativas
 where i.imv_co_motivocancelamentoimovel = '101'; -- imoveis ativos 

select distinct * from saida.tmp_joao_estudo_spiunet


 select uti_co_ug "Cd UG", no_ug "UG", imv_sg_uf "UF",
        no_municipio "Município",
        lpad(cast(imv_nu_rip as character(13)),13,'0')::character(13) as "RIP",
        (((imv_ed_tipologradouro::text || ' '::text) || btrim(imv_ed_logradouro::text)) || COALESCE(' - '::text || btrim(imv_ed_numero::text), '  '::text)) || COALESCE(' - '::text || btrim(imv_ed_complemento::text), '  '::text)::character varying(150) as "Endereço",
        lpad(cast(imv_ed_cep as character(8)),8,'0')::character(8) as "CEP",
        trim(imv_ed_bairro)::character varying(100) "Bairro",
        to_char(imv_mq_areaterreno,'999G999G990D0000')::character(50) "Área do Terreno",
        to_char(uti_va_utilizacao,'999G999G990D00')::character(50) "Valor do Imóvel"
   from tmp_joao_estudo_spiunet
  where uti_co_regime = '4'  -- Vago para Uso
    and imv_co_municipio in ('7107','9051','6291','7099','6969','7097','6681') 
    --1) São Paulo/SP;
    --2) Campo Grande/MS;
    --3) Campinas/SP;
    --4) São José dos Campos/SP;
    --5) Ribeirão Preto/SP;
    --6) São José do Rio Preto/SP;
    --7) Marília/SP
  order by 1, 2
