set serveroutput on 
--tipuri de colectii

--tablouri indexate
set serveroutput on
declare 
type tab_index is table of angajati.nume%type index by pls_integer;
v_angajati tab_index;
begin
select nume into v_angajati(1) from angajati where id_angajat = 100;
select nume into v_angajati(5) from angajati where id_angajat = 101;
select nume into v_angajati(-1) from angajati where id_angajat = 102;
if v_angajati.exists(-1) then dbms_output.put_line(v_angajati(-1));
end if;
dbms_output.put_line(v_angajati.count);
dbms_output.put_line(v_angajati.first);
dbms_output.put_line(v_angajati.last);
dbms_output.put_line(v_angajati.prior(0));
dbms_output.put_line(v_angajati.next(2));
v_angajati.delete(-1);
dbms_output.put_line(v_angajati.count);
v_angajati.delete(1,5);
dbms_output.put_line(v_angajati.count);
end;
/


declare 
type tabela_index is table of angajati.salariul%type index by varchar2(20);
angajat tabela_index;
begin
select max(salariul) into angajat('purchasing') from angajati where id_departament = 30;
select max(salariul) into angajat('hr') from angajati where id_departament = 60;
dbms_output.put_line(angajat('hr'));
dbms_output.put_line(angajat('purchasing'));
end;
/


declare 
type tabela_index is table of angajati%rowtype index by pls_integer;
v_angajat tabela_index;
begin
for i in 101..120 loop
select * into v_angajat(i) from angajati where id_angajat = i;
end loop;
for  i in v_angajat.first..v_angajat.last loop
dbms_output.put_line(v_angajat(i).nume);
end loop;
dbms_output.put_line(v_angajat.count);
v_angajat.delete(111,120);
dbms_output.put_line(v_angajat.count);
for  i in v_angajat.first..v_angajat.last loop
dbms_output.put_line(v_angajat(i).nume);
end loop;
end;
/

--tablouri imbricate

declare 
type tab_imb is table of angajati%rowtype;
angajat tab_imb := tab_imb();
i number := 1;
begin
while i + 100 < 120 loop
angajat.extend();
select * into angajat(i) from angajati where id_angajat = i+100;
i := i + 1;
end loop;
for i in angajat.first.. angajat.last loop
dbms_output.put_line(angajat(i).nume);
end loop;
dbms_output.put_line(angajat.count);
angajat.trim(2);
dbms_output.put_line(angajat.count);
angajat.delete(2);
dbms_output.put_line(angajat.count);
dbms_output.put_line( case when angajat.exists(2) then 'da' else 'nu' end);
for i in angajat.first.. angajat.last loop
if angajat.exists(i) then
dbms_output.put_line(angajat(i).nume);
else
dbms_output.put_line('nu exista angajatul');
end if;
end loop;
end;
/


create type tip_nume is table of varchar2(100);

declare
    -- Folosim tipul creat la nivel de schema, nu unul local si initializam tabloul
    v_nume_angajati tip_nume := tip_nume();
    i number := 1;
begin
    while i + 100 <= 120 loop
        v_nume_angajati.extend();
        -- Adugare nume angajat in elementul curent al tabloului
        select nume into v_nume_angajati(i) from angajati where id_angajat = i + 100;
        i := i + 1;
    end loop;
    
    -- Afisare toate numele stocate, parcurgand de la primul la ultimul index
    for i in v_nume_angajati.first..v_nume_angajati.last loop
        dbms_output.put_line(v_nume_angajati(i));
    end loop;
end;
/

DROP TYPE tip_nume;

create table ang ( id number(5), nume_ang tip_nume)nested table nume_ang store as nume_ang_nt;
insert into ang values( 1, tip_nume('ion', 'ana', 'maria'));
commit;

select * from ang;

select a.id, t.column_value  from ang a, table(nume_ang) t where a.id = 1;

--vectori de lungime variabila 

declare 
type vector is varray(20) of angajati%rowtype;
ang vector := vector();
i number := 1;
begin
while i + 100 < 120 loop
ang.extend();
select * into ang(i) from angajati where id_angajat = i+100;
i := i +1;
end loop;
for i in ang.first..ang.last loop
if ang.exists(i) then  dbms_output.put_line(ang(i).nume);
else
NULL;
end if;
end loop;
 dbms_output.put_line(ang.count);
 ang.trim(2);
  dbms_output.put_line(ang.count);
  ang.delete;
   dbms_output.put_line(ang.limit);
   end;
   /

