//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: Priority Event Calendar
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
// - https://learn.zybooks.com/zybook/WISCCOMPSCI300Spring2025/chapter/12/section/3
//
///////////////////////////////////////////////////////////////////////////////

import java.util.Arrays;
import java.util.NoSuchElementException;

/**
 * Tester class for the CS300 P10 Priority Events project. You may add tester methods to this class
 * but they must be declared private; the existing public tester methods may use the output of these
 * private testers to help determine their output (as with testAddEvent or testCompleteEvent).
 */
public class PriorityEventsTester {

  /**
   * This method runs all sub-testers related to testing adding an Event to the priority queue. You
   * may wish to add additional output for clarity, or additional private tester methods related to
   * adding Events.
   * 
   * @return true if all tests relating to adding an Event to a priority queue pass; false otherwise
   */
  public static boolean testAddEvent() {
    boolean testAdd = true;
    testAdd &= testAddEventChronological();
    testAdd &= testAddEventAlphabetical();
    return testAdd;
  }

  /**
   * We will attempt to create a PriorityEvents which adds events correctly, comparing with
   * getHeapData() method. This method will test the chonological ordering and is used to run dthe
   * testAddEvent() method.
   * 
   * @return true if all tests pass, false otherwise.
   */
  private static boolean testAddEventChronological() {
    {// Scenario 1: Queue already full
      PriorityEvents testEvents = new PriorityEvents(4); // Capacity 4
      PriorityEvents.sortChronologically();

      Event ev1 = new Event("Event 1", 3, 3, 3);
      Event ev2 = new Event("Event 2", 4, 3, 3);
      Event ev3 = new Event("Event 3", 5, 3, 3);
      Event ev4 = new Event("Event 4", 6, 3, 3);
      Event ev5 = new Event("Event 5", 7, 3, 3);
      testEvents.addEvent(ev1);
      testEvents.addEvent(ev2);
      testEvents.addEvent(ev3);
      testEvents.addEvent(ev4);

      try {
        testEvents.addEvent(ev5);
        return false;
      } catch (IllegalStateException e) {
        // Correct implementation
      }
    }

    {// Scenario 2: Event is null and if an event is completed
      PriorityEvents testEvents = new PriorityEvents(4); // Capacity 4
      PriorityEvents.sortChronologically();

      Event completedEvent = new Event("Event 1", 3, 3, 3);
      completedEvent.markAsComplete(); //
      Event nullEvent = null;

      // Add completed Event
      try {
        testEvents.addEvent(completedEvent);
        return false;
      } catch (IllegalArgumentException e) {
        // Correct implementation
      }

      // Add null Event
      try {
        testEvents.addEvent(nullEvent);
        return false;
      } catch (IllegalArgumentException e) {
        // Correct implementation
      }
    }

    {// Scenario 3: adding multiple events which are placed correctly in queue
      PriorityEvents testEvents = new PriorityEvents(7); // Capacity 7
      PriorityEvents.sortChronologically();

      Event ev1 = new Event("Event 1", 3, 3, 3);
      Event ev2 = new Event("Event 2", 4, 3, 3);
      Event ev3 = new Event("Event 3", 5, 3, 3);
      Event ev4 = new Event("Event 4", 6, 3, 3);
      Event ev5 = new Event("Event 5", 7, 3, 3);
      Event ev6 = new Event("Event 6", 8, 3, 3);

      testEvents.addEvent(ev6);
      testEvents.addEvent(ev1);
      testEvents.addEvent(ev3);
      testEvents.addEvent(ev4);
      testEvents.addEvent(ev2);
      testEvents.addEvent(ev5);



      // Now, we must verify the min-heap property by checking parent is smaller than its children
      Event[] heapData = testEvents.getHeapData();

      if (!isValidMinHeapHelper(heapData)) {
        return false;
      }

      // Check that the array actually implemented a heap-design
      if (!heapData[5].equals(ev5)) {
        return false;
      }

    }

    return true;
  }

  /**
   * We will attempt to create a PriorityEvents which adds events correctly, comparing with
   * getHeapData() method. This method will test the alphabetical ordering and is used to run dthe
   * testAddEvent() method.
   * 
   * @return true if all tests pass, false otherwise.
   */
  private static boolean testAddEventAlphabetical() {
    {// Scenario 1: Queue already full
      PriorityEvents testEvents = new PriorityEvents(4); // Capacity 4
      PriorityEvents.sortAlphabetically();

      Event ev1 = new Event("Event 1", 3, 3, 3);
      Event ev2 = new Event("Event 2", 4, 3, 3);
      Event ev3 = new Event("Event 3", 5, 3, 3);
      Event ev4 = new Event("Event 4", 6, 3, 3);
      Event ev5 = new Event("Event 5", 7, 3, 3);
      testEvents.addEvent(ev1);
      testEvents.addEvent(ev2);
      testEvents.addEvent(ev3);
      testEvents.addEvent(ev4);

      try {
        testEvents.addEvent(ev5);
        return false;
      } catch (IllegalStateException e) {
        // Correct implementation
      }
    }

    {// Scenario 2: Event is null and if an event is completed
      PriorityEvents testEvents = new PriorityEvents(4); // Capacity 4
      PriorityEvents.sortAlphabetically();

      Event completedEvent = new Event("Event 1", 3, 3, 3);
      completedEvent.markAsComplete(); //
      Event nullEvent = null;

      // Add completed Event
      try {
        testEvents.addEvent(completedEvent);
        return false;
      } catch (IllegalArgumentException e) {
        // Correct implementation
      }

      // Add null Event
      try {
        testEvents.addEvent(nullEvent);
        return false;
      } catch (IllegalArgumentException e) {
        // Correct implementation
      }
    }

    {// Scenario 3: adding multiple events which are placed correctly in queue
      PriorityEvents testEvents = new PriorityEvents(7); // Capacity 7
      PriorityEvents.sortAlphabetically();

      Event ev1 = new Event("Event 1", 3, 3, 3);
      Event ev2 = new Event("Event 2", 4, 3, 3);
      Event ev3 = new Event("Event 3", 5, 3, 3);
      Event ev4 = new Event("Event 4", 6, 3, 3);
      Event ev5 = new Event("Event 5", 7, 3, 3);
      Event ev6 = new Event("Event 6", 8, 3, 3);

      testEvents.addEvent(ev6);
      testEvents.addEvent(ev1);
      testEvents.addEvent(ev3);
      testEvents.addEvent(ev4);
      testEvents.addEvent(ev2);
      testEvents.addEvent(ev5);

      // Now, we must verify the min-heap property by checking parent is smaller than its children
      // Must check the descriptions since we are sorting alphabetically

      Event[] heapData = testEvents.getHeapData();

      if (!isValidMinHeapHelper(heapData)) {
        return false;
      }

      // Check that the array actually implemented a heap-design

      if (!heapData[5].getDescription().equals(ev5.getDescription())) {
        return false;
      }
    }

    return true;
  }

  /**
   * This method runs all sub-testers related to testing marking an Event in the priority queue as
   * completed. You may wish to add additional output for clarity, or additional private tester
   * methods related to marking Events as completed.
   * 
   * @return true if all tests relating to removing an Event from a priority queue pass; false
   *         otherwise
   */
  public static boolean testCompleteEvent() {
    boolean testComplete = true;
    testComplete &= testCompleteEventChronological();
    testComplete &= testCompleteEventAlphabetical();
    return testComplete;
  }

  /**
   * Tests the complete event methods for both exception handling and correct implementation
   * 
   * @return true if all tests pass, false otherwise
   */
  private static boolean testCompleteEventChronological() {
    {// Scenario 1: Checking for size == 0 and full completed array exceptions
      PriorityEvents.sortChronologically();
      PriorityEvents testEvents = new PriorityEvents(2); // Completed Capacity should be 4.

      // Trying to complete an event in an empty array
      try {
        testEvents.completeEvent();
        return false;
      } catch (IllegalStateException e) {
        // Expected Result
      }

      // Trying to complete an event when completed Capacity is full
      Event ev1 = new Event("Event 1", 3, 3, 3);
      Event ev2 = new Event("Event 2", 4, 3, 3);
      Event ev3 = new Event("Event 3", 5, 3, 3);
      Event ev4 = new Event("Event 4", 6, 3, 3);
      Event ev5 = new Event("Event 5", 7, 3, 3);
      testEvents.addEvent(ev1);
      testEvents.completeEvent();
      testEvents.addEvent(ev2);
      testEvents.completeEvent();
      testEvents.addEvent(ev3);
      testEvents.completeEvent();
      testEvents.addEvent(ev4);
      testEvents.completeEvent();

      Event[] completedActual = testEvents.getCompletedEvents();

      // Making sure the events are getting put in completedEvents
      if (completedActual.length != 4) {
        return false;
      }
      // All completedActual events should be marked as completed
      for (Event ev : completedActual) {
        if (!ev.isComplete()) {
          return false;
        }
      }

      // Making sure the completed data contian all of the used events
      Event[] expected = {ev1, ev2, ev3, ev4}; // Completed array should contain no less than these
      if (!containsAllEventsHelper(completedActual, expected)) {
        return false;
      }

      testEvents.addEvent(ev5);
      try {
        testEvents.completeEvent();
        return false;
      } catch (IllegalStateException e) {
        // Expected Result
      }
    }


    {// Scenario 2: Making sure events are completed and percolatedUp correctly
      PriorityEvents.sortChronologically();
      PriorityEvents testEvents = new PriorityEvents(7); // Capacity 7

      Event ev1 = new Event("Event 1", 3, 3, 3);
      Event ev2 = new Event("Event 2", 4, 3, 3);
      Event ev3 = new Event("Event 3", 5, 3, 3);
      Event ev4 = new Event("Event 4", 6, 3, 3);
      Event ev5 = new Event("Event 5", 7, 3, 3);
      Event ev6 = new Event("Event 6", 8, 3, 3);

      testEvents.addEvent(ev6);
      testEvents.addEvent(ev1);
      testEvents.addEvent(ev3);
      testEvents.addEvent(ev4);
      testEvents.addEvent(ev2);
      testEvents.addEvent(ev5);

      // should be in a heap with ev1 at the top

      testEvents.completeEvent(); //
      // Should swap ev1 and last index, then get rid of ev1 and put it in the completed list

      Event[] expectedHeap = {ev2, ev4, ev3, ev6, ev5};
      Event[] expectedComp = {ev1};
      Event[] actualHeap = testEvents.getHeapData();
      Event[] actualComp = testEvents.getCompletedEvents();

      // Should be a valid min-heap and the top element should be the next smalles, which is ev2
      if (!isValidMinHeapHelper(actualHeap) || actualHeap[0].compareTo(ev2) != 0) {
        return false;
      }

      // Completed should have the same elements as the expected no matter the heap-building
      // implementaiton
      if (!containsAllEventsHelper(expectedHeap, actualHeap)
          || !containsAllEventsHelper(expectedComp, actualComp)) {
        return false;
      }

      if (actualHeap[1].compareTo(ev4) != 0) {
        return false;
      }
    }

    return true;
  }

  /**
   * Tests the complete event methods for both exception handling and correct implementation
   * 
   * @return true if all tests pass, false otherwise
   */
  private static boolean testCompleteEventAlphabetical() {
    {// Scenario 1: Checking for size == 0 and full completed array exceptions
      PriorityEvents.sortAlphabetically();
      PriorityEvents testEvents = new PriorityEvents(2); // Completed Capacity should be 4.

      // Trying to complete an event in an empty array
      try {
        testEvents.completeEvent();
        return false;
      } catch (IllegalStateException e) {
        // Expected Result
      }

      // Trying to complete an event when completed Capacity is full
      Event ev1 = new Event("Event 1", 3, 3, 3);
      Event ev2 = new Event("Event 2", 4, 3, 3);
      Event ev3 = new Event("Event 3", 5, 3, 3);
      Event ev4 = new Event("Event 4", 6, 3, 3);
      Event ev5 = new Event("Event 5", 7, 3, 3);
      testEvents.addEvent(ev1);
      testEvents.completeEvent();
      testEvents.addEvent(ev2);
      testEvents.completeEvent();
      testEvents.addEvent(ev3);
      testEvents.completeEvent();
      testEvents.addEvent(ev4);
      testEvents.completeEvent();

      Event[] completedActual = testEvents.getCompletedEvents();

      // Making sure the events are getting put in completedEvents
      if (completedActual.length != 4) {
        return false;
      }

      // Making sure the completed data contian all of the used events
      Event[] expected = {ev1, ev2, ev3, ev4}; // Completed array should contain no less than these
      if (!containsAllEventsHelper(completedActual, expected)) {
        return false;
      }

      testEvents.addEvent(ev5);
      try {
        testEvents.completeEvent();
        return false;
      } catch (IllegalStateException e) {
        // Expected Result
      }
    }

    {// Scenario 2: Making sure events are completed and percolatedUp correctly
      PriorityEvents.sortChronologically();
      PriorityEvents testEvents = new PriorityEvents(7); // Capacity 7

      Event ev1 = new Event("Event 1", 3, 3, 3);
      Event ev2 = new Event("Event 2", 4, 3, 3);
      Event ev3 = new Event("Event 3", 5, 3, 3);
      Event ev4 = new Event("Event 4", 6, 3, 3);
      Event ev5 = new Event("Event 5", 7, 3, 3);
      Event ev6 = new Event("Event 6", 8, 3, 3);

      testEvents.addEvent(ev6);
      testEvents.addEvent(ev1);
      testEvents.addEvent(ev3);
      testEvents.addEvent(ev4);
      testEvents.addEvent(ev2);
      testEvents.addEvent(ev5);

      // should be in a heap with ev1 at the top

      testEvents.completeEvent();
      // Should swap ev1 and last index, then get rid of ev1 and put it in the completed list

      Event[] expectedHeap = {ev2, ev4, ev3, ev6, ev5};
      Event[] expectedComp = {ev1};
      Event[] actualHeap = testEvents.getHeapData();
      Event[] actualComp = testEvents.getCompletedEvents();

      // Should be a valid min-heap and the top element should be the next smalles, which is ev2
      if (!isValidMinHeapHelper(actualHeap)
          || actualHeap[0].getDescription().compareTo(ev2.getDescription()) != 0) {
        return false;
      }

      // Completed should have the same elements as the expected no matter the heap-building
      // implementaiton
      if (!containsAllEventsHelper(expectedHeap, actualHeap)
          || !containsAllEventsHelper(expectedComp, actualComp)) {
        return false;
      }

      if (actualHeap[1].getDescription().compareTo(ev4.getDescription()) != 0) {
        return false;
      }

    }

    return true;
  }

  /**
   * Verifies the peekNextEvent() method. You may wish to break this out into smaller sub-testers.
   * 
   * @return true if all tests pass; false otherwise
   */
  public static boolean testPeek() {
    {// Scenario 1: Queue is empty, exception is thrown
      PriorityEvents testEvents = new PriorityEvents(4); // Not adding any events to this queue

      try {
        testEvents.peekNextEvent();
        return false;
      } catch (NoSuchElementException e) {

      }
    }

    {// Scenario 2: Queue is not empty and keeps same size;
      PriorityEvents testEvents = new PriorityEvents(4);
      PriorityEvents.sortChronologically();

      Event ev1 = new Event("Event 1", 3, 3, 3);
      Event ev2 = new Event("Event 2", 4, 3, 3);
      testEvents.addEvent(ev1);
      testEvents.addEvent(ev2);

      if (testEvents.size() != 2) {
        return false;
      }

      if (!testEvents.peekNextEvent().equals(ev1)) {
        return false;
      }

      if (testEvents.size() != 2) {
        return false;
      }

    }

    return true;
  }

  /**
   * Verifies the overloaded PriorityEvents constructor that creates a valid heap from an input
   * array of values. You may wish to break this out into smaller sub-testers.
   * 
   * @return true if all tests pass; false otherwise
   */
  public static boolean testHeapify() {
    {// Scenario 1: catching exception when a completed Event is tried to be added
      Event ev1 = new Event("Event 1", 3, 3, 3);
      Event ev2 = new Event("Event 2", 4, 3, 3);
      Event ev3 = new Event("Event 3", 5, 3, 3);
      Event ev4 = new Event("Event 4", 6, 3, 3);
      Event ev5 = new Event("Event 5", 7, 3, 3);

      ev3.markAsComplete();
      Event[] evArr = {ev1, ev2, ev3, ev4, ev5};
      
      try {
        PriorityEvents events = new PriorityEvents(evArr, evArr.length);
        return false;
      } catch (IllegalArgumentException e) {
        // Expected outcome
      }
    }

    {// Scenario 2: making sure a normal list is heapified
      Event ev1 = new Event("Event 1", 3, 3, 3);
      Event ev2 = new Event("Avent 2", 4, 3, 3);
      Event ev3 = new Event("Event 3", 5, 3, 3);
      Event ev4 = new Event("Event 4", 6, 3, 3);
      Event ev5 = new Event("Event 5", 7, 3, 3);
      
      Event[] evArr = {ev4, ev5, ev3, ev2, ev1}; // out of order, non min-heap
      
      // Chonological
      PriorityEvents.sortChronologically();
      PriorityEvents eventsChron = new PriorityEvents(evArr, evArr.length);
      Event[] heapActualChron = eventsChron.getHeapData();
      
      if (heapActualChron[0].compareTo(ev1) != 0) {
        return false;
      }
      
      // Alphabetical
      PriorityEvents.sortAlphabetically();
      PriorityEvents eventsAlph = new PriorityEvents(evArr, evArr.length);
      Event[] heapActualAlph = eventsAlph.getHeapData();
      
      if (heapActualAlph[0].compareTo(ev2) != 0) {
        return false;
      }
    }
    
    return true;

  }

  /**
   * Checks if an array is a valid min-heap
   * 
   * @param heapData the heap data in an array that is to be checked
   * @return false if not a valid min-heap, true otherwise
   */
  private static boolean isValidMinHeapHelper(Event[] heapData) {

    for (int i = 0; i < heapData.length - 1; ++i) {
      if (heapData[i] == null) {
        continue;
      }

      int leftChild = i * 2 + 1;
      int rightChild = leftChild + 1;

      if (leftChild < heapData.length && heapData[leftChild] != null) {
        if (heapData[i].compareTo(heapData[leftChild]) > 0) {
          return false;
        }
      }

      if (rightChild < heapData.length && heapData[rightChild] != null) {
        if (heapData[i].compareTo(heapData[rightChild]) > 0) {
          return false;
        }
      }
    }

    return true;
  }

  /**
   * Private helper method to determine if the contents of one array are the same as another array
   * regardless of order. This method doesn't count the frequency of events, just if an event is in
   * one array that it can be found in the other array. Used in testCompleteEvent() method.
   * 
   * @param a an array of Event objects
   * @param b an array of Event objects
   * @return true if array a contains the same elements of array b regardless of order, false
   *         otherwise.
   */
  private static boolean containsAllEventsHelper(Event[] a, Event[] b) {
    for (Event aEvent : a) {
      boolean foundMatch = false;

      for (Event bEvent : b) {
        if (aEvent != null && bEvent != null) {
          if (bEvent.compareTo(aEvent) == 0) {
            foundMatch = true;
            break;
          }
        }
      }

      if (!foundMatch) { // No match for event in a to any event in b
        return false;
      }

    }
    return true; // found a match for every element
  }

  public static void main(String[] args) {
    System.out.println("ADD: " + testAddEvent());
    System.out.println("COMPLETE: " + testCompleteEvent());
    System.out.println("PEEK: " + testPeek());
    System.out.println("HEAPIFY: " + testHeapify());
  }

}
