//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: Event Manager
// Course: CS 300 Spring 2025
//
// Author: Jake Christofferson
// Email: ejchristoffe@wisc.edu
// Lecturer: Mouna Kacem
//
//////////////////////// ASSISTANCE/HELP CITATIONS ////////////////////////////
//
// Persons: none
// Online Sources: Pre-made tester method header from downloaded file.
//
///////////////////////////////////////////////////////////////////////////////

import java.util.Arrays;

/**
 * This utility class implements unit tests to check the correctness of methods implemented in the
 * EventManager class of P01 Event Manager program.
 */
public class EventManagerTester {

  /**
   * Ensures the correctness of the EventManager.addToCompactArray() method
   *
   * @return true if the tester verifies a correct functionality and false if at least one bug is
   *         detected
   */
  public static boolean addToCompactArrayTester() {
    // Test scenario 1: Adding to an empty array
    {
      String[] actual = new String[5];
      if (!EventManager.addToCompactArray("A", actual)) {
        System.out.println("Adding to an empty array failed! "
            + "The method was expected to return true, but it returned false.");
        return false;
      }

      String[] expected = new String[] {"A", null, null, null, null};
      if (!Arrays.deepEquals(actual, expected)) {
        System.out.println("Adding to an empty array failed!");
        System.out.println("Expected: " + Arrays.deepToString(expected));
        System.out.println("Actual: " + Arrays.deepToString(actual));
        return false;
      }
    }
    // Test scenario 2: Adding to a non-empty array
    {
      String[] actual = new String[] {"A", "B", "C", "D", null, null};

      if (!EventManager.addToCompactArray("E", actual)) {
        System.out.println("Adding to a non-full array failed! "
            + "The method was expected to return true, but it returned false.");
        return false;
      }
      if (!EventManager.addToCompactArray("F", actual)) {
        System.out.println("Adding to a non-full array failed! "
            + "The method was expected to return true, but it returned false.");
        return false;
      }
      String[] expected = new String[] {"A", "B", "C", "D", "E", "F"};
      if (!Arrays.deepEquals(actual, expected)) {
        System.out.println("Adding to a non-full array failed!");
        System.out.println("Expected: " + Arrays.deepToString(expected));
        System.out.println("Actual: " + Arrays.deepToString(actual));
        return false;
      }
    }

    // Test scenario 3: Adding to a full-compact array
    {
      String[] actual = new String[] {"A", "B", "C", "D"};
      String[] expected = new String[] {"A", "B", "C", "D"};

      if (EventManager.addToCompactArray("E", actual)) {
        System.out.println("Adding to a full array failed! "
            + "The method was expected to return false, but it returned true.");
        return false;
      }
      if (!Arrays.deepEquals(actual, expected)) {
        System.out.println("Adding to a full array failed!");
        System.out.println("Expected: " + Arrays.deepToString(expected));
        System.out.println("Actual: " + Arrays.deepToString(actual));
        return false;
      }

    }

    return true; // Expected behavior verified. No bug detected
  }

  /**
   * Ensures the correctness of the EventManager.sizeCompactArray() method This tester ensured the
   * following scenarios: - an empty array - a partially full array - a full array
   * 
   * @return true if the tester verifies a correct functionality and false if at least one bug is
   *         detected
   */
  public static boolean sizeCompactArrayTester() {
    // Scenario 1: empty array
    {
      String[] values = {null, null, null, null, null};
      int expected = 0;
      int actual = EventManager.sizeCompactArray(values);

      if (expected != actual) {
        System.out.println("Error sizing compact array, scenario 1");
        System.out.println("Expected: " + expected + " Actual: " + actual);
        return false;
      }
    }
    // Scenario 2: partially full array
    {
      String[] values = {"A", "B", null, null, null};
      int expected = 2;
      int actual = EventManager.sizeCompactArray(values);

      if (expected != actual) {
        System.out.println("Error sizing compact array, scenario 2");
        System.out.println("Expected: " + expected + " Actual: " + actual);
        return false;
      }
    }
    // Scenario 3: full array
    {
      String[] values = {"A", "B", "C", "D", "E"};
      int expected = 5;
      int actual = EventManager.sizeCompactArray(values);

      if (expected != actual) {
        System.out.println("Error sizing compact array, scenario 3");
        System.out.println("Expected: " + expected + " Actual: " + actual);
        return false;
      }
    }
    return true; // returns true if no bugs are found
  }

  /**
   * Ensures the correctness of the EventManager.removeFromCompactArrayAtIndex() method when passed
   * an index out of bounds (index < 0 OR index >= values.length)
   *
   * @return true if the tester verifies a correct functionality and false if at least one bug is
   *         detected
   */
  public static boolean removeFromCompactArrayAtIndexOutOfBoundsTester() {
    // Scenario 1: index < 0
    {
      String[] exampleValues = {"A", "B", "C", "D", null, null};
      String expected = null;
      String actual = EventManager.removeFromCompactArrayAtIndex(-1, exampleValues);

      if (expected != actual) {
        System.out.println("Error removeFromCompactArrayAtIndexOutOfBoundsTester. Expected: null "
            + "reference, actual: " + actual);
        return false;

      }
    }
    // Scenario 2: index >= values.length
    {
      String[] exampleValues = {"A", "B", "C", "D", null, null};
      String expected = null;
      String actual =
          EventManager.removeFromCompactArrayAtIndex(exampleValues.length, exampleValues);

      if (expected != actual) {
        System.out.println("Error removeFromCompactArrayAtIndexOutOfBoundsTester. \nExpected: "
            + expected + ", actual: " + actual);
        return false;

      }
    }

    return true;
  }

  /**
   * Ensures the correctness of the EventManager.removeFromCompactArrayAtIndex() method when passed
   * a valid index
   *
   * This tester method verified the expected behavior considering at least for the following test
   * scenarios: <BR>
   * (+) removing the element at index zero from a compact non-empty array <BR>
   * (+) removing an element at the middle of the array <BR>
   * (+) removing the last element in the array
   *
   * @return true if the tester verifies a correct functionality and false if at least one bug is
   *         detected
   */
  public static boolean removeFromCompactArrayAtIndexTester() {
    // Scenario 1: remove element at index 0
    {
      String[] testArrayActual = {"A", "B", "C", null, null, null};
      String[] testArrayEnd = {"B", "C", null, null, null, null};
      String expected = "A";
      String actual = EventManager.removeFromCompactArrayAtIndex(0, testArrayActual);

      // Checks if array is correctly adjusted
      if (!Arrays.deepEquals(testArrayActual, testArrayEnd)) {
        System.out.println("\nError removing compact array at index 0(start).");
        System.out.println("Expected: " + Arrays.deepToString(testArrayActual) + "Actual: "
            + Arrays.deepToString(testArrayActual));
        return false;
      }

      // Checks if the correct String is returned
      if (!expected.equals(actual)) {
        System.out.println("Error removing correct String from compact array at index 0(start).");
        System.out.println("Expected: #" + expected + "# Actual: #" + actual + "#");
        return false;
      }
    }

    // Scenario 2: remove element in the middle of array
    {
      String[] testArrayActual = {"A", "B", "C", null, null, null};
      String[] testArrayEnd = {"A", "C", null, null, null, null};
      String expected = "B";
      String actual = EventManager.removeFromCompactArrayAtIndex(1, testArrayActual);

      // Checks if array is correctly adjusted
      if (!Arrays.deepEquals(testArrayActual, testArrayEnd)) {
        System.out.println("\nError removing compact array at index 1(middle).");
        System.out.println("Expected: " + Arrays.deepToString(testArrayActual) + "Actual: "
            + Arrays.deepToString(testArrayActual));
        return false;
      }

      // Checks if the correct String is returned
      if (!expected.equals(actual)) {
        System.out.println("Error removing correct String from compact array at index 1(middle).");
        System.out.println("Expected: #" + expected + "# Actual: #" + actual + "#");
        return false;
      }
    }

    // Scenario 3: remove the last element in the array
    {
      String[] testArrayActual = {"A", "B", "C", "D", "E", "F"};
      String[] testArrayEnd = {"A", "B", "C", "D", "E", null};
      String expected = "F";
      String actual = EventManager.removeFromCompactArrayAtIndex(5, testArrayActual);

      // Checks if array is correctly adjusted
      if (!Arrays.deepEquals(testArrayActual, testArrayEnd)) {
        System.out.println("\nError removing compact array at index 5(end).");
        System.out.println("Expected: " + Arrays.deepToString(testArrayActual) + "Actual: "
            + Arrays.deepToString(testArrayActual));
        return false;
      }

      // Checks if the correct String is returned
      if (!expected.equals(actual)) {
        System.out.println("Error removing correct String from compact array at index 5(end).");
        System.out.println("Expected: #" + expected + "# Actual: #" + actual + "#");
        return false;
      }
    }

    return true;
  }


  /**
   * Ensures the correctness of the EventManager.appendElement() method <BR>
   *
   * This tester method verified the expected behavior considering at least for the following test
   * scenarios: <BR>
   * (+) adding to an empty oversize array <BR>
   * (+) adding to the end of a non-full oversize array <BR>
   * (+) adding to a full oversize array
   *
   * @return true if the tester verifies a correct functionality and false if at least one bug is
   *         detected
   */
  public static boolean appendElementTester() {
    // Scenario 1: adding to an empty oversize array
    {
      String[] valuesActual = {null, null, null, null};
      int valuesActualSize = 0;
      String[] valuesExpected = {"A", null, null, null};
      int valuesExpectedSize = 1;

      valuesActualSize = EventManager.appendElement("A", valuesActual, valuesActualSize);

      if (!Arrays.deepEquals(valuesActual, valuesExpected)) {
        System.out.println("Error appending element scenario 1: arrays dont't match");
        System.out.println("Expected: " + Arrays.deepToString(valuesExpected));
        System.out.println("Actual: " + Arrays.deepToString(valuesActual));
        return false;
      }

      if (valuesActualSize != valuesExpectedSize) {
        System.out.println("Error appending element scenario 1: final sizes don't match");
        System.out.println("Expected: " + valuesExpectedSize + "Actual: " + valuesActualSize);
        return false;
      }

    }
    // Scenario 2: adding to the end of a non-full oversize array
    {
      String[] valuesActual = {"A", "B", null, null};
      int valuesActualSize = 2;
      String[] valuesExpected = {"A", "B", "C", null};
      int valuesExpectedSize = 3;

      valuesActualSize = EventManager.appendElement("C", valuesActual, valuesActualSize);

      if (!Arrays.deepEquals(valuesActual, valuesExpected)) {
        System.out.println("Error appending element scenario 2: arrays dont't match");
        System.out.println("Expected: " + Arrays.deepToString(valuesExpected));
        System.out.println("Actual: " + Arrays.deepToString(valuesActual));
        return false;
      }

      if (valuesActualSize != valuesExpectedSize) {
        System.out.println("Error appending element scenario 2: final sizes don't match");
        System.out.println("Expected: " + valuesExpectedSize + "Actual: " + valuesActualSize);
        return false;
      }

    }
    // Scenario 3: adding to a full oversize array
    {
      String[] valuesActual = {"A", "B", "C", "D"};
      int valuesActualSize = 4;
      String[] valuesExpected = {"A", "B", "C", "D"};
      int valuesExpectedSize = 4;

      valuesActualSize = EventManager.appendElement("A", valuesActual, valuesActualSize);

      if (!Arrays.deepEquals(valuesActual, valuesExpected)) {
        System.out.println("Error appending element scenario 3: arrays dont't match");
        System.out.println("Expected: " + Arrays.deepToString(valuesExpected));
        System.out.println("Actual: " + Arrays.deepToString(valuesActual));
        return false;
      }

      if (valuesActualSize != valuesExpectedSize) {
        System.out.println("Error appending element scenario 3: final size don't match");
        System.out.println("Expected: " + valuesExpectedSize + "Actual: " + valuesActualSize);
        return false;
      }

    }

    return true; // method completes with no errors
  }

  /**
   * Ensures the correctness of the EventManager.addEvent() method
   *
   * @return true if the tester verifies a correct functionality and false if at least one bug is
   *         detected
   */
  public static boolean addEventTester() {
    // Test scenario 1: add to an empty 2-D array
    {
      String[][] actual = new String[2][5];
      if (!EventManager.addEvent(2, "New Event", actual)) {
        System.out.println("An error occured adding to an empty array, expected to return "
            + "true, returned false.");
        return false;
      }

      String[][] expected = {{null, null, null, null, null}, {"New Event", null, null, null, null}};
      if (!Arrays.deepEquals(actual, expected)) {
        System.out.println("Adding to an empty array failed!");
        System.out.println("Expected: " + Arrays.deepToString(expected));
        System.out.println("Actual: " + Arrays.deepToString(actual));
        return false;
      }
    }

    // Test scenario 2: add to a partially full 2-D array
    {
      String[][] actual = {{"A", "B", "C", null, null}, {null, null, null, null, null}};
      if (!EventManager.addEvent(1, "D", actual)) {
        System.out.println(
            "Issue adding to a partially filled out day, expected to return true, reutrned false.");
        return false;
      }

      String[][] expected = {{"A", "B", "C", "D", null}, {null, null, null, null, null}};
      if (!Arrays.deepEquals(actual, expected)) {
        System.out.println("Adding to an empty array failed!");
        System.out.println("Expected: " + Arrays.deepToString(expected));
        System.out.println("Actual: " + Arrays.deepToString(actual));
        return false;
      }
    }

    // Test scenario 3: should not be able to add to a full section of a 2-D array
    {
      String[][] actual = {{"A", "B", "C", "D", "E"}, {"A", "B", "C", null, null}};
      if (EventManager.addEvent(1, "E", actual)) {
        System.out.println("Error adding when array is full, expected false, got true");
        return false;
      }

      String[][] expected = {{"A", "B", "C", "D", "E"}, {"A", "B", "C", null, null}};
      if (!Arrays.deepEquals(actual, expected)) {
        System.out.println("Adding to a full array failed!");
        System.out.println("Expected: " + Arrays.deepToString(expected));
        System.out.println("Actual: " + Arrays.deepToString(actual));
        return false;
      }

    }

    return true; // no bugs detected, runs as expected
  }

  /**
   * Ensures the correctness of the EventManager.deleteEvent() method - tests a partially full array
   * - tests removing a null element - tests removing an index out of bounds
   *
   * @return true if the tester verifies a correct functionality and false if at least one bug is
   *         detected
   */
  public static boolean deleteEventTester() {
    // Situation 1: removing an event from a partially full array
    {
      String[][] actualArray =
          {{"A", "B", "C", null, null}, {"A", "B", "C", null, null}, {"A", "B", "C", null, null}};
      String[][] expectedArray =
          {{"A", "B", "C", null, null}, {"A", "C", null, null, null}, {"A", "B", "C", null, null}};
      String actualString = EventManager.deleteEvent(2, 1, actualArray);
      String expectedString = "B";

      if (!Arrays.deepEquals(actualArray, expectedArray)) {
        System.out.println("Error deleting event, arrays are not the same in situation 1.");
        System.out.println("Expected: " + Arrays.deepToString(expectedArray));
        System.out.println("Actual: " + Arrays.deepToString(actualArray));
        return false;
      }

      if (!actualString.equals(expectedString)) {
        System.out.println("Error deleting event, Strings are not the same in situation 1.");
        System.out.println("Expected: " + expectedString);
        System.out.println("Actual: " + actualString);
        return false;
      }
    }
    // Situation 2: removing a null element
    {
      String[][] actualArray =
          {{"A", "B", "C", null, null}, {"A", "B", "C", null, null}, {"A", "B", "C", null, null}};
      String[][] expectedArray =
          {{"A", "B", "C", null, null}, {"A", "B", "C", null, null}, {"A", "B", "C", null, null}};
      String actualString = EventManager.deleteEvent(2, 4, actualArray);
      String expectedString = null;

      if (!Arrays.deepEquals(actualArray, expectedArray)) {
        System.out.println("Error deleting event, arrays are not the same in situation 2.");
        System.out.println("Expected: " + Arrays.deepToString(expectedArray));
        System.out.println("Actual: " + Arrays.deepToString(actualArray));
        return false;
      }

      if (actualString != expectedString) {
        System.out.println("Error deleting event, Strings are not the same in situation 2.");
        System.out.println("Expected: " + expectedString);
        System.out.println("Actual: " + actualString);
        return false;
      }
    }
    // Situation 3: removing an index out of bounds
    {
      String[][] actualArray =
          {{"A", "B", "C", null, null}, {"A", "B", "C", null, null}, {"A", "B", "C", null, null}};
      String[][] expectedArray =
          {{"A", "B", "C", null, null}, {"A", "B", "C", null, null}, {"A", "B", "C", null, null}};
      String actualString = EventManager.deleteEvent(3, -3, actualArray);
      String expectedString = null;

      if (!Arrays.deepEquals(actualArray, expectedArray)) {
        System.out.println("Error deleting event, arrays are not the same in situation 3.");
        System.out.println("Expected: " + Arrays.deepToString(expectedArray));
        System.out.println("Actual: " + Arrays.deepToString(actualArray));
        return false;
      }

      if (actualString != expectedString) {
        System.out.println("Error deleting event, Strings are not the same in situation 3.");
        System.out.println("Expected: " + expectedString);
        System.out.println("Actual: " + actualString);
        return false;
      }
    }
    return true; // No bugs were detected
  }

  /**
   * Ensures the correctness of the EventManager.markEventAsComplete() method - Tests if the event
   * will be taken out of the events array and added to the completed events array - Tests trying to
   * add a completed event to a full completed events array.
   * 
   * @return true if the tester verifies a correct functionality and false if at least one bug is
   *         detected
   */
  public static boolean markEventAsCompleteTester() {
    // Scenario 1: completing an event and adding to a partially full completed events array
    {
      String[][] events =
          {{"A", "B", "c", null}, {null, null, null, null}, {"a", "b", "c", null, null}};
      String[] completedEventsActual = {"ev1", "ev2", null, null, null, null};
      String[] completedEventsExpected = {"ev1", "ev2", "c completed on Day 1", null, null, null};
      int completedEventsCountExpected = 3;
      int completedEventsCountActual =
          EventManager.markEventAsComplete(1, 2, events, completedEventsActual, 2);

      if (!Arrays.deepEquals(completedEventsActual, completedEventsExpected)) {
        System.out.println("Error marking event complete, arrays are not the same in situation 1.");
        System.out.println("Expected: " + Arrays.deepToString(completedEventsExpected));
        System.out.println("Actual: " + Arrays.deepToString(completedEventsActual));
        return false;
      }

      if (completedEventsCountExpected != completedEventsCountActual) {
        System.out.println("Error marking event complete, arrays are not the same in situation 1.");
        System.out.println("Expected: " + completedEventsCountExpected);
        System.out.println("Actual: " + completedEventsCountActual);
        return false;
      }
    }
    // Scenario 2: completing an event and trying to add to a full completed events array
    {
      {
        String[][] events =
            {{"A", "B", "c", null}, {null, null, null, null}, {"a", "b", "c", null, null}};
        String[] completedEventsActual = {"ev1", "ev2", "ev3", "ev4", "ev5", "ev6"};
        String[] completedEventsExpected = {"ev1", "ev2", "ev3", "ev4", "ev5", "ev6"};
        int completedEventsCountExpected = 6;
        int completedEventsCountActual =
            EventManager.markEventAsComplete(1, 2, events, completedEventsActual, 6);

        if (!Arrays.deepEquals(completedEventsActual, completedEventsExpected)) {
          System.out
              .println("Error marking event complete, arrays are not the same in situation 2.");
          System.out.println("Expected: " + Arrays.deepToString(completedEventsExpected));
          System.out.println("Actual: " + Arrays.deepToString(completedEventsActual));
          return false;
        }

        if (completedEventsCountExpected != completedEventsCountActual) {
          System.out
              .println("Error marking event complete, arrays are not the same in situation 2,");
          System.out.println("Expected: " + completedEventsCountExpected);
          System.out.println("Actual: " + completedEventsCountActual);
          return false;
        }
      }
    }

    return true; // all tests pass
  }

  /**
   * Ensures the correctness of the EventManager.getAllEvents() method
   *
   * @return true if the tester verifies a correct functionality and false if at least one bug is
   *         detected
   */
  public static boolean getAllEventsTester() {

    // Scenario 1: Fed a full 2-D array with every day full.
    {
      String[][] fullCalendar = {{"A", "B", "C", "D", "E"}, {"A", "B", "C", "D", "E"},
          {"A", "B", "C", "D", "E"}, {"A", "B", "C", "D", "E"}};

      String expected =
          "Events for Day 1:\nA\nB\nC\nD\nE\n" + "Events for Day 2:\nA\nB\nC\nD\nE\n"
              + "Events for Day 3:\nA\nB\nC\nD\nE\n" + "Events for Day 4:\nA\nB\nC\nD\nE\n";
      String actual = EventManager.getAllEvents(fullCalendar);

      if (!expected.equals(actual)) {
        System.out
            .println("Error getting all events, expected: \n" + expected + "\nactual:\n" + actual);
        return false;
      }
    }

    // Scenario 2: Fed a partially full 2-D array and outputs correctly.
    {
      String[][] partiallyFullCalendar = {{"A", "B", "C", "D", null}, {"A", "B", "C", null, null},
          {null, null, null, null, null}, {"A", "B", null, null, null}};

      String expected = "Events for Day 1:\nA\nB\nC\nD\n" + "Events for Day 2:\nA\nB\nC\n"
          + "Events for Day 4:\nA\nB\n";
      String actual = EventManager.getAllEvents(partiallyFullCalendar);

      if (!expected.equals(actual)) {
        System.out.println("Error getting all events, expected: " + actual + "actual:" + actual);
        return false;
      }
    }

    // Scenario 3: Fed an empty 2-D array and returns the correctly formatted schedule.
    {
      String[][] emptyCalendar = {{null, null, null, null}, {null, null, null, null},
          {null, null, null, null}, {null, null, null, null}};

      String expected = "";
      String actual = EventManager.getAllEvents(emptyCalendar);

      if (!expected.equals(actual)) {
        System.out.println("Error getting all events, expected: " + actual + "actual:" + actual);
        return false;
      }
    }
    return true; // No bugs found in method
  }


  /**
   * Main method to run this tester class.
   *
   * @param args list of input arguments if any
   */
  public static void main(String[] args) {
    System.out.println("-----------------------------------------------------------");
    System.out
        .println("addToCompactArrayTester: " + (addToCompactArrayTester() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out
        .println("sizeCompactArrayTester: " + (sizeCompactArrayTester() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println("removeFromCompactArrayAtIndexOutOfBoundsTester: "
        + (removeFromCompactArrayAtIndexOutOfBoundsTester() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println("removeFromCompactArrayAtIndexTester: "
        + (removeFromCompactArrayAtIndexTester() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println("appendElementTester: " + (appendElementTester() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println("deleteEventTester: " + (deleteEventTester() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println("addEventTester: " + (addEventTester() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println(
        "markEventAsCompleteTester: " + (markEventAsCompleteTester() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println("getAllEventsTester: " + (getAllEventsTester() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
  }

}
