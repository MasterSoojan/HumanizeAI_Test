/**
 * Merge Sort Implementation in Java
 *
 * Time Complexity: O(n log n) in all cases
 * Space Complexity: O(n) for the temporary array
 */
public class MergeSort {

    /**
     * Main method to initiate merge sort
     *
     * @param arr the array to be sorted
     */
    public static void mergeSort(int[] arr) {
        if (arr == null || arr.length == 0) {
            return;
        }
        mergeSort(arr, 0, arr.length - 1);
    }

    /**
     * Recursive method to divide the array and sort
     *
     * @param arr the array to be sorted
     * @param left the left index
     * @param right the right index
     */
    private static void mergeSort(int[] arr, int left, int right) {
        if (left < right) {
            // Find the middle point
            int mid = left + (right - left) / 2;

            // Sort the left half
            mergeSort(arr, left, mid);

            // Sort the right half
            mergeSort(arr, mid + 1, right);

            // Merge the sorted halves
            merge(arr, left, mid, right);
        }
    }

    /**
     * Merge two sorted subarrays into one sorted array
     *
     * @param arr the array containing the subarrays
     * @param left the left index
     * @param mid the middle index
     * @param right the right index
     */
    private static void merge(int[] arr, int left, int mid, int right) {
        // Create temporary arrays
        int[] leftArr = new int[mid - left + 1];
        int[] rightArr = new int[right - mid];

        // Copy data to temporary arrays
        System.arraycopy(arr, left, leftArr, 0, leftArr.length);
        System.arraycopy(arr, mid + 1, rightArr, 0, rightArr.length);

        // Merge the temporary arrays back
        int i = 0;      // Initial index of left subarray
        int j = 0;      // Initial index of right subarray
        int k = left;   // Initial index of merged array

        while (i < leftArr.length && j < rightArr.length) {
            if (leftArr[i] <= rightArr[j]) {
                arr[k++] = leftArr[i++];
            } else {
                arr[k++] = rightArr[j++];
            }
        }

        // Copy remaining elements from leftArr
        while (i < leftArr.length) {
            arr[k++] = leftArr[i++];
        }

        // Copy remaining elements from rightArr
        while (j < rightArr.length) {
            arr[k++] = rightArr[j++];
        }
    }

    /**
     * Utility method to print array
     */
    public static void printArray(int[] arr) {
        for (int num : arr) {
            System.out.print(num + " ");
        }
        System.out.println();
    }

    /**
     * Main method to test merge sort
     */
    public static void main(String[] args) {
        int[] arr = {64, 34, 25, 12, 22, 11, 90};

        System.out.println("Original array:");
        printArray(arr);

        mergeSort(arr);

        System.out.println("Sorted array:");
        printArray(arr);
    }
}
