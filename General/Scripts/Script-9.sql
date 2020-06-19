--set search_path to dados01;

--select fct_pagtodiavenda()
drop table pgtovendas_tmp42;

create temp table pgtovendas_tmp42 as 
 SELECT sg_base, nr_mesref_pag, nr_anoref_pag,'A0' as "fl_registro", SUM(1) as "qt_quitados",
          SUM(CASE WHEN cd_divisao IN (1,51)  THEN 1 ELSE 0 END) as "qt_quitele",
          SUM(CASE WHEN cd_divisao IN (1,51) AND tp_contrato = 2 THEN 1 ELSE 0 END) as "qt_quiteleap",
          SUM(CASE WHEN cd_divisao IN (1,51) AND tp_fin > 70 THEN 1 ELSE 0 END) as "qt_quitelencp",
          SUM(CASE WHEN cd_divisao IN (2,52) THEN 1 ELSE 0 END) as "qt_quittec",
          SUM(CASE WHEN cd_divisao IN (2,52) AND tp_contrato = 2 THEN 1 ELSE 0 END) as "qt_quittecap",
          SUM(CASE WHEN cd_divisao IN (2,52) AND tp_fin > 70 THEN 1 ELSE 0 END) as "qt_quitecncp",
          SUM(CASE WHEN cd_divisao NOT IN (1,2,51,52) THEN 1 ELSE 0 END) as "qt_quitout",
          SUM(CASE WHEN cd_divisao NOT IN (1,2,51,52) AND tp_contrato = 2 THEN 1 ELSE 0 END) as "qt_quitoutap",
          SUM(CASE WHEN cd_divisao NOT IN (1,2,51,52) AND tp_fin > 70 THEN 1 ELSE 0 END) as "qt_quitoutncp",
          SUM(CASE WHEN cd_divisao = 4 THEN 1 ELSE 0 END) as "qt_cdv",
          SUM(CASE WHEN nr_dias_matraso > 0 THEN 1 ELSE 0 END)  as "qt_atraso", 
	      SUM(CASE WHEN tt_dias_uatraso > 0 THEN 1 ELSE 0 END)  as "qt_atrultima", 
          0 as "qt_vendas",
          0 as "qt_vendasdia",
	      0 as "pc_vendas", 
	      0 as "qt_eletro", 
	      0 as "qt_eleav", 
	      0 as "qt_eleap", 
	      0 as "qt_elencp", 
	      0 as "qt_tecon", 
	      0 as "qt_tecav", 
	      0 as "qt_tecap", 
	      0 as "qt_tecncp", 
	      0 as "qt_outros", 
	      0 as "qt_outav", 
	      0 as "qt_outap", 
	      0 as "qt_outncp" 
    FROM pg_pagtos GROUP BY sg_base, nr_mesref_pag, nr_anoref_pag
   UNION
 SELECT sg_base, to_char(dt_venda,'MM'), to_char(dt_venda,'YYYY'),'A1' as "fl_registro",
          0 as "qt_quitados",
	      0 as "qt_quitele",
	      0 as "qt_quiteleap",
	      0 as "qt_quitelencp", 
	      0 as "qt_quittec", 
	      0 as "qt_quittecap", 
	      0 as "qt_quitecncp", 
	      0 as "qt_quitout", 
	      0 as "qt_quitoutap", 
	      0 as "qt_quitoutncp", 
          0 as "qt_cdv", 
          0 as "qt_atraso", 
	      0 as "qt_atrultima", 
          SUM(CASE WHEN nr_dia = 1 AND tp_contven IN (1,2) THEN 1 ELSE 0 END) as "qt_vendas",
          SUM(CASE WHEN nr_dia0a6 = 1 AND tp_contven IN (1,2) THEN 1 ELSE 0 END) as "qt_vendasdia",
          0 as "pc_vendas",
          SUM(CASE WHEN nr_dia between 1 and 6 and cd_divvenda IN (1,51) THEN 1 ELSE 0 END) as "qt_eletro",
          SUM(CASE WHEN nr_dia between 1 and 6 and cd_divvenda IN (1,51) AND tp_contven = 1 AND tp_finven < 70  THEN 1 ELSE 0 END) as "qt_eleav",
          SUM(CASE WHEN nr_dia between 1 and 6 and cd_divvenda IN (1,51) AND tp_contven = 2 THEN 1 ELSE 0 END) as "qt_eleap",
          SUM(CASE WHEN nr_dia between 1 and 6 and cd_divvenda IN (1,51) AND tp_contven = 1 AND tp_finven > 70 THEN 1 ELSE 0 END) as "qt_elencp",
          SUM(CASE WHEN nr_dia between 1 and 6 and cd_divvenda IN (2,52) THEN 1 ELSE 0 END) as "qt_tecon",
          SUM(CASE WHEN nr_dia between 1 and 6 and cd_divvenda IN (2,52) AND tp_contven = 1 AND tp_finven < 70 THEN 1 ELSE 0 END) as "qt_tecav",
          SUM(CASE WHEN nr_dia between 1 and 6 and cd_divvenda IN (2,52) AND tp_contven = 2 THEN 1 ELSE 0 END) as "qt_tecap",
          SUM(CASE WHEN nr_dia between 1 and 6 and cd_divvenda IN (2,52) AND tp_contven = 1 AND tp_finven > 70 THEN 1 ELSE 0 END) as "qt_tecncp",
          SUM(CASE WHEN nr_dia between 1 and 6 and cd_divvenda NOT IN (1,2,51,52) THEN 1 ELSE 0 END) as "qt_outros",
          SUM(CASE WHEN nr_dia between 1 and 6 and cd_divvenda NOT IN (1,2,51,52) AND tp_contven = 1 AND tp_finven < 70 THEN 1 ELSE 0 END) as "qt_outav",
          SUM(CASE WHEN nr_dia between 1 and 6 and cd_divvenda NOT IN (1,2,51,52) AND tp_contven = 2 THEN 1 ELSE 0 END) as "qt_outap",
          SUM(CASE WHEN nr_dia between 1 and 6 and cd_divvenda NOT IN (1,2,51,52) AND tp_contven = 1 AND tp_finven > 70 THEN 1 ELSE 0 END) as "qt_outncp"
    FROM pg_pagven GROUP BY sg_base ,to_char(dt_venda,'MM'), to_char(dt_venda,'YYYY');
    
   select * from pgtovendas_tmp42 where sg_pagto ='RDB' and nr_mesref_pag='09'
  
   SELECT sg_base, nr_mesref_pag, nr_anoref_pag, 
       SUM(qt_quitados) as "qt_quitados",
	   SUM(qt_quitele) as "qt_quitele",
	   SUM(qt_quiteleap) as "qt_quiteleap",
	   SUM(qt_quitelencp) as "qt_quitelencp",
	   SUM(qt_quittec) as "qt_quittec",
	   SUM(qt_quittecap) as "qt_quittecap",
	   SUM(qt_quitecncp) as "qt_quitecncp",
	   SUM(qt_quitout) as "qt_quitout",
	   SUM(qt_quitoutap) as "qt_quitoutap",
	   SUM(qt_quitoutncp) as "qt_quitoutncp",
       SUM(qt_cdv) as "qt_cdv",
       SUM(qt_atraso) as "qt_atraso",
	   SUM(qt_atrultima) as "qt_atrultima",
	   SUM(qt_vendas) as "qt_vendas",
	   SUM(qt_vendasdia) as "qt_vendasdia",
	   --SUM(pc_vendas) as "pc_vendas", 
	   to_char(case when SUM(qt_quitados) > 0 and SUM(qt_vendas) > 0 then (SUM(qt_vendas) / SUM(qt_quitados) * 100) else 0 end,'099D99%') as "pc",
	   SUM(qt_eletro) as "qt_eletro",
	   SUM(qt_eleav) as "qt_eleav",
	   SUM(qt_eleap) as "qt_eleap",
	   SUM(qt_elencp) as "qt_elencp",
	   SUM(qt_tecon) as "qt_tecon",
	   SUM(qt_tecav) as "qt_tecav",
	   SUM(qt_tecap) as "qt_tecap",
	   SUM(qt_tecncp) as "qt_tecncp",
       SUM(qt_outros) as "qt_outros",
	   SUM(qt_outav) as "qt_outav",
	   SUM(qt_outap) as "qt_outap",
	   SUM(qt_outncp) as "qt_outncp"
      FROM pgtovendas_tmp42 GROUP BY sg_base, nr_mesref_pag, nr_anoref_pag order by pc desc;
      
     