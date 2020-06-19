-- public.numeracon definition

-- Drop table Francisco Filho - kokkok

-- DROP TABLE public.numeracon; create tables

CREATE TABLE public.numeracon (  
	sg_loja varchar(3) NULL,
	tp_contrato numeric(2) NULL,
	tp_fin numeric(2) NULL,
	nr_contrato numeric(8) NULL,
	cd_chave varchar(7) NOT NULL,
	CONSTRAINT numeracon_pkey PRIMARY KEY (cd_chave)
);