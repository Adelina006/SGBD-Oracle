--EXCEPTII

SET SERVEROUTPUT ON

--Să se insereze în tabela departamente un nou departament cu ID-ul 200, fără a preciza denumirea acestuia. În acest caz va apare o eroarea cu codul  ORA-02290 prin care programatorul este avertizat de încălcarea unei restricţii de integritate. Această excepţie poate fi tratată astfel:

UPDATE DEPARTAMENTE 
    SET DENUMIRE_DEPARTAMENT = 'Departament Nou' 
    WHERE DENUMIRE_DEPARTAMENT IS NULL;

ALTER TABLE DEPARTAMENTE ADD CONSTRAINT CHECK_NUME CHECK (DENUMIRE_DEPARTAMENT IS NOT  NULL);

DECLARE 
INSERT_EXCEPTION EXCEPTION ;
PRAGMA EXCEPTION_INIT(INSERT_EXCEPTION, -02290);
BEGIN
INSERT INTO DEPARTAMENTE(ID_DEPARTAMENT, DENUMIRE_DEPARTAMENT) VALUES (200, NULL);
EXCEPTION 
WHEN INSERT_EXCEPTION THEN DBMS_OUTPUT.PUT_LINE('NU ATI INTRODUS SUFICIENTE DATE');
DBMS_OUTPUT.PUT_LINE(SQLERRM);
DBMS_OUTPUT.PUT_LINE(SQLCODE);
END;
/

SELECT * FROM DEPARTAMENTE;

--Să se şteargă toate înregistrările din tabela PRODUSE. Acest lucru va duce la apariţia erorii cu codul –2292, reprezentând încălcarea restricţiei referenţiale. Valorile SQLCODE şi SQLERRM vor fi inserate în tabela ERORI. ATENTIE! Aceste variabile nu se pot utiliza direct într-o comandă SQL, drept pentru care vor fi încărcate mai întâi in variabile PL/SQL şi apoi utilizate în instrucţiuni SQL
CREATE TABLE ERORI (UTILIZATOR VARCHAR2(50), DATA DATE, MESAJ VARCHAR2(255), COD NUMBER(10));
DECLARE 
MESAJ VARCHAR(255);
COD NUMBER(10);
REF_EXCEPTION EXCEPTION;
PRAGMA EXCEPTION_INIT(REF_EXCEPTION, -2292);
BEGIN
DELETE FROM PRODUSE;
EXCEPTION
WHEN REF_EXCEPTION THEN
DBMS_OUTPUT.PUT_LINE('EROARE');
COD:= SQLCODE;
MESAJ := SQLERRM;
INSERT INTO ERORI VALUES ( USER, SYSDATE, MESAJ, COD);
END;
/
ROLLBACK;
SELECT * FROM PRODUSE;
SELECT * FROM ERORI;

--Să se invoce o eroare în cazul în care utilizatorul încearcă să execute blocul PL/SQL după ora 17. 

DECLARE 
ORA_EXCEPTION EXCEPTION ;
BEGIN 
IF TO_NUMBER(TO_CHAR(SYSDATE, 'HH24')) > 17 THEN 
RAISE ORA_EXCEPTION;
END IF;
EXCEPTION 
WHEN ORA_EXCEPTION THEN DBMS_OUTPUT.PUT_LINE('E TRECUT DE ORA 17');
END;
/

--Să se modifice denumirea produsului cu id-ul 3. Dacă nu se produce nici o actualizare (valoarea atributului SQL%ROWCOUNT este 0) sau dacă apare o altă eroare (OTHERS) atunci să se declanşeze o excepţie prin care să fie avertizat utilizatorul:
DECLARE
ID_EXCEPTION EXCEPTION;
BEGIN
UPDATE PRODUSE SET ID_PRODUS = 'ABC' WHERE ID_PRODUS= 3;
IF SQL%ROWCOUNT = 0 THEN RAISE ID_EXCEPTION;
END IF;
EXCEPTION 
WHEN ID_EXCEPTION THEN DBMS_OUTPUT.PUT_LINE('ID UL NU ESTE VALID');
WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('A APARUT O EROARE');
END;
/

--Să se atribuie excepţiei din exemplul anterior un cod şi un mesaj de eroare şi să se insereze aceste valori în tabela ERORI.
DECLARE
cod NUMBER;
mesaj VARCHAR2(255);
invalid_prod EXCEPTION;
PRAGMA EXCEPTION_INIT(invalid_prod,-20999);

BEGIN
UPDATE produse 
SET denumire_produs='Laptop ABC'
WHERE id_produs=3;

IF SQL%NOTFOUND THEN
RAISE_APPLICATION_ERROR (-20999,'Cod produs invalid!');
END IF;

EXCEPTION
WHEN invalid_prod THEN
DBMS_OUTPUT.PUT_LINE('Nu exista produsul cu acest ID');
cod:=SQLCODE;
mesaj:=SQLERRM;
INSERT INTO ERORI VALUES(USER, SYSDATE, cod, mesaj);
END;
/
SELECT * FROM ERORI;

/*
1. Creaţi o tabela numita Mesaje, având un câmp unic, de tip Varchar2.
create table mesaje1 (camp varchar2(50));
2. Scrieţi un bloc PL/SQL pentru a selecta codul comenzilor încheiate în anul 2000.
a. Dacă interogarea returnează mai mult de o valoare pentru numărul comenzii, trataţi excepţia cu o rutină de tratare corespunzătoare şi inseraţi în tabela MESAJE mesajul “Interogarea returneaza mai multe inregistrari”.
b. Dacă interogarea nu returnează nici o valoare pentru numărul comenzii, trataţi excepţia cu o rutină de tratare corespunzătoare şi inseraţi în tabela Mesaje mesajul “Interogarea nu returneaza inregistrari”.
c. Dacă se returnează o singura linie, introduceţi în tabela Mesaje numărul comenzii.
d. Trataţi orice altă excepţie cu o rutină de tratare corespunzătoare şi inseraţi în tabela MESAJE mesajul “A apărut o eroare!”.
*/

CREATE TABLE MESAJE2 (CAMP VARCHAR2(50));
SELECT * FROM COMENZI;
DECLARE 
COD VARCHAR2(10);
BEGIN
SELECT ID_COMANDA INTO COD FROM COMENZI WHERE EXTRACT(YEAR FROM DATA)  = 2000;
INSERT INTO MESAJE2 VALUES(COD);
EXCEPTION 
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('NU EXISTA COMENZI IN 2000');
INSERT INTO MESAJE2 VALUES ('INTEROGAREA NU RETURNEAZA INREGISTRARI');
WHEN TOO_MANY_ROWS THEN 
DBMS_OUTPUT.PUT_LINE('EXISTA PREA MULTE COMENZI');
INSERT INTO MESAJE2 VALUES('INTEROGAREA RETURNEAZA PREA MULTE INREGISTRARI');
WHEN OTHERS THEN 
DBMS_OUTPUT.PUT_LINE('A APARUT O EROARE');
INSERT INTO MESAJE2 VALUES('A APARUT O EROARE');
END;
/

SELECT * FROM MESAJE2;


-- Verificam daca un departament are angajati. Daca nu, ridicam o exceptie definita de noi pentru a semnala ca departamentul ar trebui desfiintat
declare
    v_denumire_dep departamente.denumire_departament%type;
    v_nr_angajati number;
    exc_ang exception;
begin
    select d.denumire_departament, count(a.id_angajat)  into v_denumire_dep, v_nr_angajati
    from angajati a right join departamente d on a.id_departament = d.id_departament
    where d.id_departament = 210
    group by d.id_departament, d.denumire_departament;
    
    if v_nr_angajati > 0 then
        dbms_output.put_line(v_denumire_dep || ' ' || v_nr_angajati);
    else
        raise exc_ang;
    end if;
exception
    when exc_ang then
        dbms_output.put_line('Departamentul trebuie desfiintat pentru ca nu are angajati');
end;
/

declare
    exc_ang exception;
    v_cod number;
    v_msg jurnal_erori.mesaj_eroare%type;
    v_msg_afisat varchar2(500);
    pragma exception_init(exc_ang,-20000);
begin
    UPDATE ANGAJATI SET SALARIUL = SALARIUL + 0.1* SALARIUL WHERE ID_ANGAJAT = 10000;

    if sql%rowcount = 0 then
        raise_application_error(-20000,'id not found');
    else
        dbms_output.put_line(sql%rowcount);
    end if;
exception
    when exc_ang then
        dbms_output.put_line('Angajatul nu exista');
        v_cod:= sqlcode;    
        v_msg:= sqlerrm;
        v_msg_afisat:= 'Angajatul nu exista';
        insert into jurnal_erori values(s_jurnal_erori.nextval,user,v_cod, v_msg, v_msg_afisat, systimestamp);
end;
/
