/*CREATE TABLE IF NOT EXISTS Solicitacao (
	id serial NOT NULL,
	protocolo character varying(45) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    data_prazo timestamp without time zone,S
    sequencial character varying NOT NULL,
    protocolo_mobile character varying,
    CONSTRAINT solicitacao_pkey PRIMARY KEY (id)
);*/

/*INSERT INTO Solicitacao(
	protocolo, 
	created_at,
	data_prazo,
	sequencial,
	protocolo_mobile
) VALUES (
	'3', NOW()::timestamp, NOW()::timestamp, '1', '2' 
);*/


-- Remover duplicatas de protocolos e protocolo mobile, mantendo aqueles que tiverem a data de criação mais antiga.

/*DELETE FROM Solicitacao X
	USING Solicitacao Y 
	WHERE X.created_at > Y.created_at AND (X.protocolo = Y.protocolo OR X.protocolo_mobile = Y.protocolo_mobile);*/
	
-- A ideia aqui é criar duas tabelas extras, protocolo e protocolo mobile para garantir que existam 
-- apenas 1 dos tipos na tabela solicitação.

/*
CREATE TABLE IF NOT EXISTS Protocolo ( 
    id serial NOT NULL, 
    protocolo character varying(45) NOT NULL,
    CONSTRAINT protocolo_pkey PRIMARY KEY(protocolo)
);

CREATE TABLE IF NOT EXISTS ProtocoloMobile (
    id serial NOT NULL, 
    protocolo_mobile character varying NOT NULL,
    CONSTRAINT protocolo_mobile_pkey PRIMARY KEY(protocolo_mobile)
);
*/

-- Agora populamos as novas tabelas de protocolos com os dados ja existentes
/*
INSERT INTO Protocolo(protocolo)
    SELECT protocolo FROM Solicitacao;

INSERT INTO ProtocoloMobile(protocolo_mobile)
    SELECT protocolo_mobile from Solicitacao;
*/

-- Removendo a chave primária do id serial, já que esse não se repete e não é necessário ser adicionado manualmente e adicioando 
-- o protocolo e protocolo_mobile como chave estrangeira do banco, blindando o banco para casos repetidos.

/*ALTER TABLE Solicitacao
DROP CONSTRAINT IF EXISTS solicitacao_pkey;

ALTER TABLE Solicitacao
ADD CONSTRAINT protocolo_fkey FOREIGN KEY (protocolo) REFERENCES Protocolo(protocolo),
ADD CONSTRAINT protocolo_mobile_fkey FOREIGN KEY(protocolo_mobile) REFERENCES ProtocoloMobile(protocolo_mobile);*/

-- Agora vamos permitir com que protocolo e protocolo_mobile sejam nulos, isso vai ajudar na hora de usar os triggers
-- de geração  de protocolos, permitindo que sejam atualizados depois

/*ALTER TABLE Solicitacao ALTER COLUMN protocolo DROP NOT NULL;*/

-- Criar function de correção de serial e criação de protocolo e também trigger de atualização do banco
CREATE OR REPLACE FUNCTION serial_protocolo_insert()
RETURNS trigger AS $$
DECLARE
	novo_protocolo		character varying;
BEGIN
	
	novo_protocolo = 'Samuel';
	
	RETURN novo_protocolo;
END;
$$ LANGUAGE plpgsql;












