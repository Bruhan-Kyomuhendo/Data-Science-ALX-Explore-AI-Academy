# This is a script that tests the `is_prime` function.


"""Here's a simple explanation of how the `is_prime(num)` function works:

1. If the input number `num` is less than 2, it's not prime because prime numbers are greater than 1.
2. Otherwise, it checks if the number `num` is divisible by any number between 2 and its square root.
3. If the number is divisible by any of these numbers, it means that `num` is not prime, and the function returns `False`.
4. If the number is not divisible by any of these numbers, it means that `num` is prime, and the function returns `True`."""

def is_prime(num):
    """
    Check if a given number is prime or not.

    Parameters:
    num (int): The number to be checked.

    Returns:
    bool: True if the number is prime, False otherwise.
    """   
    if num < 2:
        return False
    for i in range(2, int(num**0.5) + 1):
        if num % i == 0:
            return False
    return True

# Testing the function

print(is_prime(17))  # Expected output: True
print(is_prime(18))  # Expected output: False