drop table emp;
drop table dept;

CREATE TABLE DEPT(
    DEPTNO NUMBER(2) NOT NULL,
    DNAME VARCHAR2(14) NOT NULL,
    LOC VARCHAR2(13) );

CREATE TABLE EMP(
    EMPNO NUMBER(4) NOT NULL,
    ENAME VARCHAR2(10),
    JOBID VARCHAR2(9),
    MGR NUMBER(4),
    HIREDATE DATE NOT NULL,
    SAL NUMBER(7,2),
    COMM NUMBER(7,2),
    DEPTNO NUMBER(2)
);

ALTER TABLE DEPT ADD CONSTRAINT PK_DEPTNO PRIMARY KEY(DEPTNO);

ALTER TABLE EMP ADD CONSTRAINT PK_empno PRIMARY KEY(EMPNO);
ALTER TABLE EMP ADD FOREIGN KEY (DEPTNO) REFERENCES DEPT(DEPTNO);

INSERT INTO DEPT VALUES (10,'ACCOUNTING', 'NEW YORK');
INSERT INTO DEPT VALUES (20,'RESEARCH', 'DALLAS');
INSERT INTO DEPT VALUES (30,'SALES', 'CHICAGO');
INSERT INTO DEPT VALUES (40,'OPERATIONS', 'BOSTON');

INSERT INTO EMP VALUES(7369,'SMITH', 'CLERK', 7902,to_date('17-12-1980','dd-mm-yyyy'),800,NULL,20);
INSERT INTO EMP VALUES(7499,'ALLEN', 'SALESMAN', 7698,to_date('20-2-1981','dd-mm-yyyy'), 1600,300,30);
INSERT INTO EMP VALUES(7521,'WARD', 'SALESMAN', 7698,to_date('22-2-1981','dd-mm-yyyy'), 1250,500,30);
INSERT INTO EMP VALUES(7566,'JONES', 'MANAGER', 7839,to_date('2-4-1981','dd-mm-yyyy'), 2975,NULL,20);
INSERT INTO EMP VALUES(7654,'MARTIN', 'SALESMAN', 7698,to_date('28-9-1981','dd-mm-yyyy'), 1250,1400,30);
INSERT INTO EMP VALUES(7698,'BLAKE', 'MANAGER', 7839,to_date('1-5-1981','dd-mm-yyyy'), 2850,NULL,30);
INSERT INTO EMP VALUES(7782,'CLARK', 'MANAGER', 7839,to_date('9-6-1981','dd-mm-yyyy'), 2450,NULL,10);
INSERT INTO EMP VALUES(7788,'SCOTT', 'ANALYST', 7566,to_date('13-JUL-87')-85, 3000,NULL,20);
INSERT INTO EMP VALUES(7839,'KING', 'PRESIDENT', NULL,to_date('17-11-1981','dd-mm-yyyy'),5000,NULL,10);
INSERT INTO EMP VALUES(7844,'TURNER', 'SALESMAN', 7698,to_date('8-9-1981','dd-mm-yyyy'), 1500,0, 30);
INSERT INTO EMP VALUES(7876,'ADAMS', 'CLERK', 7788,to_date('13-JUL-87')-51, 1100,NULL,20);
INSERT INTO EMP VALUES(7900,'JAMES', 'CLERK', 7698,to_date('3-12-1981','dd-mm-yyyy'), 950,NULL,30);
INSERT INTO EMP VALUES(7902,'FORD', 'ANALYST', 7566,to_date('3-12-1981','dd-mm-yyyy'), 3000,NULL,20);
INSERT INTO EMP VALUES(7934,'MILLER', 'CLERK', 7782,to_date('23-1-1982','dd-mm-yyyy'), 1300,NULL,10);

CREATE OR REPLACE PROCEDURE add_dept(dept dept.deptno%TYPE, nombre dept.dname%TYPE, loca dept.loc%TYPE)
IS
    deptno_null EXCEPTION;
    name_null EXCEPTION;
    PRAGMA exception_init(deptno_null, -20303);
    PRAGMA exception_init(name_null, -20304);
BEGIN
    
    IF dept IS NULL THEN RAISE deptno_null; END IF;
    IF nombre IS NULL THEN RAISE name_null; END IF;
    
    INSERT INTO dept VALUES(dept,nombre,loca);
    
    EXCEPTION
        WHEN name_null THEN
            raise_application_error(-20304,'Error: El nombre del departamento no puede ser NULL.');
        WHEN deptno_null THEN
            raise_application_error(-20303,'Error: El valor "deptno" no puede ser NULL.');
        WHEN VALUE_ERROR THEN
            raise_application_error(-20302,'Error: Se han ingresado uno o más valores con el formato incorrecto.');
        WHEN DUP_VAL_ON_INDEX THEN
            raise_application_error(-20301,'Error: La llave que intenta insertar ya existe.');
        WHEN OTHERS THEN
            raise_application_error(-20300,'Error: Algo salió mal.');
END;
/
CREATE OR REPLACE PROCEDURE update_dept(dept dept.deptno%TYPE, nombre dept.dname%TYPE, loca dept.loc%TYPE)
IS
    deptno_null EXCEPTION;
    name_null EXCEPTION;
    PRAGMA exception_init(deptno_null, -20303);
    PRAGMA exception_init(name_null, -20304);
BEGIN
    
    IF dept IS NULL THEN RAISE deptno_null; END IF;
    IF nombre IS NULL THEN RAISE name_null; END IF;
    
    UPDATE dept SET dname = nombre, loc = loca WHERE dept = deptno;
    
    EXCEPTION
        WHEN name_null THEN
            raise_application_error(-20304,'Error: El nombre del departamento no puede ser NULL.');
        WHEN deptno_null THEN
            raise_application_error(-20303,'Error: El valor "deptno" no puede ser NULL.');
        WHEN VALUE_ERROR THEN
            raise_application_error(-20302,'Error: Se han ingresado uno o más valores con el formato incorrecto.');
        WHEN DUP_VAL_ON_INDEX THEN
            raise_application_error(-20301,'Error: La llave (número de departamento) que ha insertado no existe.');
        WHEN OTHERS THEN
            raise_application_error(-20300,'Error: Algo salió mal.');
END;
/
CREATE OR REPLACE PROCEDURE delete_dept
        (v_depto IN DEPT.DEPTNO%TYPE)
IS
        dept_found      NUMBER;
        emps_found      NUMBER;
        e_delete_dept   EXCEPTION;
        e_exist_dept    EXCEPTION;
        PRAGMA EXCEPTION_INIT(e_delete_dept, -20200);
        PRAGMA EXCEPTION_INIT(e_exist_dept, -20201);
BEGIN
        SELECT COUNT(*)
        INTO dept_found
        FROM DEPT
        WHERE DEPTNO = v_depto;

        SELECT COUNT(*)
        INTO emps_found
        FROM EMP
        WHERE DEPTNO = v_depto;

        IF dept_found = 1 AND emps_found = 0 THEN
            DELETE FROM DEPT WHERE DEPT.DEPTNO = v_depto;
        ELSIF dept_found = 1 AND emps_found > 0 THEN
            RAISE e_delete_dept;
        ELSIF dept_found = 0 THEN
            RAISE e_exist_dept;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN e_delete_dept THEN
        RAISE_APPLICATION_ERROR(-20200,'ERROR: Tal departamento contiene un empleado en el.');
        WHEN e_exist_dept THEN
        RAISE_APPLICATION_ERROR(-20201,'ERROR: Tal departamento no existe.');
        WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20202,'ERROR: Algo ha salido mal');
END delete_dept;
/
CREATE OR REPLACE PROCEDURE add_emp(empno emp.empno%TYPE, ename emp.ename%TYPE, jb emp.job%TYPE, mgr emp.mgr%TYPE, hired emp.hiredate%TYPE, sal emp.sal%TYPE, comm emp.comm%TYPE, deptno emp.deptno%TYPE)
IS
    emp_nn EXCEPTION;
    hired_nn EXCEPTION;
    deptfk EXCEPTION;
    dept_nn EXCEPTION;
    PRAGMA EXCEPTION_INIT (deptfk, -02291);
    PRAGMA EXCEPTION_INIT (emp_nn, -20200);
    PRAGMA EXCEPTION_INIT (hired_nn, -20201);
    PRAGMA EXCEPTION_INIT (dept_nn, -20203);
BEGIN
    IF empno IS NULL THEN
        RAISE emp_nn;
    END IF;
    IF hired IS NULL THEN
        RAISE hired_nn;
    END IF;
    IF deptno IS NULL THEN
        RAISE dept_nn;
    END IF;

    INSERT INTO emp VALUES(empno, ename, jb, mgr, hired, sal, comm, deptno);
    
EXCEPTION
        WHEN emp_nn THEN
            RAISE_APPLICATION_ERROR(-20200, 'Error: El nombre del empleado no puede ser NULL');
        WHEN hired_nn THEN
            RAISE_APPLICATION_ERROR(-20201, 'Error: La fecha no puede ser NULL');
        WHEN deptfk THEN
            RAISE_APPLICATION_ERROR(-20202, 'Error: Departamento inexistente');
        WHEN dept_nn THEN
            RAISE_APPLICATION_ERROR(-20203, 'Error: El departamento no puede ser NULL');
        WHEN VALUE_ERROR THEN
            RAISE_APPLICATION_ERROR(-20204, 'Error: Se han ingresado uno o más valores con formato incorrecto');
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20205, 'Error: La llave que intenta insertar ya existe');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20206, 'Error: Algo salió mal');
END;
/
CREATE OR REPLACE PROCEDURE DELETE_EMP
        (v_emp IN EMP.EMPNO%TYPE)
IS
        emp_exist      NUMBER;
        e_exist_emp    EXCEPTION;
        PRAGMA EXCEPTION_INIT(e_exist_emp, -20200);
BEGIN
    SELECT COUNT(*)
    INTO emp_exist
    FROM EMP
    WHERE EMP.EMPNO = v_emp;

    IF emp_exist = 1 THEN
        DELETE FROM EMP WHERE EMP.EMPNO = v_emp;
    ELSE
        RAISE e_exist_emp;
    END IF;

    EXCEPTION
        WHEN e_exist_emp THEN
        RAISE_APPLICATION_ERROR(-20200,'ERROR: No existe el empleado.');
END DELETE_EMP;
/
CREATE OR REPLACE PROCEDURE update_emp(eno emp.empno%TYPE, enam emp.ename%TYPE, jb emp.job%TYPE, magr emp.mgr%TYPE, hired emp.hiredate%TYPE, sala emp.sal%TYPE, commi emp.comm%TYPE, depno emp.deptno%TYPE)
IS
    emp_nn EXCEPTION;
    hired_nn EXCEPTION;
    deptfk EXCEPTION;
    dept_nn EXCEPTION;
    emp_ex EXCEPTION;
    PRAGMA EXCEPTION_INIT (deptfk, -02291);
    PRAGMA EXCEPTION_INIT (emp_nn, -20200);
    PRAGMA EXCEPTION_INIT (hired_nn, -20201);
    PRAGMA EXCEPTION_INIT (dept_nn, -20202);
    PRAGMA EXCEPTION_INIT (emp_ex, -20203);
    cont NUMBER;
BEGIN
    IF eno IS NULL THEN
        RAISE emp_nn;
    END IF;
    IF hired IS NULL THEN
        RAISE hired_nn;
    END IF;
    IF depno IS NULL THEN
        RAISE dept_nn;
    END IF;

    SELECT COUNT(*) INTO cont
    FROM emp
    WHERE empno = eno;
    IF cont < 1 THEN
        RAISE emp_ex;
    END IF;

    UPDATE emp
    SET ename = enam,
        job = jb,
        mgr = magr,
        hiredate = hired,
        sal = sala,
        comm = commi,
        deptno = depno
    WHERE empno = eno;

    EXCEPTION
        WHEN emp_nn THEN
            RAISE_APPLICATION_ERROR(-20200, 'Error: El nombre del empleado no puede ser NULL');
        WHEN hired_nn THEN
            RAISE_APPLICATION_ERROR(-20201, 'Error: La fecha no puede ser NULL');
        WHEN deptfk THEN
            RAISE_APPLICATION_ERROR(-20204, 'Error: Departamento inexistente');
        WHEN dept_nn THEN
            RAISE_APPLICATION_ERROR(-20202, 'Error: El departamento no puede ser NULL');
        WHEN VALUE_ERROR THEN
            RAISE_APPLICATION_ERROR(-20205, 'Error: Se han ingresado uno o más valores con formato incorrecto');
        WHEN emp_ex THEN
            RAISE_APPLICATION_ERROR(-20203, 'Error: Empleado inexistente');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20206, 'Error: Algo salió mal');
END;
/
CREATE OR REPLACE FUNCTION noEmp_depto
    (v_deptNo  EMP.DEPTNO%TYPE) RETURN NUMBER IS
    emp_count   NUMBER := 0;
    dept_exist  NUMBER;
    e_exist_dept    EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_exist_dept,-20200);
BEGIN
    SELECT COUNT(*)
    INTO dept_exist
    FROM DEPT
    WHERE DEPTNO = v_deptNo;

    IF dept_exist = 1 THEN
        SELECT COUNT(*)
        INTO emp_count
        FROM EMP
        WHERE DEPTNO = v_deptNo;
        RETURN emp_count;
    ELSE
        RAISE e_exist_dept;
    END IF;
    EXCEPTION
        WHEN e_exist_dept THEN
            raise_application_error(-20301,'Error: La llave ingresada no existe.');
        WHEN VALUE_ERROR THEN
            RAISE_APPLICATION_ERROR(-20205, 'Error: Se han ingresado uno o más valores con formato incorrecto');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20206, 'Error: Algo salió mal');
END;