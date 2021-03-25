drop table cif.tmp_tb_imovel_cif_publicacao;
create table cif.tmp_tb_imovel_cif_publicacao as
SELECT imovel.endereco as id_imovel,
       cast(ORGAO_SIAPE.CODORGSIAPE as char(5)) as cod_orgao_responsavel,
       ('MP - MINISTERIO DO PLANEJ.,ORCAMENTO E GESTAO')::character varying(45) as nome_orgao,
       cast(coalesce(imovel.NOMEENDERECO,'') || ' - BRASILIA/DF ' as char(60)) as endereco_imovel,
       case when imovel.cep = '' then '00000000' else cast(replace(coalesce(imovel.cep,'00000000'),'-','') as char(8)) end  as cep_imovel,
       case situacao.codigosituacao when '12' then '10' else lpad(cast(situacao.codigosituacao as char(2)),2,'0') end as codigo_situacao_imovel
  FROM (select situacaoimovel.endereco, situacaoimovel.SITUACAO, situacaoimovel.dtsituacao
          from (select situacaoimovel.endereco, MAX (dtsituacao) as dtsituacao
                  from cif.situacaoimovel
                 group by situacaoimovel.endereco) as situacaoimovel2, cif.situacaoimovel
         where situacaoimovel2.endereco = situacaoimovel.endereco 
           and situacaoimovel2.dtsituacao = situacaoimovel.dtsituacao 
           and situacaoimovel.situacao NOT IN (5,70)) as situacaoimoveis_nao_alienados  -- 5 = Alienados | 70 = Outros

       left join (select ocupanteimovel.endereco, ocupanteimovel.CODIGOOCUPANTE, ocupanteimovel.DTDESOCUPACAO, ocupanteimovel.DTOCUPACAO
                    from (select OCUPANTEIMOVEL.endereco, MAX(ocupanteimovel.dtocupacao) as dtocupacao
                            from cif.OCUPANTEIMOVEL
                           where ocupanteimovel.ENDERECO not in ('01020108570103','01020307510406','01020304570102','01010115550201',
                                                                 '01020108550601', '01010109530405','01020410610308','01020106570303',
                                                                 '04081405530406','01020304550308','01010316520202','01020307570307',
                                                                 '01020106600101','01010307580602','01020307520608','04081307510301',
                                                                 '01010210590201','01020308600407')
                                    group by OCUPANTEIMOVEL.endereco) as ocupanteimovel2, cif.OCUPANTEIMOVEL 
                            where ocupanteimovel2.ENDERECO = ocupanteimovel.ENDERECO 
                              and ocupanteimovel2.dtocupacao = ocupanteimovel.DTOCUPACAO) as ocupante_imovel_ultima_dtocupacao 
                 on situacaoimoveis_nao_alienados.endereco = ocupante_imovel_ultima_dtocupacao.ENDERECO
                left join cif.SITUACAO on situacao.codigosituacao = situacaoimoveis_nao_alienados.situacao
                left join cif.OCUPANTE on ocupante_imovel_ultima_dtocupacao.codigoocupante = ocupante.codigoocupante
                left join cif.IMOVEL on imovel.endereco = situacaoimoveis_nao_alienados.ENDERECO and imovel.ENDERECO = ocupante_imovel_ultima_dtocupacao.endereco
                left join cif.ORGAO_SIAPE on imovel.cdorgadm = ORGAO_SIAPE.CODORGCIF
        WHERE   -- retirando incosistencias de endereços nulos
                imovel.endereco is not null AND
                imovel.NOMEENDERECO is not null AND
                -- selecionando apenas imoveis sob gestao do MP
                imovel.CDORGADM in ('07000') AND 
                -- retirando endereços a pedido da CGAPF
                imovel.ENDERECO NOT IN 
                (SELECT ENDERECO FROM cif.v_imoveis_nao_publicados_cgu) -- solicitado pelo Vitor 06/05/14
