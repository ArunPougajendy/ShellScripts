import java.io.*;
import java.sql.*;
import java.util.StringTokenizer;

public class FileHtml1 {

        /**
         * Developed by Arun
         */
        static final private String driver="oracle.jdbc.driver.OracleDriver";
        static final private String db_url="jdbc:oracle:thin:@IP:PORT:DBNAME";
        static final private String user="USER";
        static final private String pass="PASS";
        public static void main(String[] args) {
                // TODO Auto-generated method stub
                Connection conn=null;
                Statement stmt=null;
                String tr="<tr>";
                String slashtr="</tr>";
                String td="<td>";
                String slashtd="</td>";
                String slashhtml="</html>";
                String slashbody="</body>";
                String tdclr="<td bgcolor="+"#FF0000>";
                int VAL_CAP=60;

                try {
                        System.out.println("Registering the Driver...");
                        Class.forName(driver);
                        System.out.println("Creating the connection...");
                        conn=DriverManager.getConnection(db_url,user,pass);
                        System.out.println("Creating the statement...");
                        stmt=conn.createStatement();
                        System.out.println("Creating the ResultSet....");
                        ResultSet rs=stmt.executeQuery("SELECT QUERY");

                        File f=new File("/*output file path nad name*/");
                        FileWriter fw=new FileWriter(f,true);
                        String header="Content-Type: text/html,<!DOCTYPE html>,<h2>Kenan/JBOSS/SCMS Servers:</h2>,<html>,<body>,<table border=1 style=width:70%>,<tr>,<td bgcolor=#38E0C7>LOG_DETAILS</td>,<td bgcolor=#38E0C7>COUNT</td>,<td bgcolor=#38E0C7>USED_SPACE</td>,</tr>";
                        StringTokenizer st=new StringTokenizer(header,",");
                        while(st.hasMoreElements())
                        {
                        fw.write(st.nextToken().toString().trim());
                        fw.write("\r\n");
                        }
                           fw.close();
                           fw=new FileWriter(f,true);
                           while(rs.next())
                           {
                                   String frame=null;
                                   String capacity=null;
                                   fw=new FileWriter(f,true);
                                   frame=tr+","+td+rs.getString(1).trim()+slashtd+","+td+rs.getString(2).trim()+slashtd+","+td+rs.getString(3).trim()+slashtd+",";

                                   
                                   StringTokenizer st1=new StringTokenizer(frame,",");
                                   while(st1.hasMoreElements())
                                        {
                                        fw.write(st1.nextToken().trim());
                                        fw.write("\r\n");
                                        }
                                   fw.close();
                           }
                           fw=new FileWriter(f,true);
                           String frame_end="</table>,</body>,</html>";
                           StringTokenizer st2=new StringTokenizer(frame_end,",");
                           while(st2.hasMoreElements())
                                {
                                fw.write(st2.nextToken().trim());
                                fw.write("\r\n");
                                }
                           fw.close();
                } catch (ClassNotFoundException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                } catch (SQLException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                } catch (IOException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                }finally
                {
                        try {
                                stmt.close();
                                conn.close();
                        } catch (SQLException e) {
                                // TODO Auto-generated catch block
                                e.printStackTrace();
                        }finally
                        {
                                System.out.println("Connection closed.....");
                        }
                }

        }

}
