def merge_sort(arr):
    """
    Sorts an array using the merge sort algorithm.

    Time Complexity: O(n log n) in all cases
    Space Complexity: O(n)

    Args:
        arr (list): The array to be sorted

    Returns:
        list: The sorted array
    """
    if len(arr) <= 1:
        return arr

    # Find the middle point
    mid = len(arr) // 2

    # Recursively sort the left half
    left = merge_sort(arr[:mid])

    # Recursively sort the right half
    right = merge_sort(arr[mid:])

    # Merge the sorted halves
    return merge(left, right)


def merge(left, right):
    """
    Merges two sorted arrays into a single sorted array.

    Args:
        left (list): First sorted array
        right (list): Second sorted array

    Returns:
        list: Merged sorted array
    """
    result = []
    i = j = 0

    # Compare elements from left and right arrays
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1

    # Add remaining elements from left array
    while i < len(left):
        result.append(left[i])
        i += 1

    # Add remaining elements from right array
    while j < len(right):
        result.append(right[j])
        j += 1

    return result


def merge_sort_inplace(arr, left=0, right=None):
    """
    Sorts an array in-place using the merge sort algorithm.

    Time Complexity: O(n log n) in all cases
    Space Complexity: O(n) - due to temporary arrays during merging

    Args:
        arr (list): The array to be sorted
        left (int): Starting index (default: 0)
        right (int): Ending index (default: len(arr) - 1)
    """
    if right is None:
        right = len(arr) - 1

    if left < right:
        mid = (left + right) // 2
        merge_sort_inplace(arr, left, mid)
        merge_sort_inplace(arr, mid + 1, right)
        merge_inplace(arr, left, mid, right)


def merge_inplace(arr, left, mid, right):
    """
    Merges two sorted subarrays in-place.

    Args:
        arr (list): The array containing subarrays
        left (int): Starting index of left subarray
        mid (int): Ending index of left subarray
        right (int): Ending index of right subarray
    """
    # Create temporary arrays
    left_arr = arr[left:mid + 1]
    right_arr = arr[mid + 1:right + 1]

    i = j = 0
    k = left

    # Merge the temporary arrays back into arr
    while i < len(left_arr) and j < len(right_arr):
        if left_arr[i] <= right_arr[j]:
            arr[k] = left_arr[i]
            i += 1
        else:
            arr[k] = right_arr[j]
            j += 1
        k += 1

    # Copy remaining elements from left_arr
    while i < len(left_arr):
        arr[k] = left_arr[i]
        i += 1
        k += 1

    # Copy remaining elements from right_arr
    while j < len(right_arr):
        arr[k] = right_arr[j]
        j += 1
        k += 1


if __name__ == "__main__":
    # Test cases
    print("Merge Sort Implementation Examples")
    print("=" * 50)

    # Test 1: Basic sorting
    test_arr1 = [64, 34, 25, 12, 22, 11, 90]
    print(f"Original array: {test_arr1}")
    sorted_arr1 = merge_sort(test_arr1)
    print(f"Sorted array: {sorted_arr1}")
    print()

    # Test 2: Already sorted array
    test_arr2 = [1, 2, 3, 4, 5]
    print(f"Already sorted: {test_arr2}")
    sorted_arr2 = merge_sort(test_arr2)
    print(f"After merge sort: {sorted_arr2}")
    print()

    # Test 3: Reverse sorted array
    test_arr3 = [9, 7, 5, 3, 1]
    print(f"Reverse sorted: {test_arr3}")
    sorted_arr3 = merge_sort(test_arr3)
    print(f"After merge sort: {sorted_arr3}")
    print()

    # Test 4: Array with duplicates
    test_arr4 = [5, 2, 8, 2, 9, 1, 5, 5]
    print(f"Array with duplicates: {test_arr4}")
    sorted_arr4 = merge_sort(test_arr4)
    print(f"After merge sort: {sorted_arr4}")
    print()

    # Test 5: In-place sorting
    test_arr5 = [64, 34, 25, 12, 22, 11, 90]
    print(f"In-place sort - Original: {test_arr5}")
    merge_sort_inplace(test_arr5)
    print(f"In-place sort - Sorted: {test_arr5}")
    print()

    # Test 6: Single element and empty
    test_arr6 = [42]
    test_arr7 = []
    print(f"Single element: {merge_sort(test_arr6)}")
    print(f"Empty array: {merge_sort(test_arr7)}")
