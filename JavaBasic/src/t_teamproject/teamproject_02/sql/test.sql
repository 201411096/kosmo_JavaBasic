/****************************** TABLE STRUCTURE START ******************************/
--테이블 5개 + 3개
--시퀀스 2개 + 3개
/***** POSITION TABLE *****/
CREATE TABLE POS(
    POSID NUMBER(2),
    POSNAME VARCHAR2(20),
    CONSTRAINT POS_POSID_PK PRIMARY KEY(POSID)
);
/***** EMPLOYEE TABLE *****/
CREATE TABLE EMPLOYEE(
    EID VARCHAR2(20),
    EPASSWORD VARCHAR2(20),
    ENAME VARCHAR2(20),
    TEL VARCHAR2(20) UNIQUE,
    SAL  NUMBER(20),
    HIRE_DATE DATE,
    AGE NUMBER(3),
    POSID  NUMBER(2),
    CONSTRAINT EMPLOYEE_EID_PK PRIMARY KEY(EID),
    CONSTRAINT EMPLOYEE_POSID_FK FOREIGN KEY(POSID) REFERENCES POS(POSID)
);
/***** PRODUCTGROUP TABLE *****/
CREATE TABLE PRODUCTGROUP(
    PGROUPID NUMBER(10),
    PGROUPNAME VARCHAR(20) NOT NULL,
    CONSTRAINT productgroup_pk PRIMARY KEY(PGROUPID)
);
/***** PRODUCT TABLE *****/
CREATE TABLE PRODUCT(
    PID NUMBER(10),
    PGROUPID NUMBER(10) NOT NULL,
    PNAME VARCHAR(20) NOT NULL UNIQUE,
    PDETAIL VARCHAR(200),
    PPRICE NUMBER(10) NOT NULL,
    CONSTRAINT product_pk PRIMARY KEY(PID),
    CONSTRAINT product_fk_pgroupname FOREIGN KEY(PGROUPID) REFERENCES PRODUCTGROUP(PGROUPID)
);
CREATE SEQUENCE PRODUCT_PID_SEQ MAXVALUE 1000 CYCLE;
/***** PRODUCTMANAGEMENT TABLE *****/
CREATE TABLE PRODUCTMANAGEMENT(
    PMANAGEMENTID NUMBER(10),
    PID NUMBER(10),
    PDATE DATE,
    CONSTRAINT productmanagement_pk PRIMARY KEY(PMANAGEMENTID),
    CONSTRAINT productmanagement_fk_pid FOREIGN KEY(PID) REFERENCES PRODUCT(PID)
);
CREATE SEQUENCE PM_PMANAGEMENTID_SEQ MAXVALUE 1000000 CYCLE; --제품관리에 사용할 시퀀스

/***** CUSTOMER TABLE *****/
CREATE TABLE CUSTOMER( -- 안 들어갈듯
    CID NUMBER(10),
    CNAME VARCHAR2(10),
    CTEL VARCHAR2(20) UNIQUE,
    ISCUSTOMER NUMBER(1), --0이면 비회원 1이면 회원
    CONSTRAINT CUSTOMER_PK PRIMARY KEY(CID)
);
CREATE SEQUENCE CUSTOMER_CID MAXVALUE 1000000 CYCLE;
/***** ORDERED TABLE *****/
CREATE TABLE ORDERED(
    OID NUMBER(10),
    PID NUMBER(10),
    OCNT NUMBER(10),
    ODATE DATE,
    OLID NUMBER(10),
--    CID NUMBER(10),
    CONSTRAINT ORDER_PK PRIMARY KEY(OID),
    CONSTRAINT ORDER_PID_FK FOREIGN KEY(PID) REFERENCES PRODUCT(PID),
    CONSTRAINT ORDER_OLID_FK FOREIGN KEY(OLID) REFERENCES ORDERLIST(OLID)
--    CONSTRAINT ORDER_CID_FK FOREIGN KEY(CID) REFERENCES CUSTOMER(CID)
);
CREATE SEQUENCE ORDERED_OID MAXVALUE 1000000 CYCLE;
/***** ORDERLIST TABLE *****/
CREATE TABLE ORDERLIST(
    OLID NUMBER(10),
    TOTALPRICE NUMBER(20),
    CONSTRAINT OLID_PK PRIMARY KEY(OLID)
);
CREATE SEQUENCE ORDERLIST_OLID MAXVALUE 1000000 CYCLE;
/****************************** TABLE STRUCTURE END ******************************/
//****************************** DROP TABLE START ******************************/
DROP TABLE EMPLOYEE;
DROP TABLE POS;
DROP TABLE PRODUCTGROUP;
DROP TABLE PRODUCT;
DROP SEQUENCE PRODUCT_PID_SEQ;
DROP TABLE PRODUCTMANAGEMENT;
DROP SEQUENCE PM_PMANAGEMENTID_SEQ;
--아래는 테스트 중인 부분
DROP TABLE ORDERED;
DROP TABLE ORDERLIST;
DROP TABLE CUSTOMER;
DROP SEQUENCE CUSTOMER_CID;
DROP SEQUENCE ORDERED_OID;
DROP SEQUENCE ORDERLIST_OLID;
//****************************** DROP TABLE END ******************************/
/****************************** TEST ******************************/
/***** EMPLOYEE TABLE TEST *****/

/* EMPLOYEE TABLE TEST CASE */
INSERT INTO EMPLOYEE(EID, EPASSWORD, ENAME, TEL, SAL, HIRE_DATE, AGE, POSID) VALUES(?, ?, ?, ?, ?, ?, ?, ?);
INSERT INTO EMPLOYEE(EID, EPASSWORD, ENAME, TEL, SAL, HIRE_DATE, AGE, POSID) VALUES('admin', 'admin', 'admin', '00-000-0000', '100000', '200415', 45, 0);
INSERT INTO EMPLOYEE(EID, EPASSWORD, ENAME, TEL, SAL, HIRE_DATE, AGE, POSID) VALUES('abc123', 'abc123', 'aname', '111-1111', '20000', '200416',  30,1);
INSERT INTO EMPLOYEE(EID, EPASSWORD, ENAME, TEL, SAL, HIRE_DATE, AGE, POSID) VALUES('def456', 'def456', 'dname', '222-2222', '10000', '200417', 22, 2);
INSERT INTO EMPLOYEE(EID, EPASSWORD, ENAME, TEL, SAL, HIRE_DATE, AGE, POSID) VALUES('aaa111', 'aaa111', 'aname', '333-3333', '10000', '200417', 20, 2);

SELECT * FROM EMPLOYEE WHERE eid = ?;
SELECT e.eid AS eid, e.epassword AS epassword, e.ename AS ename, e.tel AS tel, e.sal AS sal, e.hire_date AS hire_date, p.posname AS posname FROM EMPLOYEE e INNER JOIN POS p ON e.POSID=p.POSID WHERE e.eid='?';
SELECT * FROM EMPLOYEE WHERE eid = 'admin';
SELECT * FROM EMPLOYEE e INNER JOIN POS p ON e.POSID=p.POSID WHERE e.eid='admin';
SELECT e.eid AS eid, e.epassword AS epassword, e.ename AS ename, e.tel AS tel, e.sal AS sal, e.hire_date AS hire_date, p.posname AS posname FROM EMPLOYEE e INNER JOIN POS p ON e.POSID=p.POSID WHERE e.eid='admin';
/*SEARCH EMPLOYEE*/
SELECT E.ENAME AS ENAME, E.EID AS EID, E.TEL AS ETEL, P.POSNAME AS POSNAME, E.AGE AS EAGE, E.SAL AS SAL, TO_CHAR(E.HIRE_DATE, 'YYYY/MM/DD') AS HIRE_DATE FROM EMPLOYEE E INNER JOIN POS P ON E.POSID=P.POSID WHERE E.ENAME LIKE '%aname%';
SELECT E.ENAME AS ENAME, E.EID AS EID, E.TEL AS ETEL, P.POSNAME AS POSNAME, E.AGE AS EAGE, E.SAL AS SAL, TO_CHAR(E.HIRE_DATE, 'YYYY/MM/DD') AS HIRE_DATE FROM EMPLOYEE E INNER JOIN POS P ON E.POSID=P.POSID WHERE E.EID LIKE '%abc%';
/*UPDATE EMPLOYEE*/
UPDATE EMPLOYEE SET ENAME=?, POSID=?, TEL=?, HIRE_DATE =?, SAL=?, AGE=? WHERE EID=?;
UPDATE EMPLOYEE SET ENAME='aaaname', POSID=2, TEL='333-3333-3333', HIRE_DATE ='200418', SAL=5000, AGE=23 WHERE EID='aaa111';
/*DELETE EMPLOYEE*/
DELETE FROM EMPLOYEE WHERE eid=?;
DELETE FROM EMPLOYEE WHERE eid='bbb123456';

/***** POSITION TABLE TEST *****/
/* POS TABLE TEST CASE */
INSERT INTO POS(POSID, POSNAME) VALUES(?, ?);
INSERT INTO POS(POSID, POSNAME) VALUES(0, 'ADMIN');
INSERT INTO POS(POSID, POSNAME) VALUES(1, 'MANAGER');
INSERT INTO POS(POSID, POSNAME) VALUES(2, 'SALESMAN');

/***** PRODUCTGROUP TABLE TEST *****/
/* PRODUCTGROUP TABLE TEST CASE */
INSERT INTO productgroup(pgroupid, pgroupname)  VALUES(0, '메인메뉴');
INSERT INTO productgroup(pgroupid, pgroupname)  VALUES(1, '사이드메뉴');
INSERT INTO productgroup(pgroupid, pgroupname)  VALUES(2, '음료수');
INSERT INTO productgroup(pgroupid, pgroupname)  VALUES(3, '세트메뉴');

/***** PRODUCT TABLE TEST *****/
/* PRODUCT TABLE TEST CASE */
INSERT INTO product(pid, pgroupid, pname, pdetail, pprice) VALUES(PRODUCT_PID_SEQ.NEXTVAL, 0, '메인메뉴00', '메인메뉴00 입니다.', 6000);
INSERT INTO product(pid, pgroupid, pname, pdetail, pprice) VALUES(PRODUCT_PID_SEQ.NEXTVAL, 0, '메인메뉴01', '메인메뉴01 입니다.', 7000);
INSERT INTO product(pid, pgroupid, pname, pdetail, pprice) VALUES(PRODUCT_PID_SEQ.NEXTVAL, 0, '메인메뉴02', '메인메뉴02 입니다.', 8000);
INSERT INTO product(pid, pgroupid, pname, pdetail, pprice) VALUES(PRODUCT_PID_SEQ.NEXTVAL, 0, '메인메뉴03', '메인메뉴03 입니다.', 8500);
INSERT INTO product(pid, pgroupid, pname, pdetail, pprice) VALUES(PRODUCT_PID_SEQ.NEXTVAL, 1, '사이드메뉴00', '사이드메뉴00 입니다.', 2000);
INSERT INTO product(pid, pgroupid, pname, pdetail, pprice) VALUES(PRODUCT_PID_SEQ.NEXTVAL, 1, '사이드메뉴01', '사이드메뉴01 입니다.', 2500);
INSERT INTO product(pid, pgroupid, pname, pdetail, pprice) VALUES(PRODUCT_PID_SEQ.NEXTVAL, 1, '사이드메뉴02', '사이드메뉴02 입니다.', 3000);
INSERT INTO product(pid, pgroupid, pname, pdetail, pprice) VALUES(PRODUCT_PID_SEQ.NEXTVAL, 1, '사이드메뉴03', '사이드메뉴03 입니다.', 3000);
INSERT INTO product(pid, pgroupid, pname, pdetail, pprice) VALUES(PRODUCT_PID_SEQ.NEXTVAL, 2, '음료수00', '음료수00 입니다.', 1000);
INSERT INTO product(pid, pgroupid, pname, pdetail, pprice) VALUES(PRODUCT_PID_SEQ.NEXTVAL, 2, '음료수01', '음료수01 입니다.', 1000);
INSERT INTO product(pid, pgroupid, pname, pdetail, pprice) VALUES(PRODUCT_PID_SEQ.NEXTVAL, 2, '음료수02', '음료수02 입니다.', 500);
INSERT INTO product(pid, pgroupid, pname, pdetail, pprice) VALUES(PRODUCT_PID_SEQ.NEXTVAL, 2, '음료수03', '음료수03 입니다.', 1500);
INSERT INTO product(pid, pgroupid, pname, pdetail, pprice) VALUES(PRODUCT_PID_SEQ.NEXTVAL, 3, '세트00', '메인메뉴00과 사이드메뉴00 음료수00으로 구성되어있습니다.', 9000);
INSERT INTO product(pid, pgroupid, pname, pdetail, pprice) VALUES(PRODUCT_PID_SEQ.NEXTVAL, 3, '세트01', '메인메뉴00과 사이드메뉴02 음료수03으로 구성되어있습니다.', 10000);
INSERT INTO product(pid, pgroupid, pname, pdetail, pprice) VALUES(PRODUCT_PID_SEQ.NEXTVAL, 3, '세트02', '메인메뉴02과 사이드메뉴02 음료수00으로 구성되어있습니다.', 9500);
INSERT INTO product(pid, pgroupid, pname, pdetail, pprice) VALUES(PRODUCT_PID_SEQ.NEXTVAL, 3, '세트03', '메인메뉴02과 사이드메뉴02 음료수03으로 구성되어있습니다.', 12000);
UPDATE product SET pgroupid=?, pdetail=?, pname=?, pprice=? WHERE PID=?;
/*search product by pid*/
SELECT p.pid AS PID, p.pgroupid AS PGROUPID, p.pname AS PNAME, p.pprice AS PPRICE, p.pdetail AS PDETAIL FROM PRODUCT P WHERE PID = 1;
/*search product by pgroupname orderby pid*/
SELECT P.* FROM PRODUCT P INNER JOIN PRODUCTGROUP PG ON P.PGROUPID=PG.PGROUPID WHERE PG.PGROUPNAME='메인메뉴' ORDER BY P.PID;
SELECT P.PGROUPID FROM PRODUCT P INNER JOIN PRODUCTGROUP PG ON P.PGROUPID=PG.PGROUPID WHERE PG.PGROUPNAME='메인메뉴' ORDER BY P.PID;

P.PGROUPID;

/***** PRODUCTMANAGEMENT TABLE TEST *****/
INSERT INTO PRODUCTMANAGEMENT(PMANAGEMENTID, PID, PDATE) VALUES ();
SELECT PID FROM PRODUCT WHERE PNAME='메인메뉴02';
INSERT INTO PRODUCTMANAGEMENT(PMANAGEMENTID, PID, PDATE) VALUES (PM_PMANAGEMENTID_SEQ.nextval, (SELECT PID FROM PRODUCT WHERE PNAME='메인메뉴02'), SYSDATE);
-- 제품별 재고 개수
SELECT PID, COUNT(*) FROM PRODUCTMANAGEMENT PM INNER JOIN PRODUCT P ON p.pid=pm.pid  GROUP BY PID;
-- 주문한 개수만큼 재고의 상품을 삭제
SELECT * FROM PRODUCTMANAGEMENT WHERE PID=28 ORDER BY pdate DESC, PMANAGEMENTID ASC;
SELECT ext.* FROM (SELECT * FROM PRODUCTMANAGEMENT WHERE PID=28 ORDER BY pdate DESC, PMANAGEMENTID ASC) ext WHERE ROWNUM <= 5;
DELETE FROM PRODUCTMANAGEMENT WHERE PMANAGEMENTID IN (SELECT ext.PMANAGEMENTID FROM (SELECT * FROM PRODUCTMANAGEMENT WHERE PID=28 ORDER BY pdate DESC, PMANAGEMENTID ASC) ext WHERE ROWNUM <= 5);
DELETE FROM PRODUCTMANAGEMENT WHERE PMANAGEMENTID IN (SELECT ext.PMANAGEMENTID FROM (SELECT * FROM PRODUCTMANAGEMENT WHERE PID=10 ORDER BY pdate DESC, PMANAGEMENTID ASC) ext WHERE ROWNUM <= 10);
/***** ORDERED LIST TABLE TEST *****/
INSERT INTO ORDERLIST(OLID, TOTALPRICE) VALUES(ORDERLIST_OLID.NEXTVAL, ?);
/***** ORDERED TABLE TEST *****/
INSERT INTO ORDERED(OID, PID, OCNT, ODATE, OLID) VALUES(ORDERED_OID.NEXTVAL, ?, ?, SYSDATE, ORDERLIST_OLID.CURRVAL);

INSERT INTO ORDERLIST(OLID, TOTALPRICE) VALUES(ORDERLIST_OLID.NEXTVAL, 10000);
INSERT INTO ORDERED(OID, PID, OCNT, ODATE, OLID) VALUES(ORDERED_OID.NEXTVAL, 4, 5, '200418', ORDERLIST_OLID.CURRVAL);
INSERT INTO ORDERED(OID, PID, OCNT, ODATE, OLID) VALUES(ORDERED_OID.NEXTVAL, 3, 5, '200419', ORDERLIST_OLID.CURRVAL);
INSERT INTO ORDERED(OID, PID, OCNT, ODATE, OLID) VALUES(ORDERED_OID.NEXTVAL, 6, 20, '200420', ORDERLIST_OLID.CURRVAL);
INSERT INTO ORDERED(OID, PID, OCNT, ODATE, OLID) VALUES(ORDERED_OID.NEXTVAL, 8, 30, '200320', ORDERLIST_OLID.CURRVAL);
INSERT INTO ORDERED(OID, PID, OCNT, ODATE, OLID) VALUES(ORDERED_OID.NEXTVAL, 6, 20, '190420', ORDERLIST_OLID.CURRVAL);
--일별 매출
SELECT SUM(OR) FROM ORDERED WHERE TO_CHAR(ODATE, 'YYMM')=TO_CHAR(SYSDATE, 'YYMM') GROUP BY TO_CHAR(SYSDATE, 'YYMMDD');
SELECT TO_CHAR(ODATE) AS DAY, SUM(OL.TOTALPRICE) AS PRICE FROM ORDERED O INNER JOIN ORDERLIST OL ON O.OLID=OL.OLID WHERE TO_CHAR(ODATE, 'YYMM')=TO_CHAR(SYSDATE, 'YYMM') GROUP BY TO_CHAR(ODATE);
--월별 매출
SELECT TO_CHAR(ODATE, 'YYMM') AS MONTH, SUM(OL.TOTALPRICE) AS PRICE FROM ORDERED O INNER JOIN ORDERLIST OL ON O.OLID=OL.OLID WHERE TO_CHAR(ODATE, 'YY')=TO_CHAR(SYSDATE, 'YY') GROUP BY TO_CHAR(ODATE, 'YYMM');
--연도별 매출
SELECT TO_CHAR(ODATE, 'YY') AS YEAR, SUM(OL.TOTALPRICE) AS PRICE FROM ORDERED O INNER JOIN ORDERLIST OL ON O.OLID=OL.OLID GROUP BY TO_CHAR(ODATE, 'YY');