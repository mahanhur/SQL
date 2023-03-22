
--table 생성
CREATE TABLE emp_temp AS
	SELECT * FROM EMP e 
			WHERE 1<>1  -- 데이터는 넣지 말아라
			
--DDL은 반드시 COMMIT해줄 것(autocommit은 좋은 습관이 아님)
COMMIT;

SELECT *FROM emp_temp;

--테이블에 데이터 입력
INSERT INTO emp_temp (empno, ename, job, mgr, hiredate, sal, comm, deptno)
 VALUES (9999, '홍길동', 'PRESIDENT', NULL, '2001/01/01', 6000, 500, 10);

INSERT INTO emp_temp (empno, ename, job, mgr, hiredate, sal, comm, deptno)
 VALUES (2111, '이순신', 'MANAGER', 9999, TO_DATE('07/30/1999', 'MM/DD/YYYY'), 4000, NULL, 20);

INSERT INTO emp_temp (empno, ename, job, mgr, hiredate, sal, comm, deptno)
 VALUES (3111, '심청이', 'MANAGER', 9999, SYSDATE, 4000, NULL, 20);
 
--commit;

--insert문에서 subquery사용
INSERT INTO emp_temp (empno, ename, job, mgr, hiredate, sal, comm, deptno)
 SELECT e.empno
 		, e.ename
 		, e.job
 		, e.mgr
 		, e.hiredate
 		, e.SAL
 		, e.COMM 
 		, e.DEPTNO 
   FROM emp e, salgrade s
  WHERE e.sal BETWEEN s.losal AND s.HISAL 
    AND s.grade = 1
;

SELECT *
  FROM EMP_TEMP ;
  
 -- 테스트 개발을 위한 임시테이블 생성
CREATE TABLE dept_temp2
	AS (SELECT * FROM DEPT);

-- 테스트 개발을 위한 임시테이블 확인
SELECT *
 FROM dept_temp2;
 
--update.. set.. where 이용 --> 이유불문하고 where 사용! 현업에서  
UPDATE DEPT_TEMP2 
   SET loc = 'SEOUL'
 WHERE loc = 'BOSTON';
 
ROLLBACK;

UPDATE dept_temp2 
   SET dname = 'DATABASE'
	, loc = 'SEOUL'
 WHERE deptno = 40; 
 
COMMIT;

UPDATE dept_temp2
   SET (dname, loc) = (SELECT dname, loc FROM dept WHERE deptno = 40)
 WHERE deptno = 40;
 
--delete구문
-- 웬만해서는 하면 안되는...
-- 대부분의 경우(또는 반드시) WHERE 조건이 필요
-- 보통의경우 delete보다는 update로 상태값을 변경하곤 함
-- 예시 : 근무/휴직/퇴사 등의 유형으로 값을 변경

SELECT *
  FROM emp_temp2;
 
CREATE TABLE emp_temp2 AS (SELECT *
  FROM emp);
  
 COMMIT;

SELECT COUNT(*)  --> 영향도 파악
  FROM emp_temp2
 WHERE job = 'MANAGER';
 
DELETE FROM emp_temp2
 WHERE job = 'MANAGER'
 
ROLLBACK;

--where 조건을 좀 더 복잡하게 주고 delete 실행 case
DELETE FROM emp_temp2
 WHERE empno IN (SELECT empno 
 				FROM emp_temp2 e, salgrade s 
 				WHERE e.sal BETWEEN s.losal AND s.HISAL
 				AND s.grade = 3
 				AND deptno = 30)
 				
 				
/*
 * CREATE문 정의 - 기존에 없는 테이블 구조 생성
 * 데이터는 없고, 테이블의 컬럼과 데이터타입, 제약 조건등의 구조를 생성
 * 
*/ 				
 
CREATE TABLE emp_new(
	 empno		number(4),
	 ename		varchar2(10),
	 job		varchar2(9),
	 mgr 		number(4),
	 hiredate	DATE,
	 sal		number(7,2),
	 comm		number(7,2),
	 deptno		number(2)
);

SELECT *
  FROM EMP e 

 WHERE rownum <= 5;
 
COMMIT;


ALTER TABLE emp_new
	ADD (hp varchar(20));
	
SELECT *
  FROM emp_new;
  
ALTER TABLE EMP_NEW
 RENAME COLUMN hp TO TEL_NUM;
 
ALTER TABLE emp_new
 MODIFY empno NUMBER(5);
 
ALTER TABLE EMP_NEW 
 DROP COLUMN tel_num;
 

/*
 * SEQUENCE 일련번호를 생성하여 테이블관리를 편하게 하고자 함
 */

CREATE SEQUENCE SEQ_DEPTNO
	INCREMENT BY 1
	START WITH 1
	MAXVALUE 999
	MINVALUE 1
	NOCYCLE NOCACHE;
	
COMMIT;

INSERT INTO dept_temp2(deptno, dname, loc)
 VALUES (seq_deptno.nextval, 'database', 'seoul');

INSERT INTO dept_temp2(deptno, dname, loc)
 VALUES (seq_deptno.nextval, 'web', 'busan');

INSERT INTO dept_temp2(deptno, dname, loc)
 VALUES (seq_deptno.nextval, 'mobile', 'seongsoo');
 
SELECT *
  FROM DEPT_TEMP2;
  
 /*
  * constraint 지정
  * 자주사용되는 제약조건 not null / unique / pk / fk
 */
 
 CREATE TABLE login
 (	log_id			varchar2(20) NOT NULL
 	, log_pwd		varchar2(20) NOT NULL
 	, tel			varchar2(20) 
 );
 
INSERT INTO login (log_id, log_pwd, tel)
	values('id01', 'pw01', '010-1234-2342');
INSERT INTO login (log_id, log_pwd)
	values('id02', 'pw02');
	
SELECT *
  FROM login;
 
 -- tel 컬럼의 중요성을 나중에 인지하고, not null 제약조건을 설정
 ALTER TABLE login
  MODIFY tel NOT NULL;
 -- null한 값이 있는 경우 notnull 제약을 추가로 설정 불가 오류
 
 --> null한 데이터 찾아서 수정
 UPDATE login SET tel='010-6802-9475' WHERE log_id='id02';
 --> 이후 notnull 제약조건 정상 걸림

COMMIT;

SELECT owner
	, constraint_NAME
	, constraint_type
	, TABLE_name
  FROM USER_CONSTRAINTS ;
 WHERE table_name = 'LOGIN';
 
ALTER TABLE login
 MODIFY (tel CONSTRAINT TEL_NN NOT NULL);
 
ALTER TABLE login
 DROP CONSTRAINT sys_c007040; --제약조건 이름이 없어 주어진 이름 사용
 
--unique 사용
 
CREATE TABLE log_unique
(
	log_id		varchar2(20) UNIQUE,
	log_pwd		varchar2(20) NOT NULL,
	tel			varchar2(20)
);

SELECT *
FROM user_constraints;
WHERE table_name = 'log_unique';


--PK사용
CREATE TABLE log_pk
( log_id 		varchar2(20) PRIMARY KEY, 
  log_pwd 		varchar2(20) NOT null, 
  tel 	 		varchar2(20)
);

INSERT INTO log_pk (log_id, log_pwd, tel)
 values('pk01', 'pwd01', '010-2452-2545');
INSERT INTO log_pk (log_id, log_pwd, tel)
 values(NULL, 'pwd01', '010-2452-2545'); -- 오류
 
 
--index
 --빠른 검색을 위한 색인
 --장점 : 순식간에 원하는 값을 찾아준다
 --단점 : 입력과 출력이 잦을 경우, 인덱스가 설정된 테이블의 속도가 저하된다.
 
CREATE INDEX idx_emp_job
 ON emp(job);
 
SELECT *
FROM USER_INDEXES
WHERE TABLE_name IN ('EMP', 'DEPT');


/*
 * view : 테이블을 편리하게 사용하기 위한 목적으로 생성하는 가상 테이블
 * 
*/

CREATE VIEW vw_emp
 AS (SELECT empno, ename, job, deptno
 	  FROM emp WHERE deptno = 10);
 	 
 SELECT *
 FROM vw_emp;

SELECT *
FROM user_views
WHERE view_name = 'VW_EMP';


--rownum -> 상위 N개 출력
SELECT rownum, A.*
  FROM (SELECT * FROM emp ORDER BY sal desc) A;

 
 SELECT rownum, A.*
  FROM (SELECT * FROM emp ORDER BY sal desc) A
  WHERE rownum <= 5;

 --**서브쿼리 없이 order할경우 order는 가장 마지막에 적용하므로 값이 다름에 주의
SELECT *
  FROM emp
WHERE rownum >= 5
  ORDER BY sal DESC;

 --데이터사전 : 오라클 dbms에서 관리하는 관리 테이블 리스트 출력
 SELECT *
   FROM dict;
  
 SELECT *
   FROM dict
   WHERE TABLE_name LIKE 'USER_%'; -- %와일드카드
   
   COMMIT;