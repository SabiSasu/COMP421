import java.sql.* ;
import java.util.Scanner;

import static java.lang.System.exit;

public class VaccineApp {
    public static void main ( String [ ] args ) throws SQLException
    {
        //FROM SAMPLE CODE:
        // Register the driver
        try { DriverManager.registerDriver ( new com.ibm.db2.jcc.DB2Driver() ) ; }
        catch (Exception cnfe){ System.out.println("Class not found"); }

        // This is the url you must use for DB2.
        //Note: This url may not valid now !
        String url = "jdbc:db2://winter2021-comp421.cs.mcgill.ca:50000/cs421";

        //REMEMBER to remove your user id and password before submitting your code!!
        String your_userid = "osasu";
        String your_password = "";
        //AS AN ALTERNATIVE, you can just set your password in the shell environment in the Unix (as shown below) and read it from there.
        //$  export SOCSPASSWD=yoursocspasswd
        if(your_userid == null && (your_userid = System.getenv("SOCSUSER")) == null)
        {
            System.err.println("Error!! do not have a password to connect to the database!");
            exit(1);
        }
        if(your_password == null && (your_password = System.getenv("SOCSPASSWD")) == null)
        {
            System.err.println("Error!! do not have a password to connect to the database!");
            exit(1);
        }
        Connection con = DriverManager.getConnection (url,your_userid,your_password) ;
        Statement statement = con.createStatement ( ) ;

        //MY CODE:
        Scanner scanner = new Scanner(System.in);
        while(true) {
            String menu = "VaccineApp Main Menu\n\t1. Add a Person\n\t2. Assign a slot to a Person\n\t3. Enter Vaccination information\n\t4. Exit Application\nPlease Enter Your Option:";
            System.out.println(menu);
            String input = scanner.nextLine();

            switch (input) {
                case "1": AddPerson(scanner, statement, con);
                    break;
                case "2": AssignSlot(scanner, statement, con);
                    break;
                case "3": EnterVaccinationRec(scanner, statement, con);
                    break;
                case "4": statement.close ( ) ; con.close ( ) ; exit(1);
                    break;
                default:
                    System.err.println("Please input a valid command");
                    break;
            }
        }
    }

    private static void EnterVaccinationRec(Scanner scanner, Statement statement, Connection con) throws SQLException {
        //enter person
        System.out.println("Enter person heatlh insurance number:");
        String hin = scanner.nextLine();
        try {
            long millis=System.currentTimeMillis();
            java.sql.Date date_today =new java.sql.Date(millis);
            //print 1 slot where vaccine info is missing, if no no-vaccine slots -> exit
            String querySQL = "SELECT t.tslot,t.ttime,t.tdate,t.locname from timeslot t where t.health_ins_num = ? and t.vialid is null and t.tdate > ?";
            PreparedStatement query = con.prepareStatement(querySQL);
            query.setString(1, hin);
            query.setDate(2, date_today);
            java.sql.ResultSet rs = query.executeQuery();
            boolean exists = false;
            Object[] slotinfo = new Object[4];
            System.out.println("Slot#, Time, Date, Locname");
            while (rs.next()) {
                slotinfo[0] = rs.getInt ( 1 ) ;
                slotinfo[1] = rs.getTime (2);
                slotinfo[2] = rs.getDate (3);
                slotinfo[3] = rs.getString (4);
                System.out.print (rs.getInt(1) +", ");
                System.out.print (rs.getTime(2) +", ");
                System.out.print (rs.getDate(3) +", ");
                System.out.print (rs.getString(4));
                System.out.print ("\n");
                exists = true;
            }
            if (exists == false)
                throw new Exception("Please assign a slot before entering vaccination information");


            //insert vaccine information
            System.out.println("Please enter the following vaccine information in order with commas between:\nVaccine name, Batch no, Vial ID");
            String vaccineinformation = scanner.nextLine().trim();
            String[] vaccineinfo = vaccineinformation.split(", ");
            if (vaccineinfo.length != 3)
                throw new Exception("Vaccine information is invalid");

            //check if the user received a shot before -> if yes, make sure its same brand of vaccine
            String querySQL2 = "SELECT t.vname from timeslot t where t.health_ins_num = ? and t.vialid is not null";
            query = con.prepareStatement(querySQL2);
            query.setString(1, hin);
            rs = query.executeQuery();
            while (rs.next()) {
                String name = rs.getString (1);
                if(!vaccineinfo[0].toUpperCase().equals(name.toUpperCase()))
                    throw new Exception("This person already received a vaccine from " + name + " and must get the same vaccine brand for their 2nd dose");
            }
            //enter nurse information
            System.out.println("Enter the responsible nurse's license no:");
            String licenseno = scanner.nextLine().trim();

            //I assume the vial information has not been entered yet
            String insertSQL = "INSERT INTO VIAL VALUES ( ? , ?, ? ) " ;
            query = con.prepareStatement(insertSQL);
            query.setString(1, vaccineinfo[0]);
            query.setInt(2, Integer.parseInt(vaccineinfo[1]));
            query.setInt(3, Integer.parseInt(vaccineinfo[2]));
            query.executeUpdate();
            //update timeslot
            String updateSQL = "UPDATE TIMESLOT SET vname = ?,batchno = ?,vialid = ?, licensenum= ? WHERE tslot = ? and ttime = ? and tdate = ? and locname = ? and health_ins_num = ?";
            query = con.prepareStatement(updateSQL);
            query.setString(1, vaccineinfo[0]);
            query.setInt(2, Integer.parseInt(vaccineinfo[1]));
            query.setInt(3, Integer.parseInt(vaccineinfo[2]));
            query.setInt(4, Integer.parseInt(licenseno));
            query.setInt(5, (Integer) slotinfo[0]);
            query.setTime(6, (Time) slotinfo[1]);
            query.setDate(7, (Date) slotinfo[2]);
            query.setString(8, (String) slotinfo[3]);
            query.setString(9, hin);
            query.executeUpdate();
            con.commit();
        }
        catch (SQLException e)
        {
            int sqlCode = e.getErrorCode(); // Get SQLCODE
            String sqlState = e.getSQLState(); // Get SQLSTATE
            System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
            System.out.println(e);
            con.rollback();
        } catch (Exception e) {
            System.err.println(e.toString());
            con.rollback();
        }
    }

    private static void AssignSlot(Scanner scanner, Statement statement, Connection con) {
        //enter person
        System.out.println("Enter person heatlh insurance number:");
        String hin = scanner.nextLine();
        try {
            //check if person already got 2 vaccines -> if yes exit
            String querySQL = "SELECT COUNT(*) from timeslot t where t.health_ins_num = ? and t.vialid is not null";
            PreparedStatement query = con.prepareStatement(querySQL);
            query.setString(1, hin);
            java.sql.ResultSet rs = query.executeQuery();
            if (rs.next()) {
                if (rs.getInt(1) == 2)
                    throw new Exception("Person has already received 2 vaccine doses");
            }

            long millis=System.currentTimeMillis();
            java.sql.Date date_today =new java.sql.Date(millis);
            //check if a person already has an availale slot assigned -> if yes exit
            String querySQL2 = "SELECT COUNT(*) from timeslot t where t.health_ins_num = ? and t.vialid is null and t.tdate > ?";
            query = con.prepareStatement(querySQL2);
            query.setString(1, hin);
            query.setDate(2, date_today);
            rs = query.executeQuery();
            if (rs.next()){
                if (rs.getInt(1) > 1)
                    throw new Exception("Person has already received 2 vaccine doses");
            }

            //print available slots (after today)
            String querySQL3 = "SELECT t.tslot,t.ttime,t.tdate,t.locname from timeslot t where t.vialid is null and t.health_ins_num is null and t.tdate > ?";
            query = con.prepareStatement(querySQL3);
            query.setDate(1, date_today);
            rs = query.executeQuery();
            System.out.println("Slot#, Time, Date, Locname");
            while (rs.next())
            {
                System.out.print (rs.getString(1) +", ");
                System.out.print (rs.getString(2) +", ");
                System.out.print (rs.getString(3) +", ");
                System.out.print (rs.getString(4));
                System.out.print ("\n");
            }

            //enter the slot we want: tslot,ttime,tdate,locname
            System.out.println("Please enter the following information in order with commas between:\nSlot#, Time, Date, Locname");
            String slotinformation = scanner.nextLine();
            String[] slotinfo = slotinformation.split(", ");

            //update health_ins_num,tdate_allocated on the slot, check again that the slot is not in the past (after today) and is allocated to no one
            String querySQL4 = "SELECT COUNT(*) from timeslot t where t.vialid is null and t.health_ins_num is null and t.tdate > ? and t.tslot = ? and t.ttime = ? and t.tdate = ? and t.locname = ?";
            query = con.prepareStatement(querySQL4);
            query.setDate(1, date_today);
            query.setTime(3, Time.valueOf(slotinfo[1]));
            query.setDate(4, Date.valueOf(slotinfo[2]));
            query.setString(5, slotinfo[3]);
            query.setInt(2, Integer.parseInt(slotinfo[0]));

            rs = query.executeQuery();
            if (rs.next()){
                if (rs.getInt(1) != 1) {
                    throw new Exception("Time slot input is invalid, try again");
                }
            }

            String updatePersonSQL = "UPDATE TIMESLOT SET health_ins_num = ? , tdate_allocated = ? WHERE tslot = ? and ttime = ? and tdate = ? and locname = ?";
            query = con.prepareStatement(updatePersonSQL);
            query.setString(1, hin);
            query.setDate(2, date_today);
            query.setInt(3, Integer.parseInt(slotinfo[0]));
            query.setTime(4, Time.valueOf(slotinfo[1]));
            query.setDate(5, Date.valueOf(slotinfo[2]));
            query.setString(6, slotinfo[3]);
            query.executeUpdate () ;
            con.commit();
            System.out.println("Done\n");

        }
        catch (SQLException e)
        {
            int sqlCode = e.getErrorCode(); // Get SQLCODE
            String sqlState = e.getSQLState(); // Get SQLSTATE
            System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
            System.out.println(e);
        } catch (Exception e) {
            System.err.println(e.toString());
        }
    }

    private static void AddPerson(Scanner scanner, Statement statement, Connection con) {
        System.out.println("Enter heatlh insurance number:");
        String hin = scanner.nextLine().trim();
        try{
            String querySQL = "SELECT COUNT(*) from person where phealth_ins_num = ?";
            PreparedStatement query = con.prepareStatement(querySQL);
            query.setString(1, hin);
            java.sql.ResultSet rs = query.executeQuery();
            String count = "";
            if (rs.next())
                count = rs.getString ( 1 ) ;
            //there is no user, create
            while(true){
                if (count.equals("0")){
                    //create user
                    System.out.println("Please enter the following information in order with commas between:\nName, Gender, DOB, Street Address, City, Phone#, Postal Code, Category Name");
                    String userinformation = scanner.nextLine().trim();
                    String[] userinfo = userinformation.split(", ");
                    if (userinfo.length == 8){
                        long millis=System.currentTimeMillis();
                        java.sql.Date date_registered =new java.sql.Date(millis);

                        String insertPersonSQL = "INSERT INTO PERSON (phealth_ins_num, pname, pgender, pdob, pstreet_addr, pcity_addr, pphone, ppostal, pdate_registered, pcategory) VALUES ("
                                + "?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                        PreparedStatement updatequery = con.prepareStatement(insertPersonSQL);
                        updatequery.setString(1, hin);
                        updatequery.setString(2, userinfo[0].trim());
                        updatequery.setString(3, userinfo[1].trim());
                        updatequery.setString(4, userinfo[2].trim());
                        updatequery.setString(5, userinfo[3].trim());
                        updatequery.setString(6, userinfo[4].trim());
                        updatequery.setString(7, userinfo[5]);
                        updatequery.setString(8, userinfo[6].trim());
                        updatequery.setDate(9, date_registered);
                        updatequery.setString(10, userinfo[7].trim());
                        int result = updatequery.executeUpdate();
                        con.commit();
                        System.out.println("Done\n");
                        break;
                    }
                    System.out.println("Please try again\n");
                }
                //there is a user, update
                else if (count.equals("1")){
                    System.out.println("This health insurance number is already associated with a person.\n Do you wish to update their information? (Y/N)");
                    String isUpdate = scanner.nextLine();

                    if (isUpdate.toUpperCase().equals("Y")){
                        //update user
                        System.out.println("Please enter the following information in order with commas between:\nName, Gender, DOB, Street Address, City, Phone#, Postal Code, Category Name");
                        String userinformation = scanner.nextLine();
                        String[] userinfo = userinformation.split(", ");
                        if (userinfo.length == 8){
                            long millis=System.currentTimeMillis();
                            java.sql.Date date_registered =new java.sql.Date(millis);

                            String updatePersonSQL = "UPDATE PERSON SET pname = ?, pgender = ?, pdob = ? , pstreet_addr = ?, pcity_addr = ?, pphone = ?, ppostal= ?, pcategory= ? WHERE phealth_ins_num = ?";
                            PreparedStatement updatequery = con.prepareStatement(updatePersonSQL);
                            updatequery.setString(1, userinfo[0].trim());
                            updatequery.setString(2, userinfo[1].trim());
                            updatequery.setString(3, userinfo[2].trim());
                            updatequery.setString(4, userinfo[3].trim());
                            updatequery.setString(5, userinfo[4].trim());
                            updatequery.setString(6, userinfo[5].trim());
                            updatequery.setString(7, userinfo[6].trim());
                            updatequery.setString(8, userinfo[7].trim());
                            updatequery.setString(9, hin);
                            int result = updatequery.executeUpdate();
                            con.commit();
                            System.out.println("Done\n");
                        }
                        break;
                    }
                    else if (isUpdate.toUpperCase().equals("N")){
                        System.out.println("Done\n");
                        break;
                    }
                    else{
                        System.err.println("Please input Y or N\n");
                    }
                }
            }
        }
        catch (SQLException e)
        {
            int sqlCode = e.getErrorCode(); // Get SQLCODE
            String sqlState = e.getSQLState(); // Get SQLSTATE
            System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
            System.out.println(e);
        }

    }
}
