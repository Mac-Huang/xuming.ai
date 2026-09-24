// PROVIDED FILE -- DO NOT SUBMIT TO GRADESCOPE

/**
 * An abstract data type describing common stack functionality. A stack observes a last-in-first-out
 * protocol, where the only accessible value is the most-recently added value.
 *
 * @param <T> the type of data contained in this stack
 */
public interface StackADT<T> {

  /**
   * Returns true if this stack is empty.
   *
   * @return true if the stack contains no elements, false otherwise
   */
  public boolean isEmpty();

  /**
   * Returns the number of elements in the stack.
   *
   * @return the number of elements in the stack
   */
  public int size();


  /**
   * Add a new element to the top of this stack, assumed to be non-null.
   *
   * @param value the value to add
   */
  public void push(T value);

  /**
   * Removes and returns the value added to this stack most recently
   *
   * @return the most recently-added value, or null if the stack is empty
   */
  public T pop();

  /**
   * Accesses the value added to this stack most recently, without modifying the stack
   *
   * @return the most recently-added value, or null if the stack is empty
   */
  public T peek();

  /**
   * Removes all the elements from the stack. The stack will be empty after this call returns.
   */
  public void clear();

  /**
   * Returns true if this stack contains a much with a specific element, false otherwise
   *
   * @param value the value to check
   * @return true if the stack contains the element, false otherwise
   */
  public boolean contains(T value);
}
