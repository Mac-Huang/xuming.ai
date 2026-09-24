//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title:    P07 Freeze Tracker
// Course:   CS 300 Spring 2025
//
// Author:   Jake Christofferson
// Email:    ejchristoffe@wisc.edu
// Lecturer: Mouna Kacem
//
//////////////////// PAIR PROGRAMMERS COMPLETE THIS SECTION ///////////////////
// 
// Partner Name:    Sri Chirumanilla
// Partner Email:   chirumanilla@wisc.edu
// Partner Lecturer's Name: Mouna Kacem
// 
// VERIFY THE FOLLOWING BY PLACING AN X NEXT TO EACH TRUE STATEMENT:
//   _x_ Write-up states that pair programming is allowed for this assignment.
//   _x_ We have both read and understand the course Pair Programming Policy.
//   _x_ We have registered our team prior to the team registration deadline.
//
//////////////////////// ASSISTANCE/HELP CITATIONS ////////////////////////////
//
// Persons:         none
// Online Sources:  
// https://stackoverflow.com/questions/49700276/deleting-from-doubly-linked-list-java
// - Helped understand what removing a node needed to do, why we need to update 
//   Prev and Next nodes, and the order to do things.
//
///////////////////////////////////////////////////////////////////////////////

import java.util.Iterator;
import java.util.NoSuchElementException;

public class IteratorBwd implements Iterator<LakeRecord>{
  /**
   * Pointer to the current node 
   */
  private LinkedNode current;
  
  /**
   * Used to create a new Iterator in the forward direction
   * 
   * @param start where the iterator should start
   */
  public IteratorBwd(LinkedNode end) {
    this.current = end;
  }
  
  /**
   * Used to see if the iterator has a next node
   */
  @Override
  public boolean hasNext() {
    return current != null;
  }
  
  /**
   * Used to to go to the previous element in the Linked List
   * 
   * @returns the next LakeRecord
   */
  @Override
  public LakeRecord next() throws NoSuchElementException{
    if (current == null) {
      throw new NoSuchElementException();
    }
    
    LakeRecord prevRecord = current.getLakeRecord();
    current = current.getPrev();
    
    return prevRecord;
  }
  
}