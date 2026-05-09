set serveroutput on
--Se șterg produsele din categoria hardware3 care nu au fost comandate. Se afișează numărul de rânduri şterse.

begin
delete from produse p where p.categorie = 'hardware3' and not exists (select 1 from rand_comenzi r where r.id_produs = p.id_produs);
DBMS_OUTPUT.PUT_LINE (SQL%ROWCOUNT || ' randuri sterse');
ROLLBACK;
DBMS_OUTPUT.PUT_LINE (SQL%ROWCOUNT || ' randuri afectate');
END;
/
select * from produse where categorie = 'hardware3';

--Se încearcă adăugarea unei regiuni și apoi modificarea denumirii produsului având codul 3. În cazul în care acest produs nu există (comanda update nu realizează nici o modificare) va fi afişat un mesaj corespunzător.
begin
insert into regiuni values(5,'regiune');
update produse set denumire_produs = 'produs nou' where id_produs = 3;
if sql%notfound then DBMS_OUTPUT.PUT_LINE('nu exista');
end if;
end;
/
set serveroutput on
select * from regiuni;

--Se șterge din tabela REGIUNI, regiunea a cărei ID este introdus de utilizator prin intermediul variabilei de substituție g_rid. Mesajul este afișat folosind variabila de mediu nr_sters
accept g_nr prompt 'introduceti id';
variable nr_sters varchar2(10);
declare 
begin
delete from regiuni where id_regiune = &g_nr;
:nr_sters := sql%rowcount ;
dbms_output.put_line('s au sters ' || :nr_sters);
end;
/

rollback;


--CURSOR IMPLICIT 
SET SERVEROUTPUT ON
DECLARE 
BEGIN
UPDATE ANGAJATI SET SALARIUL = SALARIUL *1.1 WHERE ID_ANGAJAT = 1111111;
DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);
IF SQL%FOUND THEN DBMS_OUTPUT.PUT_LINE('s A GASIT ');
ELSE
DBMS_OUTPUT.PUT_LINE('NU S A GASIT');
END IF;
 END;
 /
 
 DECLARE 
 V_SALARIU NUMBER;
 BEGIN
 SELECT SALARIUL INTO V_SALARIU FROM ANGAJATI WHERE ID_ANGAJAT = 111111;
 EXCEPTION WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('ANGAJATUL NU EXISTA');
 END;
 /
 
 begin
 -- Inaintea primei instructiuni LMD din bloc, toate atributele cursorului au valoarea NULL
    dbms_output.put_line(sql%rowcount);
    
    update angajati set salariul = salariul * 1.1 where id_angajat = 101;
    dbms_output.put_line(sql%rowcount);
    
    delete from angajati where id_angajat = 105;

    dbms_output.put_line(sql%rowcount);
end;
/

begin
    update angajati set salariul = salariul * 1.1 where id_angajat = 101;
    dbms_output.put_line(sql%rowcount);
    rollback;
    
    -- Dupa o instructiune COMMIT sau ROLLBACK, SQL%ROWCOUNT are valoarea 0
    dbms_output.put_line(sql%rowcount);
end;
/






