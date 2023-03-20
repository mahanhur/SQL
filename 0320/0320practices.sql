SELECT *
  FROM EMP
 WHERE mgr IS NULL
   AND comm IS NULL;
  
SELECT *
  FROM EMP;
  
SELECT *
  FROM EMP
 WHERE ENAME LIKE '%S';
 
-- 실급과제3번
SELECT *
  FROM EMP
 WHERE (DEPTNO = 20 OR DEPTNO = 30)
   AND SAL > 2000;

 
--4번 
  SELECT *
  FROM EMP
 WHERE DEPTNO = 20
   AND SAL > 2000
UNION
   SELECT *
  FROM EMP
 WHERE DEPTNO = 30
   AND SAL > 2000;
   
--5번
SELECT *
  FROM EMP
 WHERE COMM IS NULL
   AND MGR IS NOT NULL
   AND JOB IN ('MANAGER', 'CLERK')
   AND ENAME NOT LIKE '_L%';
   
SELECT *
  FROM v$sqlfn_metadata
 WHERE name = 'NVL';

SELECT LENGTH(ENAME), EMPNO
  FROM EMP e 
  WHERE ename = 'SCOTT   ';

UPDATE EMP SET ENAME='SCOTT' WHERE ENAME='SCOTT   '; 

SELECT LENGTH(T)
FROM (SELECT TRIM(ENAME) AS T
  FROM EMP e 
 WHERE ENAME = 'SCOTT   ');
 
SELECT CONCAT(TRIM(ENAME), EMPNO)
  FROM EMP e 
 WHERE ENAME = 'SCOTT   ';
 
--replace
SELECT '010-6801-8156' AS mobile_phone
		, replace('010-6801-8156', '-', '') AS REPLACE_mobile_phone
FROM dual;

--lpad, rpad
SELECT lpad_20, LENGTH(lpad_20)
  FROM (SELECT LPAD('ORACLE', 20) AS lpad_20
		, RPAD('ORACLE', 20) AS rpad_20		
  FROM dual);
  
--실습과제lpad, rpad
 SELECT RPAD(SUBSTR(EMPNO,1,2), LENGTH(EMPNO), '*')
 		, RPAD(SUBSTR(ENAME,1,1), LENGTH(ENAME), '*')
   FROM EMP e 
  WHERE LENGTH(ENAME) >= 6
  
--date 함수
SELECT sysdate AS now
		, sysdate -1 AS yesterday
		, sysdate + 10 AS ten_days_after
  FROM dual;
  
SELECT ADD_MONTHS(sysdate, 5)
  FROM dual;
 
SELECT ADD_MONTHS(HIREDATE, 240)
  FROM emp;

 --입사일로부터 40년이 지난 직원 구하기
SELECT *
  FROM EMP e JOIN (SELECT EMPNO, ENAME, ADD_MONTHS(HIREDATE, 12*40) AS a
  FROM EMP) b
  ON e.empno = b.EMPNO 
 WHERE sysdate > b.a;

SELECT sysdate AS now
		, next_day(sysdate, '월요일') AS n_day
		, last_day(sysdate) AS l_date
  FROM dual;
 
-- 날짜의 반올림
SELECT sysdate AS now
		, round(sysdate, 'CC') AS format_CC
		, round(sysdate, 'YYYY') AS format_YYYY
		, round(sysdate, 'DDD') AS format_DDD
  FROM dual;
 
 --upcasting(암묵적 형변환은 웬만하면 이용하지 말 것)
SELECT EMPNO 
  FROM EMP e
 WHERE DEPTNO = '20';
 
-- 명시적 형변환 ( To_로 시작)
--24시간 표시
SELECT to_char(sysdate, 'YYYY/MM/DD HH24')
  FROM dual;
  
--시분초까지 표시
SELECT to_char(sysdate,'DD HH24:MI:SS')
  FROM dual;
  
--SELECT SYSDATE 
--		, to_char(sysdate, 'MM') AS mm1
--		, to_char(sysdate, 'mon') 'NLS_DATE_LANGUAGE:KOREAN'
--  FROM dual;		
		
		--시간표현
SELECT SYSDATE 
		, to_char(sysdate, 'HH24:MI:SS') AS tm
  FROM dual;
  
SELECT to_number('10,000', '999,999,999') AS num
  FROM dual;
  
SELECT to_date('2023/03/20', 'YYYY.MM.DD') AS DATE1
  FROM dual;
--TO_DATE RR과 YY의 값 비교  
SELECT to_date('50/12/10', 'RR/MM/DD') AS RR_YEAR_49
  FROM dual;
SELECT to_date('50/12/10', 'YY/MM/DD') AS YY_YEAR_49
  FROM dual;
