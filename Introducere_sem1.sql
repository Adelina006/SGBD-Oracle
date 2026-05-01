SET SERVEROUTPUT ON

BEGIN 
--EXECUTE IMMEDIATE 'DROP TABLE PROD';
EXECUTE IMMEDIATE 'CREATE TABLE PROD AS SELECT * FROM PRODUSE WHERE 1=2';
END;
/

SELECT * FROM PROD;

DECLARE 
V_CODP PRODUSE.ID_PRODUS%TYPE;
V_DENP PRODUSE.denumire_produs%type;
V_DES PRODUSE.descriere%type;
V_CAT PRODUSE.categorie%type;
BEGIN
SELECT ID_PRODUS, DENUMIRE_PRODUS,DESCRIERE, CATEGORIE INTO V_CODP, V_DENP, V_DES, V_CAT 
FROM PRODUSE WHERE ID_PRODUS = 3133;
INSERT INTO PROD(ID_PRODUS, DENUMIRE_PRODUS,DESCRIERE, CATEGORIE) VALUES ( V_CODP, V_DENP, V_DES, V_CAT);
DBMS_OUTPUT.PUT_LINE('S-A ADAUGAT IN TABELA PROD PRODUSUL ' || V_CODP||' '||V_DENP||' '||V_CAT);
END;
/

--Se creează tabela EMP_SAL prin intermediul unei variabile de tip VARCHAR2.
--La creare, în tabela EMP_SAL se va adăuga o nouă înregistrare. 

DROP TABLE EMP_SAL;

VARIABLE G_ID NUMBER;
DECLARE
V_SIR VARCHAR2(200);
BEGIN
:G_ID:=110;
V_SIR:='CREATE TABLE EMP_SAL AS SELECT ID_ANGAJAT, PRENUME, NUME, SALARIUL 
FROM ANGAJATI WHERE ID_ANGAJAT ='|| :G_ID;
DBMS_OUTPUT.PUT_LINE(V_SIR);
EXECUTE IMMEDIATE V_SIR;
END;
/

SELECT * FROM EMP_SAL;

--Se adaugă o nouă coloană STOC în tabela PRODUSE:
DECLARE 
V_SIR VARCHAR2(200);
BEGIN
V_SIR := ' ALTER TABLE PRODUSE ADD (STOC NUMBER(7))';
DBMS_OUTPUT.PUT_LINE(V_SIR);
EXECUTE IMMEDIATE V_SIR;
END;
/
SELECT * FROM PRODUSE;

--Se adaugă o nouă înregistrare în tabela EMP_SAL:
BEGIN
INSERT INTO EMP_SAL(ID_ANGAJAT, NUME, PRENUME,SALARIUL) VALUES
(150, 'Popa', 'Mihai', 1500);
END;
/
SELECT * FROM EMP_SAL;

--Se adaugă o nouă înregistrare în tabela produse 
--prin introducerea valorilor cu ajutorul variabilelor de substituţie:
BEGIN
INSERT INTO PRODUSE(ID_PRODUS, DENUMIRE_PRODUS, DESCRIERE) VALUES
(&ID, '&DENUMIRE', '&DESCRIERE');
END;
/

SELECT * FROM PRODUSE;

--Se mărește cu x procente salariul angajaților din tabela EMP_SAL care au
--în prezent salariul mai mic decât o anumită valoare:
DECLARE
V_PROCENT NUMBER := 0.2;
V_SAL NUMBER := 2000;
BEGIN
UPDATE EMP_SAL SET SALARIUL = SALARIUL *(1+V_PROCENT)
WHERE SALARIUL < V_SAL;
END;
/

--Se realizează o aprovizionare în cadrul depozitului prin care se măresc stocurile 
--tuturor produselor cu 100 bucăți (coloana STOC a fost anterior adăugată):
BEGIN
UPDATE PRODUSE SET STOC = NVL(STOC, 0) + 100;
END;
/
SELECT * FROM PRODUSE;

--În urma comenzilor realizate de clienţi, monitoarele de tipul LCD sunt vândute, 
--se deci scade din stocul existent un număr de monitoare introdus de la tastatură: 
BEGIN
UPDATE PRODUSE SET STOC = STOC - &NUMAR
WHERE UPPER(DENUMIRE_PRODUS) LIKE('%LCD%');
COMMIT;
END;
/

--Se şterge angajatul cu numele Pop din tabela emp_sal: 
BEGIN
DELETE FROM EMP_SAL WHERE INITCAP(NUME) LIKE 'Pop%';
COMMIT;
END;
/
SELECT * FROM EMP_SAL;

DECLARE
V_RAND PRODUSE%ROWTYPE;
BEGIN
SELECT * INTO V_RAND FROM PRODUSE WHERE ID_PRODUS = 2254;
DBMS_OUTPUT.PUT_LINE(V_RAND.DENUMIRE_PRODUS);
END;
/

--Creaţi un bloc PL/SQL ce adaugă un produs nou in tabela PRODUSE.
DECLARE
V_ID PRODUSE.ID_PRODUS%TYPE;
BEGIN
 SELECT MAX(ID_PRODUS) INTO V_ID FROM PRODUSE;
V_ID:= V_ID + 10;
INSERT INTO PRODUSE (ID_PRODUS, DENUMIRE_PRODUS, CATEGORIE, STOC) VALUES (V_ID, '&V_DEN',  '&V_CAT', &STOC);
END;
/

SET SERVEROUTPUT ON
--Creaţi un bloc PL/SQL ce selectează stocul maxim pentru produsele existente in tabela PRODUSE. Tipăriţi rezultatul pe ecran.
DECLARE
V_PROD PRODUSE%ROWTYPE;
BEGIN
SELECT * INTO V_PROD FROM PRODUSE WHERE STOC = (SELECT MAX(STOC) FROM PRODUSE) AND ROWNUM = 1;
DBMS_OUTPUT.PUT_LINE(V_PROD.DENUMIRE_PRODUS||' '||V_PROD.STOC);
END;
/

--. Creaţi un bloc PL/SQL care şterge un produs pe baza codului acestuia primit ca parametru (variabila de substituţie). Anulaţi ştergerea dintr-ul alt bloc PL/SQL.
VARIABLE G_COD NUMBER;
BEGIN
:G_COD := &COD;
DELETE FROM PRODUSE WHERE ID_PRODUS = :G_COD;
END;
/

SELECT * FROM PRODUSE;

BEGIN
ROLLBACK;
END;
/
