-- psql minimundo p/ conectar ao banco de dados.
CREATE TABLE solicitacao (
    id serial NOT NULL,
    protocolo character varying(45) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    data_prazo timestamp without time zone,
    sequencial character varying NOT NULL,
    protocolo_mobile character varying,
    CONSTRAINT solicitacao_pkey PRIMARY KEY (id)
);
