import mysql.connector

try:
    # Set up the connection
    conn = mysql.connector.connect(
        host="localhost",
        user="root",          # Change if your username is different
        password="yourpassword", # Put your actual password here
        database="Company_Management_System"
    )
    
    cursor = conn.cursor()
    
    # Using the VIEW we created in SQL
    cursor.execute("SELECT * FROM employee_dept_summary")
    
    print("=== COMPANY EMPLOYEE REPORT ===")
    print(f"{'Name':<15} | {'Salary':<10} | {'Dept':<10} | {'Location'}")
    print("-" * 50)
    
    for (name, salary, dept, loc) in cursor.fetchall():
        print(f"{name:<15} | {salary:<10.2f} | {dept:<10} | {loc}")

except mysql.connector.Error as err:
    print(f"Error: {err}")
finally:
    if 'conn' in locals() and conn.is_connected():
        cursor.close()
        conn.close()