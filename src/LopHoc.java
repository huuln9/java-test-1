import java.util.*;

public class LopHoc {
    private Integer soLuongSV;
    private Student[] students;

    void nhap() {
        Scanner scanner = new Scanner(System.in);

        System.out.println("-----------------------NHAP DS SV-----------------------");

        System.out.print("Nhap so luong sinh vien: ");
        this.soLuongSV = scanner.nextInt();
        
        this.students = new Student[this.soLuongSV];

        for (int i = 0; i < this.soLuongSV; i++) {
            System.out.println("\nNhap sinh vien " + (i + 1) + ": ");
            Student student = new Student();
            this.students[i] = student;
        }
    }

    void xuat() {
        System.out.println("-----------------------XUAT DS SV-----------------------");

        System.out.print("So luong sinh vien: " + this.soLuongSV + "\n");

        for (int i = 0; i < this.soLuongSV; i++) {
            System.out.println("\nSinh vien " + (i + 1) + ": ");
            this.students[i].xuat();
        }
    }
    
    void xuatTheoDiem() {
        System.out.println("-----------------------XEP HANG SV-----------------------");

        this.xuat();

        Arrays.sort(this.students, Comparator.reverseOrder());

        this.xuat();
    }
}
