create table siapa.siapa_t_consolida_darf_debito_credito as    
select 'DEB' as "Origem",
       d.nu_debito as id_origem,
       d.nu_rip,
       d.nu_utiliz,
       d.nu_resp_contraiu_debito id_responsavel,
       e.nu_darf_senda,
       e.nu_referencia,
       c.nu_credito
  from siapa.siapa_a_darf_emissao e 
       inner join siapa.siapa_a_debito d  on substring(e.nu_identificador_origem,10,8) = d.nu_debito
       left  join siapa.siapa_a_credito c on c.nu_darf_senda = e.nu_darf_senda and c.nu_darf_senda <> '00000000000000000'
 where rtrim(sg_identificador_origem) = 'DEB'         
union
select 'FCL' as "Origem",
       fcl.nu_fcl as id_origem,
       fcl.nu_rip nu_rip,
       fcl.nu_utiliz nu_utiliz,
       fcl.nu_resp id_responsavel,
       e.nu_darf_senda,
       e.nu_referencia,
       c.nu_credito
  from siapa.siapa_a_darf_emissao e 
       inner join siapa.siapa_a_fcl_nova fcl on fcl.nu_fcl = substring(e.nu_identificador_origem,8,8)
       left  join siapa.siapa_a_credito c on c.nu_darf_senda = e.nu_darf_senda and c.nu_darf_senda <> '00000000000000000'
 where rtrim(sg_identificador_origem) = 'FCL'
union
select 'COB' as "Origem",
       cob.nu_cobranca_lista as id_origem,
       cob.nu_rip_cobr nu_rip,
       cob.nu_utiliz_cobr nu_utiliz,
       null id_responsavel,
       e.nu_darf_senda,
       e.nu_referencia,
       c.nu_credito
  from siapa.siapa_a_darf_emissao e 
       left join siapa.siapa_a_cobranca cob on cob.nu_cobranca_lista = substring(e.nu_identificador_origem,10,8)
       left  join siapa.siapa_a_credito c on c.nu_darf_senda = e.nu_darf_senda and c.nu_darf_senda <> '00000000000000000'
 where rtrim(sg_identificador_origem) = 'COB'
 
 


 select * from siapa.siapa_t_consolida_darf_debito_credito
 
 grant all on siapa.siapa_t_consolida_darf_debito_credito to public 
 
