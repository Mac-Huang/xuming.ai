//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: Print Manager
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
// - https://www.geeksforgeeks.org/queue-interface-java/
//
///////////////////////////////////////////////////////////////////////////////

import java.util.NoSuchElementException;
import java.util.Arrays;

/**
 * Tester class for testing the functionality of the PrintJobQueue, PrintJobStack, and PrintManager
 * classes.
 */
public class PrintManagerTester {
  // TODO implement each of the tester methods

  /**
   * Test the behavior of adding one or more elements to a PrintJobStack.
   *
   * This tester ensures the correctness of PrintJobStack push, peek, isEmpty, size, and contains
   * operations.
   *
   * @return true if elements are correctly added to the stack, false otherwise
   */
  public static boolean testStackPushPeekIsEmptySizeContains() {
    PrintJobStack testStack = new PrintJobStack();

    // Make sure testStack is initialized correctly
    if (testStack.size() != 0 || !testStack.isEmpty() || testStack.peek() != null
        || testStack.pop() != null) {
      return false;
    }

    PrintJob newJob1 = new PrintJob("Printing1", 7);
    PrintJob newJob2 = new PrintJob("Printing2", 78);
    testStack.push(newJob1);

    if (testStack.size() != 1 || testStack.isEmpty() || !testStack.peek().equals(newJob1)) {
      return false;
    }

    if (!testStack.contains(newJob1)) {
      return false;
    }

    testStack.push(newJob2);
    if (testStack.size() != 2 || testStack.isEmpty() || !testStack.peek().equals(newJob2)) {
      return false;
    }

    if (!testStack.contains(newJob2)) {
      return false;
    }

    return true; // all tests pass
  }

  /**
   * Test the behavior of removing one or more elements from the stack (PrintJobStack.pop)
   *
   * @return true if elements are correctly removed from the stack, false otherwise
   */
  public static boolean testStackPop() {
    PrintJobStack stack = new PrintJobStack();
    PrintJob pj1 = new PrintJob("BottomPrint", 5);
    PrintJob pj2 = new PrintJob("MiddlePrint", 90);
    PrintJob pj3 = new PrintJob("TopPrint", 8);

    stack.push(pj1);
    stack.push(pj2);
    stack.push(pj3);

    PrintJob justRemoved = stack.pop();
    if (!justRemoved.equals(pj3)) {
      return false;
    }

    if (stack.size() != 2 || stack.isEmpty() || !stack.peek().equals(pj2)) {
      return false;
    }

    return true; // default return statement
  }

  /**
   * Test the behavior of getting the list of elements in the stack (PrintJobStack.getList).
   *
   * @return true if this tester verifies a correct functionality, false otherwise.
   */
  public static boolean testGetListStack() {
    PrintJobStack stack = new PrintJobStack();
    PrintJob pj1 = new PrintJob("BottomPrint", 5);
    PrintJob pj2 = new PrintJob("MiddlePrint", 90);
    PrintJob pj3 = new PrintJob("TopPrint", 8);

    stack.push(pj1);
    stack.push(pj2);
    stack.push(pj3);

    PrintJob[] array = stack.getList();

    if (array.length != 3 || !array[0].equals(pj3) || !array[1].equals(pj2)
        || !array[2].equals(pj1)) {
      return false;
    }
    return true; // default return statement
  }


  /**
   * Test the behavior of adding one or more elements to the queue (PrintJobQueue.enqueue).
   *
   * @return true if elements are correctly added to the queue, false otherwise
   */
  public static boolean testQueueEnqueue() {
    // Adding one element to an empty list
    PrintJobQueue queue = new PrintJobQueue();

    PrintJob pj1 = new PrintJob("FirstPrint", 8);
    PrintJob pj2 = new PrintJob("SecondPrint", 89);

    // Make sure queue is intialized correctly
    if (!queue.isEmpty() || queue.size() != 0 || queue.contains(pj1)) {
      return false;
    }

    queue.enqueue(pj1);

    if (queue.isEmpty() || queue.size() != 1 || !queue.contains(pj1) || queue.contains(pj2)
        || !queue.peek().equals(pj1)) {
      return false;
    }

    // Adding one element to a non-empty list

    queue.enqueue(pj2);

    if (queue.isEmpty() || queue.size() != 2 || !queue.contains(pj1) || !queue.contains(pj2)
        || !queue.peek().equals(pj1)) {
      return false;
    }

    return true; // all tests pass
  }

  /**
   * Test the behavior of PrintJobQueue isEmpty, peek, size, and contains when considering an empty
   * and a non-empty queue.
   *
   * @return true if this tester verifies a correct functionality, false otherwise
   */
  public static boolean testQueueIsEmptyPeekSizeContains() {
    {// considering an empty queue
      PrintJobQueue queue = new PrintJobQueue();

      if (!queue.isEmpty() || queue.size() != 0 || queue.contains(new PrintJob("asdf", 4))) {
        return false;
      }

      try {
        queue.peek();
        return false;
      } catch (NoSuchElementException e) {

      }
    }

    {// considering a non-empty queue
      PrintJobQueue queue = new PrintJobQueue();
      PrintJob pj1 = new PrintJob("FirstPrint", 8);
      PrintJob pj2 = new PrintJob("SecondPrint", 89);

      queue.enqueue(pj1);
      queue.enqueue(pj2);

      if (queue.isEmpty() || queue.size() != 2 || !queue.contains(pj1) || !queue.contains(pj2)) {
        return false;
      }

      try {
        if (!queue.peek().equals(pj1)) {
          return false;
        }
      } catch (NoSuchElementException e) {
        return false;
      }
    }

    return true;
  }

  /**
   * Test the behavior of removing one or more elements from the queue. Consider the case of
   * dequeuing from (1) an empty queue, (2) a queue that contains only one element, (3) a queue that
   * contains multiple elements.
   *
   * @return true if elements are correctly removed from the queue, false otherwise
   */
  public static boolean testQueueRemove() {
    {// Trying to dequeue from an empty list
      PrintJobQueue queue = new PrintJobQueue();

      try {
        queue.dequeue();
        return false;
      } catch (NoSuchElementException e) {

      }

      if (queue.size() != 0) {
        return false;
      }
    }

    {// Trying to dequeue from a queue with one element
      PrintJob pj1 = new PrintJob("FirstPrint", 8);

      PrintJobQueue queue = new PrintJobQueue();
      queue.enqueue(pj1);

      PrintJob removed;
      try {
        removed = queue.dequeue();
      } catch (NoSuchElementException e) {
        return false;
      }

      if (!removed.equals(pj1) || queue.size() != 0 || queue.contains(pj1)) {
        return false;
      }
    }

    {// Trying to dequeue from a queue with multiple elements
      PrintJob pj1 = new PrintJob("FirstPrint", 8);
      PrintJob pj2 = new PrintJob("SecondPrint", 89);
      PrintJob pj3 = new PrintJob("ThirdPrint", 1);
      PrintJob pj4 = new PrintJob("FourthPrint", 4221);

      PrintJobQueue queue = new PrintJobQueue();
      queue.enqueue(pj1);
      queue.enqueue(pj2);
      queue.enqueue(pj3);
      queue.enqueue(pj4);

      PrintJob removed;
      try {
        removed = queue.dequeue();
      } catch (NoSuchElementException e) {
        return false;
      }

      if (!removed.equals(pj1) || queue.size() != 3 || queue.contains(pj1)) {
        return false;
      }
    }

    return true; // tests pass
  }

  /**
   * Test the behavior of getting the list of elements in the queue (PrintJobQueue.getList).
   *
   * @return true if this tester verifies a correct functionality, false otherwise.
   */
  public static boolean testGetListQueue() {
    // Setting up queue, expected, and actual arrays
    PrintJob pj1 = new PrintJob("FirstPrint", 8);
    PrintJob pj2 = new PrintJob("SecondPrint", 89);
    PrintJob pj3 = new PrintJob("ThirdPrint", 1);
    PrintJob pj4 = new PrintJob("FourthPrint", 4221);

    PrintJobQueue queue = new PrintJobQueue();
    queue.enqueue(pj1);
    queue.enqueue(pj2);
    queue.enqueue(pj3);
    queue.enqueue(pj4);

    PrintJob[] expected = new PrintJob[4];
    expected[0] = pj1;
    expected[1] = pj2;
    expected[2] = pj3;
    expected[3] = pj4;

    PrintJob[] actual = queue.getList();

    if (actual.length != 4)
      return false;

    // This works because only need PrintJobs in the arrays to be deeply equal
    if (!Arrays.deepEquals(expected, actual))
      return false;

    return true; // tests pass
  }


  /**
   * Test the submission of one or more new print jobs to the print queue.
   *
   * This tester verifies the correctness of PrintManager submitJob, getJobCount, containsJob, and
   * viewPendingJobs operations.
   *
   * @return true if this tester verifies a correct functionality, false otherwise.
   */
  public static boolean testSubmitJobGetJobCountContainsJobViewPendingJobs() {
    PrintJob pj1 = new PrintJob("FirstPrint", 8);
    PrintJob pj2 = new PrintJob("SecondPrint", 89);

    PrintManager manager = new PrintManager();

    try {
      manager.containsJob(null);
      return false;
    } catch (IllegalArgumentException e) {

    }

    // Make sure empty viewPending is correct
    String actual = manager.viewPendingJobs();
    String expected = "";

    if (!actual.equals(expected))
      return false;

    if (manager.getJobCount() != 0)
      return false;

    if (!manager.submitJob(pj1))
      return false;
    if (manager.submitJob(pj1) || manager.getJobCount() != 1)
      return false;

    if (!manager.submitJob(pj2) || manager.getJobCount() != 2)
      return false;
    if (!manager.containsJob(pj1) || !manager.containsJob(pj2))
      return false;

    // Make sure a full view pending is correct
    actual = manager.viewPendingJobs();
    expected = "FirstPrint: 8 pages\nSecondPrint: 89 pages";

    if (!actual.equals(expected))
      return false;



    return true; // all tests pass
  }


  /**
   * Test processing and printing the next job in the queue.
   *
   * @return true if the job is successfully printed and added to the history, false otherwise.
   */
  public static boolean testPrintNextJobViewCompletedJobs() {
    PrintJob pj1 = new PrintJob("FirstPrint", 8);
    PrintJob pj2 = new PrintJob("SecondPrint", 89);

    PrintManager manager = new PrintManager();

    // Testing empty view completed jobs
    String actual = manager.viewCompletedJobs();
    String expected = "";

    if (!actual.equals(expected))
      return false;

    manager.submitJob(pj1);
    manager.submitJob(pj2);

    if (!manager.printNextJob().equals(pj1))
      return false;

    actual = manager.viewCompletedJobs();
    expected = "FirstPrint: 8 pages";
    if (!actual.equals(expected) || manager.getJobCount() != 1)
      return false;

    if (!manager.printNextJob().equals(pj2))
      return false;
    if (manager.getJobCount() != 0)
      return false;

    actual = manager.viewCompletedJobs();
    expected = "SecondPrint: 89 pages\nFirstPrint: 8 pages";
    if (!actual.equals(expected))
      return false;

    return true; // tests pass
  }

  /**
   * Test reprinting the last completed job for a given document type.
   *
   * @return true if the last job is successfully moved back to the print queue, false otherwise.
   */
  public static boolean testReprintLastJob() {
    PrintJob pj1 = new PrintJob("FirstPrint", 8);
    PrintJob pj2 = new PrintJob("SecondPrint", 89);

    PrintManager manager = new PrintManager();

    try {
      manager.reprintLastJob();
      return false;
    } catch (NoSuchElementException e) {

    }

    manager.submitJob(pj1);
    manager.submitJob(pj2);

    if (manager.getJobCount() != 2)
      return false;
    manager.printNextJob();
    if (manager.getJobCount() != 1)
      return false;
    manager.printNextJob();

    manager.reprintLastJob();
    if (manager.getJobCount() != 1 || !manager.containsJob(pj2))
      return false;

    return true; // tests pass
  }


  /**
   * Test clearing all pending print jobs from the queue.
   *
   * @return true if the print queue is empty after reset, false otherwise.
   */
  public static boolean testResetPrinting() {
    // Test Case 1: No pending print job (empty queue)
    {
      PrintJob pj1 = new PrintJob("FirstPrint", 8);
      PrintManager manager = new PrintManager();
      manager.submitJob(pj1);
      manager.printNextJob();
      if (manager.getJobCount() != 0)
        return false;

      manager.resetPrinting();
      if (manager.getJobCount() != 0 || manager.containsJob(pj1)) {
        return false;
      }
    }

    // Test Case 2: clear a non-empty pending print job queue
    {
      PrintJob pj1 = new PrintJob("FirstPrint", 8);
      PrintJob pj2 = new PrintJob("SecondPrint", 89);

      PrintManager manager = new PrintManager();
      manager.submitJob(pj1);
      manager.submitJob(pj2);

      manager.resetPrinting();
      if (manager.getJobCount() != 0 || manager.containsJob(pj2) || manager.containsJob(pj1)) {
        return false;
      }
    }

    return true; // default return statement
  }

  /**
   * Test clearing the print history for a specific document type. 
   *
   * @return true if the history for the given type is successfully cleared, false otherwise.
   */
  public static boolean testClearPrintHistory() {
    // Test Case 1: No print history (empty stack)
    {
      PrintManager manager = new PrintManager();
      manager.clearPrintHistory();
      if (!manager.viewCompletedJobs().equals("")) {
        return false;
      }
    }
    // Test Case 2: clear a non-empty print history stack
    {
      PrintJob pj1 = new PrintJob("FirstPrint", 8);
      PrintJob pj2 = new PrintJob("SecondPrint", 89);

      PrintManager manager = new PrintManager();
      manager.submitJob(pj1);
      manager.submitJob(pj2);
      manager.printNextJob();
      manager.printNextJob();
      
      manager.clearPrintHistory();
      
      if (!manager.viewCompletedJobs().equals("")) {
        return false;
      }
    }
    return true; // default return statement
  }


  /**
   * Main method to run the tester methods
   *
   * @param args list of input arguments if any
   */
  public static void main(String[] args) {
    // Running and printing results for all the tests

    boolean test1 = testStackPushPeekIsEmptySizeContains();
    System.out.println("testStackAdd: " + (test1 ? "PASS" : "FAIL"));

    boolean test2 = testStackPop();
    System.out.println("testStackRemove: " + (test2 ? "PASS" : "FAIL"));

    boolean test3 = testGetListStack();
    System.out.println("testGetListStack: " + (test3 ? "PASS" : "FAIL"));

    boolean test4 = testQueueEnqueue();
    System.out.println("testQueueEnqueue: " + (test4 ? "PASS" : "FAIL"));

    boolean test5 = testQueueIsEmptyPeekSizeContains();
    System.out.println("testQueueIsEmptyPeekSizeContains: " + (test5 ? "PASS" : "FAIL"));

    boolean test6 = testQueueRemove();
    System.out.println("testQueueRemove: " + (test6 ? "PASS" : "FAIL"));

    boolean test7 = testGetListQueue();
    System.out.println("testGetListQueue: " + (test7 ? "PASS" : "FAIL"));

    boolean test8 = testSubmitJobGetJobCountContainsJobViewPendingJobs();
    System.out.println(
        "testSubmitJobGetJobCountContainsJobViewPendingJobs: " + (test8 ? "PASS" : "FAIL"));

    boolean test9 = testPrintNextJobViewCompletedJobs();
    System.out.println("testPrintNextJobViewCompletedJobs: " + (test9 ? "PASS" : "FAIL"));

    boolean test10 = testReprintLastJob();
    System.out.println("testReprintLastJob: " + (test10 ? "PASS" : "FAIL"));

    boolean test11 = testResetPrinting();
    System.out.println("testResetPrinting: " + (test11 ? "PASS" : "FAIL"));

    boolean test12 = testClearPrintHistory();
    System.out.println("testClearHistory: " + (test12 ? "PASS" : "FAIL"));

    System.out.println("ALL TESTS: " + (test1 && test2 && test3 && test4 && test5 && test6 && test7
        && test8 && test9 && test10 && test11 && test12 ? "PASS" : "FAIL"));
  }
}
