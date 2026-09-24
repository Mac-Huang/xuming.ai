//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: P09 Hobbemoun
// Course: CS 300 Spring 2025
//
// Author: Jake Christofferson
// Email: ejchristoffe@wisc.edu
// Lecturer: Mouna Kacem
//
//////////////////// PAIR PROGRAMMERS COMPLETE THIS SECTION ///////////////////
//
// Partner Name: Sri Chirumanilla
// Partner Email: chirumanilla@wisc.edu
// Partner Lecturer's Name: Mouna Kacem
//
// VERIFY THE FOLLOWING BY PLACING AN X NEXT TO EACH TRUE STATEMENT:
// _x_ Write-up states that pair programming is allowed for this assignment.
// _x_ We have both read and understand the course Pair Programming Policy.
// _x_ We have registered our team prior to the team registration deadline.
//
//////////////////////// ASSISTANCE/HELP CITATIONS ////////////////////////////
//
// Persons: none
// Online Sources:
//   - https://www.geeksforgeeks.org/inorder-successor-in-binary-search-tree/
//
///////////////////////////////////////////////////////////////////////////////

import java.util.Iterator;
import java.util.NoSuchElementException;

/**
 * An iterator that traverses a HobbemounTree in in-order sequence, visiting all Hobbemoun objects
 * from smallest (weakest) to largest (strongest). This iterator starts at the weakest (i.e.,
 * smallest) Hobbemoun in the tree and proceeds to the strongest (i.e., largest) using the next
 * method defined by the tree structure (HobbemounTree).
 */
public class HobbemounIterator extends Object implements Iterator<Hobbemoun> {
  /**
   * THe hobbemoun tree that will iterate over
   */
  private HobbemounTree tree;

  /**
   * The next strongest Hobbemoun to be returned by the iterator.
   */
  private Hobbemoun nextHobbemoun;

  /**
   * Constructs a new HobbemounIterator to iterate over the specified tree. The iteration starts at
   * the weakest (smallest) Hobbemoun in the tree.
   *
   * @param tree - the HobbemounTree to traverse
   */
  public HobbemounIterator(HobbemounTree tree) {
    this.tree = tree;
    this.nextHobbemoun = tree.getWeakest();
  }

  /**
   * Returns true if the iteration has more Hobbemoun to visit. Specified by: hasNext in interface
   * Iterator<Hobbemoun>
   *
   * @return true if there is another Hobbemoun in the iteration to return, false if the end of the
   *         traversal has been reached
   */
  @Override
  public boolean hasNext() {
    return nextHobbemoun != null;
  }

  /**
   * Returns the next Hobbemoun in the in-order traversal of the tree. Specified by: next in
   * interface Iterator<Hobbemoun>
   *
   * @return the next Hobbemoun in sequence
   * @throws NoSuchElementException - if the iteration has no more elements
   */
  @Override
  public Hobbemoun next() {
    if (!hasNext()) {
      throw new NoSuchElementException();
    }

    Hobbemoun curr = nextHobbemoun;

    nextHobbemoun = tree.next(nextHobbemoun);

    return curr;
  }
}
