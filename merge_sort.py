def merge_sort(arr):
    """
    Sorts an array using the Merge Sort algorithm.

    Time Complexity: O(n log n) in all cases
    Space Complexity: O(n)

    Args:
        arr: List of comparable elements to sort

    Returns:
        Sorted list
    """
    if len(arr) <= 1:
        return arr

    # Divide the array into two halves
    mid = len(arr) // 2
    left = arr[:mid]
    right = arr[mid:]

    # Recursively sort both halves
    left = merge_sort(left)
    right = merge_sort(right)

    # Merge the sorted halves
    return merge(left, right)


def merge(left, right):
    """
    Merges two sorted arrays into a single sorted array.

    Args:
        left: First sorted array
        right: Second sorted array

    Returns:
        Merged sorted array
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


# Example usage and testing
if __name__ == "__main__":
    # Test case 1: Random unsorted array
    arr1 = [64, 34, 25, 12, 22, 11, 90]
    print(f"Original array: {arr1}")
    print(f"Sorted array: {merge_sort(arr1)}")
    print()

    # Test case 2: Array with duplicates
    arr2 = [5, 2, 8, 2, 9, 1, 5, 5]
    print(f"Original array: {arr2}")
    print(f"Sorted array: {merge_sort(arr2)}")
    print()

    # Test case 3: Already sorted array
    arr3 = [1, 2, 3, 4, 5]
    print(f"Original array: {arr3}")
    print(f"Sorted array: {merge_sort(arr3)}")
    print()

    # Test case 4: Reverse sorted array
    arr4 = [5, 4, 3, 2, 1]
    print(f"Original array: {arr4}")
    print(f"Sorted array: {merge_sort(arr4)}")
    print()

    # Test case 5: Single element
    arr5 = [42]
    print(f"Original array: {arr5}")
    print(f"Sorted array: {merge_sort(arr5)}")
    print()

    # Test case 6: Empty array
    arr6 = []
    print(f"Original array: {arr6}")
    print(f"Sorted array: {merge_sort(arr6)}")
