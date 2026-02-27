def linear_search(list, target):
    for i in range(len(list)):
        if list[i] == target:
            return i
    return None

list = [1,2,3,4,5,6,7,8,9,10]
target = 5

print(linear_search(list, target))



