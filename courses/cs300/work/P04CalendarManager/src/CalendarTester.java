//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: Event Creator
// Course: CS 300 Spring 2025
//
// Author: Jake Christofferson
// Email: ejchristoffe@wisc.edu
// Lecturer: Mouna Kacem
//
//////////////////////// ASSISTANCE/HELP CITATIONS ////////////////////////////
//
// Persons: none
// Online Sources:
// https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java
// /lang/Comparable.html, helped understand the
// compareTo method and Comparable<> implementation.
//
// https://learn.zybooks.com/zybook/WISCCOMPSCI300Spring2025
// /chapter/5/section/12, helped me understand how to implement
// compareTo method.
//
// https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/time/
// YearMonth.html, Helped me understand what the YearMonth class was and how
// it is used.
//
///////////////////////////////////////////////////////////////////////////////

// TODO get rid of unused imports
import java.time.DateTimeException;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.NoSuchElementException;
import java.util.Arrays;


/**
 * Utility class that defines tester methods for p04 Monthly Calendar.
 */
public class CalendarTester {

  /**
   * Ensures the correctness of the constructor and getter methods defined in the Event class when
   * no exception is expected to be thrown.
   *
   * @return true if the tester verifies a correct functionality and false if at least one bug is
   *         detected
   */
  public static boolean testEventConstructorAndGettersValidBehavior() {
    { // Scenario 1: Testing Constructor
      try {
        Event actualEv = new Event("test event", 3, 21, 32);
      } catch (IllegalArgumentException e) {
        System.out.println(e.getMessage());
        return false;
      }
    }

    { // Scenario 2: Testing getStartTimeAsString()
      Event actualEv = new Event("test event", 3, 21, 32);
      actualEv.markAsComplete();

      if (!actualEv.getStartTimeAsString().equals("21:32")) {
        return false;
      }
    }

    { // Scenario 3: Testing getDescription()
      Event actualEv = new Event("test event", 3, 21, 32);

      if (!actualEv.getDescription().equals("test event")) {
        return false;
      }
    }

    { // Scenario 4: Testing getDay()
      Event actualEv = new Event("test event", 3, 21, 32);

      if (actualEv.getDay() != 3) {
        return false;
      }
    }

    { // Scenario 5: Testing isComplete()
      Event actualEv = new Event("test event", 3, 21, 32);

      if (actualEv.isComplete()) {
        return false;
      }
    }

    return true; // All tests passed
  }

  /**
   * Ensures the correctness of the constructor of the Event class when it is passed invalid inputs.
   *
   * @return true if the tester verifies a correct functionality and false if at least one bug is
   *         detected
   */
  public static boolean testEventConstructorThrowingExceptions() {
    { // Scenario 1: Catch description null error
      try {
        Event testEvent = new Event(null, 4, 12, 24);
        return false;
      } catch (IllegalArgumentException e) {
        // Wanted output
      }
    }

    { // Scenario 2: Catch description blank error
      try {
        Event testEvent = new Event("           ", 4, 12, 24);
        return false;
      } catch (IllegalArgumentException e) {
        // Wanted output
      }
    }

    { // Scenario 3.1: Catch day not in range below
      try {
        Event testEvent = new Event("test desc", -3, 12, 24);
        return false;
      } catch (IllegalArgumentException e) {
        // Wanted output
      }
    }

    { // Scenario 3.2: Catch day not in range above
      try {
        Event testEvent = new Event("test desc", 32, 12, 24);
        return false;
      } catch (IllegalArgumentException e) {
        // Wanted output
      }
    }

    { // Scenario 4.1: Catch start hour not in range below
      try {
        Event testEvent = new Event("test desc", 4, -2, 24);
        return false;
      } catch (IllegalArgumentException e) {
        // Wanted output
      }
    }

    { // Scenario 4.2: Catch start hour not in range above
      try {
        Event testEvent = new Event("test desc", 4, 24, 24);
        return false;
      } catch (IllegalArgumentException e) {
        // Wanted output
      }
    }

    { // Scenario 5.1: Catch start min not in range below
      try {
        Event testEvent = new Event("test desc", 4, 12, -12);
        return false;
      } catch (IllegalArgumentException e) {
        // Wanted output
      }
    }

    { // Scenario 5.1: Catch start min not in range above
      try {
        Event testEvent = new Event("test desc", 4, 12, 60);
        return false;
      } catch (IllegalArgumentException e) {
        // Wanted output
      }
    }

    return true;
  }

  /**
   * Ensures the correctness of the Event.compareTo() method.
   *
   * @return true if the tester verifies a correct functionality and false if at least one bug is
   *         detected
   */
  public static boolean testEventCompareTo() {
    // compare two events e1 and e2 where e1 start time is less than e2 start time and ensure
    // that
    { // e1.compareTo(e2) < 0
      try {
        Event e1 = new Event("desc", 1, 10, 30);
        Event e2 = new Event("desc", 1, 10, 31);

        if (!(e1.compareTo(e2) < 0)) {
          return false;
        }

      } catch (IllegalArgumentException e) {
        return false;
      }
    }


    { // e2.compareTo(e1) > 0
      try {
        Event e1 = new Event("desc", 1, 10, 30);
        Event e2 = new Event("desc", 1, 10, 31);

        if (!(e2.compareTo(e1) > 0)) {
          return false;
        }

      } catch (IllegalArgumentException e) {
        return false;
      }

    }

    { // e1.compareTo(e1) == 0
      try {
        Event e1 = new Event("desc", 1, 10, 30);

        if (e1.compareTo(e1) != 0) {
          return false;
        }

      } catch (IllegalArgumentException e) {
        return false;
      }

    }

    // consider two different events e1 and e2 with the same start time and
    // (may be different days) and ensure that:

    { // Checking e1.compareTo(e2) == 0 and Checkinge2.compareTo(e1) == 0
      try {
        Event e1 = new Event("desc", 1, 10, 30);
        Event e2 = new Event("desc", 30, 10, 30);

        if (e1.compareTo(e2) != 0) {
          return false;
        }

        if (e2.compareTo(e1) != 0) {
          return false;
        }

      } catch (IllegalArgumentException e) {
        return false;
      }

    }

    return true;
  }

  /**
   * Ensures the correctness of the Event.equals() method.
   *
   * @return true if the tester verifies a correct functionality and false if at least one bug is
   *         detected
   */
  public static boolean testEventEquals() {
    // consider comparing two events with same day, description, and start time and ensure they
    // are equals
    {
      Event e1 = new Event("desc", 1, 1, 12);
      Event e2 = new Event("desc", 1, 1, 12);
      e1.markAsComplete();

      if (!e1.equals(e2)) {
        return false;
      }
    }

    // consider comparing an event to its String representation and ensure equals method
    // returns false
    {
      Event e1 = new Event("desc", 1, 0, 12);
      e1.markAsComplete();

      if (e1.equals(e1.toString())) {
        return false;
      }
    }

    // consider comparing an event to a null reference and ensure event.equals(null) returns
    // false
    {
      Event e1 = new Event("desc", 1, 0, 12);
      e1.markAsComplete();

      if (e1.equals(null)) {
        return false;
      }
    }

    return true;
  }

  /**
   * Ensures the correctness of the MonthCalendar.addEvent() method when valid inputs are provided
   * and no duplicate event exists for the day, ensuring the event is added correctly to the
   * specified day's list.
   *
   * @return true if the tester verifies a correct functionality and false if at least one bug is
   *         detected
   */
  public static boolean testSuccessfulAddEvent() {
    // 1. Create a MonthCalendar instance for a valid month and year.
    // 2. Add multiple events on the same day with different descriptions and different start times.
    // 3. Verify that addEvent() returns true when called with valid inputs and no duplicate event
    // exists in the day's event list.
    // 4. Use getEvents() to verify:
    // - Events of the same day are sorted in ascending order based on Event.compareTo().
    // - If two events have the same start time (and different descriptions) , they retain
    // their order of addition.
    { // Completes the above steps ensuring the correct order of events happens method runs without
      // errors
      MonthCalendar actual = new MonthCalendar(2000, 1);
      boolean ev1 = actual.addEvent(2, "Desc 1", 4, 53);
      boolean ev2 = actual.addEvent(2, "Desc 2", 4, 12);
      boolean ev3 = actual.addEvent(2, "Desc 3", 5, 12);
      boolean ev4 = actual.addEvent(2, "Desc 2.5", 4, 30);
      boolean ev5 = actual.addEvent(2, "Desc 1.0", 4, 53);

      if (!(ev1 && ev2 && ev3 && ev4)) {
        return false;
      }

      ArrayList<Event> expected = new ArrayList<>();
      expected.add(new Event("Desc 2", 2, 4, 12));
      expected.add(new Event("Desc 2.5", 2, 4, 30));
      expected.add(new Event("Desc 1", 2, 4, 53));
      expected.add(new Event("Desc 1.0", 2, 4, 53));
      expected.add(new Event("Desc 3", 2, 5, 12));

      ArrayList<Event>[] actualArray = new ArrayList[31];
      actualArray = actual.getEvents();

      // Comparing each of the values in expected and actualArray
      for (int i = 0; i < actualArray[1].size(); ++i) {

        if (!expected.get(i).equals(actualArray[1].get(i))) {
          return false;
        }
      }

    }

    return true;
  }

  /**
   * Ensures the correctness of the MonthCalendar.addEvent() method when called with invalid inputs
   * or an attempt to add a duplicate event.
   *
   * @return true if the tester verifies a correct functionality and false if at least one bug is
   *         detected
   */
  public static boolean testUnsuccessfulAddEvents() {
    // TODO Verify that the addEvent() returns false when provided an invalid day,
    // invalid description, or invalid start time.
    {
      MonthCalendar actual = new MonthCalendar(2000, 1);
      boolean ev1 = actual.addEvent(36, "Desc 1", 4, 53);
      boolean ev2 = actual.addEvent(2, "        ", 4, 53);
      boolean ev3 = actual.addEvent(2, "Desc 2", 60, 53);
      boolean ev4 = actual.addEvent(2, "Desc 3", 4, -12);

      if (ev1 || ev2 || ev3 || ev4) { // Make sure all evs are false as it should be
        return false;
      }
    }
    
    // Verify that the addEvent() method returns false and does not modify the events list
    // when attempting to add a duplicate event (same day, description, and start time).
    // Use getEvents() to confirm that:
    // - No event is added when an invalid input is provided.
    // - The events of the day list remains unchanged after attempting to add a duplicate event.
    {
      MonthCalendar actual = new MonthCalendar(2000, 1);
      actual.addEvent(2, "Desc 1", 4, 53);
      boolean ev2 = actual.addEvent(2, "Desc 1", 4, 53);

      if (ev2) { // Make sure ev2 is false as it should be
        return false;
      }

      ArrayList<Event> expected = new ArrayList<>();
      expected.add(new Event("Desc 1", 2, 4, 53));
      expected.add(new Event("Desc 1", 2, 4, 53));
      
      ArrayList<Event>[] actualArray = new ArrayList[31];
      actualArray = actual.getEvents();
      
      for (int i = 0; i < actualArray[1].size(); ++i) {

        if (!expected.get(i).equals(actualArray[1].get(i))) { // Events should still be the same
          return false;
        }
      }
      
    }
    
    return true;
  }

  /**
   * Ensures the correctness of the MonthCalendar.cancelEvent() method when no exceptions are
   * expected.
   *
   * @return true if the tester verifies a correct functionality and false if at least one bug is
   *         detected
   */
  public static boolean testCancelEventValid() {
    // verify (using the getEvents() method) that events are removed correctly on the correct
    // day
    {
      ArrayList<Event>[] expected = new ArrayList[31]; // Will use to compare a specific day
      expected[1] = new ArrayList<>();
      expected[1].add(new Event("Desc 1", 2, 4, 53));
      expected[1].add(new Event("Desc 3", 2, 5, 12));

      MonthCalendar actual = new MonthCalendar(2000, 1);
      actual.addEvent(2, "Desc 1", 4, 53);
      actual.addEvent(2, "Desc 2", 4, 12);
      actual.addEvent(2, "Desc 3", 5, 12);

      // testing the cancelEvent method.
      actual.cancelEvent("Desc 2", 2, 4, 12);

      if (!expected[1].equals(actual.getEvents()[1])) {
        return false;
      }
    }

    return true;
  }

  /**
   * Ensures the correctness of the MonthCalendar.cancelEvent() method when exceptions are expected.
   *
   * @return true if the tester verifies a correct functionality and false if at least one bug is
   *         detected
   */
  public static boolean testCancelEventExceptions() {
    // TODO verify that removing with an invalid day or removing an event that does not exist
    // cause the correct exceptions
    { // Trying with an illegal Event construction with invalid day.
      try {
        MonthCalendar actual = new MonthCalendar(2000, 1);
        actual.addEvent(2, "Desc 1", 4, 53);
        actual.addEvent(2, "Desc 2", 4, 12);
        actual.addEvent(2, "Desc 3", 5, 12);

        actual.cancelEvent("Desc 2", 34, 4, 12);


        return false;
      } catch (IllegalArgumentException e) {

      }
    }

    { // Trying by removing an event that does not exist.
      try {
        MonthCalendar actual = new MonthCalendar(2000, 1);
        actual.addEvent(2, "Desc 1", 4, 53);
        actual.addEvent(2, "Desc 2", 4, 12);
        actual.addEvent(2, "Desc 3", 5, 12);

        actual.cancelEvent("Desc 2", 2, 4, 13);

        return false;
      } catch (NoSuchElementException e) {

      }
    }

    return true;
  }


  /**
   * Main method to run the tester methods
   *
   * @param args list of input arguments if any
   */
  public static void main(String[] args) {
    System.out.println("-----------------------------------------------------------");
    System.out.println("testEventConstructorAndGettersValidBehavior: "
        + (testEventConstructorAndGettersValidBehavior() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println("testEventConstructorThrowingExceptions: "
        + (testEventConstructorThrowingExceptions() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println("testEventCompareTo: " + (testEventCompareTo() ? "Pass" : "Failed!"));

    System.out.println("-----------------------------------------------------------");
    System.out.println("testEventEquals: " + (testEventEquals() ? "Pass" : "Failed!"));

    System.out.println("-----------------------------------------------------------");

    System.out
        .println("testSuccessfulAddEvent: " + (testSuccessfulAddEvent() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println(
        "testUnsuccessfulAddEvents: " + (testUnsuccessfulAddEvents() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");

    System.out.println("testCancelEventValid(): " + (testCancelEventValid() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out
        .println("testDeleteExceptions: " + (testCancelEventExceptions() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
  }

}
