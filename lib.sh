#!/bin/bash

# Arrays to store book details (title, author, ISBN, status, quantity)
titles=()
authors=()
isbns=()
statuses=()
quantities=()

# Arrays to store student accounts (username, password)
students_usernames=()
students_passwords=()

# Fixed admin credentials
ADMIN_ID="admin"
ADMIN_PASSWORD="admin123"

# Function to display menu options for Admin
admin_menu() {
    echo "----------------------"
    echo -e "\n\n---- Admin Panel ----"
    echo "1. Add New Book"
    echo "2. Delete Book"
    echo "3. Update Book Info"
    echo "4. Display Book List"
    echo "5. Search Book by Title/Author/ISBN"
    echo "6. Exit to Main Menu"
    echo "----------------------"
}

# Function to display menu options for Student
student_menu() {
    echo "-----------------------"
    echo -e "\n\n---- Student Panel ----"
    echo "1. Display Book List"
    echo "2. Search Book by Title/Author/ISBN"
    echo "3. Borrow Book"
    echo "4. Return Book"
    echo "5. Exit to Main Menu"
    echo "------------------------"
}

# Function to check admin credentials
admin_login() {
    read -p "Enter Admin ID: " id
    read -sp "Enter Admin Password: " password
    echo
    if [[ "$id" == "$ADMIN_ID" && "$password" == "$ADMIN_PASSWORD" ]]; then
        echo -e "\n-----Admin login successful!-----\n"
        return 0
    else
        echo -e "\n.....Invalid Admin credentials.....\n"
        return 1
    fi
}

# Function to create a new student account
create_student_account() {
    read -p "Enter Student Username: " username
    # Check if username already exists
    for user in "${students_usernames[@]}"; do
        if [[ "$user" == "$username" ]]; then
            echo -e "\n----Username already exists.\nPlease choose a different username.\n"
            return
        fi
    done
    read -sp "Enter Student Password: " password
    echo
    students_usernames+=("$username")
    students_passwords+=("$password")
    echo -e "\n-----Student account created successfully!-----\n\n----------Student Login----------\n"
}

# Function to check student credentials
student_login() {
    read -p "Enter Student Username: " username
    read -sp "Enter Student Password: " password
    echo
    for i in "${!students_usernames[@]}"; do
        if [[ "${students_usernames[$i]}" == "$username" && "${students_passwords[$i]}" == "$password" ]]; then
            echo -e "\n-----Student login successful!-----\n"
            return 0
        fi
    done
    echo -e "\n.....Invalid student credentials.....\n"
    return 1
}

# Add new book
add_book() {
    read -p "Enter Book Title: " title
    read -p "Enter Author's Name: " author
    read -p "Enter ISBN: " isbn
    read -p "Enter Quantity: " quantity
    titles+=("$title")
    authors+=("$author")
    isbns+=("$isbn")
    statuses+=("Available")
    quantities+=("$quantity")
    echo -e "\n-----Book added successfully-----\n\n"
}

# Delete book by ISBN
delete_book() {
    read -p "Enter ISBN to delete book: " isbn
    for i in "${!isbns[@]}"; do
        if [[ "${isbns[$i]}" == "$isbn" ]]; then
            unset 'titles[$i]'
            unset 'authors[$i]'
            unset 'isbns[$i]'
            unset 'statuses[$i]'
            unset 'quantities[$i]'
            echo -e "\n-----Book deleted successfully-----\n\n"
            return
        fi
    done
    echo -e "\n.....Book not found.....\n\n"
}

# Update book info
update_book() {
    read -p "Enter ISBN to update: " isbn
    for i in "${!isbns[@]}"; do
        if [[ "${isbns[$i]}" == "$isbn" ]]; then
            read -p "Enter New Book Title: " new_title
            read -p "Enter New Author's Name: " new_author
            read -p "Enter New Quantity: " new_quantity
            titles[$i]="$new_title"
            authors[$i]="$new_author"
            quantities[$i]="$new_quantity"
            echo -e "\n-----Book info updated successfully-----\n\n"
            return
        fi
    done
    echo -e "\n.....Book not found.....\n"
}

# Display all books
display_books() {
    echo -e "\n\n---------- Book List ----------\n"
    for i in "${!titles[@]}"; do
        echo -e "Title: ${titles[$i]},\nAuthor: ${authors[$i]},\nISBN: ${isbns[$i]},\nStatus: ${statuses[$i]},\nQuantity: ${quantities[$i]}\n--------------------\n"
    done
}

# Search for a book by title, author, or ISBN
search_book() {
    read -p "Enter Title, Author, or ISBN to search: " search
    for i in "${!titles[@]}"; do
        if [[ "${titles[$i]}" == *"$search"* || "${authors[$i]}" == *"$search"* || "${isbns[$i]}" == "$search" ]]; then
            echo -e "Title: ${titles[$i]},\nAuthor: ${authors[$i]},\nISBN: ${isbns[$i]},\nStatus: ${statuses[$i]},\nQuantity: ${quantities[$i]}\n--------------------\n"
            return
        fi
    done
    echo -e "\n.....No matching book found.....\n"
}

# Borrow a book
borrow_book() {
    read -p "Enter ISBN to borrow: " isbn
    for i in "${!isbns[@]}"; do
        if [[ "${isbns[$i]}" == "$isbn" && "${statuses[$i]}" == "Available" && "${quantities[$i]}" -gt 0 ]]; then
            statuses[$i]="Borrowed"
            quantities[$i]=$((quantities[$i] - 1))
            echo -e "\n-----You have borrowed the book-----\n"
            return
        elif [[ "${isbns[$i]}" == "$isbn" && "${statuses[$i]}" == "Borrowed" ]]; then
            echo -e "\n.....This book is already borrowed.....\n"
            return
        elif [[ "${isbns[$i]}" == "$isbn" && "${quantities[$i]}" -eq 0 ]]; then
            echo -e "\nSorry, no copies are available.....\nStock will update soon.....\n"
            return
        fi
    done
    echo -e "\nBook not found.....\nStock will update soon.....\nPlease, check after two days.....\n"
}

# Return a book
return_book() {
    read -p "Enter ISBN to return: " isbn
    for i in "${!isbns[@]}"; do
        if [[ "${isbns[$i]}" == "$isbn" && "${statuses[$i]}" == "Borrowed" ]]; then
            statuses[$i]="Available"
            quantities[$i]=$((quantities[$i] + 1))
            echo -e "\n-----You have returned the book-----\n"
            return
        fi
    done
    echo -e "\n-----Book not found or wasn't borrowed.....\n"
}

# Main loop
while true; do
    echo "-------------------------------------------------"
    echo " -----------------------------------------------"
    echo "|     Welcome to Library Management System      |"
    echo " -----------------------------------------------"
    echo "-------------------------------------------------"
    echo -e "\n1. Admin Login"
    echo -e "\n2. Student Login"
    echo -e "\n3. Exit"
    echo "----------------------"
    read -p "Choose option: " option
    case $option in
        1)
            if admin_login; then
                while true; do
                    admin_menu
		    echo "--------------------"
                    read -p "Choose option: " admin_choice
                    case $admin_choice in
                        1) add_book ;;
                        2) delete_book ;;
                        3) update_book ;;
                        4) display_books ;;
                        5) search_book ;;
                        6) break ;;
                        *) echo -e "\nInvalid option.....\nTry again.....\n" ;;
                    esac
                done
            fi
            ;;
        2)
            echo -e "\n\n--------------- Student Login/Signup ---------------\n\n"
            read -p "Do you have an account? (yes/no): " account_exists
            if [[ "$account_exists" == "no" ]]; then
                create_student_account
            fi
            if student_login; then
                while true; do
                    student_menu
		    echo "-------------------"
                    read -p "Choose option: " student_choice
                    case $student_choice in
                        1) display_books ;;
                        2) search_book ;;
                        3) borrow_book ;;
                        4) return_book ;;
                        5) break ;;
                        *) echo -e "\nInvalid option.....\nTry again.....\n" ;;
                    esac
                done
            fi
            ;;
        3) break ;;
        *) echo -e "\nInvalid option.....\nTry again.....\n" ;;
    esac
done

