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

DELETE FROM Solicitacao X
	USING Solicitacao Y 
	WHERE X.created_at > Y.created_at AND (X.protocolo = Y.protocolo OR X.protocolo_mobile = Y.protocolo_mobile);
	
-- A ideia aqui é criar duas tabelas extras, protocolo e protocolo mobile para garantir que existam 
-- apenas 1 dos tipos na tabela solicitação.


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


-- Agora populamos as novas tabelas de protocolos com os dados ja existentes

INSERT INTO Protocolo(protocolo)
    SELECT protocolo FROM Solicitacao;

INSERT INTO ProtocoloMobile(protocolo_mobile)
    SELECT protocolo_mobile from Solicitacao;


-- Removendo a chave primária do id serial, já que esse não se repete e não é necessário ser adicionado manualmente e adicioando 
-- o protocolo e protocolo_mobile como chave estrangeira do banco, blindando o banco para casos repetidos.

ALTER TABLE Solicitacao
DROP CONSTRAINT IF EXISTS solicitacao_pkey;

ALTER TABLE Solicitacao
ADD CONSTRAINT protocolo_fkey FOREIGN KEY (protocolo) REFERENCES Protocolo(protocolo),
ADD CONSTRAINT protocolo_mobile_fkey FOREIGN KEY(protocolo_mobile) REFERENCES ProtocoloMobile(protocolo_mobile);

-- Agora vamos permitir com que protocolo e protocolo_mobile sejam nulos, isso vai ajudar na hora de usar os triggers
-- de geração  de protocolos, permitindo que sejam atualizados depois

ALTER TABLE Solicitacao ALTER COLUMN protocolo DROP NOT NULL;

-- Criar function de correção de serial e criação de protocolo e também trigger de atualização do banco
CREATE OR REPLACE FUNCTION serial_protocolo_insert()
RETURNS trigger AS $$
DECLARE
	novo_protocolo		character varying;
	novo_sequencial		character varying;
	tam_sequencial      int;
	tam_loop			int;
	ano					numeric;
	found_protocolo     Protocolo%rowtype;
BEGIN
	
	tam_sequencial = CHAR_LENGTH(NEW.sequencial);
	novo_protocolo = NEW.sequencial;
	IF tam_sequencial < 5 THEN
		tam_loop = 5 - tam_sequencial;
		LOOP
			novo_protocolo = CONCAT('0', novo_protocolo);
			tam_loop = tam_loop - 1;
			IF tam_loop = 0 THEN
				EXIT; -- end loop
			END IF;
		END LOOP;
	END IF;
	ano = EXTRACT(YEAR FROM NOW()::timestamp);
	novo_sequencial = novo_protocolo;
	
	novo_protocolo = CONCAT(novo_protocolo, '/', ano );
	
	SELECT protocolo FROM Protocolo
	INTO found_protocolo
	WHERE protocolo = novo_protocolo;
	
	IF NOT FOUND THEN
		INSERT INTO Protocolo(protocolo) VALUES(novo_protocolo);
		UPDATE Solicitacao 
		SET 
			protocolo = novo_protocolo,
			sequencial = novo_sequencial
		WHERE NEW.sequencial = sequencial;
		
		RETURN NEW;
	ELSE
		RAISE NOTICE 'Esse protocolo já foi inserido.';
	END IF;
END;
$$ LANGUAGE plpgsql; 

-- Trigger disparado para atualizar serial e inserir protocolo

CREATE TRIGGER serial_protocolo_insert_trigger
AFTER INSERT ON Solicitacao
FOR EACH ROW
EXECUTE PROCEDURE serial_protocolo_insert();











