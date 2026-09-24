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

/**
 * Instantiable class representing a single node in a doubly-linked list of LakeRecords.
 */
public class LinkedNode {

  /**
   * The LakeRecord stored in this node
   */
  private LakeRecord data;

  /**
   * A reference to the previous node in this linked list
   */
  private LinkedNode prev;

  /**
   * A reference to the next node in this linked list
   */
  private LinkedNode next;

  /**
   * Creates a new LinkedNode with the given data, previous and next nodes
   * 
   * @param data the LakeRecord to be contained in this node
   * @param prev a reference to the previous node in this list (may be null)
   * @param next a reference to the next node in this list (may be null)
   */
  public LinkedNode(LakeRecord data, LinkedNode prev, LinkedNode next) {
    this.data = data;
    this.prev = prev;
    this.next = next;
  }

  /**
   * Creates a new LinkedNode with the given data which is not currently linked to any other nodes
   * 
   * @param data the data to be contained in this node
   */
  public LinkedNode(LakeRecord data) {
    this.data = data;
    prev = null;
    next = null;
  }

  /**
   * Accesses the LakeRecord stored in this node
   * 
   * @return the LakeRecord stored in this node
   */
  public LakeRecord getLakeRecord() {
    return data;
  }

  /**
   * Accesses the previous node in the list
   * 
   * @return a reference to the previous node in this list (may be null)
   */
  public LinkedNode getPrev() {
    return prev;
  }

  /**
   * Updates the previous node for this node
   * 
   * @param newPrev the new previous node in this list (may be null)
   */
  public void setPrev(LinkedNode newPrev) {
    prev = newPrev;
  }

  /**
   * Accesses the next node in the list
   * 
   * @return a reference to the next node in this list (may be null)
   */
  public LinkedNode getNext() {
    return next;
  }

  /**
   * Updates the next node for this node
   * 
   * @param newNext the new next node in this list (may be null)
   */
  public void setNext(LinkedNode newNext) {
    next = newNext;
  }
}
