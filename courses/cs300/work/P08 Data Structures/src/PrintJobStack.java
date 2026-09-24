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

/**
 * A singly-linked stack that stores PrintJob objects
 */
public class PrintJobStack implements StackADT<PrintJob> {

  /**
   * The number of elements in the stack
   */
  private int size;

  /**
   * A reference to the linked node at the top of the stack, null when empty
   */
  private LinkedNode<PrintJob> top;

  /**
   * Creates a new empty PrintJobStack
   */
  public PrintJobStack() {
    size = 0;
    top = null;
  }

  /**
   * Checks whether the stack is empty.
   * 
   * @return true if the stack is empty, false otherwise.
   */
  @Override
  public boolean isEmpty() {
    return size == 0 && top == null;
  }

  /**
   * Adds a new PrintJob to the top of the stack. New PrintJob is assumed to be non-null
   * 
   * @param value - the PrintJob to be added to Stack
   */
  @Override
  public void push(PrintJob value) {
    // Next is already looking at the current top value
    LinkedNode<PrintJob> toPush = new LinkedNode<>(value, top);
    
    top = toPush;
    size++;
  }

  /**
   * Removes and returns the PrintJob at the top of the stack
   * 
   * @return the most-recently added PrintJob to this stack, or null if it is empty.
   */
  @Override
  public PrintJob pop() {
    if (this.top == null) {
      return null;
    }
    
    PrintJob removed = top.getData(); // save top PrintJob
    top = top.getNext(); // Move the top pointer to the next in the list
    size--; // decrement size
    return removed;
  }

  /**
   * Returns the top most item of the stack without removing it.
   * 
   * @return The most revently added PrintJob to the stack, or null if stack is empty.
   */
  @Override
  public PrintJob peek() {
    if (top == null)
      return null;

    return top.getData();
  }

  /**
   * Returns the number of elements in the stack
   */
  @Override
  public int size() {
    return size;
  }

  /**
   * Returns true if the stack contains a match with a specific element, false otherwise.
   */
  @Override
  public boolean contains(PrintJob value) {
    boolean foundItem = false;
    PrintJobStack holder = new PrintJobStack();

    LinkedNode<PrintJob> currNode = top;
    // Traverse stack while we have not found item and current list is not empty
    while (!foundItem && currNode != null) {

      PrintJob currJob = currNode.getData();

      if (currJob.equals(value)) {
        foundItem = true;
      }

      currNode = currNode.getNext();
    }

    // Put items back on original stack
    while (!holder.isEmpty()) {
      push(holder.pop());
    }

    return foundItem;
  }

  /**
   * Removes all elements from the stack. The stack will be empty after this call
   */
  @Override
  public void clear() {
    size = 0;
    top = null;
  }

  /**
   * Creates an array of all the items in the current PrintJobStack without modifying any elements.
   * The top of the stack is a 0 and the array has length equal to the stack's size.
   * 
   * @return an array of PrintJob objects, fully populated with elements from the stack in order. No
   *         null references.
   */
  public PrintJob[] getList() {
    PrintJob[] array = new PrintJob[size];

    LinkedNode<PrintJob> currNode = top;

    // Referencing all PrinJobs in array, can use .getNext() to look through entire Stack
    for (int i = 0; i < size; ++i) {
      PrintJob currJob = currNode.getData();
      array[i] = currJob;
      currNode = currNode.getNext();
    }

    return array;
  }
}
