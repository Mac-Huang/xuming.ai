// DO NOT SUBMIT THIS FILE TO GRADESCOPE

import java.util.Scanner;

/**
 * This class implements the Driver Application for cs300 Fall 2025 p1 Event Manager
 */
public class EventManagerDriver {
  // welcome, good bye, and syntax error messages
  private static final String WELCOME_MSG =
      "==========================================================\n" +
      "               Event Manager Application\n" +
      "==========================================================\n";
  private static final String GOOD_BYE_MSG = "\n----------    Thanks for using our App! ----------";
  private static final String SYNTAX_ERROR_MSG = "Syntax Error: Please enter a valid command!";

  // Maximum number of events per day
  private static final int MAX_EVENTS_PER_DAY = 10;

  // 2D array storing the events of the month
  private static String[][] events = new String[31][MAX_EVENTS_PER_DAY];

  // oversize array storing the list of completed events
  private static String[] completedEvents = new String[100];
  private static int completedEventsCount = 0; // completed events size

  // scanner to read user inputs
  private static Scanner scanner = new Scanner(System.in);

  /**
   * Main method that launches this driver application
   *
   * @param args list of input arguments if any
   */
  public static void main(String[] args) {
    // display welcome message
    System.out.println(WELCOME_MSG);
    // read and process user command lines
    processUserCommandLines();
    // close the scanner
    scanner.close();
    // display good bye message
    System.out.println(GOOD_BYE_MSG);
  }

  /**
   * Prints out the menu of this application
   */
  private static void displayMenu() {
    System.out.println("\n======================== MENU ============================");
    System.out.println("Enter one of the following options:");
    System.out.println("[0] Display the main menu");
    System.out.println("[1] Add Event");
    System.out.println("[2] Delete Event");
    System.out.println("[3] Update Event");
    System.out.println("[4] Mark Event as Complete");
    System.out.println("[5] View Events for a Day");
    System.out.println("[6] View All Events");
    System.out.println("[7] View Completed Events");
    System.out.println("[8] Quit the application");
    System.out.println("----------------------------------------------------------");
  }

  /**
   * Prompts the user to enter an integer value representing a day of the month within the range 1 to 31.
   * @param scanner A Scanner object used to read user input
   * @return the day value entered by the user, in the range 1 to 31 (inclusive).
   */
  private static int readDay(Scanner scanner){
    System.out.print("Enter day (1-31): ");
    int day = scanner.nextInt();
    scanner.nextLine(); // Consume newline
    return day;
  }

  /**
   * Reads and processes user command lines
   */
  private static void processUserCommandLines() {
    // display the main menu
    displayMenu();
    // read user command line
    String promptCommandLine = "\nENTER COMMAND: ";
    System.out.print(promptCommandLine);
    String command = scanner.nextLine();
    // read and process user command lines until the user quits the app
    while (true) {
      if (command.isBlank()) {// blank command entered by the user
        System.out.println(SYNTAX_ERROR_MSG);
        displayMenu(); // display the main menu
        // read next user command line
        System.out.print(promptCommandLine);
        command = scanner.nextLine(); // read user command line
        continue;
      }
      try {
        switch (command.charAt(0)) {
          case '8': // quit the app
            return;
          case '0': // display main menu
            displayMenu(); // display the main menu
            break;
          case '1': // Add Event
            int day = readDay(scanner);
            System.out.print("Enter event description: ");
            String event = scanner.nextLine();
            if (EventManager.addEvent(day, event, events)) {
              System.out.println("Event added successfully.");
            } else {
              System.out.println("Failed to add event. Day is full.");
            }
            break;

          case '2': // Delete Event
            day = readDay(scanner);
            System.out.print("Enter index of the event to remove: ");
            int index = scanner.nextInt();
            scanner.nextLine(); // Consume newline
            String deletedEvent = EventManager.deleteEvent(day, index, events);
            System.out.println(deletedEvent + " deleted successfully.");

            break;
          case '3': // Update Event
            day = readDay(scanner);
            System.out.print("Enter index of the event to update: ");
            index = scanner.nextInt();
            scanner.nextLine(); // Consume newline
            System.out.print("Enter new event description: ");
            String newEvent = scanner.nextLine();
            if (EventManager.updateEvent(day, index, newEvent, events)) {
              System.out.println("Event updated successfully.");
            } else {
              System.out.println("Event not found.");
            }
            break;
          case '4': // Mark Event as Complete
            day = readDay(scanner);
            System.out.print("Enter index of the event to complete: ");
            index = scanner.nextInt();
            scanner.nextLine(); // Consume newline

            completedEventsCount =
                EventManager.markEventAsComplete(day, index, events, completedEvents,
                    completedEventsCount);
            System.out.println("Event completed successfully.");
            break;
          case '5': // View Events for a Day
            day = readDay(scanner);
            System.out.println(EventManager.getEvents(day, events));
            break;
          case '6': // View All Events
            System.out.println(EventManager.getAllEvents(events));
            break;
          case '7': // View Completed Events
            System.out.println("Completed Events:");
            System.out.println(EventManager.getCompletedEvents(completedEvents,
                completedEventsCount));
            break;
          default:
            System.out.println(SYNTAX_ERROR_MSG); // Syntax Error

        }
      } catch (Exception e) {
        if (e.getMessage() != null)
          System.out.println("ERROR: " + e.getMessage());
        else
          System.out.println("ERROR: " + e.getClass().getName() + " exception was thrown!");
      }
      // read next user command line
      System.out.print(promptCommandLine);
      command = scanner.nextLine(); // read user command line
    }
  }
}
