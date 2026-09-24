//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: P07 Freeze Tracker
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
//
// Persons: none
// Online Sources:
// https://stackoverflow.com/questions/49700276/deleting-from-doubly-linked-list-java
// - Helped understand what removing a node needed to do, why we need to update
// Prev and Next nodes, and the order to do things.
//
///////////////////////////////////////////////////////////////////////////////

import java.util.ArrayList;
import java.util.Iterator;

/**
 * A doubly-linked list implementation for managing freeze-thaw records of Lake Mendota. Implements
 * ListADT and Iterable, providing operations for adding, removing, merging, and analyzing freeze
 * data.
 */
public class FreezeTracker implements ListADT<LakeRecord>, Iterable<LakeRecord> {
  /**
   * Pointer to head of the linked list.
   */
  private LinkedNode head;
  /**
   * Pointer to tail of the linked list.
   */
  private LinkedNode tail;
  /**
   * Number of elements in the list.
   */
  private int size;
  /**
   * Whether to traverse the list is reverse-chronological order.
   */
  private boolean reversed;

  /**
   * Constructs an empty FreezeTracker.
   */
  public FreezeTracker() {
    head = null;
    tail = null;
    size = 0;
    reversed = false;
  }

  /**
   * Constructs a FreezeTracker and initializes it with an ArrayList of LakeRecords. This
   * constructor processes the provided dataset. After this process, the linked list will contain
   * exactly one cleaned and merged record per winter.
   * 
   * @param records The list of LakeRecord objects read from FreezeData.csv. This list may contain
   *                missing or duplicate entries, which are handled during initialization.
   */
  public FreezeTracker(ArrayList<LakeRecord> records) {
    this.size = records.size();

    // Creating the linked nodes
    ArrayList<LinkedNode> nodes = new ArrayList<>();
    for (LakeRecord lr : records) {
      LinkedNode newNode = new LinkedNode(lr);
      nodes.add(newNode);

    }

    this.head = nodes.get(0);
    this.tail = nodes.get(nodes.size() - 1);

    if (nodes.size() > 1) {
      // Sets head next and tail prev
      head.setNext(nodes.get(1));
      tail.setPrev(nodes.get(nodes.size() - 2));

      for (int i = 1; i < nodes.size() - 1; ++i) { // sets all other next and prev
        nodes.get(i).setPrev(nodes.get(i - 1));
        nodes.get(i).setNext(nodes.get(i + 1));
      }
    }

    // Clean Data
    removeIncompleteRecords();
    mergeWinters();

    this.reversed = false;
  }

  /**
   * Returns the number of records in the list.
   * 
   * @return The size of the list.
   */
  @Override
  public int size() {
    return size;
  }

  /**
   * Checks if the list is empty.
   * 
   * @return True if the list is empty, false otherwise.
   */
  @Override
  public boolean isEmpty() {
    return (size < 1);
  }

  /**
   * Clears all records from the list.
   */
  @Override
  public void clear() {
    this.head = null;
    this.tail = null;
    this.size = 0;
    this.reversed = false;
  }

  /**
   * Specifies which direction the list should be traversed in the future
   * 
   * @param reversed whether to traverse the list backwards
   */
  public void setReversed(boolean reversed) {
    this.reversed = reversed;
  }

  /**
   * Getter method for head
   * 
   * @return head of the linked list
   */
  public LinkedNode getHead() {
    return head;
  }

  /**
   * Getter method for tail
   * 
   * @return tail of the linked list
   */
  public LinkedNode getTail() {
    return tail;
  }

  /**
   * Appends a new freeze record to the end of the linked list in O(1) time.
   *
   * <br>
   * <br>
   * Note: This method is closely related to the learning objectives of the assignment, and so we'll
   * pay special attention to it during manual grading. Be sure to leave comments explaining each
   * algorithmic step you use!
   *
   * @param record The record to add.
   */
  @Override
  public void add(LakeRecord record) {
    LinkedNode newNode = new LinkedNode(record); // Makes the data into a LinkedNode
    if (tail != null) {
      tail.setNext(newNode); // Tail now set next to the newNode, it will no longer be tail
      newNode.setPrev(tail); // Prev will be pointing at the current tail, next will be null

    } else {
      head = newNode;
    }

    tail = newNode;// Assign tail to the newNode
    size++;
  }

  /**
   * Removes the given node from the linked list in O(1) time. Note: this method does not verify
   * that the given node is a member of the list, and should only be used as a helper function
   * inside the FreezeTracker class.
   *
   * <br>
   * <br>
   * Note: This method is closely related to the learning objectives of the assignment, and so we'll
   * pay special attention to it during manual grading. Be sure to leave comments explaining each
   * algorithmic step you use!
   *
   * @param node the node to be removed
   * @throws IllegalArgumentException if node is null
   */
  private void removeNode(LinkedNode node) {

    if (node == null) {
      throw new IllegalArgumentException();
    }

    // This is where the citation about removing nodes helped us
    LinkedNode prevNode = node.getPrev();
    LinkedNode nextNode = node.getNext();

    if (prevNode != null) {
      prevNode.setNext(nextNode);

    } else {
      head = nextNode;
    }

    if (nextNode != null) {
      nextNode.setPrev(prevNode);

    } else {
      tail = prevNode;
    }

  }

  /**
   * Removes the first node in the list that contains the given record.
   *
   * <br>
   * <br>
   * Note: This method is closely related to the learning objectives of the assignment, and so we'll
   * pay special attention to it during manual grading. Be sure to leave comments explaining each
   * algorithmic step you use!
   *
   * @param record the record to be removed
   * @return boolean indicating whether the record was found in the list
   */
  @Override
  public boolean remove(LakeRecord record) {

    LinkedNode node = this.find(record); // Find the lake record to remove

    if (node != null) { // Double Check that the node was found, if not return false and do nothing

      removeNode(node); // Remove the node and increment size
      size--;
      return true;
    }

    return false;
  }

  /**
   * Finds the given record in the list
   * 
   * @param record the LakeRecord to search for
   * @return The first LinkedNode containing the given record, or null if none exists
   */
  public LinkedNode find(LakeRecord record) {
    LinkedNode currNode = head;

    while (currNode != null) {


      if (currNode.getLakeRecord().equals(record)) {
        return currNode;
      }

      currNode = currNode.getNext();
    }

    return null;
  }

  /**
   * Returns the LakeRecord at index i in the list, using zero-indexing.
   * 
   * @param i a non-negative integer
   * @return The LakeRecord at the given index
   * @throws IndexOutOfBoundsException if i is negative or greater than size()-1
   */
  public LakeRecord get(int i) {
    if (i < 0 || size <= i) {
      throw new IndexOutOfBoundsException();
    }

    LinkedNode currNode = head;

    for (int j = 0; j < i; ++j) {
      currNode = currNode.getNext();
    }

    return currNode.getLakeRecord();
  }

  /**
   * Provides an iterator for traversal. The direction of traversal is head-to-tail if this.reversed
   * is false, and tail-to-head otherwise.
   *
   * @return An iterator traversing the list.
   */
  @Override
  public Iterator<LakeRecord> iterator() {
    if (reversed) {
      return new IteratorBwd(tail);
    } else {
      return new IteratorFwd(head);
    }
  }

  /**
   * Removes all nodes with missing freeze or thaw dates
   */
  public void removeIncompleteRecords() {
    LinkedNode currNode = head;
    while (currNode != null) {
      LakeRecord lr = currNode.getLakeRecord();

      if (lr.getFreezeDate() == null || lr.getThawDate() == null || lr.getFreezeDate().isBlank()
          || lr.getThawDate().isBlank()) {
        LinkedNode remove = currNode;
        currNode = currNode.getNext();
        removeNode(remove);
        size--;
      } else {
        currNode = currNode.getNext();
      }
    }
  }

  /**
   * Fixes all LakeRecords contained in this list with incorrect durations (Hint: LakeRecord already
   * has a method for this!)
   */
  public void updateDurations() {
    if (head == null) {
      return;
    }

    LinkedNode currNode = head;
    while (currNode != null) {
      currNode.getLakeRecord().updateDuration();
      currNode = currNode.getNext();
    }
  }

  /**
   * Merges consecutive nodes containing records from the same winter. The merged node contains a
   * single record with the earliest freeze date, the latest thaw date, and the total number of days
   * of ice cover. Note that merging discards the middle thaw and freeze dates, and so this method
   * should only be used after calling updateDurations().
   *
   * <br>
   * <br>
   * Note: This method is closely related to the learning objectives of the assignment, and so we'll
   * pay special attention to it during manual grading. Be sure to leave comments explaining each
   * algorithmic step you use!
   */
  public void mergeWinters() {
    if (head == null || head.getNext() == null) { // Head or nothing to merge
      return;
    }

    LinkedNode currNode = head;
    while (currNode != null && currNode.getNext() != null) {
      LakeRecord currRec = currNode.getLakeRecord();
      LakeRecord nextRec = currNode.getNext().getLakeRecord();

      // See if they are from the same year
      if (currRec.getYear() == nextRec.getYear()) {

        // Getting earliest Freeze and Thaw dates
        String earliestFreeze = null;

        if (Date.compareDates(currRec.getFreezeDate(), nextRec.getFreezeDate()) < 0) {
          earliestFreeze = currRec.getFreezeDate();
        } else {
          earliestFreeze = nextRec.getFreezeDate();
        }

        String latestThaw = null;
        if (Date.compareDates(currRec.getThawDate(), nextRec.getThawDate()) > 0) {
          latestThaw = currRec.getThawDate();
        } else {
          latestThaw = nextRec.getThawDate();
        }

        // Use date to get ice cover days
        // int totalIceDays = Date.daysBetween(currRec.getWinter(), earliestFreeze, latestThaw);
        int totalIceDays = currNode.getLakeRecord().getDaysOfIceCover()
            + currNode.getNext().getLakeRecord().getDaysOfIceCover();

        LakeRecord mergedRecord =
            new LakeRecord(currRec.getWinter(), earliestFreeze, latestThaw, totalIceDays);

        // Setting up new Merged Node
        LinkedNode mergedNode = new LinkedNode(mergedRecord);

        if (currNode == head) {
          head = mergedNode; // Prev stays null
        } else {
          currNode.getPrev().setNext(mergedNode); // Make sure prev looks at new node
          mergedNode.setPrev(currNode.getPrev()); // Else this merged node takes the prev of curr
        }

        if (currNode.getNext() == tail) {
          tail = mergedNode; // Next stays null
        } else {
          currNode.getNext().getNext().setPrev(mergedNode); // Make sure 'B' node next looking at
                                                            // merged
          mergedNode.setNext(currNode.getNext().getNext()); // want to look ahead to
        }

        size--; // Make sure to update size

        currNode = mergedNode; // Move on

      } else { // No need to merge
        currNode = currNode.getNext();
      }

    }

  }

  /**
   * Returns a new linked list containing all the records falling between year1 and year 2,
   * inclusive. The returned list should not contain any references to nodes or records from the
   * original list, and the relative ordering of nodes should not change.
   *
   * @param year1 minimum allowable year for the new list
   * @param year2 maximum allowable year for the new list
   * @return a new, filtered linked list covering the given range of years.
   */
  public FreezeTracker filterByYear(int year1, int year2) {
    FreezeTracker yearFiltered = new FreezeTracker();
    LinkedNode currNode = head;

    while (currNode != null) {
      LakeRecord record = currNode.getLakeRecord().copy();
      int year = record.getYear();

      if (year >= year1 && year <= year2) {
        yearFiltered.add(record);
      }

      currNode = currNode.getNext();

    }
    return yearFiltered;
  }

  /**
   * Returns a new linked list containing all of the records from the given year. The returned list
   * should not contain any references to nodes or records from the original list, and the relative
   * ordering of nodes should not change.
   *
   * @param year the single year covered by the new list
   * @return a new linked list containing only nodes from the given year
   */
  public FreezeTracker filterByYear(int year) {
    FreezeTracker yearFiltered = new FreezeTracker();
    LinkedNode currNode = head;

    while (currNode != null) {
      LakeRecord record = currNode.getLakeRecord().copy();
      int newYear = record.getYear();

      if (newYear == year) {
        yearFiltered.add(record);
      }

      currNode = currNode.getNext();

    }
    return yearFiltered;
  }

  /**
   * Returns a new linked list containing all of the records whose total days of ice cover are
   * between low and high, inclusive. The returned list should not contain any references to nodes
   * or records from the original list, and the relative ordering of nodes should not change.
   *
   * @param low  The minimum allowed duration for the new list
   * @param high The maximum allowed duration for the new list
   * @return a new list containing only records with duration in the given range
   */
  public FreezeTracker filterByDuration(int low, int high) {
    FreezeTracker filtered = new FreezeTracker();
    LinkedNode currNode = head;

    while (currNode != null) {
      LakeRecord record = currNode.getLakeRecord().copy();
      int duration = record.getDaysOfIceCover();

      if (duration >= low && duration <= high) {
        filtered.add(record);
      }
      currNode = currNode.getNext();
    }
    return filtered;
  }

  /**
   * Finds the latest date at which the lake thawed.
   * 
   * @return The date of the latest thaw, e.g. "April 15"
   */
  public String getLatestThaw() {
    if (size == 0) {
      return "No Records Found";
    }

    LinkedNode curr = head;
    String latestThaw = curr.getLakeRecord().getThawDate();
    
    while (curr != null) {
      
      String thawDate = curr.getLakeRecord().getThawDate();
      if (Date.compareDates(thawDate, latestThaw) > 0) {
        latestThaw = thawDate;
      }
      curr = curr.getNext();
    }

    return latestThaw;
  }

  /**
   * Finds the earliest date at which the lake froze.
   *
   * @return The day of the earliest freeze, e.g. "December 2"
   */
  public String getEarliestFreeze() {
    if (size == 0) {
      return "No Records Found";
    }

    LinkedNode curr = head;
    String earliestFreeze = curr.getLakeRecord().getFreezeDate();
    while (curr != null) {
      String freezeDate = curr.getLakeRecord().getFreezeDate();
      if (Date.compareDates(earliestFreeze, freezeDate) > 0) {
        earliestFreeze = freezeDate;
      }
      curr = curr.getNext();
    }

    return earliestFreeze;
  }

  /**
   * Finds the average (arithmetic mean) number of days of ice cover across the entire list
   *
   * @return The average number of days of ice cover across all nodes, or 0 if list is empty.
   */
  public float getAverageFreezeDuration() {
    if (size == 0) {
      return 0.0f;
    }

    float totalDuration = 0;
    LinkedNode curr = head;
    while (curr != null) {
      totalDuration += curr.getLakeRecord().getDaysOfIceCover();
      curr = curr.getNext();
    }
    return totalDuration / size;
  }

  /**
   * Finds the maximum number of days of ice cover across the entire list
   * 
   * @return The maximum number of days of ice cover across all nodes, or 0 if the list is empty.
   */
  public int getMaxFreezeDuration() {
    if (head == null) {
      return 0;
    }


    int maxDur = Integer.MIN_VALUE;
    LinkedNode curr = head;

    while (curr != null) {
      int currDur = curr.getLakeRecord().getDaysOfIceCover();
      if (currDur > maxDur) {
        maxDur = currDur;
      }
      curr = curr.getNext();
    }
    return maxDur;
  }

  /**
   * Finds the minimum number of days of ice cover across the entire list
   * 
   * @return The minimum number of days of ice cover across all nodes, or 0 if the list is empty.
   */
  public int getMinFreezeDuration() {
    if (head == null) {
      return 0;
    }


    int minDur = Integer.MAX_VALUE;
    LinkedNode curr = head;

    while (curr != null) {
      int currDur = curr.getLakeRecord().getDaysOfIceCover();
      if (currDur < minDur) {
        minDur = currDur;
      }
      curr = curr.getNext();
    }
    return minDur;
  }

  /**
   * Creates a string representation of the tracker with each node on a new line. The order of the
   * nodes depends on whether the string is currently reversed.
   *
   * @return a String representation of the list
   */
  public String toString() {
    String newString = "";
    LinkedNode curr = head;
    while (curr != null) {
      newString = newString + (curr.getLakeRecord().toString()) + "\n";

      curr = curr.getNext();
    }
    return newString;
  }
}
