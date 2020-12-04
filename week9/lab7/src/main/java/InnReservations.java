import java.sql.*;

import java.sql.Date;
import java.util.Scanner;
import java.time.LocalDate;
import java.util.List;
import java.util.ArrayList;

import java.util.*;
import java.lang.*;
import java.io.*;
import java.util.Random;

import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.time.ZoneId;
import java.time.Instant;
import java.util.Calendar;

/*
 * Introductory JDBC examples based loosely on the BAKERY dataset from CSC 365 labs.
 */
public class InnReservations {

   private static Connection conn = null;
   private static BufferedReader cnsl = new BufferedReader(new InputStreamReader(System.in));

    private final String JDBC_URL = "jdbc:h2:~/csc365_lab7";
    private final String JDBC_USER = "";
    private final String JDBC_PASSWORD = "";
    
    public static void main(String[] args) throws SQLException {
		try {
			InnReservations hp = new InnReservations();
			hp.initDb();
           conn.setAutoCommit(false);
            optionSelect();
		} catch (SQLException e) {
			System.err.println("SQLException: " + e.getMessage());
		} finally {
           if (conn != null) { conn.close(); }
        }
    }


   //====================================================================

   private static void optionSelect(){
      String command;

      try{
		Scanner scanner = new Scanner(System.in);
		printOptions();
        System.out.print("Input Command: ");

		 while(scanner.hasNext())
		 {
			String option_selected = scanner.next();
			option_selected = option_selected.replaceAll("\\s", "");

            if(option_selected.equals("1")){
				System.out.println("\n1...");
				FR1();
				System.out.println();
				printOptions();
            }
            else if(option_selected.equals("2")){
				System.out.println("\n2...");
				FR2();
				System.out.println();
               printOptions();
            }
            else if(option_selected.equals("3")){
               System.out.println("\n3...");
               FR3();
               System.out.println();
               printOptions();
            }
            else if(option_selected.equals("4")){
				System.out.println("\n4...");
				FR4();
				System.out.println();
               printOptions();
            }
            else if(option_selected.equals("5")){
				System.out.println("\n5...");
				FR5();
				System.out.println();
               printOptions();
            }
            else if(option_selected.equals("M")||option_selected.equals("m")){
            System.out.println("\nM...");   
				printOptions();
            }
            else if(option_selected.equals("0")){ 
			   System.out.println("\n0...");
               System.out.println("\nExiting...");
			   System.out.println();
               return;
            }
            else{
               //invalidCommand();
            }
			//printOptions();
        	System.out.println("Input Command: ");
		}
      }
      catch (InputMismatchException e){
      }
   }

   //====================================================================

   private static void printOptions(){
      System.out.println("\nMain Menu");
      System.out.println("[1]Rooms and Rates");
      System.out.println("[2]Book Resrvations");
      System.out.println("[3]Change Resrvations");
      System.out.println("[4]Cancel Resrvations");
      System.out.println("[5]Revenue Summary");
      System.out.println("[M]ain Menu");
      System.out.println("[0]Exit\n");
   }

   //====================================================================

    private static void FR1() {
        try
        {
           //variables.
           String RoomId = "";
           String roomName = "";
           int beds = 0;
           String bedType = "";
           int maxOcc = 0;
           float basePrice = 0;
           String decor = "";
           String NextAvailableCheckIn = "";
           String NextReservationDate = "";

           //generating SQL statement. 
           StringBuilder sql_stm = new StringBuilder("with roomReserves as ( ");
           sql_stm.append("select room, min(checkin) as nextReservationDate ");
           sql_stm.append("from lab7_reservations as res2 ");
           sql_stm.append("where curdate() <= checkout ");
           sql_stm.append("group by res2.room), ");

           sql_stm.append("roomAvailability as ( ");
           sql_stm.append("select res.room, greatest(curdate(), max(res.checkout)) as nextAvailableCheckIn ");
           sql_stm.append("from lab7_reservations as res ");
           sql_stm.append("group by res.room) ");

           sql_stm.append("select RoomId, roomName, beds, bedtype, maxocc, basePrice, decor, nextAvailableCheckIn, nextReservationDate ");
           sql_stm.append("from lab7_rooms rooms ");
           sql_stm.append("left outer join roomAvailability as ra ");
           sql_stm.append("on rooms.RoomId = ra.room ");
           sql_stm.append("left outer join roomReserves as rr ");
           sql_stm.append("on rooms.RoomId = rr.room ");
           sql_stm.append("order by RoomId asc; ");

           String sql = sql_stm.toString();
           
           //executing SQL statement.
           try(PreparedStatement prep_stm = conn.prepareStatement(sql))
           {
              try(ResultSet res_set = prep_stm.executeQuery())
              {

                 //Output of Statement.
                 System.out.format("\n|%-10s |%-25s |%-10s |%-10s |%-10s |%-10s |%-15s |%-25s |%-25s\n", "RoomId", "roomName", "beds", "bedType", "maxOcc", "basePrice", "decor", "NextAvailableCheckIn", "NextReservationDate");
                 System.out.println("-------------------------------------------------------------------------------------------------------------------------------------------------------");
                 
                 while(res_set.next())
                 {
                    RoomId = res_set.getString("roomId");
                    roomName = res_set.getString("roomName");
                    beds = res_set.getInt("beds");
                    bedType = res_set.getString("bedType");
                    maxOcc = res_set.getInt("maxOcc");
                    basePrice = res_set.getFloat("basePrice");
                    decor = res_set.getString("decor");
                    NextAvailableCheckIn = res_set.getString("NextAvailableCheckIn");
                    NextReservationDate = res_set.getString("nextReservationDate");
                    
                    if(NextAvailableCheckIn == null) { NextAvailableCheckIn = "Today"; }
                    if(NextReservationDate == null) { NextReservationDate = "None"; }

                    
                    System.out.format("|%-10s |%-25s |%-10s |%-10s |%-10s |%-10s |%-15s |%-25s |%-25s\n", RoomId, roomName, beds, bedType, maxOcc, basePrice, decor, NextAvailableCheckIn, NextReservationDate);
                 }
              }
           }
        } 
        catch (final SQLException e)
        {
            e.printStackTrace();
        }
    }
   //====================================================================

   private static void FR2(){
      String firstName= "";
      String lastName= "";
      String roomId = "";
      String startDate ="";
      String endDate = "";
      String childCount = "";
      String adultCount = "";

      int reserv_code = 0;
      double rate = 0.0;
      String bedType ="";
      int room_occup = 0;
      String roomName = "";

      System.out.println("\nCreating reservation request...\n");
      try{
         System.out.print("\nFirst Name: ");
         firstName = cnsl.readLine();
         System.out.print("\nLast Name: ");
         lastName = cnsl.readLine();
         System.out.println("\n| Room Code | Room Name                | Bed Type");
         System.out.println("| AOB       | Abscond or bolster       | Queen");
         System.out.println("| CAS       | Convoke and sanguine     | King");
         System.out.println("| FNA       | Frugal not apropos       | King");
         System.out.println("| HBB       | Harbinger but bequest    | Queen");
         System.out.println("| IBD       | Immutable before decorum | Queen");
         System.out.println("| IBS       | Interim but salutary     | King");
         System.out.println("| MWC       | Mendicant with cryptic   | Double");
         System.out.println("| RND       | Recluse and defiance     | King");
         System.out.println("| RTE       | Riddle to exculpate      | Queen");
         System.out.println("| TAA       | Thrift and accolade      | Double");
         System.out.println("| Any       | No preference            | ");
         System.out.print("\nDesired Room Code: ");
         roomId = cnsl.readLine();
         System.out.println("\nReservations between");
         System.out.print("\nStart Date [YYYY-MM-DD]: ");
         startDate = cnsl.readLine();
         System.out.print("\nEnd Date [YYYY-MM-DD]: ");
         endDate = cnsl.readLine();
         System.out.print("\nNumber of Children: ");
         childCount = cnsl.readLine();
         System.out.print("\nNumber of Adults: ");
         adultCount = cnsl.readLine(); 
      }
      catch(Exception e){
         System.out.println("\n" + e);
      }
      try (PreparedStatement preparedStatement = conn.prepareStatement("select Room from lab7_reservations WHERE Room =? and CheckIn >= ? and CheckOut <= ?;"))
      {
         //processReservation(firstName, lastName, roomId, bedType, startDate, endDate, childCount, adultCount);
         //SQL statement.
         preparedStatement.setString(1, roomId);
         preparedStatement.setDate(2, Date.valueOf(startDate));
         preparedStatement.setDate(3, Date.valueOf(endDate));

         //storing rooms that are book on that date already.
         ArrayList<String> allBookedRooms = new ArrayList<String>();

         //executing the SQL statement.
         ResultSet res_set = preparedStatement.executeQuery();

            try (Statement stm2 = conn.createStatement())
            {
               //Get max code from reservations to generate potential future next code.
               String sql2 = "SELECT max(CODE) as CODE from lab7_reservations;";
               ResultSet res_set2 = stm2.executeQuery(sql2);

               while(res_set2.next())
               {
                  String code = res_set2.getString("CODE");
                  reserv_code = Integer.parseInt(code) + 1;
               }
            }
            catch (SQLException e)
            {
               e.printStackTrace();
            }

            //Date checker, make sure not before current date.
            LocalDate reserv_checkInDate = LocalDate.parse(startDate);
            LocalDate reserv_checkOutDate = LocalDate.parse(endDate);
            LocalDate currentDate = LocalDate.now();
            int date1 = currentDate.compareTo(reserv_checkInDate);
            int date2 = currentDate.compareTo(reserv_checkOutDate);

            //if nothing is returned, that means reservation is possible in that date range.
            //make sure enter correct date / reservation that is in future / not in the past.
            if(!res_set.next() && (date1 <= 0 && date2 <= 0))
            {
               try (PreparedStatement preparedStatement1 = conn.prepareStatement("SELECT RoomName, maxOcc, basePrice, bedType from lab7_rooms where lab7_rooms.RoomId = ?;"))
               {
                  //Get room information based off room code given.
                  preparedStatement1.setString(1, roomId);

                  //Getting rate and bed type of room.
                  ResultSet res_set3 =  preparedStatement1.executeQuery();
                  while(res_set3.next())
                  {
                     rate = Float.parseFloat(res_set3.getString("basePrice")); 
                     bedType = res_set3.getString("bedType");
                     room_occup = Integer.parseInt(res_set3.getString("maxOcc"));
                     roomName = res_set3.getString("RoomName");
                  }


                  //Threshold making sure do not go over maxOccupancy requirement.
                  int total_customer_occupancy = Integer.parseInt(childCount) + Integer.parseInt(adultCount);
                  if(total_customer_occupancy > room_occup)
                  {
                     System.out.println("\nWe were unable to make your reservation due to a room occupancy conflict.\n");
                     System.out.println("\nPlease try again.\n");
                  }
                  else
                  {
                     try (PreparedStatement pstmt = conn.prepareStatement("INSERT INTO lab7_reservations (CODE, Room, CheckIn, CheckOut, Rate, LastName, FirstName, Adults, Kids) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);")) {

                        pstmt.setInt(1, reserv_code);
                        pstmt.setString(2, roomId);
                        pstmt.setDate(3, Date.valueOf(startDate));
                        pstmt.setDate(4, Date.valueOf(endDate));
                        pstmt.setDouble(5, rate);
                        pstmt.setString(6, lastName);
                        pstmt.setString(7, firstName);
                        pstmt.setInt(8, Integer.parseInt(adultCount));
                        pstmt.setInt(9, Integer.parseInt(childCount));

                        pstmt.executeUpdate();
                        conn.commit();
                        //Update user on success of reservation.
                        System.out.println("\n");
                        System.out.println("Succcessfully added reservation with following info: ");
                        System.out.println("First Name: " + firstName);
                        System.out.println("LastName: " + lastName);
                        System.out.println("RoomCode: " + roomId);
                        System.out.println("RoomName: " + roomName);
                        System.out.println("BedType: " + bedType);
                        System.out.println("StartDate: " + startDate);
                        System.out.println("EndDate: " + endDate);
                        System.out.println("Number of Kids: " + childCount);
                        System.out.println("Number of Adults: " + adultCount);
                        System.out.println("RESERVATION CODE: " + reserv_code);

                        //Calculating total cost of stay information.
                        double totalCost = 0;
                        LocalDate checkInDate = LocalDate.parse(startDate);
                        LocalDate checkOutDate = LocalDate.parse(endDate);
                        ZoneId timezone = ZoneId.of( "America/Los_Angeles" );

                        for(LocalDate date = checkInDate; date.isBefore(checkOutDate); date = date.plusDays(1))
                        {
                           Calendar calender = Calendar.getInstance();
                           ZonedDateTime zoned_time = date.atStartOfDay(timezone);
                           Instant i = zoned_time.toInstant();

                           java.util.Date d = java.util.Date.from(i);
                           calender.setTime(d);

                           int dayOfWeek = calender.get(Calendar.DAY_OF_WEEK);

                           if(dayOfWeek >= 2 && dayOfWeek <=6)
                           {
                              // weekday case
                              totalCost += (rate);
                           }
                           else if (dayOfWeek == 0 || dayOfWeek == 7)
                           {
                              // weekend case
                              totalCost += (rate * 1.10);
                           }
                        }
                        System.out.println("Total cost of stay: " + totalCost);

                     } catch (SQLException e) {
                        e.printStackTrace();
                        conn.rollback();
                     }
                  }
               }
               catch (SQLException e)
               {
                  conn.rollback();
                  e.printStackTrace();
               }
            }
            else
            {
               System.out.println("\nWe were unable to make your reservation due to a time conflict.\n");
               System.out.println("\nPlease try again.\n");
            }
         } catch (SQLException e) {
         e.printStackTrace();
      }
   }

   //====================================================================

   private static void FR3(){
       try
       {
          Scanner scanner = new Scanner(System.in);

          // get reservation code.
          System.out.println("\nEnter your reservation code: ");
          int reserv_code = scanner.nextInt();;
          scanner.nextLine(); // flush3

          // attributes to change
          Map<String, String> toChange =  new HashMap<>();

          while(true){
             System.out.println("Select attribute to change:");
             System.out.println("1 - First name");
             System.out.println("2 - Last name");
             System.out.println("3 - Begin date");
             System.out.println("4 - End date");
             System.out.println("5 - Number of adults");
             System.out.println("6 - Number of children");
             System.out.println("0 - DONE");

             //(Code, Room, CheckIn, Checkout, Rate, LastName, FirstName, Adults, Kids)
             String input = scanner.next();
             scanner.nextLine(); // flush
             if (input.equalsIgnoreCase("0")){
                break;
             }
             switch (input){
                case "1":
                   System.out.println("Enter new first name: ");
                   String firstName = scanner.nextLine();
                   toChange.put("FirstName", firstName);
                   break;
                case "2":
                   System.out.println("Enter new last name: ");
                   String lastName = scanner.nextLine();
                   toChange.put("LastName", lastName);
                   break;
                case "3":
                   System.out.println("Enter new begin date: ");
                   String begin = scanner.next();
                   toChange.put("CheckIn", begin);
                   break;
                case "4":
                   System.out.println("Enter new end date: ");
                   String end = scanner.next();
                   toChange.put("Checkout", end);
                   break;
                case "5":
                   System.out.println("Enter number of adults: ");
                   String adults = scanner.next();
                   toChange.put("Adults", adults);
                   break;
                case "6":
                   System.out.println("Enter number of kids: ");
                   String kids = scanner.next();
                   toChange.put("Kids", kids);
                   break;
             }
          }
          if(toChange.containsKey("FirstName")) {
             try(PreparedStatement preparedStatement = conn.prepareStatement("update lab7_reservations set firstname=? where code = ?;")){
                preparedStatement.setString(1,toChange.get("FirstName"));
                preparedStatement.setInt(2, reserv_code);
                preparedStatement.executeUpdate();
                conn.commit();
                System.out.println("Success updating FirstName.");
             } catch (SQLException e){
                System.out.println("\nError updating FirstName");
                System.out.println("\nPlease try again.\n");
                e.printStackTrace();
                conn.rollback();
             }
          }
          if(toChange.containsKey("LastName")) {
             try(PreparedStatement preparedStatement = conn.prepareStatement("update lab7_reservations set LastName=? where code = ?;")){
                preparedStatement.setString(1,toChange.get("LastName"));
                preparedStatement.setInt(2, reserv_code);
                preparedStatement.executeUpdate();
                conn.commit();
                System.out.println("Success updating LastName.");
             } catch (SQLException e){
                System.out.println("\nError updating LastName");
                System.out.println("\nPlease try again.\n");
                e.printStackTrace();
                conn.rollback();
             }
          }
          if(toChange.containsKey("Adults")) {
             try(PreparedStatement preparedStatement = conn.prepareStatement("update lab7_reservations set Adults=? where code = ?;")){
                preparedStatement.setInt(1,Integer.parseInt(toChange.get("Adults")));
                preparedStatement.setInt(2, reserv_code);
                preparedStatement.executeUpdate();
                conn.commit();
                System.out.println("Success updating Adults.");
             } catch (SQLException e){
                System.out.println("\nError updating Adults");
                System.out.println("\nPlease try again.\n");
                e.printStackTrace();
                conn.rollback();
             }
          }
          if(toChange.containsKey("Kids")) {
             try(PreparedStatement preparedStatement = conn.prepareStatement("update lab7_reservations set Kids=? where code = ?;")){
                preparedStatement.setInt(1, Integer.parseInt(toChange.get("Kids")));
                preparedStatement.setInt(2, reserv_code);
                preparedStatement.executeUpdate();
                conn.commit();
                System.out.println("Success updating Kids.");
             } catch (SQLException e){
                System.out.println("\nError updating Kids");
                System.out.println("\nPlease try again.\n");
                e.printStackTrace();
                conn.rollback();
             }
          }

          if(toChange.containsKey("CheckIn")) {
             try(PreparedStatement preparedStatement = conn.prepareStatement("update lab7_reservations set CheckIn=? where code = ?;")){
                preparedStatement.setDate(1, Date.valueOf(toChange.get("CheckIn")));
                preparedStatement.setInt(2, reserv_code);
                preparedStatement.executeUpdate();
                conn.commit();
                System.out.println("Success updating CheckIn.");
             } catch (SQLException e){
                System.out.println("\nError updating CheckIn");
                System.out.println("\nPlease try again.\n");
                e.printStackTrace();
                conn.rollback();
             }
          }
          if(toChange.containsKey("Checkout")) {
             try(PreparedStatement preparedStatement = conn.prepareStatement("update lab7_reservations set Checkout=? where code = ?;")){
                preparedStatement.setDate(1, Date.valueOf(toChange.get("Checkout")));
                preparedStatement.setInt(2, reserv_code);
                preparedStatement.executeUpdate();
                conn.commit();
                System.out.println("Success updating Checkout.");
             } catch (SQLException e){
                System.out.println("\nError updating Checkout");
                System.out.println("\nPlease try again.\n");
                e.printStackTrace();
                conn.rollback();
             }
          }
       } catch (Exception e){
          e.printStackTrace();
       }
   }

   //====================================================================

    private static void FR4()
    {
        try
        {
            Scanner scanner = new Scanner(System.in);

            // get reservation code.
            System.out.println("\nEnter your reservation code: ");
            int reserv_code = scanner.nextInt();

            //confirm cancellation.
            scanner.nextLine(); //move to next line.
            System.out.println("Are you sure you want to cancel your reservation? (Y/N): ");
            String confirmCancel = scanner.nextLine();

            if(confirmCancel.equals("Y") || confirmCancel.equals("y"))
            {
               try (PreparedStatement preparedStatement = conn.prepareStatement("DELETE FROM lab7_reservations WHERE Code = ?"))
               {
                  preparedStatement.setInt(1, reserv_code);
                  preparedStatement.execute();
                  conn.commit();
                  System.out.println("Your reservation has been cancelled.");
               }
               catch (SQLException e)
               {
                  e.printStackTrace();
                  conn.rollback();
                  System.out.println("\nThe reservation either does not exist or could not be found.\n");
                  System.out.println("\nPlease try again.\n");
               }
            } 
        } catch (Exception e){
           e.printStackTrace();
        }

    }

   //====================================================================

   private static void FR5()
   {
      String room = "";
      String january = "";
      String february = "";
      String march = "";
      String april = "";
      String may = "";
      String june = "";
      String july = "";
      String august = "";
      String september = "";
      String october = "";
      String november = "";
      String december = "";
      String annual = "";

      System.out.println("\nMonth-By-Month revenue overview:\n");

      String sql = "with rev as (select Room," + 
      "round(sum(case when month(Checkout) = 1 then datediff(day, Checkout, CheckIn) *-1 * rate else 0 end),0) as January, " +
      "round(sum(case when month(Checkout) = 2 then datediff(day, Checkout, CheckIn) *-1 * rate else 0 end),0) as February," +
      "round(sum(case when month(Checkout) = 3 then datediff(day, Checkout, CheckIn) *-1 * rate else 0 end),0) as March, " +
      "round(sum(case when month(Checkout) = 4 then datediff(day, Checkout, CheckIn) *-1 * rate else 0 end),0) as April, " +
      "round(sum(case when month(Checkout) = 5 then datediff(day, Checkout, CheckIn) *-1 * rate else 0 end),0) as May, " +
      "round(sum(case when month(Checkout) = 6 then datediff(day, Checkout, CheckIn) *-1 * rate else 0 end),0) as June, " +
      "round(sum(case when month(Checkout) = 7 then datediff(day, Checkout, CheckIn) *-1 * rate else 0 end),0) as July, " +
      "round(sum(case when month(Checkout) = 8 then datediff(day, Checkout, CheckIn) *-1 * rate else 0 end),0) as August, " +
      "round(sum(case when month(Checkout) = 9 then datediff(day, Checkout, CheckIn) *-1 * rate else 0 end),0) as September, " +
      "round(sum(case when month(Checkout) = 10 then datediff(day, Checkout, CheckIn) *-1 * rate else 0 end),0) as October, " +
      "round(sum(case when month(Checkout) = 11 then datediff(day, Checkout, CheckIn) *-1 * rate else 0 end),0) as November, " +
      "round(sum(case when month(Checkout) = 12 then datediff(day, Checkout, CheckIn) *-1 * rate else 0 end),0) as December, " +
      "round(sum(datediff(day, Checkout, Checkin) *-1 * rate),0) as Annual " +
      "from lab7_reservations " +
      "group by Room ) " +
      "select Room, January, February, March, April, May, June, July, August, September, October, November, December, Annual " +
      "from rev " +
      "union " +
      "select 'Total', sum(January), sum(February), sum(March), sum(April), sum(May), sum(June), sum(July), sum(August),sum(September), sum(October), sum(November), sum(December), sum(Annual) from rev;";

      try(Statement stm = conn.createStatement())
      {
         ResultSet res_set = stm.executeQuery(sql);

         System.out.format("|%-10s |%-10s |%-10s |%-10s |%-10s |%-10s |%-10s |%-10s |%-10s |%-10s |%-10s |%-10s |%-10s |%-10s\n", "Room(s)", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", "Anual");
         System.out.println("------------------------------------------------------------------------------------------------------------------------------------------------------------------");
         while (res_set.next())
         {
            room = res_set.getString("Room");
            january = res_set.getString("January");
            february = res_set.getString("February");
            march = res_set.getString("March");
            april = res_set.getString("April");
            may = res_set.getString("May");
            june = res_set.getString("June");
            july = res_set.getString("July");
            august = res_set.getString("August");
            september = res_set.getString("September");
            october = res_set.getString("October");
            november = res_set.getString("November");
            december = res_set.getString("December");
            annual = res_set.getString("Annual");

            System.out.format("|%-10s |%-10s |%-10s |%-10s |%-10s |%-10s |%-10s |%-10s |%-10s |%-10s |%-10s |%-10s |%-10s |%-10s\n", room + ":", "$" + january, "$" + february, "$" + march, "$" + april, "$" + may, "$" + june, "$" + july, "$" + august, "$" + september, "$" + october, "$" + november, "$" + december, "$" + annual);
         }
      }
      catch (SQLException e)
      {
         System.out.println("\n" + e);
      }

   }

   //====================================================================

    private void initDb() throws SQLException {
       try {
          conn  = DriverManager.getConnection(JDBC_URL,
                  JDBC_USER,
                  JDBC_PASSWORD);
          boolean roomsExist = false;
          boolean reservationsExist = false;

           ResultSet resultSet = conn.getMetaData().getCatalogs();
           while (resultSet.next()){
               String dbName = resultSet.getString(1);
               if (dbName.equals("lab7_rooms")){
                   roomsExist = true;
               }
               if (dbName.equals("lab7_reservations")){
                   reservationsExist = true;
               }
           }

           try (Statement stmt = conn.createStatement()) {
               if (!roomsExist) {
                   stmt.execute("DROP TABLE IF EXISTS lab7_reservations");
                   stmt.execute("DROP TABLE IF EXISTS lab7_rooms");
                   stmt.execute("CREATE TABLE lab7_rooms (RoomId varchar(5) PRIMARY KEY, roomName varchar(30), beds int, bedType varchar(8), maxOcc int, basePrice decimal(7,2), decor varchar(20), unique(roomName))");

                   // populate lab7_rooms
                   stmt.execute("INSERT INTO lab7_rooms(RoomId, roomName, beds, bedType, maxOcc, basePrice, decor) VALUES ('AOB', 'Abscond or bolster', 2, 'Queen', 4, 175, 'traditional')");
                   stmt.execute("INSERT INTO lab7_rooms(RoomId, roomName, beds, bedType, maxOcc, basePrice, decor) VALUES ('CAS', 'Convoke and sanguine', 2, 'King', 4, 175, 'traditional')");
                   stmt.execute("INSERT INTO lab7_rooms(RoomId, roomName, beds, bedType, maxOcc, basePrice, decor) VALUES ('FNA', 'Frugal not apropos', 2, 'King', 4, 250, 'traditional')");
                   stmt.execute("INSERT INTO lab7_rooms(RoomId, roomName, beds, bedType, maxOcc, basePrice, decor) VALUES ('HBB', 'Harbinger but bequest', 1, 'Queen', 2, 100, 'modern')");
               }
               if (!reservationsExist){
                   stmt.execute("DROP TABLE IF EXISTS lab7_reservations");
                   stmt.execute("CREATE TABLE lab7_reservations (CODE varchar(5) PRIMARY KEY not null, room varchar(5), CheckIn date, CheckOut date, Rate decimal (7,2), LastName varchar(15), FirstName varchar(15), Adults int, Kids int, foreign key (room) references lab7_rooms(RoomId))");
                   stmt.execute("INSERT INTO lab7_reservations(Code, Room, CheckIn, Checkout, Rate, LastName, FirstName, Adults, Kids) VALUES (10105, 'HBB', '2010-10-23', '2010-10-25', 100, 'SELBIG', 'CONRAD', 1, 0)");
               stmt.execute("INSERT INTO lab7_reservations(Code, Room, CheckIn, Checkout, Rate, LastName, FirstName, Adults, Kids) VALUES (10109, 'HBB', '2021-12-01', '2021-12-25', 100, 'BIGGIE', 'SMALLS', 1, 0);");
               stmt.execute("INSERT INTO lab7_reservations(Code, Room, CheckIn, Checkout, Rate, LastName, FirstName, Adults, Kids) VALUES (10110, 'HBB', '2019-12-01', '2019-12-25', 100, 'SMALL', 'BOI', 1, 0);");
               stmt.execute("INSERT INTO lab7_reservations(Code, Room, CheckIn, Checkout, Rate, LastName, FirstName, Adults, Kids) VALUES (10106, 'FNA', '2020-12-14', '2020-12-16', 175, 'JERRY', 'BUTTERS', 1, 0);");
               stmt.execute("INSERT INTO lab7_reservations(Code, Room, CheckIn, Checkout, Rate, LastName, FirstName, Adults, Kids) VALUES (10107, 'FNA', '2020-12-24', '2020-12-26', 175, 'BOBBY', 'BOOBERS', 1, 0);");
               stmt.execute("INSERT INTO lab7_reservations(Code, Room, CheckIn, Checkout, Rate, LastName, FirstName, Adults, Kids) VALUES (10108, 'CAS', '2020-11-28', '2020-11-30', 250, 'MARY', 'ADAMS', 1, 0);");
               }
           } catch (Exception e){
               System.out.println(e.getMessage());
           }
       } catch (Exception e){
           System.out.println(e.getMessage());
       }
    }
    

}

