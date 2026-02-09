import mysql.connector

try:
    # 1. Setup Connection
    conn = mysql.connector.connect(
        host="localhost",
        user="root",          # Double check this is your MySQL username
        password="516802", # Put your actual password here
        database="Company_Management_System"
    )
    
    if conn.is_connected():
        print("Successfully connected to the database!")
    
    cursor = conn.cursor()
    
    # 2. Fetch the Data
    cursor.execute("SELECT * FROM employee_dept_summary")
    rows = cursor.fetchall()

    # 3. Check if we actually got anything
    if not rows:
        print("The table is empty! Go back to Workbench and insert some employees.")
    else:
        print("\n=== COMPANY EMPLOYEE REPORT ===")
        print(f"{'Name':<15} | {'Salary':<10} | {'Dept':<10} | {'Location'}")
        print("-" * 50)
        
        for (name, salary, dept, loc) in rows:
            print(f"{name:<15} | {salary:<10.2f} | {dept:<10} | {loc}")
        print("-" * 50)

except mysql.connector.Error as err:
    print(f"SQL Error: {err}")
finally:
    if 'conn' in locals() and conn.is_connected():
        cursor.close()
        conn.close()
        print("\nConnection closed.")

# This keeps the window open so you can see the table
input("\nPress Enter to exit...")