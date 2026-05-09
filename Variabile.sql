SET SERVEROUTPUT ON

DECLARE
M DECIMAL;
N FLOAT;
BEGIN
M := 100.223;
N := 100.223;
DBMS_OUTPUT.PUT_LINE(M || ' '||N);
END;
/

--se afiseaza numele si prenumele angajatului cu codul 100
DECLARE
V_NUME ANGAJATI.NUME%TYPE;
V_PRENUME ANGAJATI.PRENUME%TYPE;
BEGIN
SELECT NUME, PRENUME INTO V_NUME, V_PRENUME FROM ANGAJATI WHERE ID_ANGAJAT=100;
DBMS_OUTPUT.PUT_LINE(V_NUME || ' ' ||V_PRENUME);
END;
/

SELECT * FROM COMENZI;

VARIABLE G_NUMAR NUMBER;
BEGIN
SELECT COUNT(*) INTO :G_NUMAR FROM COMENZI WHERE UPPER(MODALITATE) ='ONLINE';
END;
/
PRINT G_NUMAR;

BEGIN
:G_NUMAR := :G_NUMAR + 10;
DBMS_OUTPUT.PUT_LINE(:G_NUMAR);
:G_NUMAR := :G_NUMAR + 10;
END;
/
PRINT G_NUMAR;

--se selecteaza produsele si pretul acestora pentru acele produse care au pretul < pretul mediu 
--al produsului cu codul 3133 fara a utiliza un select imbricat
--SELECT * FROM RAND_COMENZI WHERE ID_PRODUS = 3133;

VARIABLE G_MEDIU NUMBER
SET SERVEROUTPUT ON;
SET AUTOPRINT ON;
BEGIN 
SELECT AVG(PRET) INTO :G_MEDIU FROM RAND_COMENZI WHERE ID_PRODUS=3133;
END;
/
SELECT * FROM RAND_COMENZI WHERE PRET < :G_MEDIU;

--se afiseaza numarul de comenzi ale angajatului al carui cod este introdus de 
--utilizator prin intermediul variabilei de substitutie &id_angajat
SELECT * FROM COMENZI;

DECLARE 
V_NR NUMBER;
BEGIN
SELECT COUNT(*) INTO V_NR FROM COMENZI WHERE ID_ANGAJAT = &ID_ANGAJAT;
DBMS_OUTPUT.PUT_LINE(V_NR);
END;
/

-- se afiseaza salariul si prenumele angajatului cu numele Abel
VARIABLE G_SALARIU NUMBER;
DEFINE S_NUME = ABEL;
DECLARE
V_PRENUME ANGAJATI.PRENUME%TYPE;
BEGIN 
SELECT PRENUME, SALARIUL INTO V_PRENUME, :G_SALARIU FROM ANGAJATI WHERE UPPER(NUME) = '&S_NUME';
DBMS_OUTPUT.PUT_LINE(V_PRENUME|| ' ' || :G_SALARIU);
END;
/


DECLARE
var NUMBER;
BEGIN
var := 1;
DBMS_OUTPUT.PUT_LINE(var);

<<bloc1>>
DECLARE
var NUMBER;
BEGIN
var :=2;
DBMS_OUTPUT.PUT_LINE(var);
END bloc1;

DBMS_OUTPUT.PUT_LINE(var);

<<bloc2>>
DECLARE
var NUMBER;
BEGIN
var :=3;
DBMS_OUTPUT.PUT_LINE(var);
<<bloc3>>
DECLARE
var NUMBER;
BEGIN
var :=4;
DBMS_OUTPUT.PUT_LINE(var);
DBMS_OUTPUT.PUT_LINE(bloc2.var);
END bloc3;
DBMS_OUTPUT.PUT_LINE(var);
END bloc2;
DBMS_OUTPUT.PUT_LINE(var);
END;
/

VARIABLE G_REZULTAT NUMBER;
ACCEPT NUM1 PROMPT 'iNTRODUCETI PRIMUL NR';
ACCEPT NUM2 PROMPT 'iNTRODUCETI AL DOILEA NR';
DECLARE
V_NUM1 NUMBER := &NUM1;
V_NUM2 NUMBER := &NUM2;
BEGIN
:G_REZULTAT := (V_NUM1 + V_NUM2)/3;
END;
/
PRINT G_REZULTAT;

--Să se afişeze salariul mărit cu un x procente.
--Salariul şi procentul se citesc de la tastatură.

ACCEPT SAL PROMPT 'INTRODUCETI SALARIUL';
ACCEPT PROCENT PROMPT 'INTRODUCETI PROCENTUL';
DECLARE
V_SAL NUMBER := &SAL;
V_PRO NUMBER := 1 + (&PROCENT /100);
BEGIN
V_SAL := V_SAL * V_PRO;
DBMS_OUTPUT.PUT_LINE(V_SAL);
END;
/

--Să se calculeze valoarea fără TVA pentru un preț introdus de la tastatură ce conține TVA.
VARIABLE G_TVA NUMBER;
ACCEPT PRET PROMPT 'INTRODUCETI PRETUL';
DECLARE
V_PRET NUMBER := &PRET;
BEGIN
:G_TVA :=19;
V_PRET := V_PRET / (1+ (:G_TVA /100));
DBMS_OUTPUT.PUT_LINE(V_PRET);
END;
/

--Utilizând un tip de dată înregistrare definit de utilizator,
--să se afișeze preţul minim al produsului cu codul 3133.
SELECT * FROM PRODUSE;
DECLARE 
TYPE PRODUS IS RECORD 
(DENUMIRE PRODUSE.DENUMIRE_PRODUS%TYPE,
COD PRODUSE.ID_PRODUS%TYPE NOT NULL := 1,
PRET PRODUSE.PRET_MIN%TYPE);
PROD PRODUS;
BEGIN
SELECT DENUMIRE_PRODUS, ID_PRODUS, PRET_MIN INTO PROD FROM PRODUSE  WHERE ID_PRODUS = 3133;
DBMS_OUTPUT.PUT_LINE(PROD.DENUMIRE|| ' -'|| PROD.PRET || '- ' ||PROD.COD);
END;
/

--Utilizând un tip de dată înregistrare de același tip cu
--tabela produse să se afişeze preţul minim al produsului cu codul 3133.
DECLARE 
PROD PRODUSE%ROWTYPE;
BEGIN
SELECT * INTO PROD FROM PRODUSE WHERE ID_PRODUS = 3133;
DBMS_OUTPUT.PUT_LINE(PROD.DENUMIRE_PRODUS|| ' -'|| PROD.PRET_MIN || '- ' ||PROD.ID_PRODUS);
END;
/

--Utilizând un tip de dată înregistrare de același tip cu un rând din tabela DEPARTAMENTE să se afișeze
--denumirea fiecărui departament cu id-ul: 10, 20, 30, 40, 50.
SELECT * FROM DEPARTAMENTE;
DECLARE
DEP DEPARTAMENTE%ROWTYPE;
I NUMBER := 10;
BEGIN
LOOP
SELECT * INTO DEP FROM DEPARTAMENTE WHERE ID_DEPARTAMENT = I;
DBMS_OUTPUT.PUT_LINE('ID DEP: '|| DEP.ID_DEPARTAMENT || ' DENUMIRE: ' || DEP.DENUMIRE_DEPARTAMENT);
EXIT WHEN I>= 50;
I := I +10;
END LOOP;
END;
/

variable g_mesaj varchar2(30);

declare
    v_zi number(2) := 27;
    v_zi_saptamana varchar2(4) := upper('luni');
    -- variabila cu restrie not null (trebuie initializata)
    v_luna varchar2(30) not null := 'null';
    -- variabila constanta (trebuie initializata)
    c_an constant number(4) := 2026;
    v_an number(4); -- nu va afisa nimic, doar o linie libera pentru ca inca nu am initializat variabila
begin
    dbms_output.put_line(v_zi_saptamana || ' ' || v_zi || ' ' || v_luna || ' ' || c_an);
    dbms_output.put_line(v_an);

    -- bloc imbricat
    <<bloc1>>
    declare
        -- redefinire si initializare variabila v_zi_saptamana
        v_zi_saptamana varchar2(30) := 'VINERI';
    begin
        v_an := 2026;
        v_luna := 'FEBRUARIE';
        -- initializare variabila globala
        :g_mesaj := 'Hello World!';

        dbms_output.put_line(v_zi_saptamana || ' ' || v_zi || ' ' || v_luna || ' ' || c_an);
        dbms_output.put_line(v_an);
        -- afisare valoare variabila globala in interiorul blocului
        dbms_output.put_line(:g_mesaj);
    end bloc1;
end;
/

declare
    v_char char(10) := 'ABC';
    v_varchar varchar2(10) := 'ABC';
    v_long long;
    v_clob clob;
    v_number number(5,2) := 123.23;
    v_bool boolean := true;
    v_date date := sysdate;
    v_ts timestamp := systimestamp;
    v_bi binary_integer;
    v_pi pls_integer;
    v_bf binary_float := 123.123456789;
    v_bd binary_double := 123.123456789;
begin
    v_long := '&long';
    v_clob := '&clob';
    dbms_output.put_line(v_char);
    dbms_output.put_line(v_varchar);
    dbms_output.put_line(v_long);
    dbms_output.put_line(v_clob);
    dbms_output.put_line(v_number);
    dbms_output.put_line(case when v_bool then 'true' else 'false' end);
    dbms_output.put_line(v_date);
    dbms_output.put_line(v_ts);
    
    v_bi := 2;
    v_pi := 4;
    dbms_output.put_line(v_bi);
    dbms_output.put_line(v_pi);
    dbms_output.put_line(v_bf);
    dbms_output.put_line(v_bd);
end;
/

declare
    v_nume varchar2(30);
    v_nume_upper varchar2(30);
begin
    -- va afisa fereastra de dialog de 2 ori, putand introduce doua valori diferite in fiecare fereastra, chiar daca e folosita aceeasi variabila de substitutie 'nume'
    v_nume := '&nume';
    v_nume_upper := upper('&nume');
    dbms_output.put_line(v_nume);
    dbms_output.put_line(v_nume_upper);
end;
/

declare
    v_nume varchar2(30);
    v_nume_upper varchar2(30);
begin
    -- va afisa fereastra de dialog o singura data, variabila de substitutie 'nume2' va primi aceeasi valoare
    v_nume := '&&nume2';
    v_nume_upper := upper('&&nume2');
    dbms_output.put_line(v_nume);
    dbms_output.put_line(v_nume_upper);
end;
/
