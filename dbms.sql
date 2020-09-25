select m.member_id, m.first_name,m.last_name,t.title,(select count (r.title_id)
                                                        from rental r
                                                        where r.member_id=m.member_id
                                                        and r.title_id=t.title_id)
from member m,title t
order by 1;
--
create table sept_and(id number not null,data date,nr number);

declare 
d date :=to_date('01/09/2019','dd/mm/yyyy');
n number := 30;
v_nr number;
begin
    for i in 1..n loop
        select count(*)
        into v_nr
        from rental
        where to_char(book_date,'dd/mm/yyyy')=to_char(d,'dd/mm/yyyy');
        
        insert into sept_and values(i,d,v_nr);
        d:=d+1;
    end loop;
end;
--
declare 
v_nume varchar2(30):='&p_nume';
v_verif varchar2(30);
v_nr number :=0;
v_tot number:=0;
begin 
    select first_name
    into v_verif
    from member 
    where upper(first_name)=upper(v_nume);
    
    select count(*)
    into v_tot
    from title;
    
    select count(distinct title_id)
    into v_nr
    from rental r,member m
    where r.member_id=m.member_id
    and upper(m.first_name)=upper(v_nume);
    
    if v_nr>=0.75*v_tot then dbms_output.put_line('A imprumutat '|| v_nr || ' si este categoria 1');
                                v_cat:=10; 
    elsif v_nr>=0.5*v_tot then dbms_output.put_line('A imprumutat '|| v_nr || ' si este categoria 2');
                                v_cat:=5; 
    elsif v_nr>=0.25*v_tot then dbms_output.put_line('A imprumutat '|| v_nr || ' si este categoria 3');
                                v_cat:=3; 
    else dbms_output.put_line('A imprumutat '|| v_nr || ' si este categoria 4');
        v_cat:=0; 
    end if;
    
    update member_and set discount=v_cat where upper(first_name)=upper(v_nume);
    
exception 
when no_data_found then dbms_output.put_line('Membrul nu exista');
when too_many_rows then dbms_output.put_line('Prea multi membrii');
end;
--
DECLARE   
TYPE tablou_indexat IS TABLE OF NUMBER INDEX BY PLS_INTEGER;   --are indici numere reale
t    tablou_indexat; 
BEGIN 
-- punctul a   
FOR i IN 1..10 LOOP     
    t(i):=i;   
END LOOP;   
DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');   
FOR i IN t.FIRST..t.LAST LOOP       
    DBMS_OUTPUT.PUT(t(i) || ' ');    
END LOOP;   
DBMS_OUTPUT.NEW_LINE; 

 
-- punctul b   
FOR i IN 1..10 LOOP     
    IF i mod 2 = 1 THEN 
        t(i):=null;      
    END IF;   
END LOOP;   
DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
FOR i IN t.FIRST..t.LAST LOOP       
    DBMS_OUTPUT.PUT(nvl(t(i), 0) || ' ');    
END LOOP;   
DBMS_OUTPUT.NEW_LINE;

 
-- punctul c   
t.DELETE(t.first);   
t.DELETE(5,7);   
t.DELETE(t.last);   
DBMS_OUTPUT.PUT_LINE('Primul element are indicele ' || t.first || ' si valoarea ' || nvl(t(t.first),0));   
DBMS_OUTPUT.PUT_LINE('Ultimul element are indicele ' || t.last || ' si valoarea ' || nvl(t(t.last),0));   
DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');   
FOR i IN t.FIRST..t.LAST LOOP      
    IF t.EXISTS(i) THEN          
        DBMS_OUTPUT.PUT(nvl(t(i), 0)|| ' ');    
    END IF;   
END LOOP;   
DBMS_OUTPUT.NEW_LINE; 

 
-- punctul d   
t.delete;   
DBMS_OUTPUT.PUT_LINE('Tabloul are ' || t.COUNT ||' elemente.'); 
END;
--
CREATE OR REPLACE TYPE subordonati_vasu AS VARRAY(10) OF NUMBER(4);
/

CREATE TABLE manageri_vasu (cod_mgr NUMBER(10),
                            nume VARCHAR2(20),
                            lista subordonati_vasu);
DECLARE
v_sub subordonati_vasu:= subordonati_vasu(100,200,300);
v_lista manageri_vasu.lista%TYPE;
BEGIN
    INSERT INTO manageri_vasu
    VALUES (1, 'Mgr 1', v_sub);
    
    INSERT INTO manageri_vasu
    VALUES (2, 'Mgr 2', null);
    
    INSERT INTO manageri_vasu
    VALUES (3, 'Mgr 3', subordonati_vasu(400,500));
    
    SELECT lista
    INTO v_lista
    FROM manageri_vasu
    WHERE cod_mgr=1;
    
    FOR j IN v_lista.FIRST..v_lista.LAST loop
    DBMS_OUTPUT.PUT_LINE (v_lista(j));
    END LOOP;
END;
--
DECLARE   
TYPE vector IS VARRAY(5) OF NUMBER;  
vect vector:= vector();
vect_salary vector:= vector();
begin
    select employee_id
    bulk collect into vect
    from
        (
        select  employee_id
        from emp_vasu
        where commission_pct is null
        order by salary asc
        )
    where rownum <=5;
    
    
    FOR i IN vect.FIRST..vect.LAST LOOP      
    DBMS_OUTPUT.PUT_line(vect(i) || ' ');
    end loop;
    
    DBMS_OUTPUT.PUT_line('Salariile vechi: ');
    
    
    FOR i IN vect.FIRST..vect.LAST LOOP 
        vect_salary.extend();
        
        select salary 
        into vect_salary(i)
        from emp_vasu
        where employee_id=vect(i);
    end loop;
    
    FOR i IN vect_salary.FIRST..vect_salary.LAST LOOP      
    DBMS_OUTPUT.PUT_line(vect_salary(i) || ' ');
    end loop;
    
    FOR i IN vect.FIRST..vect.LAST LOOP
        
        update emp_vasu
        set salary=salary+(5/100)*salary
        where employee_id=vect(i);
        
        vect_salary(i):=vect_salary(i)+(5/100)*vect_salary(i);
    end loop;
    DBMS_OUTPUT.PUT_line('Salariile noi: ');
    FOR i IN vect_salary.FIRST..vect_salary.LAST LOOP      
    DBMS_OUTPUT.PUT_line(vect_salary(i) || ' ');
    end loop;
   
end;
--
CREATE OR REPLACE TYPE tip_orase_vasu AS VARRAY(10) OF varchar2(20);

CREATE TABLE excursie_vasu (cod_excursie NUMBER(4), 
                            denumire VARCHAR2(20), 
                            orase tip_orase_vasu,
                            status varchar2(10));
declare
v1 tip_orase_vasu:=tip_orase_vasu('brasov','ploiesti','sibiu','bucuresti','iasi');
v2 tip_orase_vasu:=tip_orase_vasu('iasi','sibiu','oradea','timisoara','tulcea');
v3 tip_orase_vasu:=tip_orase_vasu('oradea','craiova','constanta','timisoara','tulcea');
v4 tip_orase_vasu:=tip_orase_vasu('buzau','sibiu','pitesti','cluj','brasov');
v5 tip_orase_vasu:=tip_orase_vasu('cluj','arad','alba','timisoara','constanta');
aux tip_orase_vasu:=tip_orase_vasu();
varo varchar2(20);
vari number(10);

cursor c is
        select denumire,orase
        from excursie_vasu
        order by 1;
cursor c1 is
select cod_excursie,denumire,orase
from excursie_vasu;
begin
--a    
--    INSERT INTO excursie_vasu   VALUES (1, 'ex1', v1,'disp');
--    INSERT INTO excursie_vasu   VALUES (2, 'ex2', v2,'disp');
--    INSERT INTO excursie_vasu   VALUES (3, 'ex3', v3,'disp');
--    INSERT INTO excursie_vasu   VALUES (4, 'ex4', v4,'disp');
--    INSERT INTO excursie_vasu   VALUES (5, 'ex5', v5,'disp');

--b1
--    select orase
--    into aux
--    from excursie_vasu
--    where denumire='ex1';
--    aux.extend();
--    aux(aux.last):='pitesti';
    
--    update excursie_vasu
--    set orase=aux
--    where denumire='ex1';

--b2    
/*    select orase
    into aux
    from excursie_vasu
    where denumire='ex2';
    
    aux.extend();
    
    for i in reverse 2..(aux.last)-1 loop
        aux(i+1):=aux(i);
    end loop;
    
    aux(2):='braila';
    
    update excursie_vasu
    set orase=aux
    where denumire='ex2';
*/
--b4
/*    select orase
    into aux
    from excursie_vasu
    where denumire='ex3';
    
    varo:='constanta';
    
    for i in aux.first..aux.last loop
        if aux(i)=varo then
            vari:=i;
            DBMS_OUTPUT.PUT_line(i);
            
        end if;
    end loop;
    
    for i in vari..(aux.last-1) loop
        aux(i):=aux(i+1);
    end loop;
    
    aux.trim();
    
    update excursie_vasu
    set orase=aux
    where denumire='ex3';
*/
--d
/*for r in c loop
    DBMS_OUTPUT.PUT_LINE('Excursia '||r.denumire);
    for i in 1..r.orase.last loop
        DBMS_OUTPUT.PUT_LINE(r.orase(i));
    end loop;
end loop;*/
--e
vari:=999;
for r in c loop
        aux:=r.orase;
        if aux.last()<vari then
            vari:=aux.last;
        end if;
end loop;

for r in c1 loop
    aux:=r.orase;
    if aux.last()=vari then
        update excursie_vasu e
        set e.status='anulata'
        where r.cod_excursie=e.cod_excursie;
    end if;
end loop;


end;
--
DECLARE
CURSOR c IS
            SELECT department_name nume, COUNT(employee_id) nr
            FROM departments d, employees e
            WHERE d.department_id=e.department_id(+)
            GROUP BY department_name;
BEGIN
FOR i in c LOOP
    IF i.nr=0 THEN
        DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume||
        ' nu lucreaza angajati');
    ELSIF i.nr=1 THEN
        DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume ||
        ' lucreaza un angajat');
    ELSE
        DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume||
        ' lucreaza '|| i.nr||' angajati');
    END IF;
END LOOP;
END;
--
DECLARE
v_cod employees.employee_id%TYPE;
v_nume employees.last_name%TYPE;
v_nr NUMBER(4);
CURSOR c IS
            SELECT sef.employee_id cod, MAX(sef.last_name) nume,
            count(*) nr
            FROM employees sef, employees ang
            WHERE ang.manager_id = sef.employee_id
            GROUP BY sef.employee_id
            ORDER BY nr DESC;
BEGIN
OPEN c;
LOOP
FETCH c INTO v_cod,v_nume,v_nr;
EXIT WHEN c%ROWCOUNT>3 OR c%NOTFOUND;
DBMS_OUTPUT.PUT_LINE('Managerul '|| v_cod ||
' avand numele ' || v_nume ||
' conduce ' || v_nr||' angajati');
END LOOP;
CLOSE c;
END;
--
DECLARE
v_nr number(4);
v_job_id jobs.job_id%TYPE;
v_job_title jobs.job_title%TYPE;
v_first_name employees.first_name%TYPE;
v_last_name employees.last_name%TYPE;
v_salary employees.salary%TYPE;
v_job_id2 employees.job_id%TYPE;

CURSOR c1 IS
SELECT job_id, job_title
FROM jobs;

cursor c2 is
select first_name,last_name,salary,job_id
from employees;

BEGIN
OPEN c1;
LOOP
    FETCH c1 INTO v_job_id,v_job_title;
    EXIT WHEN c1%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('------------------------------');
    DBMS_OUTPUT.PUT_LINE('Jobul '|| v_job_title||
    ' are urmatorii angajati');
    open c2;
    loop
        fetch c2 into v_first_name,v_last_name,v_salary,v_job_id2;
        exit when c2%notfound;
        
        if v_job_id=v_job_id2 then
            DBMS_OUTPUT.PUT_LINE(v_first_name||' '||v_last_name||' '||v_salary);
        end if;    
    end loop;
    close c2;
END LOOP;
CLOSE c1;
END;
--b. ciclu cursoare 
DECLARE

CURSOR c1 IS
SELECT job_id, job_title
FROM jobs;

cursor c2 is
select first_name,last_name,salary,job_id
from employees;

BEGIN

for i in c1 loop
    
    
    DBMS_OUTPUT.PUT_LINE('------------------------------');
    DBMS_OUTPUT.PUT_LINE('Jobul '|| i.job_title||
    ' are urmatorii angajati');
    for j in c2 loop
        
        if i.job_id=j.job_id then
            DBMS_OUTPUT.PUT_LINE(j.first_name||' '||j.last_name||' '||j.salary);
        end if;    
    end loop;
    
END LOOP;

END;
--c. ciclu cursoare cu subcereri 

DECLARE

CURSOR c1 IS
SELECT job_id, job_title
FROM jobs;

cursor c2 is
select first_name,last_name,salary,job_id
from employees;

BEGIN

for i in (SELECT job_id, job_title
            FROM jobs) loop
    
    
    DBMS_OUTPUT.PUT_LINE('------------------------------');
    DBMS_OUTPUT.PUT_LINE('Jobul '|| i.job_title||
    ' are urmatorii angajati');
    for j in (select first_name,last_name,salary,job_id
                from employees) loop
        
        if i.job_id=j.job_id then
            DBMS_OUTPUT.PUT_LINE(j.first_name||' '||j.last_name||' '||j.salary);
        end if;    
    end loop;
    
END LOOP;

END;
--d. expresii cursor
DECLARE
TYPE refcursor IS REF CURSOR;
CURSOR c1 IS
            SELECT job_id,job_title,
                                CURSOR (select first_name,last_name,
                                                salary,job_id
                                            from employees e
                                            WHERE j.job_id=e.job_id)

            FROM jobs j;

c2 refcursor;

v_job_id jobs.job_id%TYPE;
v_job_title jobs.job_title%TYPE;
v_first_name employees.first_name%TYPE;
v_last_name employees.last_name%TYPE;
v_salary employees.salary%TYPE;
v_job_id2 employees.job_id%TYPE;

BEGIN
    OPEN c1;
    LOOP
        FETCH c1 INTO v_job_id, v_job_title,c2;
        EXIT WHEN c1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('------------------------------');
        DBMS_OUTPUT.PUT_LINE('Jobul '|| v_job_title||
        ' are urmatorii angajati');
        LOOP
            FETCH c2 INTO v_first_name,v_last_name,v_salary,v_job_id2;
            EXIT WHEN c2%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE (v_first_name||' '||v_last_name||' '||v_salary);
        END LOOP;
        
    END LOOP;
    CLOSE c1;
END;
--
CREATE OR REPLACE FUNCTION f2_vasu
(v_nume employees.last_name%TYPE DEFAULT 'Bell')
RETURN NUMBER IS salariu employees.salary%type;
BEGIN
    SELECT salary INTO salariu
    FROM employees
    WHERE last_name = v_nume;
    
    RETURN salariu;
END f2_vasu;

declare
v_user varchar2(25);
begin
    select user
    into v_user
    from dual;
    
    DBMS_OUTPUT.PUT_LINE(f2_vasu('Bell'));
    
    insert into info_vasu 
    values (v_user,sysdate,'f2',1,'Nu are erori');
    
    exception
    WHEN NO_DATA_FOUND THEN
    insert into info_vasu 
    values (v_user,sysdate,'f2',0,'Nu exista angajati cu numele dat');
    
    WHEN TOO_MANY_ROWS THEN
    insert into info_vasu 
    values (v_user,sysdate,'f2',2,'Exista mai multi angajati cu numele dat');
    
     WHEN others THEN
    insert into info_vasu 
    values (v_user,sysdate,'f2',3,'Alta eroare!');
end;
--
CREATE OR REPLACE FUNCTION ex3_vasu (v_oras locations.city%TYPE)     
RETURN NUMBER IS nr_ang; 
declare
Ex Exception;
BEGIN     
    SELECT count(jh.employee_id) 
    INTO nr_ang      
    FROM   employees e,locations l,departments d    
    WHERE  e.department_id=d.department_id
    and  d.location_id=l.location_id
    and  l.city = v_oras
    and e.employee_id in (select e2.employee_id
                        from job_history jh2,employees e2
                        where jh2.employee_id=e.employee_id
                        having count(distinct jh2.job_id)>=2);
     if nr_ang=0 then
        insert into info_vasu values (v_user,sysdate,'ex3_vasu',1,'nu are erori');
        
    
    RETURN nr_ang;
    
    --EXCEPTION     
      --  WHEN NO_DATA_FOUND THEN 
       -- RAISE_APPLICATION_ERROR(-20000,'Nu exista angajati');     
      --  WHEN TOO_MANY_ROWS THEN        
      --  RAISE_APPLICATION_ERROR(-20001,'Exista mai multi angajati');     
      --  WHEN OTHERS THEN        
      --  RAISE_APPLICATION_ERROR(-20002,'Alta eroare!'); 
END ex3_vasu;

begin
    select user
    into v_user
    from dual;
    
    DBMS_OUTPUT.PUT_LINE(f2_vasu('Roma'));
    
    insert into info_vasu values (v_user,sysdate,'ex3_vasu',1,'nu are erori');
  
    exception
    WHEN NO_DATA_FOUND THEN
    insert into info_vasu 
    values (v_user,sysdate,'f2',0,'Nu exista angajati cu numele dat');
    
    WHEN TOO_MANY_ROWS THEN
    insert into info_vasu 
    values (v_user,sysdate,'f2',2,'Exista mai multi angajati cu numele dat');
    
     WHEN others THEN
    insert into info_vasu 
    values (v_user,sysdate,'f2',3,'Alta eroare!');


SELECT count(jh.employee_id)      
    FROM   employees e,locations l,job_history jh,departments d    
    WHERE  e.department_id=d.department_id
    and  d.location_id=l.location_id
    and jh.employee_id=e.employee_id
    and (select count(jh2.employee_id)
            from job_history jh2
            where jh2.employee_id=e.employee_id)>=2
    and l.city='Seattle';
--
create sequence sec_ex1_vasu
start with 300
increment by 1
maxvalue 500
minvalue 300;

CREATE OR REPLACE PACKAGE pachetex1_vasu AS
    PROCEDURE p_ad_ang (v_nume emp_vasu.last_name%type,
                        v_prenume emp_vasu.first_name%type,
                        v_telefon emp_vasu.phone_number%TYPE,
                        v_email emp_vasu.email%TYPE);
                
    FUNCTION f_min_sal (v_dep dept_vasu.department_id%TYPE,
                        v_job emp_vasu.job_id%type) RETURN NUMBER;
                        
    FUNCTION f_manager (v_nume emp_vasu.last_name%TYPE,
                        v_prenume emp_vasu.first_name%type) RETURN NUMBER;
                        
    FUNCTION f_cod_dept (v_nume_dept dept_vasu.department_name%TYPE) RETURN NUMBER;
    
    FUNCTION f_cod_job (v_nume_job jobs.job_title%TYPE) RETURN NUMBER;
    
END pachetex1_vasu;

CREATE OR REPLACE PACKAGE BODY pachetex1_vasu AS
FUNCTION f_min_sal (v_dep dept_vasu.department_id%TYPE,
                        v_job emp_vasu.job_id%type) RETURN NUMBER is minim number;
    BEGIN
        SELECT min(salary)
        INTO minim
        FROM employees e
        WHERE e.job_id=v_job
        AND e.department_id=v_dept;
        
    RETURN minim;
END f_min_sal;

FUNCTION f_manager (v_nume emp_vasu.last_name%TYPE,
                    v_prenume emp_vasu.first_name%type) RETURN NUMBER is cod_manager number;
    BEGIN
        SELECT man.employee_id
        INTO cod_manager
        FROM employees ang,employees man
        WHERE ang.manager_id=man.employee_id
        and upper(man.first_name)=upper(v_prenume)
        and upper(man.last_name)=upper(v_nume);
        
    RETURN cod_manager;
END f_manager;
    
PROCEDURE p_ad_ang (v_nume emp_vasu.last_name%type,
                        v_prenume emp_vasu.first_name%type,
                        v_telefon emp_vasu.phone_number%TYPE,
                        v_email emp_vasu.email%TYPE)
AS
BEGIN
INSERT INTO emp_vasu
VALUES (sec_vasu.NEXTVAL, v_first_name, v_last_name, v_email,
v_phone_number,v_hire_date, v_job_id, v_salary,
v_commission_pct, v_manager_id,v_department_id);
END p_emp;

END pachetex1_vasu;
--
CREATE OR REPLACE TRIGGER trig6_vasuex1
 BEFORE DELETE ON dept_vasu
BEGIN
    IF USER!= UPPER('SCOTT') THEN
        RAISE_APPLICATION_ERROR(-20900,'Nu esti Scott!');
    END IF;
END;
--
CREATE OR REPLACE TRIGGER trig_vasuex2
BEFORE UPDATE OF commission_pct ON emp_vasu
FOR EACH ROW
BEGIN
IF(:NEW.commission_pct>=0.5)
THEN
RAISE_APPLICATION_ERROR(-20001,'Noul comision depaseste 50% din salariu');
END IF;
END;
--
--SET SERVEROUTPUT ON
--SET VERIFY OFF
--ACCEPT p_loc PROMPT 'Dati locatia: '
DECLARE
    
    v_loc dept_vasu.location_id%TYPE := &tas;
    v_nume dept_vasu.department_name%TYPE;
BEGIN
    SELECT department_name
    INTO v_nume
    FROM dept_vasu
    WHERE location_id = v_loc;
    
    DBMS_OUTPUT.PUT_LINE('In locatia '|| v_loc ||
    ' functioneaza departamentul '||v_nume);
EXCEPTION
WHEN NO_DATA_FOUND THEN
INSERT INTO error_vasu
VALUES ( -20002, 'nu exista departamente in locatia data');
DBMS_OUTPUT.PUT_LINE('a aparut o exceptie ');
WHEN TOO_MANY_ROWS THEN
INSERT INTO error_vasu
VALUES (-20003,'exista mai multe departamente in locatia data');
DBMS_OUTPUT.PUT_LINE('a aparut o exceptie ');
WHEN OTHERS THEN
INSERT INTO error_vasu (mesaj)
VALUES ('au aparut alte erori');
END;
--
SET SERVEROUTPUT ON
SET VERIFY OFF
ACCEPT p_sal PROMPT 'Dati salariul: '
DECLARE
v_sal number:= &p_sal;
v_nume employees.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO v_nume
    FROM emp_vasu
    WHERE salary= v_sal;
    
    DBMS_OUTPUT.PUT_LINE('Salariul de '|| v_sal ||
    ' il are '||v_nume);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        INSERT INTO error_vasu
        VALUES ( -20002, 'nu exista salariati care sa castige acest salariu');
        DBMS_OUTPUT.PUT_LINE('nu exista salariati care sa castige acest salariu');
    WHEN TOO_MANY_ROWS THEN
        INSERT INTO error_vasu
        VALUES (-20003,'exista mai mul?i salariati care castiga acest salariu');
        DBMS_OUTPUT.PUT_LINE('exista mai mul?i salariati care castiga acest salariu');
    WHEN OTHERS THEN
        INSERT INTO error_vasu (mesaj)
        VALUES ('au aparut alte erori');
        DBMS_OUTPUT.PUT_LINE('alte erori');
END;
--

DECLARE
v_dep number:= &p_dep;
v_k number;
v_id number;
exceptie_fara_ang exception;
BEGIN
    SELECT count(*)
    INTO v_k
    FROM emp_vasu
    WHERE department_id= v_dep;
    
    select department_id
    into v_id
    from dept_vasu
    where department_id=v_dep;
    
    if v_k =0 then 
    --raise_application_error(-20000,'nu are angajati');
    raise exceptie_fara_ang;
    end if;

    DBMS_OUTPUT.PUT_LINE('In dep '|| v_dep ||
    ' sunt '||v_k||' angajati');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        INSERT INTO error_vasu
        VALUES ( -20002, 'nu exista departamentul');
        DBMS_OUTPUT.PUT_LINE('nu exista dep');
    WHEN TOO_MANY_ROWS THEN
        INSERT INTO error_vasu
        VALUES (-20003,'exista mai multe dep');
        DBMS_OUTPUT.PUT_LINE('exista mai multe dep ');
    when exceptie_fara_ang then
        INSERT INTO error_vasu
        VALUES (-20004,'nu exista ang');
        DBMS_OUTPUT.PUT_LINE('nu exista ang');
    WHEN OTHERS THEN
        INSERT INTO error_vasu
        VALUES (-20005,'alta eroare');
        DBMS_OUTPUT.PUT_LINE('alta eroare');
END;
--
