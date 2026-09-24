// PROVIDED FILE -- DO NOT SUBMIT TO GRADESCOPE

/**
 * An abstract data type describing common queue functionality. A queue observes a
 * first-in-first-out protocol, where the only accessible value is the least-recently added value.
 *
 * @param <T> the type of data contained in this queue
 */
public interface QueueADT<T> {

  /**
   * Returns true if this queue is empty.
   *
   * @return true if the queue contains no elements, false otherwise
   */
  public boolean isEmpty();

  /**
   * Returns the number of elements in the queue.
   *
   * @return the number of elements in the queue
   */
  public int size();

  /**
   * Add a new element to the back of the queue, assumed to be non-null.
   *
   * @param value the value to add
   */
  public void enqueue(T value);

  /**
   * Removes and returns the value added to this queue least recently
   *
   * @return the least recently-added value
   * @throws java.util.NoSuchElementException if this queue is empty
   */
  public T dequeue();

  /**
   * Accesses the value added to this queue least recently, without modifying the queue
   *
   * @return the least recently-added value
   * @throws java.util.NoSuchElementException if this queue is empty
   */
  public T peek();


  /**
   * Removes all the elements from the queue. The queue will be empty after this call returns.
   */
  public void clear();

  /**
   * Returns true if this queue contains a match with a specific element, false otherwise
   *
   * @param value the value to check
   * @return true if the queue contains the element, false otherwise
   */
  public boolean contains(T value);
}
