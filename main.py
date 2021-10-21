# import only system from os
from os import system, name
from prettytable import PrettyTable
import cx_Oracle
import config as cfg

# Screen cleaner function
def clear():
    
    # for Windows
    if name == 'nt': system('cls')
    
    # for mac and Linux
    else: system('clear')

# Pause screen function
def pause():
    input("\nPresione <ENTER> para continuar...")

def add_dept():
    try:
        # Create a connection to the Oracle Database
        connection = cx_Oracle.connect(cfg.username,cfg.password,cfg.dsn)
        
        # Create a new cursor
        cursor = connection.cursor()
        
        # Ask fot the data
        clear()
        print("\t << Nuevo departamento >>\n")

        no_dept = int(input("Número del departamento (deptno): "))
        name = input("Nombre del departamento (dname): ")
        location = input("Localización del departamento (loc): ")

        # Execute procedure
        cursor.callproc(f"{cfg.username}.add_dept",[no_dept, name, location])
        
        # Save
        connection.commit()

        # Close the cursor
        cursor.close()

        #Confirm
        clear()
        print(f"El departamento \"{name}\" se ha agregado correctamente.")
    except cx_Oracle.Error as error:
        print(error)
        print("El registro no se llevo a cabo (x_x)")
    except ValueError:
        print("\tError: El número de departamento debe ser un valor entero.")
    pause()

def update_dept():
    try:
        # Create a connection to the Oracle Database
        connection = cx_Oracle.connect(cfg.username,cfg.password,cfg.dsn)
        
        # Create a new cursor
        cursor = connection.cursor()
        
        # Ask fot the data
        clear()
        print("\t << Actualizar departamento >>\n")

        no_dept = int(input("Número del departamento (deptno): "))
        name = input("Nombre del departamento (dname): ")
        location = input("Localización del departamento (loc): ")

        # Execute procedure
        cursor.callproc(f"{cfg.username}.update_dept",[no_dept, name, location])
        
        # Save
        connection.commit()

        # Close the cursor
        cursor.close()

        #Confirm
        clear()
        print(f"El departamento \"{name}\" se ha actualizado correctamente.")
    except cx_Oracle.Error as error:
        print(error)
        print("La actualización no se llevo a cabo (x_x)")
    except ValueError:
        print("\tError: El número de departamento debe ser un valor entero.")
    pause()

def delete_dept():
    try:
        # Create a connection to the Oracle Database
        connection = cx_Oracle.connect(cfg.username,cfg.password,cfg.dsn)
        
        # Create a new cursor
        cursor = connection.cursor()
        
        # Ask fot the data
        clear()
        print("\t << Eliminar departamento >>\n")

        no_dept = int(input("Número del departamento (deptno): "))

        # Execute procedure
        cursor.callproc(f"{cfg.username}.delete_dept",[no_dept])
        
        # Save
        connection.commit()

        # Close the cursor
        cursor.close()

        #Confirm
        clear()
        print(f"El departamento \"{no_dept}\" se ha eliminado correctamente.")
    except cx_Oracle.Error as error:
        print(error)
        print("La eliminacion no se llevo a cabo (x_x)")
    except ValueError:
        print("\tError: El número de departamento debe ser un valor entero.")
    pause()

def add_emp():
    try:
        # create a connection to the Oracle Database
        connection = cx_Oracle.connect(cfg.username,cfg.password,cfg.dsn)
        
        # create a new cursor
        cursor = connection.cursor()
        
        clear()
        print("\t << Nuevo empleado >>\n")

        no_emp = int(input("Número del empleado (empno): "))
        name = input("Nombre del empleado (ename): ")
        job = input("Trabajo del empleado (jobid): ")
        manager = int(input("Jefe del empleado (mgr): "))
        hiredate = input("Fecha de inicio (hiredate): ")
        salary = int(input("Salario del empleado (sal): "))
        commision = int(input("Comisión (comm): "))
        no_dept = int(input("Número del departamento (deptno): "))
        #Execute procedure
        cursor.callproc(f"{cfg.username}.add_emp",[no_emp, name, job, manager, hiredate, salary, commision, no_dept])
        
        # Save
        connection.commit()

        cursor.close()

        #Confirm
        clear()
        print(f"El empleado \"{name}\" se ha agregado correctamente.")
    except cx_Oracle.Error as error:
        print(error)
        print("El registro no se llevo a cabo (x_x)")
    except ValueError:
        print("\tError: El número de empleado o del departamento debe ser un valor entero.")
    pause()

def update_emp():
    try:
        # create a connection to the Oracle Database
        connection = cx_Oracle.connect(cfg.username,cfg.password,cfg.dsn)
        
        # create a new cursor
        cursor = connection.cursor()
        
        clear()
        print("\t << Actualizar empleado >>\n")

        no_emp = int(input("¿Que empleado quieres actualizar? (escribe el id): "))
        clear()
        name = input("Nombre del empleado (ename): ")
        job = input("Trabajo del empleado (jobid): ")
        manager = int(input("Jefe del empleado (mgr): "))
        hiredate = input("Fecha de inicio (hiredate): ")
        salary = int(input("Salario del empleado (sal): "))
        commision = int(input("Comisión (comm): "))
        no_dept = int(input("Número del departamento (deptno): "))
        #Execute procedure
        cursor.callproc(f"{cfg.username}.update_emp",[no_emp, name, job, manager, hiredate, salary, commision, no_dept])
        
        # Save
        connection.commit()

        cursor.close()

        #Confirm
        clear()
        print(f"El empleado \"{name}\" se ha modificado correctamente.")
    except cx_Oracle.Error as error:
        print(error)
        print("La modificación no se llevo a cabo (x_x)")
    except ValueError:
        print("\tError: El número de empleado o del departamento debe ser un valor entero.")
    pause()

def delete_emp():
    try:
        # create a connection to the Oracle Database
        connection = cx_Oracle.connect(cfg.username,cfg.password,cfg.dsn)
        
        # create a new cursor
        cursor = connection.cursor()
        
        clear()
        print("\t << Eliminar empleado >>\n")

        no_emp = int(input("Número del empleado (empno): "))
        #Execute procedure
        cursor.callproc(f"{cfg.username}.delete_emp",[no_emp])
        
        # Save
        connection.commit()

        cursor.close()

        #Confirm
        clear()
        print(f"El empleado \"{no_emp}\" se ha eliminado correctamente.")
    except cx_Oracle.Error as error:
        print(error)
        print("La eliminacion no se llevo a cabo (x_x)")
    except ValueError:
        print("\tError: El número de empleado debe ser un valor entero.")
    pause()

def noEmp_depto():
    try:
        # create a connection to the Oracle Database
        connection = cx_Oracle.connect(cfg.username,cfg.password,cfg.dsn)
        
        # create a new cursor
        cursor = connection.cursor()
        
        clear()
        print("\t << Contar empleados por departamento >>\n")
        
        no_depto = int(input("Número del departamento (deptno): "))

        no_emps = cursor.callfunc(f"{cfg.username}.noemp_depto",int,[no_depto])
        #cursor.close()

        #Confirm
        clear()
        print(f"El numero de empleados en el departamento \"{no_depto}\" es \"{no_emps}\".")
    except cx_Oracle.Error as error:
        print(error)
        print("El conteo no se ha llevado a cabo(x_x)")
    except ValueError:
        print("\tError: El número de departamento debe ser un valor entero.")
    pause()

# Print all registers in a table
def show_data(table):

    # Clean screen
    clear()

    # Create a connection to the Oracle Database
    connection = cx_Oracle.connect(cfg.username,cfg.password,cfg.dsn)
        
    # Create a new cursor
    cursor = connection.cursor()

    # Execute query
    cursor.execute(f"SELECT * FROM {table}")

    print(f"\t\tTabla {table}\n")

    # Get columns names
    col_name = [row[0] for row in cursor.description]

    # Declare the table (PrettyTable)
    pretty_table = PrettyTable(col_name)

    # Get all rows
    for row in cursor:
        pretty_table.add_row(row)

    # Print table
    print(pretty_table)
    pause()


# Print a menu
def menu():
    clear()
    print("\t\t<< MENÚ - CRUD >>\n")

    print("\t1 ) Agregar departamento")
    print("\t2 ) Actualizar departamento")
    print("\t3 ) Eliminar departamaento")
    print()
    print("\t4 ) Agregar empleado")
    print("\t5 ) Actualizar empleado")
    print("\t6 ) Eliminar empleado")
    print("\t7 ) Número de empleados en un departamento")
    print()
    print("\t8 ) Mostrar la tabla de departamentos")
    print("\t9 ) Mostrar la tabla de empleados")
    print()
    print("\t10) Salir")

# main function
def main():

    opcion = 0

    while opcion != 10:
        
        menu()
        opcion = int(input("\n\t>> Elección: "))
        
        if(opcion == 1):
            add_dept()
        elif(opcion == 2):
            update_dept()
        elif(opcion == 3):
            delete_dept()
        elif(opcion == 4):
            add_emp()
        elif(opcion == 5):
            update_emp()
        elif(opcion == 6):
            delete_emp()
        elif(opcion == 7):
            noEmp_depto()
        elif(opcion == 8):
            show_data("DEPT")
        elif(opcion == 9):
            show_data("EMP")

if __name__ == '__main__':
    main()