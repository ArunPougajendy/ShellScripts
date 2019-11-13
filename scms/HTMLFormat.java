import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.StringTokenizer;
import java.io.*;

/**
 * Developed by Arun
 *
 */
public class HTMLFormat {

    public static void main(String[] args) {
        try {
            FileOutputStream outputStream1 = new FileOutputStream("/*output file path nad name*/");
            OutputStreamWriter outputStreamWriter1 = new OutputStreamWriter(outputStream1);
            BufferedWriter bufferedWriter1 = new BufferedWriter(outputStreamWriter1);
                BufferedReader read1;
                read1 = new BufferedReader(new FileReader("/*input file path nad name*/"));
                String line1=read1.readLine();
                while(line1!=null)
                {

                    StringTokenizer stringtokenizer = new StringTokenizer(line1, "*");
                        while (stringtokenizer.hasMoreElements())
                        {
                                bufferedWriter1.write(stringtokenizer.nextToken().toString());
                                bufferedWriter1.newLine();
                        }
                line1=read1.readLine();
                }

            bufferedWriter1.close();

        } catch (IOException e) {
            e.printStackTrace();
        }

    }
}


