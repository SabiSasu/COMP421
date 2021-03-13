import java.sql.* ;
import java.util.Scanner;

import static java.lang.System.exit;

public class VaccineApp {
    public static void main ( String [ ] args ) throws SQLException
    {
        // Register the driver.  You must register the driver before you can use it.
        try { DriverManager.registerDriver ( new com.ibm.db2.jcc.DB2Driver() ) ; }
        catch (Exception cnfe){ System.out.println("Class not found"); }

        // This is the url you must use for DB2.
        //Note: This url may not valid now !
        String url = "jdbc:db2://winter2021-comp421.cs.mcgill.ca:50000/cs421";

        //REMEMBER to remove your user id and password before submitting your code!!
        String your_userid = "osasu";
        String your_password = "qPQ9qi3Y";
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
            //print 1 slot where vaccine info is missing, if no no-vaccine slots -> exit
            String querySQL = "SELECT t.tslot,t.ttime,t.tdate,t.locname from timeslot t where t.health_ins_num = " + hin + " and t.vialid is null and t.tdate > " + date_today;
            java.sql.ResultSet rs = statement.executeQuery(querySQL);
            boolean exists = false;
            Object[] slotinfo = new Object[4];
            System.out.println("Slot#, Time, Date, Locname");
            while (rs.next()) {
                System.out.println(rs.toString());
                slotinfo[0] = rs.getInt ( 1 ) ;
                slotinfo[1] = rs.getTime (2);
                slotinfo[1] = rs.getDate (3);
                slotinfo[1] = rs.getString (4);
                exists = true;
            }
            if (exists == false)
                throw new Exception("Please assign a slot before entering vaccination information");

            //insert vaccine information
            //INSERT INTO  VACCINE(vname, vwaitperiod, vdoses, vmanufacturer) VALUES
            System.out.println("Please enter the following vaccine information in order with commas between:\nVaccine name, Batch no, Vial ID\n");
            String vaccineinformation = scanner.nextLine();
            String[] vaccineinfo = vaccineinformation.split(",");

            //check if the user received a shot before -> if yes, make sure its same brand of vaccine
            querySQL = "SELECT t.vname from timeslot t where t.health_ins_num = " + hin + " and t.vialid is not null";
            rs = statement.executeQuery(querySQL);
            while (rs.next()) {
                String name = rs.getString (1);
                if(!vaccineinfo[0].toUpperCase().equals(name.toUpperCase()))
                    throw new Exception("This person already received a vaccine from " + name + " and must get the same vaccine brand for their 2nd dose");
            }
            //enter nurse information
            System.out.println("Enter the responsible nurse's license no:");
            String licenseno = scanner.nextLine();

            //INSERT INTO TIMESLOT(tslot,ttime,tdate,locname,health_ins_num,tdate_allocated,vname,batchno,vialid) VALUES
            String insertSQL = "INSERT INTO VIAL VALUES ( "+vaccineinfo[0]+" , "+vaccineinfo[1]+", "+vaccineinfo[2]+" ) " ;
            System.out.println ( insertSQL ) ;
            statement.executeUpdate ( insertSQL ) ;
            String updateSQL = "UPDATE TIMESLOT SET vname = " +vaccineinfo[0]+ ",batchno = "+vaccineinfo[1]+",vialid = "+vaccineinfo[2]+", licensenum="+licenseno
                    +" WHERE tslot = "+slotinfo[0]+" and ttime = "+slotinfo[1]+" and tdate = "+slotinfo[2]+" and locname = "+slotinfo[3]+" and health_ins_num = "+hin;
            statement.executeUpdate(updateSQL);
            con.commit();
        }
        catch (SQLException e)
        {
            int sqlCode = e.getErrorCode(); // Get SQLCODE
            String sqlState = e.getSQLState(); // Get SQLSTATE
            // Your code to handle errors comes here;
            // something more meaningful than a print would be good
            System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
            System.out.println(e);
            con.rollback();
        } catch (Exception e) {
            System.err.println(e.toString());
        }
    }

    private static void AssignSlot(Scanner scanner, Statement statement, Connection con) {
        //enter person
        System.out.println("Enter person heatlh insurance number:");
        String hin = scanner.nextLine();
        try {
            //check if person already got 2 vaccines -> if yes exit
            String querySQL = "SELECT COUNT(*) from timeslot t where t.health_ins_num = " + hin + " and t.vialid is not null";
            java.sql.ResultSet rs = statement.executeQuery(querySQL);
            if (rs.getInt(1) == 2){
                throw new Exception("Person has already received 2 vaccine doses");
            }
            long millis=System.currentTimeMillis();
            java.sql.Date date_today =new java.sql.Date(millis);
            //check if a person already has an availale slot assigned -> if yes exit
            querySQL = "SELECT COUNT(*) from timeslot t where t.health_ins_num = " + hin + " and t.vialid is null and t.tdate > "+date_today;
            rs = statement.executeQuery(querySQL);
            if (rs.getInt(1) > 1) {
                throw new Exception("Person has already received 2 vaccine doses");
            }

            //print available slots (after today)
            querySQL = "SELECT t.tslot,t.ttime,t.tdate,t.locname from timeslot t where t.vialid is null and t.health_ins_num is null and t.tdate > " + date_today;
            rs = statement.executeQuery ( querySQL ) ;
            System.out.println("Slot#, Time, Date, Locname");
            while (rs.next())
            {
                System.out.println (rs.toString());
            }

            //enter the slot we want: tslot,ttime,tdate,locname
            System.out.println("Please enter the following information in order with commas between:\nSlot#, Time, Date, Locname\n");
            String slotinformation = scanner.nextLine();
            String[] slotinfo = slotinformation.split(",");

            //update health_ins_num,tdate_allocated on the slot, check again that the slot is not in the past (after today)
            querySQL = "SELECT COUNT(*) from timeslot t where t.vialid is null and t.health_ins_num is null and t.tdate > " + date_today
                    + " and tslot = " + slotinfo[0] + " and ttime = " + slotinfo[1] + " and tdate = " + slotinfo[2] + "and locname = " + slotinfo[3];
            rs = statement.executeQuery(querySQL);
            if (rs.getInt(1) != 1) {
                throw new Exception("Time slot input is invalid, try again");
            }

            String updatePersonSQL = "UPDATE TIMESLOT SET health_ins_num = "+ hin +" , tdate_allocated = "+ date_today
                    + " WHERE tslot = " + slotinfo[0] + " and ttime = " + slotinfo[1] + " and tdate = " + slotinfo[2] + "and locname = " + slotinfo[3];
            statement.executeUpdate ( updatePersonSQL ) ;

            con.commit();
            System.out.println("Done\n");

        }
        catch (SQLException e)
        {
            int sqlCode = e.getErrorCode(); // Get SQLCODE
            String sqlState = e.getSQLState(); // Get SQLSTATE
            // Your code to handle errors comes here;
            // something more meaningful than a print would be good
            System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
            System.out.println(e);
        } catch (Exception e) {
            System.err.println(e.toString());
        }
    }

    private static void AddPerson(Scanner scanner, Statement statement, Connection con) {
        System.out.println("Enter heatlh insurance number:");
        String hin = scanner.nextLine();
        try{
            String querySQL = "SELECT COUNT(*) from person WHERE NAME phealth_ins_num = " + hin;
            java.sql.ResultSet rs = statement.executeQuery ( querySQL ) ;

            //there is no user, create
            while(true){
                if (rs.getInt(1) == 0){
                    //create user
                    System.out.println("Please enter the following information in order with commas between:\nName, Gender, DOB, Street Address, City, Phone#, Postal Code, Category Name\n");
                    String userinformation = scanner.nextLine();
                    String[] userinfo = userinformation.split(",");
                    if (userinfo.length == 8){
                        long millis=System.currentTimeMillis();
                        java.sql.Date date_registered =new java.sql.Date(millis);

                        String insertPersonSQL = "INSERT INTO PERSON(phealth_ins_num, pname, pgender, pdob, pstreet_addr, pcity_addr, pphone, ppostal, pdate_registered, pcategory) VALUES ("
                                + hin + ", "+ userinfo[0] + ", "+ userinfo[1] + ", "+ userinfo[2] + ", "+ userinfo[3] + ", "+ userinfo[4] + ", "+ userinfo[5] + ", "+ userinfo[6] + ", "+ date_registered + ", "+ userinfo[7] + ")";
                        statement.executeUpdate ( insertPersonSQL ) ;
                        con.commit();
                        System.out.println("Done\n");
                        break;
                    }
                    System.out.println("Please try again\n");
                }
                //there is a user, update
                else if (rs.getInt(1) == 1){
                    System.out.println("This health insurance number is already associated with a person.\n Do you wish to update their information? (Y/N)\n");
                    String isUpdate = scanner.nextLine();

                    if (isUpdate.toUpperCase().equals("Y")){
                        //update user
                        System.out.println("Please enter the following information in order with commas between:\nName, Gender, DOB, Street Address, City, Phone#, Postal Code, Category Name\n");
                        String userinformation = scanner.nextLine();
                        String[] userinfo = userinformation.split(",");
                        if (userinfo.length == 8){
                            long millis=System.currentTimeMillis();
                            java.sql.Date date_registered =new java.sql.Date(millis);

                            String updatePersonSQL = "UPDATE PERSON SET pname = "+ userinfo[0] +" , pgender = "+ userinfo[1] + ", pdob = "+ userinfo[2]
                                    + ", pstreet_addr = "+ userinfo[3] + ", pcity_addr="+ userinfo[4] + ", pphone = "+ userinfo[5] + ", ppostal= "+ userinfo[6] + ", pcategory="+ userinfo[7] + ") WHERE phealth_ins_num = " + hin;
                            statement.executeUpdate ( updatePersonSQL ) ;
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
            // Your code to handle errors comes here;
            // something more meaningful than a print would be good
            System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
            System.out.println(e);
        }

    }
}
