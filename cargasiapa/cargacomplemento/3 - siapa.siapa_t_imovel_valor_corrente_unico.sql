delete from siapa.siapa_t_imovel_testada_valor_unico;
insert into siapa.siapa_t_imovel_testada_valor_unico 
select tc.* 
from siapa.siapa_t_imovel_testada_valor_corrente tc
     inner join (select nu_rip, valor_imovel, min(id_pgv) id_pgv from siapa.siapa_t_imovel_testada_valor_corrente group by nu_rip, valor_imovel) vt
     on tc.nu_rip = vt.nu_rip and tc.id_pgv = vt.id_pgv;