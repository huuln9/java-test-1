import java.util.Scanner;

public class Person {
    protected String name;
    protected Integer age;

    public Person() {
        Scanner scanner = new Scanner(System.in);
        
        System.out.print("Nhap ten: ");
        this.name = scanner.nextLine();

        System.out.print("Nhap tuoi: ");
        this.age = scanner.nextInt();
    }

    protected void xuatTT() {
        System.out.println("name: " + this.name);
        System.out.println("age: " + this.age);
    }
}
