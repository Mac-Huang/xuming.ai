/**
 * CS 400: Programming III
 * SortedCollection Interface
 * University of Wisconsin-Madison
 *
 * This interface defines the contract for sorted collection implementations.
 */

public interface SortedCollection<T extends Comparable<T>> {
    /**
     * Inserts a new data value into the sorted collection.
     *
     * @param data the new value being inserted
     * @throws NullPointerException if data argument is null
     */
    void insert(T data) throws NullPointerException;

    /**
     * Check whether data is stored in the collection.
     *
     * @param data the value to check for in the collection
     * @return true if the collection contains data one or more times,
     *         and false otherwise
     * @throws NullPointerException if data argument is null
     */
    boolean contains(Comparable<T> data) throws NullPointerException;

    /**
     * Counts the number of values in the collection, with each duplicate
     * value being counted separately within the value returned.
     *
     * @return the number of values in the collection, including duplicates
     */
    int size();

    /**
     * Checks if the collection is empty.
     *
     * @return true if the collection contains 0 values, false otherwise
     */
    boolean isEmpty();

    /**
     * Removes all values and duplicates from the collection.
     */
    void clear();
}