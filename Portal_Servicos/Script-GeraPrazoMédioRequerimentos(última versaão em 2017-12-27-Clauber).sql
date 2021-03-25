drop table temporarios.ods_prazo_medio;
create table temporarios.ods_prazo_medio as
select ds_uf, ds_titulo, ds_situacao_atual, sum(pz_dias_conclusao) prazo, sum(contador) contador,
       (sum(pz_dias_conclusao) / sum(contador) ) prazo_medio
  from (select CASE WHEN ei.ds_uf IS NOT NULL THEN ei.ds_uf::bpchar
                    WHEN er.ds_uf IS NOT NULL THEN er.ds_uf::bpchar
                    ELSE 'NI'::character(2)
                END AS ds_uf,
       ods.dt_alteracao,
       sv.ds_titulo,
       CASE 
            WHEN ods.ds_situacao_anterior = 'AGUARDANDO_ANALISE_PREVIA' THEN 'Aguardando Triagem'::text
            WHEN ods.ds_situacao_anterior = 'EM_ANALISE_PREVIA'::text THEN 'Em Análise Prévia'::text
            WHEN ods.ds_situacao_anterior = 'EM_ANALISE_TECNICA'::text THEN 'Em Análise Técnica'::text
            when ods.ds_situacao_anterior = 'AGUARDANDO_RETORNO_SEI'::text then 'Em Análise Técnica'::text
            WHEN ods.ds_situacao_anterior = 'AGUARDANDO_REQUERENTE'::text THEN 'Aguardando Requerente'::text
            WHEN ods.ds_situacao_anterior = 'DEFERIDO'::text THEN   'Deferido​'::text
            WHEN ods.ds_situacao_anterior = 'INDEFERIDO'::text THEN 'Indeferido​'::text
            WHEN ods.ds_situacao_anterior = 'CANCELADO'::text THEN  'Cancelado'::text
            WHEN ods.ds_situacao_anterior = 'EXPIRADO'::text THEN   'Cancelado'::text
            ----------------------------------------------------------------------------------------------------------------------------------
            WHEN ods.ds_situacao_anterior = 'AGUARDANDO_ANALISE'::text THEN 'Aguardando Triagem'::text
            WHEN ods.ds_situacao_anterior = 'COM_PENDENCIA'::text THEN 'Aguardando Requerente'::text
            WHEN ods.ds_situacao_anterior = 'PROCESSO_ABERTO'::text THEN 'Em Análise Técnica'::text
            when ods.ds_situacao_anterior is null and ods.ds_situacao_atual = 'AGUARDANDO_ANALISE_PREVIA'::text then 'Aguardando Análise Prévia'::text
            ELSE coalesce(ods.ds_situacao_anterior, r.id_requerimento::text)
     END AS ds_situacao_atual,
     case when ods.ds_situacao_anterior is null and ods.ds_situacao_atual = 'AGUARDANDO_ANALISE_PREVIA'::text 
          then current_date::date - ods.dt_alteracao_anterior::date
          else ods.dt_alteracao::date - ods.dt_alteracao_anterior::date end as pz_dias_conclusao,
       1 AS contador
  from servico.ods_historico_requerimento ods
       inner join servico.tb_requerimento r
             left  join servico.tb_servico sv on sv.id_servico = r.id_servico and ds_link is null
             LEFT  JOIN (servico.tb_imovel i INNER JOIN servico.tb_endereco ei ON ei.id_endereco = i.id_endereco) ON i.id_imovel = r.id_imovel
             LEFT  JOIN (servico.tb_requerente rqe 
                   LEFT JOIN (servico.tb_evento ev INNER JOIN servico.tb_endereco er ON er.id_endereco = ev.id_endereco) 
                        ON rqe.id_evento = ev.id_evento) 
                   ON rqe.id_requerimento = r.id_requerimento
       on r.id_requerimento = ods.id_requerimento           
 where dt_alteracao <= (select min(dt_alteracao) 
                          from servico.ods_historico_requerimento h 
                         where ods.id_requerimento = h.id_requerimento and ds_situacao_atual = 'EM_ANALISE_TECNICA')
   and r.dt_envio >= '2017-03-15' 
 union
 select CASE WHEN ei.ds_uf IS NOT NULL THEN ei.ds_uf::bpchar
                    WHEN er.ds_uf IS NOT NULL THEN er.ds_uf::bpchar
                    ELSE 'NI'::character(2)
                END AS ds_uf,
       ods.dt_alteracao,
       sv.ds_titulo,
       CASE 
            WHEN ods.ds_situacao_atual = 'DEFERIDO'::text THEN   'Concluído​'::text
            WHEN ods.ds_situacao_atual = 'INDEFERIDO'::text THEN 'Concluído​'::text
            WHEN ods.ds_situacao_atual = 'CANCELADO'::text THEN  'Concluído'::text
            WHEN ods.ds_situacao_atual = 'EXPIRADO'::text THEN   'Concluído'::text
     END AS ds_situacao_atual,
     case when ods.ds_situacao_atual in ('DEFERIDO','INDEFERIDO','CANCELADO','EXPIRADO') 
          then ods.dt_alteracao::date - r.dt_envio::date end as pz_dias_conclusao,
      1 AS contador    
  from servico.ods_historico_requerimento ods
       inner join servico.tb_requerimento r
             left  join servico.tb_servico sv on sv.id_servico = r.id_servico and ds_link is null
             LEFT  JOIN (servico.tb_imovel i INNER JOIN servico.tb_endereco ei ON ei.id_endereco = i.id_endereco) ON i.id_imovel = r.id_imovel
             LEFT  JOIN (servico.tb_requerente rqe 
                   LEFT JOIN (servico.tb_evento ev INNER JOIN servico.tb_endereco er ON er.id_endereco = ev.id_endereco) 
                        ON rqe.id_evento = ev.id_evento) 
                   ON rqe.id_requerimento = r.id_requerimento
       on r.id_requerimento = ods.id_requerimento           
 where dt_alteracao <= (select min(dt_alteracao) 
                          from servico.ods_historico_requerimento h 
                         where ods.id_requerimento = h.id_requerimento and ds_situacao_atual = 'EM_ANALISE_TECNICA')
   and r.dt_envio >= '2017-03-15'
 order by dt_alteracao) as tbvirtual
where pz_dias_conclusao is not null
group by ds_uf, ds_titulo, ds_situacao_atual
order by ds_uf, ds_titulo, ds_situacao_atual;


select distinct ds_situacao_atual 
  from temporarios.ods_prazo_medio
order by 1, 3


select *
  from servico.ods_historico_requerimento
  where id_requerimento = 11761
 order by 1 

 
             







