select department_name
from departments
where location_id=1700 and manager_id is not null;
--
select distinct department_id
from employees
where department_id is not null order by department_id;
--
select last_name,first_name
from employees
where hire_date>=to_date('1.06.1987','dd.mm.yyyy')and hire_date<to_date('1.07.1987','dd.mm.yyyy');
--
select employee_id
from job_history order by employee_id desc;
--
select last_name,first_name,hire_date
from employees
where department_id=80 and hire_date>=to_date('1.03.1997','dd.mm.yyyy')and hire_date<to_date('1.04.1997','dd.mm.yyyy');
--
select job_title
from jobs
where max_salary>=8000;
--
select distinct min_salary,max_salary
from jobs
where 10000>=min_salary and 10000<=max_salary;
--sau
desc job_grades
select * from job_grades;

select * from job_grades where 10000 between lowest_sal and highest_sal;
--
select last_name,first_name
from employees
where upper(concat(last_name,first_name)) like '%L%L';
--
select *
from employees
where manager_id=123;
--
select last_name,first_name,commission_pct,salary+commission_pct*salary as "venit lunar total"
from employees
where commission_pct is not null and commission_pct<=0.25;
--
update employees set first_name=first_name||'50%mere'
where first_name='Peter';
--
select first_name,last_name
from employees
where first_name like '%50\%%' escape '\';
--
update employees set first_name=first_name||'50_200'
where first_name='Peter50%mere';
--
select first_name,last_name
from employees
where first_name like '%50\_%' escape '\';
--
SELECT last_name,first_name,nvl(to_char(department_id),'fara departament')
FROM employees;

SELECT last_name,first_name,nvl(department_id,0)
FROM employees;

--
select trunc(avg(commission_pct),10)
from employees
where commission_pct!=0;

--
select last_name,first_name
from employees
where manager_id is null;

SELECT last_name,first_name,nvl(to_char(manager_id),'fara manager')
FROM employees;

--
SELECT last_name,first_name,nvl2(commission_pct,12*salary,salary)
FROM employees;

--
SELECT last_name,first_name,nullif(length(last_name),length(first_name))
FROM employees;

--
select last_name,first_name,
        case when length(last_name)=length(first_name)then 'valori egale'
            else to_char(length(last_name)) end as "conditie"
from employees;
        
--
select last_name,first_name,salary,
        case when months_between(hire_date,sysdate)>200 then salary+0.2*salary
            when months_between(hire_date,sysdate)>150 then salary+0.15*salary
            when months_between(hire_date,sysdate)>100 then salary+0.1*salary
            else salary+0.05*salary end "salariu revizuit"
from employees;
--
SELECT e.last_name,e.first_name,e.department_id
from employees e,departments d
where commission_pct is not null
and e.department_id=d.department_id;
--
SELECT distinct job_title
from jobs j,employees e
where j.job_id=e.job_id
and e.department_id=30;
--
SELECT last_name, department_name 
FROM   employees e, departments d 
WHERE  e.department_id = d.department_id(+);
--
SELECT last_name,first_name, department_name 
FROM   employees e, departments d 
WHERE  e.department_id(+) = d.department_id;
--
SELECT e.last_name,e.first_name,d.department_name 
FROM   employees e full outer join departments d  
on  e.department_id = d.department_id;
--
SELECT e.last_name,e.first_name,j.job_title,d.department_name,e.salary,g.grade_level,g.lowest_sal,g.highest_sal
FROM   employees e,departments d,jobs j,job_grades g  
where e.department_id = d.department_id
and e.job_id=j.job_id
and e.salary between g.lowest_sal and g.highest_sal;
--
SELECT e.last_name "angajat nume",e.first_name "angajat prenume",e.hire_date "angajat data angajare",nvl(m.last_name,'nu are sef') "sef nume",m.first_name "sef prenume",m.hire_date "sef data angajarii"
FROM   employees e,employees m 
where e.manager_id=m.employee_id(+)
and e.hire_date < nvl(m.hire_date,sysdate);
--
SELECT e.last_name "angajat nume",e.first_name "angajat prenume",e.department_id "angajat cod depart",
c.last_name,c.first_name,c.department_id
FROM   employees e,employees c
where e.department_id=c.department_id
and e.department_id in (20,30) 
and e.employee_id!=c.employee_id
order by e.last_name,e.first_name;
--
SELECT  last_name, salary 
FROM    employees 
WHERE   last_name != 'Fay' 
AND     department_id = (SELECT department_id                          
                        FROM employees                          
                        WHERE last_name = 'Fay');
--
SELECT last_name, salary, commission_pct, department_id 
FROM   employees
WHERE (salary, commission_pct) IN (SELECT salary, commission_pct        
                                    FROM   employees e, departments d        
                                    WHERE  e.department_id = d.department_id 
                                    AND    department_name = 'Sales') 
AND    department_id != (SELECT department_id 
                        FROM   departments                           
                        WHERE  department_name = 'Sales');
--
SELECT a.employee_id "CodAng", a.last_name "NumeAng",b.employee_id "CodMgr", b.last_name "NumeMgr",c.employee_id "CodMgrMgr", c.last_name "NumeMgrMgr"  
FROM   employees a, employees b,employees c
WHERE  a.manager_id = b. employee_id(+)
and b.manager_id = c.employee_id(+);
--
select e.first_name,e.last_name,nvl(e.salary+e.salary*e.commission_pct,e.salary),d.department_name
from employees e,departments d
where e.department_id=d.department_id
and nvl(e.salary+e.salary*e.commission_pct,e.salary)>=12000;
--
select e.employee_id,j.job_title,jh.start_date,jh.end_date,
trunc(months_between(jh.end_date,jh.start_date),3) "interval de timp"
from employees e,job_history jh,jobs j
where e.employee_id=jh.employee_id
and jh.job_id=j.job_id;
--
select e.employee_id,j.job_title "job anterior",jh.start_date,jh.end_date,
trunc(months_between(jh.end_date,jh.start_date),3) "interval de timp",
e.first_name,e.last_name,ja.job_title "job actual",ja.job_id "cod job actual"
from employees e,job_history jh,jobs j,jobs ja
where e.employee_id=jh.employee_id
and jh.job_id=j.job_id
and e.job_id=ja.job_id;
--
select e.employee_id,j.job_title "job anterior",jh.start_date,jh.end_date,
trunc(months_between(jh.end_date,jh.start_date),3) "interval de timp",
e.first_name,e.last_name,ja.job_title "job actual",ja.job_id "cod job actual",
d.department_name "departament anterior",da.department_name "departament actual"
from employees e,job_history jh,jobs j,jobs ja,departments d,departments da
where e.employee_id=jh.employee_id
and jh.job_id=j.job_id
and e.job_id=ja.job_id
and j.job_id=ja.job_id--a lucrat in trecut pe aceasi pozitie ca acum
and jh.department_id=d.department_id
and e.department_id=da.department_id;
--
select d.department_id,count(e.employee_id)
from departments d,employees e
where d.department_id=e.department_id
group by d.department_id
having count(e.employee_id)>10;
--
select first_name,last_name,count(*)"nr de joburi"
 from employees e,job_history jh
 where e.employee_id=jh.employee_id
 group by e.last_name,e.first_name
 having count(*)>=2;
--
SELECT COUNT(*) AS "Total",
SUM(DECODE(TO_CHAR(hire_date, 'yyyy'), 1997, 1, 0)) AS "1997",
SUM(DECODE(TO_CHAR(hire_date, 'yyyy'), 1998, 1, 0)) AS "1998",
SUM(DECODE(TO_CHAR(hire_date, 'yyyy'), 1999, 1, 0)) AS "1999",
SUM(DECODE(TO_CHAR(hire_date, 'yyyy'), 2000, 1, 0)) AS "2000",
SUM(DECODE(TO_CHAR(hire_date, 'yyyy'), 2000, 0,1999,0,1998,0,1997,0,1)) AS "restul anilor"
FROM employees;
--
select nvl(d.department_name,'fara dep'),nvl(j.job_title,'fara job'),
round(avg(e.salary),2),grouping(department_name),grouping(job_title)
from employees e,departments d,jobs j
where e.department_id=d.department_id(+)
and e.job_id=j.job_id(+)
group by rollup(department_name,job_title);
--
SELECT department_id, manager_id, COUNT(employee_id) 
FROM   employees  
WHERE  manager_id IS NOT NULL AND department_id IS NOT NULL 
GROUP BY CUBE (department_id, manager_id);
--
select  nvl(d.department_name,'fara dep'),nvl(j.job_title,'fara job'),
nvl(to_char(e.manager_id),'fara manager'),max(salary),sum(salary)
from employees e,departments d,jobs j
where e.department_id=d.department_id(+)
and e.job_id=j.job_id(+)
group by grouping sets((nvl(d.department_name,'fara dep'),nvl(j.job_title,'fara job')),
(nvl(j.job_title,'fara job'),nvl(to_char(e.manager_id),'fara manager')),());
--
select e.job_id,avg(e.salary)"salariu med"
from employees e
where 3>(select count(distinct avg(e2.salary))
        from employees e2
        group by e2.job_id
        having avg(e2.salary) <(select avg(e3.salary)
                                from employees e3
                                where e3.job_id=e.job_id)
        )
group by e.job_id
order by 2;
--
select *
from(
    select e.last_name,e.first_name,e.salary,e.job_id,
    rank()over (partition by e.job_id order by e.salary desc)as rang
    from employees e)
where rang<=3
order by 4,5;
--
select e.last_name,e.first_name,e.salary
from employees e
where e.salary> ALL(SELECT AVG(e2.salary)
                    FROM employees e2
                    GROUP BY e2.department_id);

select e.last_name,e.first_name,e.salary
from employees e
where e.salary> (select max(AVG(e2.salary))
                    FROM employees e2
                    GROUP BY e2.department_id); 
--
SELECT first_name, last_name, department_id
FROM employees e
WHERE MONTHS_BETWEEN(SYSDATE, hire_date) >= (SELECT MAX(MONTHS_BETWEEN(SYSDATE, hire_date))
                                              FROM employees e1
                                              WHERE e.department_id = e1.department_id
                                              );
--
select e.employee_id,e.last_name,e.first_name,ja.job_title,da.department_name,e.hire_date,jv.start_date,jvn.job_title,dvn.department_name
from employees e,jobs ja,departments da,job_history jv,jobs jvn,departments dvn
where e.employee_id=jv.employee_id
and e.job_id=ja.job_id
and e.department_id=da.department_id
and jv.job_id=jvn.job_id
and jv.department_id=dvn.department_id
order by 1;
--
select e.first_name,e.last_name,e.employee_id,e.job_id,e.department_id
from employees e,job_history jh
where e.employee_id=jh.employee_id
and e.job_id=jh.job_id
intersect
select e.first_name,e.last_name,e.employee_id,e.job_id,e.department_id
from employees e,job_history jh
where e.employee_id=jh.employee_id
and e.department_id=jh.department_id;
--
SELECT department_id   
FROM   departments       
MINUS 
SELECT DISTINCT department_id    
FROM   employees; 
--
--a) utiliz‰nd operatorul MINUS; 
SELECT employee_id
FROM employees
MINUS
SELECT e.employee_id
FROM employees e,job_history jh
where e.employee_id = jh.employee_id;
--b) utiliz‰nd operatorul NOT IN. 
SELECT employee_id
FROM employees
WHERE employee_id NOT IN(SELECT e.employee_id
                          FROM employees e,job_history jh
                          where e.employee_id = jh.employee_id);
--
SELECT employee_id, job_id, department_id
FROM employees
MINUS
SELECT e.employee_id, e.job_id, e.department_id
FROM employees e,job_history jh
where e.employee_id = jh.employee_id
and (e.job_id = jh.job_id OR e.department_id = jh.department_id);
--
select e.employee_id,e.first_name,e.last_name,count(w.project_id)
from employees e,work w
where e.employee_id=w.employee_id
and w.project_id in (select project_id
                        from projects
                        where to_char(start_date,'yyyy')='1999')
group by e.employee_id,e.first_name,e.last_name
having count(w.project_id)=(select count(project_id)
                            from projects
                            where to_char(start_date,'yyyy')='1999');
--
select level, employee_id, last_name, manager_id 
from employees e2
start with employee_id=(select e.employee_id
                        from employees e
                        where e.salary=(select min(e3.salary)
                                        from employees e3))
connect by PRIOR manager_id = employee_id;
--
select level, e.employee_id, e.last_name,e.salary,e.manager_id 
from employees e
start with e.employee_id='206'
connect by PRIOR manager_id = employee_id and e.salary>15000;
--
select level,employee_id,last_name,first_name,hire_date,salary,manager_id
from employees
where level=2
start with last_name='De Haan'
connect by manager_id=prior employee_id;
--
select level,employee_id,last_name,first_name,hire_date,salary,manager_id
from employees
where level=3
start with last_name='Hunold'
connect by prior manager_id= employee_id;
--
select level,employee_id,manager_id
from employees
where manager_id is not null
start with manager_id in(select manager_id
                        from employees
                        where manager_id is not null)
connect by prior manager_id=employee_id;
--
select level,employee_id,last_name,first_name,manager_id
from employees e
where employee_id=(select distinct manager_id
                    from employees e1
                    where e1.manager_id=e.employee_id)
start with manager_id is null
connect by  manager_id=prior employee_id;
--sau
select level,employee_id,last_name,first_name,manager_id
from employees e
where employee_id in(select distinct manager_id
                    from employees e1
                    where e1.manager_id is not null )
start with manager_id is null
connect by  manager_id=prior employee_id;
--
WITH emp_sk AS   
(SELECT   employee_id, hire_date   
FROM     employees   
WHERE    manager_id = (SELECT employee_id
                        FROM   employees
                        WHERE  INITCAP(last_name) = 'King'                          
                        AND    INITCAP(first_name) = 'Steven'))    
SELECT  employee_id, INITCAP(first_name) ||' '||UPPER(last_name), 
        job_id, hire_date,manager_id    
FROM    employees    
WHERE   TO_CHAR(hire_date, 'yyyy') != 1970    
START WITH employee_id  IN (SELECT   employee_id                    
                            FROM     emp_sk                   
                            WHERE    hire_date = (SELECT   MIN(hire_date)                                        
                                                    FROM     emp_sk))    
CONNECT BY PRIOR employee_id = manager_id;
--sau
select level,employee_id,last_name||' '||first_name "nume",job_id,hire_date
from employees
where to_char(hire_date,'yyyy')!='1970'
start with employee_id in(select employee_id
                        from employees e
                        where manager_id=(select employee_id
                                            from employees
                                            where first_name='Steven'
                                            and last_name='King'
                                                )
                        and e.hire_date=(select min(hire_date)
                                        from employees
                                        where manager_id=(select employee_id
                                                        from employees
                                                        where first_name='Steven'
                                                        and last_name='King'
                                                            )
                                        )
                            )
connect by manager_id=prior employee_id;
--
update emp_vasu e
set e.email = substr(e.last_name, 1, 1) || '_' || e.first_name
where e.salary = (select max(e1.salary)
                from emp_vasu e1
                where e1.department_id = e.department_id);
--
MERGE INTO emp_vasu a   
USING employees b   
ON (a.employee_id = b.employee_id)   
WHEN MATCHED THEN      
UPDATE SET a.first_name=b. first_name,       
            a.last_name=b.last_name,             
            a.email=b.email,                 
            a.phone_number=b.phone_number,         
            a.hire_date= b.hire_date,            
            a.job_id= b.job_id,
            a.salary = b.salary,               
            a.commission_pct= b.commission_pct,       
            a.manager_id= b.manager_id,           
            a.department_id= b.department_id     
WHEN NOT MATCHED THEN      
INSERT VALUES(b.employee_id, b.first_name, b.last_name, b.email,
                b.phone_number, b.hire_date, b.job_id, b.salary,
                b.commission_pct, b.manager_id, b.department_id);
--