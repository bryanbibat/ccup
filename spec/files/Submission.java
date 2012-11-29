import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Scanner;

public class Submission {
	public static void main(String... args) throws IOException {
		Scanner sc = new Scanner(new File("input.txt"));
		PrintWriter out
		   = new PrintWriter(new BufferedWriter(new FileWriter("output.txt")));
	    while (sc.hasNextLine()) {
	        Scanner lsc = new Scanner(sc.nextLine());
	        long sum = 0;
	        while (lsc.hasNextInt()) {
	        	sum += lsc.nextInt();	      
	        }
	        out.println(Long.toString(sum));
	        lsc.close();
	    }
	    out.close();
	    sc.close();
	}
}
