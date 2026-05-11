--TRIGGERI
SET SERVEROUTPUT ON
--Se creează un trigger care se declanşează înaintea fiecărei operaţii de inserare în tabela PRODUSE.
CREATE OR REPLACE TRIGGER PROD_INSERT BEFORE INSERT ON PRODUSE BEGIN
DBMS_OUTPUT.PUT_LINE('TRIGGERUL S -A EXECUTAT');
END;
/

INSERT INTO PRODUSE VALUES(292, 'APA', 'AAA', 'BAUTURI', 10, 5);

--Triggerul se declanşează la operaţiile de INSERT, DELETE sau UPDATE pe tabela Produse. In tabela TEMP_LOG se introduce tipul operaţiei, utilizatorul care a executat-o, data curentă.
CREATE TABLE TEMP_LOG (OPERATIE VARCHAR2(30), UTILIZATOR VARCHAR2(40), DATA DATE DEFAULT SYSDATE);

CREATE OR REPLACE TRIGGER PRODUSE_TRIG BEFORE INSERT OR UPDATE OR DELETE ON PRODUSE
DECLARE 
V_TIP TEMP_LOG.OPERATIE%TYPE;
BEGIN
CASE
WHEN INSERTING THEN V_TIP := 'I';
WHEN UPDATING THEN V_TIP := 'U';
ELSE V_TIP := 'D';
END CASE;
INSERT INTO TEMP_LOG VALUES ( V_TIP, USER, SYSDATE);
END;
/

SELECT * FROM TEMP_LOG;

DELETE FROM PRODUSE WHERE ID_PRODUS = 200;

--Se creează un trigger pentru a nu se permite depăşirea unei limite maxime a salariului unui angajat
CREATE OR REPLACE TRIGGER SAL_MAX BEFORE INSERT OR UPDATE ON ANGAJATI FOR EACH ROW
DECLARE 
V_SAL_MAX NUMBER;
BEGIN
SELECT SALARIU_MAX INTO V_SAL_MAX FROM FUNCTII WHERE ID_FUNCTIE = :NEW.ID_FUNCTIE;
IF :NEW.SALARIUL > V_SAL_MAX THEN 
RAISE_APPLICATION_ERROR(-20201, 'NU SE POATE DEPASI SALARIUL MAXIM');
END IF;
END;
/

SELECT * FROM FUNCTII;

INSERT INTO ANGAJATI(ID_ANGAJAT,NUME,  SALARIUL, EMAIL,DATA_ANGAJARE, ID_FUNCTIE) VALUES (1000,'MARIA', 7000,'SDFGHJK',SYSDATE, 'AD_ASST');

--INSTED OF
CREATE OR REPLACE VIEW CLIENTI_V AS SELECT cl.id_client, cl.prenume_client, cl.nume_client, cl.limita_credit,co.ID_comanda, co.data FROM CLIENTI CL , COMENZI CO WHERE CL.ID_CLIENT = CO.ID_CLIENT;

CREATE OR REPLACE TRIGGER EX_TRG INSTEAD OF INSERT OR UPDATE OR DELETE ON CLIENTI_V FOR EACH ROW
BEGIN

IF INSERTING THEN insert into clienti (id_client, prenume_client, nume_client, limita_credit) values (:new.id_client, :new.prenume_client, :new.nume_client, :new.limita_credit);
insert into comenzi (ID_comanda, data, id_client) values (:new.ID_comanda, :new.data, :new.id_client);

ELSIF DELETING THEN 
delete from comenzi where ID_comanda=:old.ID_comanda;

ELSIF UPDATING('NUME_CLIENT') THEN UPDATE CLIENTI SET NUME_CLIENT = :NEW.NUME_CLIENT WHERE ID_CLIENT = :OLD.ID_CLIENT;
elsif updating ('data') then
update comenzi
set data=:new.data
where ID_comanda=:old.ID_comanda;
end if;
END;
/

SHOW ERRORS;

insert into clienti_v values (10,'Ioan','Bucur',200,100,sysdate);
insert into clienti_v values (20,'Dana','Popa',250,110,sysdate);
select * from clienti where id_client in (10, 20);
select * from comenzi where id_client in (10, 20);

delete from clienti_v where nume_client='Bucur';
select * from clienti where id_client in (10, 20);
select * from comenzi where id_client in (10, 20);

update clienti_v
set nume_client='Popescu'
where id_client=20;
select * from clienti where id_client in (10, 20);


SELECT TRIGGER_TYPE, TRIGGER_NAME, TRIGGERING_EVENT FROM USER_TRIGGERS WHERE TABLE_NAME ='PRODUSE';
ALTER TRIGGER PROD_INSERT DISABLE ;
ALTER TABLE ANGAJATI DISABLE ALL TRIGGERS;


 -- Creare procedura care calculeaza salariul mediu (parametru de iesire) pentru un id de departament primit ca si parametru de intrare
 create or replace procedure sal_mediu(p_mediu out angajati.salariul%type, p_id departamente.id_departament%type) 
 is
 v_mediu number;
 begin
 select avg(salariul) into v_mediu from angajati where id_departament = p_id;
 p_mediu := v_mediu;
 DBMS_OUTPUT.PUT_LINE(v_mediu);
 end;
 /
variable g_mediu number;
execute sal_mediu(:g_mediu, 90);

select * from angajati;

declare 
cursor dep_c is select * from departamente ;
v_mediu number;
begin
for r in dep_c loop
sal_mediu(v_mediu, r.id_departament);
end loop;
end;
/

-- Trigger care se declanseaza doar cand se modifica coloana id_functie din tabela angajati (update of id_functie)
-- Salveaza functia veche a angajatului in tabela istoric_functii

create or replace trigger functie_trg after update of id_functie on angajati for each row
begin
insert into istoric_functii values (:old.id_functie);
end;
/

-- Trigger care se va desclansa inainte de actualizarea fiecarui rand din tabela angajati
-- Daca cresterea salariala depaseste 1000, o limitam la max +1000.

create or replace trigger crestere_sal before update on angajati for each row
begin
if :new.salariul > :old.salariul+1000 then :new.salariul := :old.salariul +1000;
end if;
end;










