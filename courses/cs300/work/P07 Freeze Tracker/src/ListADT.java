/**
 * A generic interface for a doubly-linked list ADT. Defines essential methods for managing a linked
 * list structure.
 *
 * @param <T> The type of elements stored in the linked list.
 */
public interface ListADT<T> {

  /**
   * Adds an element to the linked list while maintaining order.
   * 
   * @param element The element to be added.
   */
  void add(T element);

  /**
   * Returns the element at index i
   * @param i an index
   * @return The element at index i
   * @throws IndexOutOfBoundsException if i is negative or greater than size()-1
   */
  T get(int i);

  /**
   * Removes an element from the linked list.
   * 
   * @param element The element to remove.
   * @return True if the element was successfully removed, false otherwise.
   */
  boolean remove(T element);

  /**
   * Gets the total number of elements in the linked list.
   * 
   * @return The number of elements in the list.
   */
  int size();

  /**
   * Checks if the linked list is empty.
   * 
   * @return True if the list contains no elements, false otherwise.
   */
  boolean isEmpty();

  /**
   * Removes all elements from the linked list. After calling this method, the list will be empty.
   */
  void clear();
  
}