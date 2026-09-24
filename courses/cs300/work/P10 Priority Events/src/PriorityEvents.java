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

// TODO File header

import java.util.Arrays;
import java.util.NoSuchElementException;

/**
 * This class implements a single priority queue of events for the CS300 P10 program Priority Events
 * using a min-heap structure maintained in an array
 */
public class PriorityEvents {

  /**
   * Indicates whether the events in this priority queue should be arranged in heap order with
   * respect to their timestamps (using Event.compareTo()) or alphabetically by their descriptions
   */
  private static boolean sortAlphabetically = false;

  /**
   * Reports whether this priority queue is maintained according to Event description or timestamp
   * 
   * @return true if this PriorityQueue is ordered by description, false if ordered by timestamp
   */
  public static boolean isSortedAlphabetically() {
    return sortAlphabetically;
  }

  /**
   * Sets all priority queue to be sorted alphabetically
   */
  public static void sortAlphabetically() {
    sortAlphabetically = true;
  }

  /**
   * Setsd all priority queues to be sorted chronologically (Not alphabetically)
   */
  public static void sortChronologically() {
    sortAlphabetically = false;
  }

  /**
   * An array which contains all of the completed Events that have passed through this priority
   * queue; this array has double the capacity of heapData.
   */
  private Event[] completed;

  /**
   * The number of events currently in the completed array
   */
  private int completedSize;

  /**
   * An array which maintains the heap structure for our priority queue; data in this array MUST be
   * maintained in valid heap order with respect to either Event comparisons or description, per the
   * value of the sortAlphabetically field of this object
   */
  private Event[] heapData;

  /**
   * The number of events currently stored in the heapData array
   */
  private int size;

  /**
   * Create a new priority queue of events, initializing all data fields accordingly
   * 
   * @param capacity the capacity of the queue to be created; must be > 0
   * @throws IllegalArgumentException if a capacity of 0 or less is provided
   */
  public PriorityEvents(int capacity) throws IllegalArgumentException {
    if (capacity <= 0) {
      throw new IllegalArgumentException(
          "Error Creating Priority Queue: created queue with capacity " + capacity);
    }

    this.heapData = new Event[capacity];
    this.size = 0;
    this.completed = new Event[capacity * 2];
    this.completedSize = 0;
  }

  /**
   * Creates a valid min-heap from the provided oversize array of Events
   * 
   * @param events the Events to be prioritized (Heapified)
   * @param size   the number of Events in the provided events array, assume valid
   * @throws IllegalArgumentException if any Event in events has already been completed
   */
  public PriorityEvents(Event[] events, int size) throws IllegalArgumentException {
    // dectect if there is a complete event
    if (detectCompleteEventHelper(events)) {
      throw new IllegalArgumentException("Event has already been completed: ");

    }

    this.heapData = Arrays.copyOf(events, size);
    this.size = size;
    
    // Build max heap starting at largest parent node
    for (int i = size - 1; i >= 0; i--) {
      percolateDown(i);

    }

    this.completed = new Event[heapData.length * 2];
    this.completedSize = 0;
  }

  /**
   * Private helper method to take an array of Events and detect if any of them have been completed.
   * 
   * @param events the array of events to detect a completed event
   * @return true if a completed event was detected, false if all events are not completed
   */
  private boolean detectCompleteEventHelper(Event[] events) {

    for (Event ev : events) {
      if (ev != null && ev.isComplete()) {
        return true;
      }
    }

    return false;
  }

  /**
   * Helper method; MUST BE IMPLEMENTED RECURSIVELY
   * 
   * Percolates the value at index i of the heapData array toward index 0 according to min-heap
   * protocols, comparing either Event timestamps or descriptions depending on the value of the
   * sortAlphabetically field
   * 
   * Note: This method is closely related to the learning objectives of the assignment, and so we'll
   * pay special attention to it during manual grading. Be sure to leave comments explaining each
   * algorithmic step you use!
   * 
   * @param i the index of the Event in heapData to be percolated
   */
  protected void percolateUp(int i) {
    // CITE: Helped me understand the percolate up method -
    // https://learn.zybooks.com/zybook/WISCCOMPSCI300Spring2025/chapter/12/section/3

    // i is already at the root of the heap
    if (i <= 0) {
      return;
    }

    // Getting parent data
    int parentIndex = (i - 1) / 2;
    Event currEvent = heapData[i];
    Event parentEvent = heapData[parentIndex];


    // Need to know which sorting is being used
    if (isSortedAlphabetically()) {

      // if currEvent description is "larger" or equal do nothing
      if (currEvent.getDescription().compareTo(parentEvent.getDescription()) >= 0) {
        return; // No swaps needed
      } else {
        // Swap parent and child
        heapData[i] = parentEvent;
        heapData[parentIndex] = currEvent;

        // Continue Recursing to the top
        percolateUp(parentIndex);
      }

    } else {

      // if currEvent is larger or equal, do nothing
      if (currEvent.compareTo(parentEvent) >= 0) {
        return; // No swaps needed
      } else {
        // Swap parent and child
        heapData[i] = parentEvent;
        heapData[parentIndex] = currEvent;

        // Continue Recursing to the top
        percolateUp(parentIndex);
      }
    }
  }

  /**
   * Helper method; MUST BE IMPLEMENTED RECURSIVELY
   * 
   * Percolates the value at index i of the heapData array away from index 0 according to min-heap
   * protocols, comparing either Event timestamps or descriptions depending on the value of the
   * sortAlphabetically field
   * 
   * Note: This method is closely related to the learning objectives of the assignment, and so we'll
   * pay special attention to it during manual grading. Be sure to leave comments explaining each
   * algorithmic step you use!
   * 
   * @param i the index of the Event in heapData to be percolated
   */
  protected void percolateDown(int i) {
    // CITE: Helped me understand the percolate down method -
    // https://learn.zybooks.com/zybook/WISCCOMPSCI300Spring2025/chapter/12/section/3

    // i is invalid or is null
    if (i >= this.heapData.length || this.heapData[i] == null) {
      return;
    }

    int childIndexLeft = (2 * i) + 1;
    int childIndexRight = (2 * i) + 2;
    Event currEvent = heapData[i];

    // Base Case:
    // The would-be child index doesn't fit in the current heapData array; curr node is a leaf
    if (childIndexLeft >= this.size) {
      return;
    }

    // assume left is smaller
    int minChildIndex = childIndexLeft;
    Event minChild = heapData[minChildIndex];

    // Check if there is a place for a right child, then if it is smaller than the left
    if (childIndexRight < this.size) {

      boolean rightIsSmaller;

      // Check sorting type
      if (isSortedAlphabetically()) {

        rightIsSmaller = heapData[childIndexLeft].getDescription()
            .compareTo(heapData[childIndexRight].getDescription()) > 0;

      } else {

        rightIsSmaller = heapData[childIndexLeft].compareTo(heapData[childIndexRight]) > 0;
      }

      // Only need to swap if the right ends up being smaller
      if (rightIsSmaller) {
        minChildIndex = childIndexRight;
        minChild = heapData[childIndexRight];
      }
    }

    // Now that we've found out which child is the smallest, we can percolate down the correct way
    boolean shouldSwap;

    // Alphabetical or not, then assign shouldSwap
    if (isSortedAlphabetically()) {

      shouldSwap = currEvent.getDescription().compareTo(minChild.getDescription()) > 0;
    } else {
      shouldSwap = currEvent.compareTo(minChild) > 0;
    }


    // Finally, if needed make the swap and recurse
    if (shouldSwap) {
      heapData[i] = minChild;
      heapData[minChildIndex] = currEvent;
      percolateDown(minChildIndex);
    }


  }

  /**
   * For Testing purposes, returns a deep copy of the completed events array WITHOUT clearing
   * 
   * @return a DEEP COPY of the contents of the completed array
   */
  protected Event[] getCompletedEvents() {
    // DEEP Copy Events
    Event[] deepComplete = Arrays.copyOf(completed, completed.length);

    return deepComplete;
  }

  /**
   * For testing purposes; accesses a deep copy of the heapData array. It is not necessary to create
   * deep copies of the Events contained in that array.
   * 
   * @return a deep copy of the heapData array
   */
  protected Event[] getHeapData() {
    // DEEP Copy Events
    Event[] deepHeap = Arrays.copyOf(heapData, heapData.length);

    return deepHeap;
  }

  /**
   * Reports whether theis priority queue currently contains any Events, not counting those in the
   * completed array
   * 
   * @return true if this priority queue contains no events false otherwise
   */
  public boolean isEmpty() {
    return size == 0;
  }

  /**
   * Accesses the number of events currently in this priority queue, not counting those in the
   * completed array
   * 
   * @return the number of Events in this priority queue
   */
  public int size() {
    return size;
  }

  /**
   * Accesses the number of events in the completed array
   * 
   * @return the number of Events in the completed array
   */
  public int numCompleted() {
    return completedSize;
  }

  /**
   * Returns a deep copy of the completed array, and empties out the array.
   * 
   * @return deep copy of the completed array before clearing it out
   */
  public Event[] clearCompletedEvents() {
    // Copy Events
    Event[] deepComplete = Arrays.copyOf(completed, completedSize);

    // Clear current completed events
    completed = new Event[heapData.length * 2];

    return deepComplete;
  }

  /**
   * Accessses the next (according to priority) event without removing it from queue
   * 
   * @return a reference to the next(upcoming or alphabetical) event in the queue
   * @throws NoSuchElementException if the queue is currently empty
   */
  public Event peekNextEvent() throws NoSuchElementException {
    if (size <= 0) {
      throw new NoSuchElementException("Priority Queue currently empty");
    }

    return heapData[0];
  }

  /**
   * Inserts a new Event into the priority queue in the correct location in O(log N) time -> MUST
   * call one of the percolate helper methods
   * 
   * @param e the new Event to be added
   * @throws IllegalStateException    if the queue is full
   * @throws IllegalArgumentException if the event is null or the Event is completed
   */
  public void addEvent(Event e) throws IllegalStateException, IllegalArgumentException {

    // See if exception needs to be thrown
    if (this.heapData.length == this.size) {
      throw new IllegalStateException("Error, queue currently full");
    }

    if (e == null || e.isComplete()) {
      throw new IllegalArgumentException("Error, event to add is either null or complete");
    }

    // Add event, percolate, and increment size
    heapData[size] = e;
    percolateUp(size);
    size++;
  }

  /**
   * Removes the next (according to priority) Event from the priority queue, marks it as complete,
   * and appends it to the completed array. -> MUST call one of the percolate helper methods
   * 
   * @throws IllegalStateException if the queue is empty or the completed array is full
   */
  public void completeEvent() throws IllegalStateException {
    // Check for exceptions
    if (size == 0 || completed.length == completedSize) {
      throw new IllegalStateException("Queue empty or completed queue is full");
    }

    // Mark root complete, and swap it with the current last element in the heap
    heapData[0].markAsComplete();
    completed[completedSize] = heapData[0];

    heapData[0] = heapData[size - 1];
    heapData[size - 1] = null;

    // Update sizes
    this.size--;
    this.completedSize++;

    // Percolate down the root to keep the min-heap property
    percolateDown(0);
  }

  /**
   * Required helper method for toString, which creates a deep copy of the current queue
   * 
   * @return a new PriorityEvents Queue with a deep copy of the heapData and completed arrays and
   *         thier corresponding sizes
   */
  protected PriorityEvents deepCopy() {
    PriorityEvents deepCopy = new PriorityEvents(this.size);

    // adds all completed events in the current order to the new PriorityEvents object
    for (Event ev : this.completed) {
      if (ev != null) {
        deepCopy.addEvent(ev);
        deepCopy.completeEvent();
      }
    }

    // then adds all of the heapData events in the same order to the PriorityEvents deep copy
    for (Event ev : heapData) {
      if (ev != null) {
        deepCopy.addEvent(ev);
      }
    }

    return deepCopy;
  }

  /**
   * Creates a String representation of all events in the queue in sorted order, one on each line
   * (no trailing newline). Must NOT modify the queue - use a deep copy of the queue instead.
   * 
   * @return a String representation of all events in sorted order
   */
  @Override
  public String toString() {
    PriorityEvents deepCopy = this.deepCopy();
    String string = "";

    while (!deepCopy.isEmpty()) {
      string = string + deepCopy.peekNextEvent().toString() + "\n";
      deepCopy.completeEvent();
    }


    return string.substring(0, string.length() - 2);
  }
}


