package test3;

import java.util.Scanner;

public class QuickSort {
    
    Scanner scanner = new Scanner(System.in);
    
    int[] arr;
    
    public QuickSort() {
        System.out.print("Nhap so luong phan tu: ");
        int num = scanner.nextInt();
        
        this.arr = new int[num];
        
        for (int i = 0; i < num; i++) {
            System.out.print("Nhap phan tu thu " + (i + 1) + ": ");
            this.arr[i] = scanner.nextInt();
        }

        System.out.println("------------ARR------------");
        
        for (int i = 0; i < this.arr.length; i++) {
            System.out.print(this.arr[i] + " ");
        }
        System.out.println("");

       this.quickSort(this.arr, 0, this.arr.length - 1);

        System.out.println("------------ARR SORTED------------");

        for (int i = 0; i < this.arr.length; i++) {
            System.out.print(this.arr[i] + " ");
        }
        System.out.println("");

    }
    
    void quickSort(int[] arr, int iLow, int iHigh) {
        if (iLow < iHigh) {
            int index = this.partition(arr, iLow, iHigh);
            
            this.quickSort(arr, iLow, index - 1);
            this.quickSort(arr, index + 1, iHigh);
        }
    }
    
    int partition(int[] arr, int iLow, int iHigh) {
        int pivot = arr[iHigh];
        int iLeft = iLow;
        int iRight = iHigh - 1;

        while (true) {
            while (iLeft <= iRight && arr[iLeft] < pivot) iLeft++;
            while (iRight >= iLeft && arr[iRight] > pivot) iRight--;

            if (iLeft >= iRight) break;

            this.swap(iLeft, iRight);
            iLeft++;
            iRight++;
        }
        this.swap(iLeft, iHigh);
        return iLeft;
    }
    
    void swap(int a, int b) {
        int t = arr[a];
        arr[a] = arr[b];
        arr[b] = t;
    }
}
