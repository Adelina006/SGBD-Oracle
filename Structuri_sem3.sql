SET SERVEROUTPUT ON

DECLARE
  N NUMBER(2) DEFAULT 10;
BEGIN
  N:=N+100;
  N:=N/0;
  DBMS_OUTPUT.PUT_LINE('N='||N);
  EXCEPTION
       WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('IMPARTIREA LA ZERO NU ESTE PERMISA');
       WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('A APARUT O EXCEPTIE');
       DBMS_OUTPUT.PUT_LINE('SIGUR A APARUT O EXCEPTIE');

END;
/


create table mychar(nume varchar2(4000));
create table mychar2(IS_ACTIVE BOOLEAN);

DECLARE
  nume varchar2(20000);
  IS_ACTIVE BOOLEAN;
BEGIN
    NULL;
END;
/


SET SERVEROUTPUT ON
DECLARE
  V_ID_ANGAJAT angajati.ID_ANGAJAT%TYPE;
  V_PRENUME angajati.PRENUME%TYPE;
  V_NUME angajati.NUME%TYPE;
  V_EMAIL angajati.EMAIL%TYPE;
  V_IMPOZIT CONSTANT NUMBER(3) DEFAULT 16;
  V_NOTA NUMBER(2) NOT NULL:=10;
BEGIN
 --V_IMPOZIT:=20;
 V_NOTA:=9;
 select ID_ANGAJAT,PRENUME,NUME,EMAIL
   into V_ID_ANGAJAT,V_PRENUME,V_NUME,V_EMAIL
    from angajati where id_angajat=100;
 dbms_output.put_line(V_id_angajat);
 dbms_output.put_line(V_prenume);
 dbms_output.put_line(V_nume);
 dbms_output.put_line(V_email); 
END;
/

SET SERVEROUTPUT ON
DECLARE
  x angajati%rowtype;
BEGIN
 select * into x from angajati where id_angajat=100;
 dbms_output.put_line(x.id_angajat);
 dbms_output.put_line(x.prenume);
 dbms_output.put_line(x.nume);
 dbms_output.put_line(x.email); 
END;
/

DECLARE
   V_SALARIU NUMBER;
BEGIN
   IF V_SALARIU IS NULL THEN
    dbms_output.put_line('SALARIU LIPSA');
   ELSE IF V_SALARIU<10000 THEN -- NESTED IFS
     dbms_output.put_line('SALARIU MIC');
   ELSE
     dbms_output.put_line('SALARIU MARE');
   END IF;  
   END IF; 
END;
/

DECLARE
   V_SALARIU NUMBER:=100;
BEGIN
   IF V_SALARIU IS NULL THEN
   BEGIN
    dbms_output.put_line('SALARIU LIPSA');
    dbms_output.put_line('INTRODUCETI UN SALARIU');
    EXCEPTION WHEN OTHERS THEN NULL;
   END; 
   ELSIF V_SALARIU<1000 OR V_SALARIU>100000 THEN
     dbms_output.put_line('SALARIU ERONAT');
   ELSIF V_SALARIU<10000 THEN 
     dbms_output.put_line('SALARIU MIC');
   ELSE
     dbms_output.put_line('SALARIU MARE');
   END IF;     
END;
/

DECLARE
   V_SALARIU NUMBER;
BEGIN
   IF V_SALARIU IS NULL THEN   
    dbms_output.put_line('SALARIU LIPSA');
    dbms_output.put_line('INTRODUCETI UN SALARIU');      
   ELSIF V_SALARIU<1000 OR V_SALARIU>100000 THEN
     dbms_output.put_line('SALARIU ERONAT');
   ELSIF V_SALARIU<10000 THEN 
     dbms_output.put_line('SALARIU MIC');
   ELSE
     dbms_output.put_line('SALARIU MARE');
   END IF;     
   
END;
/


DECLARE
   V_SALARIU NUMBER:=15000;
BEGIN
   CASE
   WHEN V_SALARIU IS NULL THEN   
    dbms_output.put_line('SALARIU LIPSA');
    dbms_output.put_line('INTRODUCETI UN SALARIU');      
   WHEN V_SALARIU<1000 OR V_SALARIU>100000 THEN
     dbms_output.put_line('SALARIU ERONAT');
   WHEN V_SALARIU<10000 THEN 
     dbms_output.put_line('SALARIU MIC');   
  -- WHEN  V_SALARIU>=10000 THEN   
   ELSE
      --NULL;
      dbms_output.put_line('SALARIU MARE');   
   END CASE;    
   dbms_output.put_line('CONTINUAM');
   dbms_output.put_line('CONTINUAM');
   dbms_output.put_line('CONTINUAM');
END;
/


DECLARE
   V_SALARIU NUMBER:=15000;
BEGIN
   CASE
   WHEN V_SALARIU IS NULL THEN   
    dbms_output.put_line('SALARIU LIPSA');
    dbms_output.put_line('INTRODUCETI UN SALARIU');      
   WHEN V_SALARIU<1000 OR V_SALARIU>100000 THEN
     dbms_output.put_line('SALARIU ERONAT');
   WHEN V_SALARIU<10000 THEN 
     dbms_output.put_line('SALARIU MIC');   
  -- WHEN  V_SALARIU>=10000 THEN   
   END CASE;  
   dbms_output.put_line('CONTINUAM');
   dbms_output.put_line('CONTINUAM');
   dbms_output.put_line('CONTINUAM');
   
   EXCEPTION 
    WHEN CASE_NOT_FOUND THEN
      dbms_output.put_line('SALARIU MARE');   
END;
/

DECLARE
   I PLS_INTEGER:=5;
BEGIN
    dbms_output.put_line('I='||I);
    I:=I+1;
    FOR I IN 20..30 LOOP         
     dbms_output.put_line('I='||I);
    END LOOP;
    dbms_output.put_line('I='||I);
END;
/

-- SA SE AFISEZE NUMERELE PARE INTRE 20 SI 30
BEGIN
   
    FOR I IN 20..30 LOOP         
     IF I MOD 2 = 0 THEN
      dbms_output.put_line('I='||I);
     END IF;
    END LOOP;
   
END;
/

BEGIN
   
    FOR I IN 20..30 LOOP         
     CONTINUE WHEN I MOD 2 = 1;
      dbms_output.put_line('I='||I);     
    END LOOP;
   
END;
/

BEGIN
   
    FOR I IN 20..30 LOOP         
      dbms_output.put_line('I='||I);     
      EXIT WHEN I=25;          
    END LOOP;
   
END;
/

declare
    v_pret_lista produse.pret_lista%type;
begin
    select pret_lista into v_pret_lista from produse where id_produs = &id;
    dbms_output.put_line('Pret initial: ' || v_pret_lista);
    
    if v_pret_lista > 500 then
        v_pret_lista := 1.05 * v_pret_lista;
    elsif v_pret_lista between 200 and 500 then
        v_pret_lista := 1.1 * v_pret_lista;
    else
       v_pret_lista := 1.2 * v_pret_lista; 
    end if;
    
    dbms_output.put_line('Pret majorat: ' || v_pret_lista);
end;
/
SET SERVEROUTPUT ON
declare
    v_pret_lista produse.pret_lista%type;
begin
    select pret_lista into v_pret_lista from produse where id_produs = &id;
    dbms_output.put_line('Pret initial: ' || v_pret_lista);
    
    v_pret_lista := case when v_pret_lista > 500 then 1.05 * v_pret_lista
                         when v_pret_lista between 200 and 500 then 1.1 * v_pret_lista
                         else 1.2 * v_pret_lista end;

    
    dbms_output.put_line('Pret majorat: ' || v_pret_lista);
end;
/

declare
    v_pret_lista produse.pret_lista%type;
begin
    select pret_lista into v_pret_lista from produse where id_produs = &id;
    dbms_output.put_line('Pret initial: ' || v_pret_lista);
    
    case 
        when v_pret_lista > 500 then
            v_pret_lista := 1.05 * v_pret_lista;
        when v_pret_lista between 200 and 500 then
            v_pret_lista := 1.1 * v_pret_lista;
        else
            v_pret_lista := 1.2 * v_pret_lista;
    end case;
            
    dbms_output.put_line('Pret majorat: ' || v_pret_lista);
end;
/

DECLARE
    nota number;
Begin
    if nota is not null then
        IF nota<5 THEN
            dbms_output.put_line('Ne pare rau, candidatul este respins!');
        ELSE
            dbms_output.put_line('Felicitari, sunteti admis!');
        END IF;
    else
        dbms_output.put_line('Nota nu a fost incarcata in sistem');
    end if;
END;
/

-- Exercitiu: Sa se verifice printr-un IF Statement daca prenumele angajatului cu id 198 contine grupul de litere 'na' sau 'gl'
--si sa se afiseze un mesaj corespunzator pentru fiecare caz
DECLARE
V_PRENUME ANGAJATI.PRENUME%TYPE;
BEGIN
SELECT PRENUME INTO V_PRENUME FROM ANGAJATI WHERE ID_ANGAJAT = 198;
IF UPPER(V_PRENUME) LIKE '%NA%' THEN
DBMS_OUTPUT.PUT_LINE('PRENUMELE CONTINE NA');
ELSIF UPPER(V_PRENUME) LIKE '%GL%' THEN
DBMS_OUTPUT.PUT_LINE('PRENUMELE CONTINE GL');
ELSE
DBMS_OUTPUT.PUT_LINE('PRENUMELE NU CONTINE NA SAU GL');
END IF;
END;
/

SELECT PRENUME  FROM ANGAJATI WHERE ID_ANGAJAT = 198;

-- Exercitiu: Sa se afiseze textul 'Clientul Nume Prenume are id-ul Id' pentru clientii cu id-ul de la 101 pana la 110
-- * Se foloseste un loop numeric (101..110)
-- * Pentru fiecare iteratie se executa un SELECT INTO separat care preia un singur rand in variabila v_client
DECLARE
V_ANGAJAT ANGAJATI%ROWTYPE;
BEGIN 
FOR I IN 101..110 LOOP
SELECT * INTO V_ANGAJAT FROM ANGAJATI WHERE ID_ANGAJAT=I;
DBMS_OUTPUT.PUT_LINE('ANGAJATUL '|| V_ANGAJAT.NUME || ' '|| V_ANGAJAT.PRENUME||' ARE ID -UL ' || V_ANGAJAT.ID_ANGAJAT);
END LOOP;
END;
/

-- Exercitiu: Sa se afiseze textul 'Clientul Nume Prenume are id-ul Id' pentru clientii cu id-ul de la 101 pana la 110
-- * Interogarea SELECT se executa o singura data
-- * Loop-ul parcurge automat fiecare rand returnat de select
-- * Variabila r contine pe rand fiecare inregistrare
BEGIN
FOR R IN (SELECT * FROM CLIENTI WHERE ID_CLIENT <=110) LOOP
dbms_output.put_line('Clientul ' || r.nume_client || ' ' || r.prenume_client || ' are id-ul ' || r.id_client); 
END LOOP;
END;
/

SELECT * FROM CLIENTI ORDER BY ID_CLIENT ;

-- Exercitiu: Sa se parcurga clientii cu id intre 120 si 140.
-- Pentru fiecare client se va verifica nivelul veniturilor:
--  * daca nivelul veniturilor incepe cu A => se va afisa 'Clientul Nume nu este eligibil pentru credit'
--  * daca nivelul veniturilor incepe cu B, C sau D => se va afisa 'Clientul Nume este eligibil pentru credit de 10000 lei'
--  * altfel => se va afisa 'Clientul Nume este eligibil pentru orice tip de credit'
BEGIN 
FOR R IN (SELECT * FROM CLIENTI WHERE ID_CLIENT >= 120 AND ID_CLIENT <= 140) LOOP
CASE 
WHEN R.NIVEL_VENITURI LIKE 'A%' THEN DBMS_OUTPUT.PUT_LINE('CLIENTUL '|| R.NUME_CLIENT ||' NU ESTE ELIGIBIL PENTRU CREDIT');
WHEN R.NIVEL_VENITURI LIKE 'B%' OR R.NIVEL_VENITURI LIKE 'C%' OR R.NIVEL_VENITURI LIKE 'D%' THEN DBMS_OUTPUT.PUT_LINE('CLIENTUL '|| R.NUME_CLIENT ||' ESTE ELIGIBIL PENTRU CREDIT DE 10000 LEI');
ELSE DBMS_OUTPUT.PUT_LINE('CLIENTUL '|| R.NUME_CLIENT ||' NU ESTE ELIGIBIL PENTRU ORICE TIP DE CREDIT');
END CASE;
END LOOP;
END;
/

SELECT * FROM CLIENTI ORDER BY ID_CLIENT;

-- Exercitiu: Sa se parcurga toti angajatii.
-- Pentru fiecare angajat se va verifica luna in care a fost angajat:
--  * daca a fost angajat in lunile 12, 1, 2 => se va afisa 'Nume angajat iarna'
--  * daca a fost angajat in lunile 3, 4, 5 => => se va afisa 'Nume angajat primavara'
--  * daca a fost angajat in lunile 6, 7, 8 => => se va afisa 'Nume angajat vara'
--  * altfel => se va afisa 'Nume angajat toamna'
SELECT * FROM ANGAJATI;
BEGIN
FOR R IN (SELECT * FROM ANGAJATI) LOOP
CASE 
WHEN EXTRACT(MONTH FROM R.DATA_ANGAJARE) IN (12, 1,2) THEN DBMS_OUTPUT.PUT_LINE(R.NUME ||' ANGAJAT IARNA');
WHEN EXTRACT(MONTH FROM R.DATA_ANGAJARE) IN (3,4,5) THEN DBMS_OUTPUT.PUT_LINE(R.NUME ||' ANGAJAT PRIMAVARA');
WHEN EXTRACT(MONTH FROM R.DATA_ANGAJARE) IN (6,7,8) THEN DBMS_OUTPUT.PUT_LINE(R.NUME ||' ANGAJAT VARA');
ELSE
DBMS_OUTPUT.PUT_LINE(R.NUME ||' ANGAJAT TOAMNA');
END CASE;
END LOOP;
END;
/

--În funcție de prețul de listă a produsului având codul citit de la tastatură, se va afişa modificat pe ecran noua valoare.
SET SERVEROUTPUT ON
DECLARE
v_lista produse.pret_lista%type;
BEGIN
SELECT pret_lista into v_lista from produse where id_produs=&p;
dbms_output.put_line ('Pretul de lista initial este: '||v_lista);
IF v_lista < 500 THEN 
	v_lista:=2* v_lista;
ELSIF v_lista between 500 and 1000 THEN
	v_lista:=1.5 * v_lista;
ELSE 
	v_lista:=1.25* v_lista;
END IF;
dbms_output.put_line('Pretul final este: '||v_lista);
end;

DECLARE
v_lista produse.pret_lista%type;
BEGIN
SELECT pret_lista into v_lista from produse where id_produs=&p;
dbms_output.put_line ('Pretul de lista initial este: '||v_lista);

v_lista:= CASE WHEN v_lista < 500 THEN 2* v_lista
          WHEN v_lista between 500 and 1000 THEN	1.5 * v_lista
          ELSE 1.25* v_lista END;

dbms_output.put_line('Pretul final este: '||v_lista);
end;
/

DECLARE
v_lista produse.pret_lista%type;
BEGIN
SELECT pret_lista into v_lista from produse where id_produs=&p;
dbms_output.put_line ('Pretul de lista initial este: '||v_lista);
CASE
WHEN v_lista < 500 THEN 
	v_lista:=2* v_lista;
WHEN v_lista between 500 and 1000 THEN
	v_lista:=1.5 * v_lista;
ELSE 
	v_lista:=1.25* v_lista;
END CASE;
dbms_output.put_line('Pretul final este: '||v_lista);
end;
/

 --Se afişează pe ecran utilizând structura loop…end loop numerele 9,7, 4, 0.
 DECLARE
v_nr number(2):=10;
i number(2):=1;
BEGIN
loop
v_nr:=v_nr-i;
i:=i+1;
exit when v_nr < 0;
dbms_output.put_line(v_nr);
end loop;
END;
/

DECLARE
v_nr number(2):=10;
i number(2):=1;
BEGIN
while v_nr > 0
loop
v_nr:=v_nr-i;
i:=i+1;
dbms_output.put_line(v_nr);
end loop;
END;
/

DECLARE
v_nr number(2):=10;
i number(2);
BEGIN
for i in 1..10
loop
v_nr:=v_nr-i;
exit when v_nr < 0;
dbms_output.put_line(v_nr);
end loop;
END;
/

--Se afişează în ordine angajaţii cu codurile în intervalul 100-110 atât timp cât salariul acestora este mai mic decât media:
DECLARE
v_sal angajati.salariul%type;
v_salMediu v_sal%type;
i number(4):=100;
BEGIN
SELECT avg(salariul) into v_salmediu from angajati;
dbms_output.put_line('Salariul mediu este: '||v_salmediu);
loop
select salariul into v_sal from angajati where id_angajat=i;
dbms_output.put_line('Salariatul cu codul '||i||' are salariul: '||v_sal);
i:=i+1;
exit when v_sal<v_salmediu or i>110;
end loop;
end;
/

DECLARE
v_sal angajati.salariul%type;
v_salMediu v_sal%type;
i number(4):=100;
BEGIN
SELECT avg(salariul) into v_salmediu from angajati;
dbms_output.put_line('Salariul mediu este: '||v_salmediu);
while i<=110 loop
select salariul into v_sal from angajati where id_angajat=i;
dbms_output.put_line('Salariatul cu codul '||i||' are salariul: '||v_sal);
i:=i+1;
exit when v_sal<v_salmediu;
end loop;
end;
/

DECLARE
v_sal angajati.salariul%type;
v_salMediu v_sal%type;
-- i nu mai trebuie declarat
BEGIN
SELECT avg(salariul) into v_salmediu from angajati;
dbms_output.put_line('Salariul mediu este: '||v_salmediu);
for i in 100..110 loop
select salariul into v_sal from angajati where id_angajat=i;
dbms_output.put_line('Salariatul cu codul '||i||' are salariul: '||v_sal);
exit when v_sal<v_salmediu;
end loop;
end;
/


--Să se afişeze numărul de comenzi ale fiecărui angajat al cărui id este situat în intervalul 155..160,
--dar să se întrerupă afişarea în cazul în care se găseşte primul angajat din acest interval care nu are nici o comandă:
DECLARE 
V_NR NUMBER;
V_ANGAJAT ANGAJATI%ROWTYPE;
BEGIN
FOR I IN 155..160 LOOP
SELECT COUNT(*) INTO V_NR FROM COMENZI WHERE ID_ANGAJAT = I;
SELECT * INTO V_ANGAJAT FROM ANGAJATI WHERE ID_ANGAJAT = I;
EXIT WHEN V_NR = 0;
dbms_output.put_line(V_ANGAJAT.NUME || ' ARE '|| V_NR||' COMENZI');
END LOOP;
END;
/

DECLARE
v_nr number;
v_nume angajati.nume%type;
v_id angajati.id_angajat%type;
BEGIN
for v_id in 155..160 loop
v_nr:=0;
SELECT count(c.id_comanda) into v_nr from comenzi c,angajati a
where c.id_angajat=a.id_angajat and a.id_angajat=v_id;
dbms_output.put_line('Salariatul cu id-ul: '||v_id||' are: '||v_nr||' comenzi');
exit when v_nr=0;
END LOOP;
END;
/

--Să se încarce în tabela MESAJE numere de la 1…10 cu excepţia lui 6 şi 8.
create table mesaje (numere varchar2(10));
begin
for i in 1..10 loop
if i = 6 or i = 8 then null;
else
insert into mesaje(numere) values(i);
end if;
end loop;
end;
/
select * from mesaje;
select * from produse order by id_produs;
--tablouri indexate
set serveroutput on
declare 
type tabel_indexat is table of produse.denumire_produs%type index by pls_integer;
produse_tab tabel_indexat;
i number(5) := 2252;
begin
loop
select denumire_produs into produse_tab(i) from produse where id_produs = i;
i := i+1;
exit when i >2255;
end loop;
for r in produse_tab.first..produse_tab.last loop
if produse_tab.exists(r) then dbms_output.put_line('Nume produs: '|| produse_tab(r));
end if;
end loop;
end;
/

DECLARE
--declararea tipului si a variabilei
type ang_table is table of angajati%rowtype index by pls_integer;
v_tab ang_table;
BEGIN
--incarcarea in tablou:
for i in 130..135 loop
SELECT * into v_tab(i) from angajati where id_angajat=i;
end loop;
--extragerea din tablou
for i in v_tab.first..v_tab.last loop
dbms_output.put_line('Angajatul: '|| v_tab(i).nume|| ' lucreaza in departamentul: '||v_tab(i).id_departament);
end loop;
dbms_output.put_line('Total angajati in tabloul indexat: '|| v_tab.count);
END;
/

--varray
declare
type tip_nume is varray(150) of angajati.nume%type;
v_lista tip_nume:=tip_nume();
i number(3):=1;
begin
loop
v_lista.extend; 
select nume into v_lista(i) from angajati where id_angajat=i+99;
i:=i+1;
exit when i>107;
end loop;
for i in 1 .. 10 loop
dbms_output.put_line(v_lista(i));
end loop;
end;
/


set serveroutput on
declare 
v_nr varchar2(50) := '357763287986';
v_rez pls_integer;
begin 
for i in reverse 1..length(v_nr) loop
v_rez := substr(v_nr, i, 1);
dbms_output.put_line(v_rez);
end loop;
end;
/

declare
v_nr varchar2(50) := '5628g9ds*bjd89289';
v_rez pls_integer;
v_suma_pare pls_integer := 0;
v_suma_impare pls_integer := 0;
begin
for i in 1..length(v_nr) loop
if ascii(substr(v_nr, i, 1)) between 48 and 57 then v_rez := substr(v_nr, i, 1);
if v_rez mod 2 = 0 then
v_suma_pare := v_suma_pare + v_rez;
else
v_suma_impare:= v_suma_impare + v_rez;
end if;
end if;
end loop;
dbms_output.put_line(v_suma_pare);
dbms_output.put_line(v_suma_impare);
end;
/


DECLARE
  V_ID_PRODUS PRODUSE.ID_PRODUS%TYPE;
  V_DENUMIRE_PRODUS PRODUSE.DENUMIRE_PRODUS%TYPE;
  V_CATEGORIE PRODUSE.CATEGORIE%TYPE;
BEGIN
  FOR I IN 1726..1740 LOOP
   BEGIN
    SELECT ID_PRODUS, DENUMIRE_PRODUS,CATEGORIE INTO
     V_ID_PRODUS,V_DENUMIRE_PRODUS,V_CATEGORIE
     FROM PRODUSE WHERE ID_PRODUS=I;
     DBMS_OUTPUT.PUT_LINE(V_ID_PRODUS||' '||V_DENUMIRE_PRODUS||' '||V_CATEGORIE);
     EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
   END;  
  END LOOP;  
END;
/

DECLARE
  V_ID_PRODUS PRODUSE.ID_PRODUS%TYPE;
  V_DENUMIRE_PRODUS PRODUSE.DENUMIRE_PRODUS%TYPE;
  V_CATEGORIE PRODUSE.CATEGORIE%TYPE;
  N PLS_INTEGER;
BEGIN
  FOR I IN 1726..1740 LOOP
    SELECT COUNT(*) INTO N FROM PRODUSE WHERE ID_PRODUS=I;
    IF N=1 THEN
    SELECT ID_PRODUS, DENUMIRE_PRODUS,CATEGORIE INTO
     V_ID_PRODUS,V_DENUMIRE_PRODUS,V_CATEGORIE
     FROM PRODUSE WHERE ID_PRODUS=I;
     DBMS_OUTPUT.PUT_LINE(V_ID_PRODUS||' '||V_DENUMIRE_PRODUS||' '||V_CATEGORIE);
   END IF;     
  END LOOP;  
END;
/

SET SERVEROUTPUT ON
DECLARE
TYPE EmpTabTyp IS TABLE OF angajati%ROWTYPE INDEX BY PLS_INTEGER;
emp_tab EmpTabTyp;
BEGIN
SELECT * INTO emp_tab(200) FROM angajati WHERE id_angajat = 200;
dbms_output.put_line('Nume='||emp_tab(200).prenume);
dbms_output.put_line(case when emp_tab.exists(200) then 'exista' else 'nu exista' end);
dbms_output.put_line(case when emp_tab.exists(1) then 'exista' else 'nu exista' end);
SELECT * INTO emp_tab(205) FROM angajati WHERE id_angajat = 205;
dbms_output.put_line('Nume='||emp_tab(205).prenume);
dbms_output.put_line('Numar de elemente='||emp_tab.count);
emp_tab(122):=emp_tab(205);
dbms_output.put_line('Nume='||emp_tab(122).prenume);
dbms_output.put_line('Numar de elemente='||emp_tab.count);
emp_tab(2005).prenume:='John';
dbms_output.put_line('Numar de elemente='||emp_tab.count);
END;
/

declare 
type tabela is table of angajati%rowtype index by pls_integer;
t tabela;
begin 
select * bulk collect into t from angajati order by salariul desc;
dbms_output.put_line(t.count);
t.delete(10);
dbms_output.put_line(t.count);
for i in t.first..t.last loop
continue when not t.exists(i);
dbms_output.put_line(t(i).nume);
end loop;
end;
/
