--innerjoin 사용하는 여러 방법
--1. ORACEL PL/SQL에서 사용
SELECT *
  FROM EMP, DEPT
 WHERE EMP.DEPTNO = DEPT.DEPTNO;
 
--2.  표준SQL사용(가장 많이 사용)
SELECT *
  FROM EMP e JOIN DEPT D 
    ON e.DEPTNO = d.DEPTNO;
    
--3. using 사용
SELECT *
  FROM EMP e JOIN DEPT D 
      using(DEPTNO);
 ---> 컬럼명이 같을 경우만 사용 가능, 거의 사용xxx
  ---> java에서 deptno을 입력받을경우 해당부분 변수처리하여 이용가능하겠음
     
--join에 조건 주기
SELECT round(avg(e.sal)) AS avg_sal
  FROM emp e, dept t
 WHERE e.DEPTNO = t.DEPTNO
   AND e.sal>2000;
   
-- =조건 외의 join
SELECT *
  FROM emp e, SALGRADE s
 WHERE e.SAL BETWEEN s.LOSAL AND s.HISAL

 
 -->join함수로 salgrade집계 후 grade별 직원 수 count
SELECT count(e.ename) AS cnt
  FROM emp e, SALGRADE s
 WHERE e.SAL BETWEEN s.LOSAL AND s.HISAL 
GROUP BY s.GRADE 
ORDER BY cnt DESC;


--OUTER JOIN
SELECT e1.EMPNO 
		, e1.ename
		, e1.MGR 
		, e2.EMPNO AS mgr_no
		, e2.ename AS mgr_name
  FROM emp e1 LEFT JOIN emp e2
    ON e1.mgr = e2.EMPNO 
--> leftjoin으로 셀프조인하기
    
--
SELECT d.DEPTNO 
		, d.DNAME 
		, e1.EMPNO 
		, e1.ENAME 
		, e1.MGR
		, e1.SAL
		, s.LOSAL
		, s.HISAL
		, s.GRADE
		, e2.EMPNO AS mgr_no
		, e2.ename AS mgr_name
  FROM emp e1
  		, dept d
  		, SALGRADE s
  		, emp e2
 WHERE e1.EMPNO(+) = d.DEPTNO 
   AND e1.SAL BETWEEN s.LOSAL AND s.HISAL 
   AND e1.MGR = e2.EMPNO;
   
  
--표준SQL
SELECT d.DEPTNO 
		, d.DNAME 
		, e1.EMPNO 
		, e1.ENAME 
		, e1.MGR
		, e1.SAL
		, s.LOSAL
		, s.HISAL
		, s.GRADE
		, e2.EMPNO AS mgr_no
		, e2.ename AS mgr_name
  FROM emp e1 RIGHT JOIN dept D 
    ON e1.deptno = d.deptno
    LEFT JOIN SALGRADE s
    ON e1.sal >= s.losal AND e1.sal <= s.HISAL
    LEFT JOIN emp e2
    ON e1.mgr = e2.empno;
    
   
---서브쿼리 기초
SELECT *
  FROM emp
 WHERE sal > (SELECT avg(sal) FROM emp)
 
--다중행 서브쿼리 -> 쿼리안에 쿼리문장인데, 2개 이상의 값으로 된 테이블을 참조
 
 SELECT DEPTNO, ENAME, SAL
   FROM EMP e
  WHERE SAL IN(SELECT MAX(SAL) FROM EMP GROUP BY DEPTNO);

  
--any 서브쿼리
  SELECT DEPTNO, ENAME, SAL
   FROM EMP e
  WHERE SAL = ANY(SELECT MAX(SAL) FROM EMP GROUP BY DEPTNO);
  
--> 특정부서 사원들보다 적은 급여를 받는 사람
 SELECT *
 FROM EMP e 
 WHERE sal < any(SELECT sal FROM emp WHERE deptno = 30)
 --> 문맥상 dept30에 그 어떤 값보다 낮은 값들을 추출하라는 의미 같지만
   --> 실제로는dept30중 가장 큰 값보다만 낮으면 반환 ***헷갈리니 주의
 
 -- 두 개이상의 서브쿼리 사용하기
 /*
  * select *
  * from (select from) A, (select from) B
  * where A. = B.
  * 으로 틀 잡아놓고 짜면 편함
  */
SELECT *
  FROM (SELECT * FROM emp WHERE deptno=30) A, (SELECT * FROM dept) B 
 WHERE A.deptno = B.deptno
 
WITH e AS (SELECT * FROM emp WHERE deptno = 20)
	, d AS (SELECT * FROM dept)
	, s AS (SELECT * FROM salgrade)
SELECT e.ename
		, d.dname
		, d.loc
		, s.grade
  FROM e, d, s
 WHERE e.deptno = d.deptno
   AND e.sal BETWEEN s.losal AND s.hisal;
 