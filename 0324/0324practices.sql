-- v$~~
--오라클dbms 정보를 모아 저장해놓은 데이터

SELECT *
  FROM v$version;
 
SELECT *
  FROM v$option;

 SELECT *
  FROM v$database;

 SELECT *
  FROM v$session;

 SELECT *
  FROM v$parameter;
  
--TRANSACTION 연습
 
 CREATE TABLE dept_tcl
  AS (SELECT * FROM DEPT);
  
SELECT *
 FROM dept_tcl;
 
INSERT INTO dept_tcl
 VALUES (50, 'DATABASE', 'SEOUL');

UPDATE dept_tcl
SET loc = 'BUSAN'
WHERE deptno = 40;
 
DELETE FROM dept_tcl
 WHERE dname = 'RESEARCH';

ROLLBACK;

-- commit 실행하는 경우
INSERT INTO dept_tcl
 VALUES (50, 'NETWORK', 'SEOUL');

UPDATE dept_tcl
SET loc = 'BUSAN'
WHERE deptno = 20;
 
DELETE FROM dept_tcl
 WHERE dname = 'OPERATIONs';

SELECT *
 FROM dept_tcl;

COMMIT;

/*
 * lock
 * 
 */

SELECT *
FROM dept_tcl;


UPDATE dept_tcl
SET loc = 'DAEGU'
WHERE deptno = 20;
--sqlplus에서 실행중인 직원에 update 시도를 막고있는 상황을 
--모르고 있을 수도 있음

COMMIT;

UPDATE dept_tcl
SET loc = 'ICHEON'
WHERE deptno = 10;

--sqlplus에서 동일레코드의 값을 변경 하고 commit 안함
--> lock걸려서 접근을 못함
-->sqlplus에서 commit하고나면 데이터 접근 가능

/*
 * Tuning 기초 : 자동차 튜닝과 같이
 * DB처리 속도(우선)와 안정선 제고 목적의 경우가 대부분
 */
SELECT *
  FROM EMP e 
 WHERE substr(empno,1,2) = 75
   AND LENGTH(empno) = 4;
 -->
SELECT *
  FROM EMP e 
 WHERE empno > 7499 AND empno < 7600;
 

--튜닝전후비교
SELECT *
  FROM EMP e 
 WHERE ename || ' ' || job = 'WARD SALESMAN';
-->
SELECT *
  FROM EMP e 
 WHERE ename = 'WARD'
   AND JOB = 'SALESMAN';
   
--  
SELECT DISTINCT(e.empno), E.ENAME, M.DEPTNO 
  FROM EMP E JOIN DEPT M ON E.DEPTNO = M.DEPTNO;
SELECT e.empno, E.ENAME, M.DEPTNO 
  FROM EMP E JOIN DEPT M ON E.DEPTNO = M.DEPTNO;
--  
SELECT *
  FROM EMP e 
 WHERE DEPTNO = '10'
UNION
SELECT *
  FROM EMP e 
 WHERE DEPTNO = '20';
 
SELECT *
  FROM EMP e 
 WHERE DEPTNO IN ('10', '20');
 --
SELECT E.ENAME, E.EMPNO, SUM(E.SAL) 
  FROM EMP e 
GROUP BY E.ENAME, E.EMPNO, E.SAL ;
SELECT  E.EMPNO, E.ENAME, SUM(E.SAL) 
  FROM EMP e 
GROUP BY E.EMPNO, E.ENAME, E.SAL ;

SELECT *
  FROM EMP e 
 WHERE to_char(HIREDATE, 'YYYY') = '1981';
--> 동일한 datatype --> STRING
 
SELECT *
  FROM EMP e 
 WHERE EXTRACT(YEAR FROM HIREDATE) = 1981
 --> 동일한 datatype --> INTEGER
 
 SELECT *
   FROM user_indexes
  WHERE TABLE_name LIKE 'EMP';
 
 --index
 
 DROP INDEX idx_emp_job;
 CREATE INDEX idx_emp_job
 ON emp (job);
 
COMMIT;

--집계함수 사용 시 최대한 인덱스가 설정된 컬럼을 우선으로
SELECT job , sum(sal) AS sum
  FROM EMP e 
GROUP BY JOB 
ORDER BY sum DESC;

--view만들기
--table은 정규화, view는 반정규화하여 정보를 많이 표현하는 추세

SELECT e.EMPLOYEE_ID
	, e.JOB_ID 
	, e.MANAGER_ID 
	, e.DEPARTMENT_ID 
	, d.LOCATION_ID 
	, l.COUNTRY_ID 
	, e.FIRST_NAME 
	, e.LAST_NAME 
	, e.SALARY 
	, e.COMMISSION_PCT 
	, d.DEPARTMENT_NAME 
	, j.JOB_TITLE 
	, l.CITY 
	, l.STATE_PROVINCE 
	, c.COUNTRY_NAME 
	, r.REGION_NAME
  FROM EMPLOYEES e
  	, DEPARTMENTS d
  	, JOBS j
  	, LOCATIONS l
  	, COUNTRIES c
  	, REGIONS r 
 WHERE e.DEPARTMENT_ID = d.DEPARTMENT_ID
   AND d.LOCATION_ID = l.LOCATION_ID
   AND l.COUNTRY_ID = c.COUNTRY_ID
   AND c.REGION_ID = r.REGION_ID
   AND j.JOB_ID = e.JOB_ID 
   
   COMMIT;
   
--group by 복습 : 집계 함수를 사용하여 값을 표시
SELECT DEPTNO, FLOOR(AVG(SAL))
  FROM EMP
GROUP BY DEPTNO;

SELECT DEPTNO, job, FLOOR(AVG(SAL))
  FROM EMP
GROUP BY DEPTNO, job
ORDER BY 1,2
;

--having 구문 사용
--group by 결과에 대한 조건 설정
SELECT DEPTNO, job, FLOOR(AVG(SAL)), max(sal), min(sal)
  FROM EMP
GROUP BY DEPTNO, job
HAVING avg(sal) >= 2000
ORDER BY 1,2;
 
-- LISTAGG, PIVOT, ROLLUP, CUBE, GROUPING
SELECT deptno, listAGG(ename, ',') WITHIN group(ORDER BY sal desc) AS ename
FROM EMP e 
GROUP BY DEPTNO;

SELECT *
  FROM (SELECT deptno, job, sal FROM emp)
  pivot(max(sal) FOR deptno IN (10, 20, 30))
  ORDER BY job;
  
 --UNPIVOT
 SELECT *
   FROM (SELECT DEPTNO
   				, max(decode(job, 'CLERK', SAL)) AS "CLERK"
   				, max(decode(job, 'SALESMAN', SAL)) AS "SALES"
   				, max(decode(job, 'PRESIDENT', SAL)) AS "PRESI"
   				, max(decode(job, 'MANAGER', SAL)) AS "MAN"
   				, max(decode(job, 'ANALYST', SAL)) AS "ANA"
   		   FROM EMP e 
   		   GROUP BY DEPTNO 
   		   ORDER BY DEPTNO)
 UNPIVOT(SAL FOR JOB IN (clerk, sales, presi, man, ana))
 ORDER BY deptno, job;
 
--join연습
SELECT *
  FROM emp E JOIN dept D 
    ON e.deptno = d.deptno;
    
WITH EMP_SAL AS (SELECT E.EMPNO
					, E.ENAME
					, S.GRADE
					, E.JOB
					, E.HIREDATE
					, E.SAL
					, E.COMM
					, E.DEPTNO
					, S.LOSAL
					, S.HISAL
					FROM EMP E JOIN SALGRADE S 
					  ON E.SAL BETWEEN S.LOSAL AND S.HISAL)
, EMP_DEPT AS ( SELECT *
		     	  FROM EMP E JOIN DEPT D
				    ON E.DEPTNO = D.DEPTNO)  
				    
SELECT *
  FROM EMP_SAL;
  
 
 --RIGHT JOIN
 SELECT E1.EMPNO, E1.ENAME, E1.MGR, E2.ENAME AS MGR_NAME
   FROM EMP E1 RIGHT JOIN EMP E2
     ON E1.MGR = E2.EMPNO;
     
SELECT *
  FROM EMP E1 RIGHT JOIN DEPT D
    		  ON E1.DEPTNO = D.DEPTNO
    		  LEFT JOIN SALGRADE S
    		  ON E1.SAL BETWEEN S.LOSAL AND S.HISAL 
    		  LEFT JOIN EMP E2
    		  ON E1.MGR = E2.EMPNO 
 ;
 
--SUB-QUERY
--서브쿼리의 결과: 단일값 출력, 다중행(하나의 컬럼에 행 배역)
-- 						다중열(두 개 이상의 컬럼 별 행 배열)

SELECT DEPTNO, MAX(SAL)
  FROM EMP e 
GROUP BY DEPTNO;

SELECT *
  FROM EMP e 
 WHERE (DEPTNO, SAL) IN (SELECT DEPTNO, MAX(SAL) FROM EMP GROUP BY DEPTNO)
 ;
 
--CREATE TABLE

DROP TABLE EMP_NEW;

CREATE TABLE EMP_NEW
 AS (SELECT * FROM EMP);
 
ALTER TABLE EMP_NEW
 ADD TEL VARCHAR2(20);
 
COMMIT;

SELECT * FROM EMP_NEW2;

ALTER TABLE EMP_NEW 
 MODIFY EMPNO NUMBER(5);
 
ALTER TABLE EMP_NEW 
 RENAME COLUMN TEL TO CONTACT;
 
ALTER TABLE EMP_NEW 
 RENAME TO EMP_NEW2;