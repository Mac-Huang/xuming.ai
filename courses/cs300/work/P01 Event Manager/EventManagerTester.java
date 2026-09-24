// TODO File Header COMES HERE
// Be sure to credit the outside help section in the file header

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
   * detected
   */
  public static boolean addToCompactArrayTester() {
    // Test scenario 1: Adding to an empty array
    {
      String[] actual = new String[5];
      if (!EventManager.addToCompactArray("A", actual)) {
        System.out.println(
            "Adding to an empty array failed! " +
                "The method was expected to return true, but it returned false.");
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
        System.out.println(
            "Adding to a non-full array failed! " +
                "The method was expected to return true, but it returned false.");
        return false;
      }
      if (!EventManager.addToCompactArray("F", actual)) {
        System.out.println(
            "Adding to a non-full array failed! " +
                "The method was expected to return true, but it returned false.");
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
        System.out.println(
            "Adding to a full array failed! " +
                "The method was expected to return false, but it returned true.");
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
   * Ensures the correctness of the EventManager.sizeCompactArray() method
   *
   * @return true if the tester verifies a correct functionality and false if at least one bug is
   * detected
   */
  public static boolean sizeCompactArrayTester() {
    return false; // default return statement
  }

  /**
   * Ensures the correctness of the EventManager.removeFromCompactArrayAtIndex() method when passed
   * an index out of bounds (index < 0 OR index >= values.length)
   *
   * @return true if the tester verifies a correct functionality and false if at least one bug is
   * detected
   */
  public static boolean removeFromCompactArrayAtIndexOutOfBoundsTester() {
    return false; // default return statement
  }

  /**
   * Ensures the correctness of the EventManager.removeFromCompactArrayAtIndex() method when passed
   * a valid index
   *
   * This tester method verified the expected behavior considering at least for the following test
   * scenarios: <BR>
   *   (+) removing the element at index zero from a compact non-empty array <BR>
   *   (+) removing an element at the middle of the array <BR>
   *   (+) removing the last element in the array
   *
   * @return true if the tester verifies a correct functionality and false if at least one bug is
   * detected
   */
  public static boolean removeFromCompactArrayAtIndexTester() {
    return false; // default return statement
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
   * detected
   */
  public static boolean appendElementTester() {
    return false; // default return statement
  }

  /**
   * Ensures the correctness of the EventManager.addEvent() method
   *
   * @return true if the tester verifies a correct functionality and false if at least one bug is
   * detected
   */
  public static boolean addEventTester() {
    return false; // default return statement
  }

  /**
   * Ensures the correctness of the EventManager.deleteEvent() method
   *
   * @return true if the tester verifies a correct functionality and false if at least one bug is
   * detected
   */
  public static boolean deleteEventTester() {
    return false; // default return statement
  }

  /**
   * Ensures the correctness of the EventManager.markEventAsComplete() method
   *
   * @return true if the tester verifies a correct functionality and false if at least one bug is
   * detected
   */
  public static boolean markEventAsCompleteTester() {
    return false; // default return statement
  }

  /**
   * Ensures the correctness of the EventManager.getAllEvents() method
   *
   * @return true if the tester verifies a correct functionality and false if at least one bug is
   * detected
   */
  public static boolean getAllEventsTester() {
    return false; // default return statement
  }


  /**
   * Main method to run this tester class.
   *
   * @param args list of input arguments if any
   */
  public static void main(String[] args) {
    System.out.println("-----------------------------------------------------------");
    System.out.println(
        "addToCompactArrayTester: " + (addToCompactArrayTester() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println(
        "sizeCompactArrayTester: " + (sizeCompactArrayTester() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println("removeFromCompactArrayAtIndexOutOfBoundsTester: " + (
        removeFromCompactArrayAtIndexOutOfBoundsTester() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println("removeFromCompactArrayAtIndexTester: " + (
        removeFromCompactArrayAtIndexTester() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println("appendElementTester: " + (appendElementTester() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println("deleteEventTester: " + (deleteEventTester() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println(
        "markEventAsCompleteTester: " + (markEventAsCompleteTester() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println("getAllEventsTester: " + (getAllEventsTester() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
  }

}
