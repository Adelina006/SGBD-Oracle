/*
1.	Sa se creeze o procedura numita raport_angajati_dept care primeste:
•	parametru de intrare id-ul unui departament
•	parametru de iesire care va retine numarul total de angajati din departamentul respectiv
Procedura va parcurge cu un cursor explicit toti angajatii din departamentul primit ca parameter si va afisa pentru fiecare angajat: numele, salariul si vechimea in ani (diferenta in ani intre sysdate si data_angajare)
Sa se apeleze procedura cu id-ul de departament 60 si sa se afiseze numarul de angajati.
*/
create or replace procedure raport_angajati_dep(p_id_departament departamente.id_departament%type, p_nr_angajati out number)
is
v_vechime number;
cursor c_nr_angajat is select nume, salariul, data_angajare from angajati where id_departament = p_id_departament;
angajat_rec c_nr_angajat%rowtype;
begin
open c_nr_angajat;
loop 
fetch c_nr_angajat into angajat_rec ;
exit when c_nr_angajat%notfound;
v_vechime := trunc(months_between(sysdate, angajat_rec.data_angajare) /12) ;
dbms_output.put_line (angajat_rec.nume||'  ' || angajat_rec.salariul || '  '|| v_vechime);
end loop;

p_nr_angajati := c_nr_angajat%rowcount;
close c_nr_angajat;
end raport_angajati_dep;
/

declare
v_nr number;
begin
raport_angajati_dep(60, v_nr);
end;
/

set serveroutput on

/*
2.	Sa se creeze o functie numita calcul_bonus care primeste ca parametru id-ul unui angajat si returneaza valoarea bonusului calculat dupa urmatoarele reguli:
•	Daca angajatul nu exista, se sa trateze exceptia
•	Daca angajatul are vechimea (diferenta in ani intre sysdate si data_angajare) mai mare de 15 ani, bonusul este 25% din salariu.
•	Daca vechimea este intre 5 si 15 ani, bonusul este 15% din salariu.
•	Altfel, bonusul este 5% din salariu.
Functia va afisa numele angajatului si vechimea.
Sa se apeleze functia pentru angajatul cu id 100 si sa se afiseze bonusul retunat.
*/

CREATE OR REPLACE FUNCTION CALCUL_BONUS( P_ID_ANGAJAT IN NUMBER) RETURN NUMBER 
IS
V_BONUS NUMBER;
V_SALARIUL NUMBER;
V_VECHIME NUMBER;
V_NUME ANGAJATI.NUME%TYPE;
BEGIN
SELECT SALARIUL, NUME, TRUNC(MONTHS_BETWEEN(SYSDATE, DATA_ANGAJARE)/12) INTO V_SALARIUL, V_NUME, V_VECHIME FROM ANGAJATI WHERE ID_ANGAJAT = P_ID_ANGAJAT;
CASE
WHEN V_VECHIME > 15 THEN V_BONUS :=  V_SALARIUL *0.25;
WHEN V_VECHIME BETWEEN 5 AND 15 THEN V_BONUS := V_SALARIUL * 0.15;
ELSE
V_BONUS := V_SALARIUL * 0.05;
END CASE;
dbms_output.put_line(V_NUME|| '  '|| V_VECHIME);
RETURN V_BONUS;
EXCEPTION 
WHEN NO_DATA_FOUND THEN dbms_output.put_line('ANGAJATUL NU EXISTA ');
END CALCUL_BONUS;
/

DECLARE
V_BONUS NUMBER;
BEGIN
V_BONUS := CALCUL_BONUS(100);
dbms_output.put_line(V_BONUS);
END;
/

/*
3.	Sa se creeze un trigger la nivel de rand care se declanseaza inainte de update pe tabela angajati si implementeaza urmatoarele reguli:
•	Salariul nu poate fi micsorat (noul salariu trebuie sa fie >= vechiul salariu), altfel se ridica o exceptie
•	Daca se schimba departamentul angajatului, se afiseaza un mesaj cu: departamentul vechi -> departamentul nou
•	Daca cresterea salariala depaseste 20% din salariul actual, se limiteaza automat la 20%
Sa se testeze fiecare caz.
*/

CREATE OR REPLACE TRIGGER TRIGGER_ANGAJATI
BEFORE UPDATE
ON ANGAJATI
FOR EACH ROW

BEGIN
IF :NEW.SALARIUL  < :OLD.SALARIUL THEN RAISE_APPLICATION_ERROR(-20001, 'SALARIUL ESTE MAIMIC DECAT CEL PREZENT');
END IF;
IF  :NEW.ID_DEPARTAMENT != :OLD.ID_DEPARTAMENT THEN
dbms_output.put_line(:NEW.ID_DEPARTAMENT||'->'||OLD.ID_DEPARTAMENT);
END IF;
IF :NEW.SALARIUL > :OLD.SALARIUL * 1.2 THEN
:NEW.SALARIUL := :OLD.SALARIUL *1.2;
END IF;
END;
/



UPDATE ANGAJATI SET SALARIUL = 9000 WHERE ID_ANGAJAT = 204;


SELECT * FROM ANGAJATI;

/*
4.	Sa se creeze o functie numita total_comenzi_angajat care primeste ca parametru de intrare id-ul unui angajat. Functia va folosi un cursor explicit cu parametru pentru a parcurge toate comenzile gestionate de angajatul respectiv.
Pentru fiecare comanda se va afisa id-ul comenzii si data. Functia va returna numarul total de comenzi gestionate de angajat. 
Sa se apeleze functia pentru angajatul cu id 153 si sa se afiseze numarul de comenzi returnat.
*/

CREATE OR REPLACE FUNCTION TOTAL_COMENZI_ANGAJAT(P_ID NUMBER) RETURN NUMBER
IS
V_TOTAL NUMBER;
CURSOR C_COMENZI(C_ID_ANGAJAT NUMBER) IS SELECT ID_COMANDA, DATA FROM COMENZI WHERE ID_ANGAJAT = C_ID_ANGAJAT;
COMENZI_REC C_COMENZI%ROWTYPE;
BEGIN 
OPEN C_COMENZI(P_ID);
LOOP
FETCH C_COMENZI INTO COMENZI_REC;
dbms_output.put_line(COMENZI_REC.ID_COMANDA||'  ' ||TO_CHAR( COMENZI_REC.DATA, 'DD-MM-YYYY'));
EXIT WHEN C_COMENZI%NOTFOUND;
END LOOP;
dbms_output.put_line(C_COMENZI%ROWCOUNT);
V_TOTAL := C_COMENZI%ROWCOUNT;
CLOSE C_COMENZI;
RETURN V_TOTAL;

END;
/

DECLARE 
NR NUMBER;
BEGIN
NR := TOTAL_COMENZI_ANGAJAT(153);
dbms_output.put_line(NR);
END;
/

--PTR TOTI ANG DIN ACEL DEP SA AFISAM COMENZILE INTERMEDIATE DE ANGAJAT
CREATE OR REPLACE FUNCTION TOTAL_COMENZI_ANGAJAT_1(P_ID_DEP NUMBER) RETURN NUMBER
IS
V_TOTAL NUMBER;
CURSOR C_COMENZI(C_ID_ANGAJAT NUMBER) IS SELECT ID_COMANDA, DATA FROM COMENZI WHERE ID_ANGAJAT = C_ID_ANGAJAT;
COMENZI_REC C_COMENZI%ROWTYPE;
BEGIN 
FOR R IN (SELECT ID_ANGAJAT FROM ANGAJATI WHERE ID_DEPARTAMENT = P_ID_DEP) LOOP
OPEN C_COMENZI(R.ID_ANGAJAT);
LOOP
FETCH C_COMENZI INTO COMENZI_REC;
dbms_output.put_line(COMENZI_REC.ID_COMANDA||'  ' ||TO_CHAR( COMENZI_REC.DATA, 'DD-MM-YYYY'));
EXIT WHEN C_COMENZI%NOTFOUND;
CLOSE C_COMENZI;
END LOOP;
RETURN NULL;

END LOOP;
END;
/

DECLARE 
NR NUMBER;
BEGIN 
NR := TOTAL_COMENZI_ANGAJAT_1(80);
END;
/

SET SERVEROUTPUT ON;

/*
5.	Sa se creeze o procedura numita mareste_salariu care primeste ca parametri id-ul unui angajat si un coeficient de marire. Procedura va verifica:
•	Daca angajatul nu exista, se ridica o exceptie definita de utilizator exc_ang_inexistent
•	Daca coeficientul nu este intre 1.05 si 1.5, se ridica o exceptie definita de utilizator exc_coef_invalid
•	Daca totul este valid, se actualizeaza salariul si se afiseaza un mesaj de confirmare
Toate exceptiile trebuie tratate cu mesaje corespunzatoare. 
Sa se apeleze procedura pentru angajatul cu id 200, prima data cu un coeficient de 0.5, iar apoi cu un coeficient de 1.1. 
Sa se faca select din tabela angajati pentru angajatul cu id 200 inainte si dupa apel cu success.
*/

CREATE OR REPLACE PROCEDURE P_MARESTE_SAL (P_ID_ANGAJAT ANGAJATI.ID_ANGAJAT%TYPE, P_COEF_MARIRE IN NUMBER)
IS
EXC_ANG_INEXISTENT EXCEPTION;
EXC_ANG_INVALID EXCEPTION;
V_ANG ANGAJATI%ROWTYPE;
BEGIN
    BEGIN
    SELECT * INTO V_ANG FROM ANGAJATI WHERE ID_ANGAJAT = P_ID_ANGAJAT;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN RAISE EXC_ANG_INEXISTENT;
    END;
IF P_COEF_MARIRE NOT BETWEEN 1.05 AND 1.5 THEN RAISE EXC_ANG_INVALID;
END IF;
UPDATE ANGAJATI SET SALARIUL = SALARIUL * P_COEF_MARIRE WHERE ID_ANGAJAT = P_ID_ANGAJAT;
dbms_output.put_line(V_ANG.NUME || '  ' || V_ANG.SALARIUL|| ' A FOST MARIT');
EXCEPTION 
WHEN EXC_ANG_INEXISTENT THEN dbms_output.put_line('NU EXISTA ANGAJATUL');
WHEN EXC_ANG_INVALID THEN dbms_output.put_line('COEFICIENT INVALID');
END;
/

EXECUTE P_MARESTE_SAL (200, 1.25);

/* 1.	Sa se creeze o procedura numita raport_angajati_dept care primeste:
•	parametru de intrare id-ul unui departament
•	parametru de iesire care va retine numarul total de angajati din departamentul respectiv
Procedura va parcurge cu un cursor explicit toti angajatii din departamentul primit ca parameter si va afisa pentru fiecare angajat: numele, salariul si vechimea in ani (diferenta in ani intre sysdate si data_angajare)
Sa se apeleze procedura cu id-ul de departament 60 si sa se afiseze numarul de angajati.
 */
 
 create or replace procedure raport_angajati_dept(p_id in departamente.id_departament%type, p_nr out number) is
 cursor ang_curs is select nume, salariul, trunc(months_between(sysdate, data_angajare) / 12) as vechime from angajati where id_departament = p_id;
 ang_rec ang_curs%rowtype;
 begin
 open ang_curs;
 loop
 fetch ang_curs into ang_rec ;
 exit when ang_curs%notfound;
 dbms_output.put_line('Nume :' || ang_rec.nume ||' salariul: '||ang_rec.salariul || ' vechime: ' ||ang_rec.vechime|| ' ani');
 end loop;
 p_nr := ang_curs%rowcount;
 close ang_curs;
 end;
 /

declare 
v_nr number;
begin 
raport_angajati_dep(60, v_nr);
dbms_output.put_line(v_nr);
end;
/


/*  2.	Sa se creeze o functie numita calcul_bonus care primeste ca parametru id-ul unui angajat si returneaza valoarea bonusului calculat dupa urmatoarele reguli:
•	Daca angajatul nu exista, se sa trateze exceptia
•	Daca angajatul are vechimea (diferenta in ani intre sysdate si data_angajare) mai mare de 15 ani, bonusul este 25% din salariu.
•	Daca vechimea este intre 5 si 15 ani, bonusul este 15% din salariu.
•	Altfel, bonusul este 5% din salariu.
Functia va afisa numele angajatului si vechimea.
Sa se apeleze functia pentru angajatul cu id 100 si sa se afiseze bonusul retunat.
 */
 
 create or replace function calcul_bonus(p_id angajati.id_angajat%type) return number 
 is
 v_nume angajati.nume%type;
 v_vechime number;
 v_bonus number default 0;
 v_salariul number;
 begin
 select nume, trunc(months_between(sysdate, data_angajare) /12), salariul into v_nume, v_vechime, v_salariul from angajati where id_angajat = p_id;
 if v_vechime> 15 then v_bonus := v_salariul * 0.25;
 elsif v_vechime between 1 and 15 then v_bonus := v_salariul * 0.15;
 else v_bonus := v_salariul * 0.05;
 end if;
 dbms_output.put_line(v_nume || '  ' || v_vechime || '  '|| v_salariul);
  return v_bonus;
 exception
 when no_data_found then dbms_output.put_line('nu exista acest angajat');

 end;
 /
 
 declare
 v_bonus number;
 begin
 v_bonus := calcul_bonus(100);
 dbms_output.put_line(v_bonus);
 end;
 /
 
 /*  3.	Sa se creeze un trigger la nivel de rand care se declanseaza inainte de update pe tabela angajati si implementeaza urmatoarele reguli:
•	Salariul nu poate fi micsorat (noul salariu trebuie sa fie >= vechiul salariu), altfel se ridica o exceptie
•	Daca se schimba departamentul angajatului, se afiseaza un mesaj cu: departamentul vechi -> departamentul nou
•	Daca cresterea salariala depaseste 20% din salariul actual, se limiteaza automat la 20%
Sa se testeze fiecare caz.
 */
 
 create or replace trigger ang_rand before update on angajati for each row
 declare 
 begin
 if :new.salariul < :old.salariul then raise_application_error(-20202, 'Nu se poate introduce un salariu mai mic');
 end if;
 if :new.id_departament <> :old.id_departament then dbms_output.put_line(:old.id_departament || ' ->' || :new.id_departament);
 end if;
 if :new.salariul > :old.salariul * 1.2 then :new.salariul := :old.salariul * 1.2;
 end if;
 end;
 /
 UPDATE ANGAJATI SET id_departament = 90 WHERE ID_ANGAJAT = 204;


SELECT * FROM ANGAJATI;

/* 
4.	Sa se creeze o functie numita total_comenzi_angajat care primeste ca parametru de intrare id-ul unui angajat. 
Functia va folosi un cursor explicit cu parametru pentru a parcurge toate comenzile gestionate de angajatul respectiv. Pentru fiecare comanda se va afisa id-ul comenzii si data. 
Functia va returna numarul total de comenzi gestionate de angajat. 
Sa se apeleze functia pentru angajatul cu id 153 si sa se afiseze numarul de comenzi returnat.
 */
 
 create or replace function total_comenzi_angajat(p_id angajati.id_angajat%type) return number 
 is
 v_nr number default 0;
 cursor com_ang(p_id_ang number) is select id_comanda, data from comenzi where id_angajat = p_id_ang;
 begin
for r in com_ang(p_id) loop
dbms_output.put_line(r.id_comanda || '  '|| to_char(r.data, 'dd-mm-yyyy'));
v_nr := v_nr +1;
end loop;
return v_nr;
 end;
 /
 
 declare v_nr number;
 begin 
 v_nr := total_comenzi_angajat(153);
 dbms_output.put_line(v_nr);
 end;
 /


/* 7.	Sa se creeze un trigger la nivel de instructiune care se va declansa inainte de fiecare operatiune de inserare, actualizare, stergere pe tabela produse care:
•	La inserare: afiseaza mesajul 'Adaugare produs la data: ' urmat de data curenta
•	La actualizare: afiseaza mesajul 'Modificare efectuata de utilizatorul: ' urmat de USER
•	La stergere: blocheaza operatia ridicand o eroare cu RAISE_APPLICATION_ERROR
Sa se testeze trigger-ul prin efectuarea unui update pentru produsul 2278 si a unui delete (produs 2278) pe tabela produse.
Sa se stearga trigger-ul dupa testare.
 */
 
 create or replace trigger produse_trg before insert or update or delete on produse 
 begin
 case 
 when inserting then  dbms_output.put_line('adaugare produs la data : '|| sysdate);
 when updating then  dbms_output.put_line('Modificare efectuata de utilizatorul ' || user);
 when deleting then raise_application_error(-20206, 'Eroare');
 else NULL;
 end case;
 end;
 /
 
 update produse set pret_lista = 60 where id_produs = 2278;
delete from produse where id_produs = 2278

/* */
 


























