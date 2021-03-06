drop TABLE cif.tmp_tb_imovel_permissionario_cif_segep;
CREATE TABLE cif.tmp_tb_imovel_permissionario_cif_segep as
SELECT imovel.endereco as id_imovel, 
       case situacao.situacao 
            when 'Vago para uso' then '' else 
                 case coalesce(servidores_cgep.nome,'') 
                      when '' then cast(Rtrim(Ltrim (coalesce(ocupante.nomeocupante,'nao informado'))) as char(60)) 
                      else cast(Rtrim(Ltrim (coalesce(servidores_cgep.nome,'nao informado'))) as char(60)) end end as nome_permissionario,

       case situacao.situacao 
            when 'Vago para uso' then '' else 
                 case coalesce(servidores_cgep.cpf,'') 
	              when '' then cast(Rtrim(Ltrim(coalesce(ocupante.cpfocupante,'00000000000'))) as char(11)) 
	              else cast(Rtrim(Ltrim(coalesce(servidores_cgep.cpf,'00000000000'))) as char(11)) end end as cpf_permissionario,

       case situacao.situacao 
	    when 'Vago para uso' then '' else 
	         case coalesce(servidores_cgep.funcao,'') 
	              when '' then cast(Rtrim(Ltrim(coalesce(FUNCAO.nomefuncao,'FUNCAO NAO INFORMADA'))) as char(100)) 
	              else cast(Rtrim(Ltrim(coalesce(servidores_cgep.funcao,'FUNCAO NAO INFORMADA'))) as char(100)) end end as descricao_cargo_funcao,

       case situacao.situacao 
	    when 'Vago para uso' then '' else 
	         case coalesce(servidores_cgep.cd_orgao_lotacao,'') 
	               when '' then cast(Rtrim(Ltrim(coalesce(ORGAO_SIAPE.CODORGSIAPE,'0000000'))) as char(5)) 
	               else cast(Rtrim(Ltrim(coalesce(servidores_cgep.cd_orgao_lotacao,'0000000'))) as char(5)) end end as orgao_exercicio,

       case situacao.situacao 
            when 'Vago para uso' then '' else 
                 case coalesce(servidores_cgep.nm_orgao_lotacao,'') 
                      when '' then cast(coalesce(ORGAO.NOMEORGAO,'') as char(100)) 
                      else  cast(coalesce(servidores_cgep.nm_orgao_lotacao,'') as char(100)) end end as nome_orgao,

       case situacao.situacao 
            when 'Vago para uso' then '' else cast(Rtrim(Ltrim(coalesce(to_char(ocupante_imovel_ultima_dtocupacao.dtocupacao,'YYYYMMDD'),'00000000'))) as char(8)) END as data_ocupacao,

       case situacao.situacao 
	    when 'Vago para uso' then '' else cast(Rtrim(Ltrim(coalesce(ORGAO_PODER.PODER,' '))) as char(1)) END as poder_governamental
	    
  FROM (select situacaoimovel.endereco, situacaoimovel.SITUACAO, situacaoimovel.dtsituacao

          from (select situacaoimovel.endereco, MAX (dtsituacao) as dtsituacao
	 	  from cif.situacaoimovel
		 group by situacaoimovel.endereco) as situacaoimovel2, cif.situacaoimovel
		 
 	 where situacaoimovel2.endereco = situacaoimovel.endereco 
	   and situacaoimovel2.dtsituacao = situacaoimovel.dtsituacao 
	   and situacaoimovel.situacao NOT IN (5,6,70)) as situacaoimoveis_nao_alienados -- 5 = Alienados | 6= Vago p/ Uso | 70 = Outros

		left join (select ocupanteimovel.endereco, ocupanteimovel.CODIGOOCUPANTE, ocupanteimovel.DTDESOCUPACAO, ocupanteimovel.DTOCUPACAO
			     from (select OCUPANTEIMOVEL.endereco, MAX(ocupanteimovel.dtocupacao) as dtocupacao
				     from cif.OCUPANTEIMOVEL
				    where ocupanteimovel.ENDERECO not in ('01020108570103','01020307510406','01020304570102','01010115550201',
				                                          '01020108550601','01010109530405','01020410610308','01020106570303',
				                                          '04081405530406','01020304550308','01010316520202','01020307570307',
							                  '01020106600101','01010307580602','01020307520608','04081307510301',
							                  '01010210590201','01020308600407')
			       group by OCUPANTEIMOVEL.endereco) as ocupanteimovel2, cif.OCUPANTEIMOVEL
			    where ocupanteimovel2.ENDERECO = ocupanteimovel.ENDERECO 
			      and ocupanteimovel2.dtocupacao = ocupanteimovel.DTOCUPACAO) as ocupante_imovel_ultima_dtocupacao
		 on situacaoimoveis_nao_alienados.endereco = ocupante_imovel_ultima_dtocupacao.ENDERECO

		left join cif.SITUACAO on situacao.codigosituacao = situacaoimoveis_nao_alienados.situacao
		left join cif.OCUPANTE on ocupante_imovel_ultima_dtocupacao.codigoocupante = ocupante.codigoocupante
		left join cif.servidores_cgep on servidores_cgep.cpf  = ocupante.cpfocupante
		left join cif.ORGAO  on ocupante.CDORGEXERCICIO = ORGAO.CODIGOORGAO
		left join cif.IMOVEL on imovel.endereco = situacaoimoveis_nao_alienados.ENDERECO and imovel.ENDERECO = ocupante_imovel_ultima_dtocupacao.endereco
		left join cif.CARGO on ocupante.codigocargo = CARGO.codigocargo
		left join cif.FUNCAO on ocupante.codigofuncao = FUNCAO.codigofuncao
		left join cif.ORGAO_SIAPE on ocupante.CDORGEXERCICIO = ORGAO_SIAPE.CODORGCIF
		left join cif.ORGAO_PODER on ocupante.CDORGEXERCICIO = ORGAO_PODER.CODIGOORGAO

	WHERE   -- retirando incosistencias de endere??os nulos
		imovel.endereco is not null AND
		imovel.NOMEENDERECO is not null AND
		imovel.CDORGADM in ('07000') AND -- Codigo do orgao do Ministerio do Planejamento

		-- retirando endere??os a pedido da CGAPF
		imovel.ENDERECO NOT IN (select endereco from cif.v_imoveis_nao_publicados_cgu) -- solicitado pelo Vitor 06/05/14