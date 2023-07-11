import subprocess
import getpass

def add_user(username, password, password_file):
    # Prompt for the password if not provided
    if not password:
        password = getpass.getpass("Enter password: ")

    # Execute htpasswd command to add user
    subprocess.run(["htpasswd", "-b", "-m", "-c", password_file, username, password], check=True)
    print(f"User '{username}' added to the password file.")

def remove_user(username, password_file):
    # Execute htpasswd command to remove user
    subprocess.run(["htpasswd", "-D", password_file, username], check=True)
    print(f"User '{username}' removed from the password file.")

def main():
    password_file = "passwords.txt"  # Path to the password file

    while True:
        print("\nMenu:")
        print("1. Add user")
        print("2. Remove user")
        print("3. Exit")

        choice = input("Enter your choice: ")

        if choice == "1":
            username = input("Enter username: ")
            password = getpass.getpass("Enter password: ")
            add_user(username, password, password_file)
        elif choice == "2":
            username = input("Enter username: ")
            remove_user(username, password_file)
        elif choice == "3":
            break
        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    main()
