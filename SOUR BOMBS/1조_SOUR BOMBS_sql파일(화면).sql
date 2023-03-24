http://172.16.20.56:8080/apex/f?p=4550:1:2839658313254117

--------------------------------------------테이블 조회------------------------------------------------------------------------
SELECT * FROM EMP;

SELECT * FROM DEPT;

SELECT * FROM DEPT_HISTORY;

SELECT * FROM SALARY;

SELECT * FROM BONUS;

SELECT * FROM CERTIFICATE;

SELECT * FROM JOB;


---------------------------------------------1. 직원정보조회----------------------------------------------------------------------

행내 직원이름 및 사번으로 직원정보조회가 가능하며,
전체조회하면 행내 전체직원의 사번, 직원명, 입사일자, 연락처, 주소, 부서, 직무 정보가 사번순서로 조회 된다.

SELECT A.EMP_ID as 직원사번 
	 , A.EMP_NAME as 직원명
	 , A.HIREDATE as 입사일자
	 , A.CONTACT as 연락처
	 , A.ADDRESS as 주소
	 , B.DEPT_NAME as 부서명
	 , C.JOB_NAME as 직무 
FROM EMP A
	 INNER JOIN DEPT B ON A.DEPT_ID = B.DEPT_ID
	 INNER JOIN JOB C ON A.JOB_ID = C.JOB_ID
WHERE A.EMP_ID='1259295' 
ORDER BY A.EMP_ID;


-------------------------------------------------2. 부서별 직원현황--------------------------------------------------

행내 부서코드, 부서명, 직원사번, 직원명이 전체조회된다.

SELECT e.dept_id as 부서코드
  	 , d.dept_name as 부서명
  	 , e.emp_id as 직원사번
  	 , e.emp_name as 직원이름
FROM emp e LEFT JOIN dept d 
           ON e.dept_id = d.dept_id
ORDER BY e.dept_id;

----------------------------------------------------3. 직원별 연봉정보---------------------------------------------------------

근속년수에 따라 월급여가 결정되고, 소속부서의 등급에 따라 보너스가 지급되어 직원별 총연봉이 조회된다. 

SELECT D.DEPT_NAME
  , E.EMP_ID
  , E.EMP_NAME 
  , EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM HIREDATE)AS 근속연수
  , S.SALARY
  , S.SALARY*B.BONUS_RATE AS 성과급
  , S.SALARY*12 + S.SALARY*B.BONUS_RATE AS 성과급포함연봉
FROM EMP E
  INNER JOIN SALARY S 
    ON TRUNC(((EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM HIREDATE))/5))*5 = S.WORK_EXP
    JOIN DEPT D 
       ON E.DEPT_ID = D.DEPT_ID
    JOIN BONUS B 
       ON D.DEPT_GRADE = B.DEPT_GRADE
ORDER BY 성과급포함연봉 DESC , 4 ;


-------------------------------------------------------4. 부서별 평균연봉-----------------------------------------------------------

행내 부서 단위로 직원들의 평균연봉이 조회된다.

SELECT T1.DEPT_ID, T1.DEPT_NAME as 부서명, FLOOR(AVG(T1.성과급포함연봉)) as 부서별평균연봉
  FROM (SELECT D.DEPT_ID
      , D.DEPT_NAME
      , E.EMP_ID
      , E.EMP_NAME 
      , EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM HIREDATE)AS 근속연수
      , S.SALARY
      , S.SALARY*B.BONUS_RATE AS 성과급
      , S.SALARY*12 + S.SALARY*B.BONUS_RATE AS 성과급포함연봉
        FROM EMP E
          JOIN SALARY S 
            ON TRUNC(((EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM HIREDATE))/5))*5 = S.WORK_EXP
          JOIN DEPT D 
            ON E.DEPT_ID = D.DEPT_ID
          JOIN BONUS B 
          ON D.DEPT_GRADE = B.DEPT_GRADE) T1
 GROUP BY T1.DEPT_ID, T1.DEPT_NAME
 ORDER BY T1.DEPT_ID;

----------------------------------------------------- 5. 부서/직원별 소유 자격증 현황 ------------------------------------------------------

행내 부서코드, 부서명,  사번, 직원명, 보유 자격증 개수가 전체조회된다.

SELECT e.dept_id
   , d.dept_name
   , e.emp_id
   , e.emp_name
   , c.sum as 자격증개수
FROM emp e left join dept d 
            on e.dept_id = d.dept_id
             left join (select emp_id, sum(bancassurance + fund + sqld + derivatives) as sum from certificate group by emp_id) c
             on e.emp_id = c.emp_id
ORDER BY dept_id;


------------------------------------------------------6.  부서별 평균 자격증 보유 개수 ----------------------------------------------------

행내 부서별 직원 1인당 보유하고 있는 평균 자격증 개수가 조회된다.
부서에서 인재개발에 얼마나 신경쓰고 있나의 지표로 부서 등급산출시 확장가능

SELECT T1.DEPT_ID, T1.DEPT_NAME, AVG(T1.SUM) as 평균자격증개수
  FROM(SELECT e.dept_id
         , d.dept_name
         , e.emp_id
         , e.emp_name
         , c.sum 
        FROM emp e left join dept d 
                  on e.dept_id = d.dept_id
                   left join (select emp_id, sum(bancassurance + fund + sqld + derivatives) as sum from certificate group by emp_id) c
                   on e.emp_id = c.emp_id
      ORDER BY dept_id) T1
GROUP BY T1.DEPT_ID, T1.DEPT_NAME
ORDER BY 1;


---------------------------------------------------------7. 직원별 부서이력조회 ----------------------------------------------------------------

직원사번 입력시 해당직원의 직원명, 부서코드, 부서명, 부서발령이력 데이터가 조회된다.

SELECT E.EMP_ID
   , E.EMP_NAME
   , D.DEPT_ID
   , D.DEPT_NAME
   , TO_CHAR(H.DEPT_STARTDATE, 'YYYY-MM-DD') AS 부서발령일 
   , TO_CHAR(H.DEPT_ENDDATE, 'YYYY-MM-DD') AS 부서이동일
   , EXTRACT(YEAR FROM H.DEPT_ENDDATE) - EXTRACT(YEAR FROM H.DEPT_STARTDATE) AS "근무기간(연기준)"
  FROM EMP E LEFT JOIN DEPT_HISTORY H
            ON E.EMP_ID = H.EMP_ID
            INNER JOIN DEPT D 
            ON H.DEPT_ID = D.DEPT_ID
 WHERE E.EMP_ID = 1259295
 ;

--------------------------------------------------------8. 부서별 직무 구성조회 ---------------------------------------------------------------------

조회시 부서별 직무 구성현황을 조회 할수 있다.

SELECT D.DEPT_ID, D.DEPT_NAME, J.JOB_NAME, COUNT(E.EMP_ID) AS 직원수
  FROM DEPT D
  CROSS JOIN JOB J
  LEFT JOIN EMP E ON D.DEPT_ID = E.DEPT_ID AND J.JOB_ID = E.JOB_ID
GROUP BY D.DEPT_ID, D.DEPT_NAME, J.JOB_NAME
ORDER BY 1, 2;
