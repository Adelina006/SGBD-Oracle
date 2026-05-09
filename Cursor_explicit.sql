--CURSOR EXPLICIT
set serveroutput on

--Se afişează printr-un ciclu FOR numele şi salariile angajaţilor din departamentul 60:
declare
cursor ang_cursor is select id_angajat, nume, salariul from angajati where id_departament = 60;
begin
for ang_rec in ang_cursor loop
dbms_output.put_line(ang_rec.id_angajat || ' '|| ang_rec.nume||' '|| ang_rec.salariul);
end loop;
end;
/


--Să se afişeze suma aferentă salariilor din fiecare departament:
declare
begin
for dep_rec in (select d.id_departament as departament, sum(a.salariul)as suma from departamente d left join angajati a 
on d.id_departament = a.id_departament group by d.id_departament) loop
dbms_output.put_line(dep_rec.departament|| ' '|| nvl(dep_rec.suma, 0));
end loop;
end;
/

select * from rand_comenzi;
--Să se afişeze produsele al căror cantitate totală comandată este mai mare decât o valoare primită drept parametru.
declare 
cursor prod_cursor(p_val number) is select p.id_produs as id, p.denumire_produs as nume, sum(r.cantitate) as cantitate
from produse p left join rand_comenzi r on p.id_produs =r.id_produs group by p.id_produs, p.denumire_produs
having sum(r.cantitate) > p_val;

v_num number;
prod_rec prod_cursor%rowtype;
begin
v_num := 100;
if not prod_cursor%isopen then open prod_cursor(v_num);
end if;
loop
fetch prod_cursor into prod_rec;
exit when prod_cursor%notfound;
dbms_output.put_line(prod_rec.id|| ' '||prod_rec.nume|| ' '||prod_rec.cantitate);
end loop;
close prod_cursor;
end;
/


select * from comenzi ;
--Să se afişeze pentru fiecare comanda produsele comandate. În acest caz se utilizează două 
--variabile de tip cursor. Vom folosi parcurgerea cursorului cu FOR:
declare 
cursor comenzi_cursor is select id_comanda as id, modalitate from comenzi order by id_comanda;
cursor produse_cursor(v_comanda number) is select p.id_produs, p.denumire_produs from produse p left join rand_comenzi r on 
p.id_produs = r.id_produs where r.id_comanda = v_comanda;
begin
for comenzi_rec in comenzi_cursor loop
dbms_output.put_line(comenzi_rec.id || ' '|| comenzi_rec.modalitate);
for produse_rec in produse_cursor(comenzi_rec.id) loop
dbms_output.put_line('        ' ||produse_rec.id_produs|| ' '|| produse_rec.denumire_produs);
end loop;
end loop;
end;
/


select * from rand_comenzi;
--Se creează tabela Situatie care pastreaza informatii despre comenzi: codul,
--valoarea comenzii. Se adaugă în aceasta coloana TVA, care va păstra valoarea TVA 
--pentru fiecare comandă. Se creează un cursor căruia i se adaugă clauza FOR UPDATE pentru 
--a bloca liniile afectate din tabelă, atunci când cursorul este deschis,
--iar pentru fiecare comandă din cursor se va calcula valoarea TVA.

drop table situatie;
create table situatie as select c.id_comanda as cod , sum(r.pret * r.cantitate) as valoare 
from comenzi c left join rand_comenzi r  on c.id_comanda = r.id_comanda group by c.id_comanda;

alter table situatie add( tva number(10));

declare
cursor tva_cursor is select cod, valoare, tva from situatie for update of tva nowait;
begin
for tva_rec in tva_cursor loop
update situatie set tva = valoare * 0.19
where cod = tva_rec.cod;
end loop;
end;
/

select * from situatie;

--1.	Folosind un cursor cu parametru, afișați toți angajații și sub fiecare angajat, comenzile încheiate de către acesta. 
declare 
cursor comenzi_cursor(nr_angajat number) is select id_comanda, modalitate from comenzi where id_angajat = nr_angajat ;
cursor angajati_cursor is select id_angajat, nume, prenume from angajati;
begin 
for angajat_rec in angajati_cursor loop
dbms_output.put_line(angajat_rec.id_angajat||' '||angajat_rec.nume || ' ' ||angajat_rec.prenume);
for comanda_rec in comenzi_cursor(angajat_rec.id_angajat) loop
dbms_output.put_line('      '|| comanda_rec.id_comanda|| ' '|| comanda_rec.modalitate);
end loop;
end loop;
end;
/

--2.	Afișați informații despre primele 3 comenzi care au cea mai mare valoare
declare 
cursor comenzi_cursor is select c.id_comanda, c.modalitate, sum(r.pret * r.cantitate) as valoare
from comenzi c left join rand_comenzi r on c.id_comanda = r.id_comanda group by c.id_comanda, c.modalitate
order by valoare desc;
begin
for comanda_rec in comenzi_cursor loop
dbms_output.put_line(comanda_rec.id_comanda||' ' || comanda_rec.modalitate||' ' || comanda_rec.valoare);
exit when comenzi_cursor%rowcount >= 3;
end loop;
end;
/

--3.	Afişaţi informaţii despre primii 5 salariaţi angajaţi (se va realiza filtrarea în funcție de câmpul Data_Angajare).
declare 
cursor angajati_cursor is select id_angajat, nume, prenume, data_angajare from angajati order by data_angajare ;
begin
for angajat_rec in angajati_cursor loop
dbms_output.put_line(angajat_rec.id_angajat||' ' || angajat_rec.nume||' '|| angajat_rec.prenume|| ' '|| angajat_rec.data_angajare);
exit when angajati_cursor%rowcount >= 5 or angajati_cursor%notfound;
end loop;
end;
/



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