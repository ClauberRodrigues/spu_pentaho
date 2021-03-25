-- DROP TRIGGER tg_after_upd_imovel ON cartografia.imv_imovel;

create trigger tg_after_upd_imovel after
update
    of id_nivel_precisao on
    cartografia.imv_imovel for each row execute procedure cartografia.fn_tg_after_upd_imovel();
