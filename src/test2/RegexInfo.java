package test2;

import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class RegexInfo {
    private final String phoneReg = "0\\d{3}-\\d{3}-\\d{3}";
    private final String emailReg = "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}";
    private final String birthReg = "(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/\\d{4}";

    Scanner scanner = new Scanner(System.in);
    Pattern pattern;
    Matcher matcher;

    public RegexInfo() {
        System.out.print("Nhap vao so dien thoai: ");
        String phone = scanner.nextLine();

        System.out.print("Nhap vao email: ");
        String email = scanner.nextLine();

        System.out.print("Nhap vao ngay/thang/nam sinh: ");
        String birth = scanner.nextLine();

        pattern = Pattern.compile(phoneReg);
        matcher = pattern.matcher(phone);
        if (matcher.matches()) {
            System.out.println("So dien thoai hop le");
        } else {
            System.out.println("So dien thoai khong hop le");
        }

        pattern = Pattern.compile(emailReg);
        matcher = pattern.matcher(email);
        if (matcher.matches()) {
            System.out.println("Email hop le");
        } else {
            System.out.println("Email khong hop le");
        }

        pattern = Pattern.compile(birthReg);
        matcher = pattern.matcher(birth);
        if (matcher.matches()) {
            System.out.println("Ngay sinh hop le");
        } else {
            System.out.println("Ngay sinh khong hop le");
        }
    }
}
