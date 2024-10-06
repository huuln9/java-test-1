package test1;

import java.util.Scanner;

public class Student extends Person implements Comparable<Student> {
    private String id;
    private Double average;
    
    public Student() {
        Scanner scanner = new Scanner(System.in);

        System.out.print("Nhap id: ");
        this.id = scanner.nextLine();

        System.out.print("Nhap diem trung binh: ");
        this.average = scanner.nextDouble();
    }
    
    public void xuat() {
        System.out.println("id: " + this.id);
        System.out.println("average: " + this.average);
        this.xuatTT();
    }

    @Override
    public int compareTo(Student o) {
        return Double.compare(this.average, o.average);
    }
}
