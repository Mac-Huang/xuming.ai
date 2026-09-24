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
///
import java.util.NoSuchElementException;

/**
 * A singly-linked queue that stores elements of PrintJob
 */
public class PrintJobQueue implements QueueADT<PrintJob> {

  /**
   * A reference to the last linkedNode in the queue, contains the most-recently added element.
   */
  private LinkedNode<PrintJob> back;

  /**
   * A reference to the first linkedNode in the queue, contains the least-recently added element.
   */
  private LinkedNode<PrintJob> front;

  /**
   * The number of PrintJobs currently in the queue
   */
  private int size;

  /**
   * Creates a new empty PrintJobQueue. Initializes back and front to null and size to 0;
   */
  public PrintJobQueue() {
    back = null;
    front = null;
    size = 0;
  }

  /**
   * Add a new element to the back of the queue, assumed to be non-null
   * 
   * @param value - the PrintJob to be enqueued
   */
  @Override
  public void enqueue(PrintJob value) {

    LinkedNode<PrintJob> toAdd = new LinkedNode<>(value);

    // If there is no front, front should be the newest item
    // CITE: help with process of enqueue - geeksforgeeks.org/queue-interface-java/
    if (isEmpty()) {
      front = toAdd;
      back = toAdd;
      size++;
      return;
    }

    // If we get here, the queue is not empty
    back.setNext(toAdd);
    back = toAdd;
    size++;
  }

  /**
   * Removes and returns the value added to this queue least recently
   * 
   * @return the least-recently added element
   * @throws NoSuchElementException if this queue is empty
   */
  @Override
  public PrintJob dequeue() {
    if (isEmpty()) {
      throw new NoSuchElementException();
    }

    PrintJob toRemove = front.getData();

    // only one item in the queue
    // CITE: help with process of dequeue - geeksforgeeks.org/queue-interface-java/
    if (front == back) {
      front = null;
      back = null;

    } else { // for >1 item in the queue
      front = front.getNext();
    }

    size--;
    return toRemove;
  }

  /**
   * Access the value added least-recently to this queue, without modifying the queue.
   * 
   * @return the least-recently added value
   * @throws NoSuchElementException if the queue is empty
   */
  @Override
  public PrintJob peek() {
    if (isEmpty()) {
      throw new NoSuchElementException();
    }

    return front.getData();
  }

  /**
   * Returns true if the queue is empty
   * 
   * @return true if the queue contains no elements, false otherwise.
   */
  @Override
  public boolean isEmpty() {
    return size == 0 && front == null && back == null;
  }

  /**
   * Returns the current number of elements in the queue
   * 
   * @return the number of elements in the queue
   */
  @Override
  public int size() {
    return size;
  }

  /**
   * Returns true if this queue contains a match with a specific element, false otherwise
   * 
   * @param value the value to check for
   * @return true if the queue contains the element, false otherwise
   */
  @Override
  public boolean contains(PrintJob value) {
    boolean foundElement = false;

    LinkedNode<PrintJob> currNode = front;
    while (currNode != null) {
      if (currNode.getData().equals(value)) {
        foundElement = true;
      }

      currNode = currNode.getNext();
    }

    return foundElement;
  }

  /**
   * Removes all the elements in the queue, the queue will be empty after this call returns.
   */
  @Override
  public void clear() {
    size = 0;
    front = null;
    back = null;
  }

  /**
   * Returns an array containing all elements of the queue in their current order. The front item is
   * placed at index 0 and the back is placed at index size-1.
   * 
   * @return an array of PrintJobs, fully populated from the queue in order with no null references.
   */
  public PrintJob[] getList() {
    PrintJob[] array = new PrintJob[size];

    LinkedNode<PrintJob> curr = front;
    for (int i = 0; i < size; ++i) {
      array[i] = curr.getData();

      curr = curr.getNext();
    }

    return array;
  }

  /**
   * Compares this PrintJobQueue to another PrintJobQueue defined by the head, tail, and size.
   * 
   * @param front the front node of the queue to compare against
   * @param back  the back node of the queue to compare against
   * @param size  the size of the queue to compare against
   * @return true if this queue deeply equals the queue defined by the specified inputs (front,
   *         back, size), false otherwise/
   */
  protected boolean equalsTo(LinkedNode<PrintJob> front, LinkedNode<PrintJob> back, int size) {
    if (front == null || back == null || size == 0) {
      if (front == null && back == null && size == 0 && this.isEmpty()) {
        return true;
      } else {
        return false;
      }
    }

    if (this.front.equals(front) && this.back.equals(back) && this.size == size) {
      return true;
    } else {
      return false;
    }
  }
}


