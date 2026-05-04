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

declare 
cursor angajat is select nume, salariul from angajati where id_departament = 60;
v_nume angajati.nume%type;
v_salariul angajati.salariul%type;
begin
open angajat;
loop
fetch angajat into v_nume, v_salariul;
exit when angajat%notfound;
dbms_output.put_line(v_nume || ' '|| v_salariul);
exit when angajat%notfound;
end loop;
close angajat;
end;
/

set serveroutput on
declare
cursor ang_cursor is select id_angajat, nume, salariul from angajati where id_departament=60;
--tipul record definit cu %ROWTYPE pt incarcarea valorilor cursorului
ang_rec ang_cursor%rowtype;
begin
dbms_output.put_line('Lista cu salariariile angajatilor din departamentul 60');
open ang_cursor;
loop
fetch ang_cursor into ang_rec;
exit when ang_cursor%notfound;
dbms_output.put_line('Salariatul '||ang_rec.nume||' are salariul: '||ang_rec.salariul);
end loop;
close ang_cursor;
end;
/

--Să se încarce în tabela MESAJE primii 5 angajaţi (id şi nume)
drop table mesaje;
create table mesaje (id number(5), nume varchar2(30));

declare 
cursor c1 is select id_angajat, nume from angajati ;
angajat c1%rowtype;
begin
open c1;
for i in 1..5 loop
fetch c1 into angajat;
EXIT WHEN c1%ROWCOUNT>5 OR c1%NOTFOUND;
insert into mesaje values(angajat.id_angajat, angajat.nume);
end loop;
close c1;
end;
/

select * from mesaje;

--Să se afişeze primele 3 comenzi care au cele mai multe produse comandate. În acest caz înregistrările vor fi ordonate descrescător în funcţie de numărul produselor comandate
declare 
cursor comenzi is select c.id_comanda, cast(c.data as date) as data, count(r.id_produs) as nr_produse from comenzi c join rand_comenzi r on c.id_comanda = r.id_comanda
group by c.id_comanda, data
order by nr_produse DESC;
comanda comenzi%rowtype;
begin
open comenzi;
loop
fetch comenzi into comanda;
exit when comenzi%rowcount >3 or comenzi%notfound;
dbms_output.put_line(comanda.id_comanda || ' '|| comanda.nr_produse );
end loop;
end;
/

SET SERVEROUTPUT ON

DECLARE
CURSOR c_com IS 
select c.id_comanda, cast (c.data as date) data, count(r.id_produs) Numar
from comenzi c, rand_comenzi r 
where c.id_comanda=r.id_comanda
group by c.id_comanda, c.data
order by count(r.id_produs) desc;

rec_com c_com%rowtype;

BEGIN
DBMS_OUTPUT.PUT_LINE('Numarul de produse pentru fiecare comanda:');
IF NOT c_com%ISOPEN THEN 
OPEN c_com;
END IF;
LOOP
FETCH c_com INTO rec_com;
EXIT WHEN c_com%NOTFOUND OR c_com%ROWCOUNT>3;
DBMS_OUTPUT.PUT_LINE('Comanda '||rec_com.id_comanda||' data pe '||rec_com.data||' are: '||rec_com.numar||' produse');
END LOOP;
CLOSE c_com;
END;
/




