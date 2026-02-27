numbers = [2, 4, 6, 3, 9, 12, 3]  # List of numbers
seen_numbers = []  # To store numbers we've already processed

for number in numbers:  # For loop to iterate over the list
    if number % 2 == 0:  # If the number is even
        if number not in seen_numbers:  # Membership check
            seen_numbers.append(number)  # Add the number to seen_numbers
            
            print(f"Counting down from {number}:")
            while number > 0:  # While loop for countdown
                print(number)
                number -= 1  # Decrement the number
        else:
            print(f"{number} is even and already processed!")
    else:
        print(f"{number} is odd.")

print(f"Seen numbers: {seen_numbers}")