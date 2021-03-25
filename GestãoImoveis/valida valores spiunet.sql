drop table saida.tb_valida_valor_spiunet;
create table saida.tb_valida_valor_spiunet as 
select m.sg_uf sg_uf, m.no_municipio no_municipio, i.imv_nu_rip nu_rip_imovel,
       i.imv_va_imovel vl_imovel, i.imv_va_somabenfeitoriautilizacao vl_soma_benf_imovel,
       (select count(uti_nu_rip) 
          from spiunet.utilizacao u 
         where u.uti_nu_rip_imovel = i.imv_nu_rip and u.uti_co_motivocancelamentoutilizacao ='101') qtd_utilizacao,
       (select sum(uti_va_utilizacao) 
          from spiunet.utilizacao u 
         where u.uti_nu_rip_imovel = i.imv_nu_rip and u.uti_co_motivocancelamentoutilizacao ='101') vl_soma_utilizacoes,
       (select sum(b.bnf_va_benfeitoria)
          from spiunet.benfeitoria b 
         where b.bnf_nu_rip_imovel = i.imv_nu_rip) vl_soma_benfeitoria
  from spiunet.imovel i
       left join spiunet.municipio m on i.imv_co_municipio = m.co_municipio 
 where i.imv_co_motivocancelamentoimovel ='101';
 

 select count(*) 
   from saida.tb_valida_valor_spiunet
   
 
 select count(*) from spiunet.imovel where imv_co_motivocancelamentoimovel ='101' --52584
 
 select u.imv_va_somabenfeitoriautilizacao from spiunet.imovel u 