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

/**
 * Manages the printing process by maintaining a queue of print jobes and a history of printed
 * documents categorized by document type.
 */
public class PrintManager {

  /**
   * Stack of the history of printed jobs
   */
  private PrintJobStack printHistoryStack;

  /**
   * Queue for managing pending print jobs
   */
  private PrintJobQueue printQueue;

  /**
   * Constructs a new PrintManager, initializes the print queue and history stack.
   */
  public PrintManager() {
    printHistoryStack = new PrintJobStack();
    printQueue = new PrintJobQueue();
  }

  /**
   * Submits a new printjob to the pending print queue.
   * 
   * @param print the job to be printed.
   * @return true if the print job successfully submitted to the pending print queue, or false if a
   *         match with print already exists in the print queue.
   */
  public boolean submitJob(PrintJob print) {

    if (!printQueue.contains(print)) {
      printQueue.enqueue(print);
      return true;
    }

    return false; // printQueue already contains the printJob
  }

  /**
   * Returns the count of pending print jobs in the queue.
   * 
   * @return the number of pending jobs
   */
  public int getJobCount() {
    return printQueue.size();
  }

  /**
   * Processess and prints the next job in the print queue. Also, adds it to the print history stack
   * and returns the PrintJob that was printed.
   * 
   * @return the PrintJob that was printed from the queue
   * @throws NoSuchElementException if the queue is empty.
   */
  public PrintJob printNextJob() {
    PrintJob printed = printQueue.dequeue(); // Will throw exception here

    printHistoryStack.push(printed);

    return printed;
  }

  /**
   * Reprints the last job. This method retrieves the most recent PrintJob from the print history
   * stack, removes it from the history stack, and places it back in the print queue for reprinting.
   * If there is no job available for reprinting.
   * 
   * @throws NoSuchElementException if the print history stack is empty
   */
  public void reprintLastJob() {
    if (printHistoryStack.isEmpty()) {
      throw new NoSuchElementException("Print History Stack is Empty");
    }
    PrintJob reprint = printHistoryStack.pop();
    printQueue.enqueue(reprint);
  }

  /**
   * Removes all file from the pending print queue.
   */
  public void resetPrinting() {
    printQueue.clear();
  }

  /**
   * Removes all files from the history stack.
   */
  public void clearPrintHistory() {
    printHistoryStack.clear();
  }

  /**
   * Searches for a specific print job in the pending queue
   * 
   * @param print the print job to search for
   * @return true if the print queue contains a match with the argument, false otherwise.
   * @throws IllegalArgumentException if the print argument is null
   */
  public boolean containsJob(PrintJob print) {
    if (print == null) {
      throw new IllegalArgumentException("PrintJob param is null");
    }

    return printQueue.contains(print);
  }

  /**
   * Returns a string representation of all pending print jobs in the print queue. This method
   * iterates through all the list of pending print jobs in the print queue, with each job
   * represented on a separate line. The returned String does NOT contain a trailing newline.
   * 
   * @return A string representation of all the pending print jobs in the print queue, each in a
   *         separate line. If the printQueue is empty, the method returns an empty string "".
   */
  public String viewPendingJobs() {
    String pendingJobs = "";
    if (printQueue.isEmpty()) {
      return pendingJobs;
    }
    PrintJob[] pendingArray = printQueue.getList();

    for (int i = 0; i < pendingArray.length - 1; ++i) {
      pendingJobs = pendingJobs + pendingArray[i].toString() + "\n";
    }

    // Last element so no trailing newline
    pendingJobs = pendingJobs + pendingArray[pendingArray.length - 1];

    return pendingJobs;
  }

  /**
   * Returns a String representation of the history of completed print jobs. This method gets the
   * list of print jobs in the print history stack, iterates through all the print jobs, each job on
   * a separate line. The returned String does NOT contain a trailing newline.
   * 
   * @return A string representation of the history of completed print jobs.
   */
  public String viewCompletedJobs() {
    String jobHistory = "";
    if (printHistoryStack.isEmpty()) {
      return jobHistory;
    }
    PrintJob[] historyArray = printHistoryStack.getList();

    for (int i = 0; i < historyArray.length - 1; ++i) {
      jobHistory = jobHistory + historyArray[i] + "\n";
    }

    // Last element so no trailing newline
    jobHistory = jobHistory + historyArray[historyArray.length - 1];

    return jobHistory;
  }
}
