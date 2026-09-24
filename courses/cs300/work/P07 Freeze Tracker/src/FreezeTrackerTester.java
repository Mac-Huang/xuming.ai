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
// Persons: none
// Online Sources:
// https://stackoverflow.com/questions/49700276/deleting-from-doubly-linked-list-java
// - Helped understand what removing a node needed to do, why we need to update
// Prev and Next nodes, and the order to do things.
//
///////////////////////////////////////////////////////////////////////////////

import java.util.ArrayList;
import java.util.Iterator;
import java.util.MissingResourceException;

/**
 * Tester class for FreezeTracker functionality.
 */
public class FreezeTrackerTester {

  /**
   * Tests adding records to an empty FreezeTracker and the end of a non-empty FreezeTracker.
   * 
   * Ensure that size has been updated correctly, that the first and last winters are correct, and
   * that all added records are present in the correct locations in the list.
   * 
   * @return true if all cases pass, false otherwise.
   */
  public static boolean testAdd() {
    {// Empty
      LakeRecord lr1 = new LakeRecord("2001-02", "December 16", "March 1", 70);

      FreezeTracker empty = new FreezeTracker();

      empty.add(lr1);

      if (empty.size() != 1 || !empty.get(0).equals(lr1)) {
        return false;
      }
    }

    { // Non-Empty
      ArrayList<LakeRecord> lakeRecords = new ArrayList<>();
      LakeRecord lr1 = new LakeRecord("2001-02", "December 16", "March 1", 70);
      LakeRecord lr2 = new LakeRecord("2002-03", "December 17", "March 2", 70);
      LakeRecord lr3 = new LakeRecord("2003-04", "December 18", "March 3", 71);
      lakeRecords.add(lr1);
      lakeRecords.add(lr2);


      FreezeTracker actual = new FreezeTracker(lakeRecords);
      lakeRecords.add(lr3);
      FreezeTracker expected = new FreezeTracker(lakeRecords);

      actual.add(lr3);

      if (actual.size() != 3) {
        return false;
      }

      for (int i = 0; i < actual.size(); ++i) {
        if (!actual.get(i).equals(expected.get(i))) {
          return false;
        }
      }
    }

    return true; // all tests passed
  }

  /**
   * Tests removing records from different positions (beginning, middle, end). Your initial
   * FreezeTracker list should contain AT LEAST five records; none of these tests will clear out the
   * list (that's a different test, below).
   * 
   * Verify both return values and the list state.
   * 
   * @return true if all cases pass, false otherwise.
   */
  public static boolean testRemove() {
    { // beginnning
      ArrayList<LakeRecord> lakeRecords = new ArrayList<>();
      LakeRecord lr1 = new LakeRecord("2001-02", "December 16", "March 1", 70);
      LakeRecord lr2 = new LakeRecord("2002-03", "December 17", "March 2", 70);
      LakeRecord lr3 = new LakeRecord("2003-04", "December 18", "March 3", 71);
      LakeRecord lr4 = new LakeRecord("2004-05", "December 19", "March 4", 72);
      LakeRecord lr5 = new LakeRecord("2005-06", "December 20", "March 5", 73);
      lakeRecords.add(lr1);
      lakeRecords.add(lr2);
      lakeRecords.add(lr3);
      lakeRecords.add(lr4);
      lakeRecords.add(lr5);

      FreezeTracker actual = new FreezeTracker(lakeRecords);

      lakeRecords.remove(0);
      FreezeTracker expected = new FreezeTracker(lakeRecords);

      actual.remove(lr1);

      if (actual.size() != 4) {
        return false;
      }

      for (int i = 0; i < actual.size(); ++i) {
        if (!actual.get(i).equals(expected.get(i))) {
          return false;
        }
      }
    }

    { // middle
      ArrayList<LakeRecord> lakeRecords = new ArrayList<>();
      LakeRecord lr1 = new LakeRecord("2001-02", "December 16", "March 1", 70);
      LakeRecord lr2 = new LakeRecord("2002-03", "December 17", "March 2", 70);
      LakeRecord lr3 = new LakeRecord("2003-04", "December 18", "March 3", 71);
      LakeRecord lr4 = new LakeRecord("2004-05", "December 19", "March 4", 72);
      LakeRecord lr5 = new LakeRecord("2005-06", "December 20", "March 5", 73);
      lakeRecords.add(lr1);
      lakeRecords.add(lr2);
      lakeRecords.add(lr3);
      lakeRecords.add(lr4);
      lakeRecords.add(lr5);

      FreezeTracker actual = new FreezeTracker(lakeRecords);

      lakeRecords.remove(2);
      FreezeTracker expected = new FreezeTracker(lakeRecords);

      actual.remove(lr3);

      if (actual.size() != 4) {
        return false;
      }

      for (int i = 0; i < actual.size(); ++i) {
        if (!actual.get(i).equals(expected.get(i))) {
          return false;
        }
      }
    }

    { // end
      ArrayList<LakeRecord> lakeRecords = new ArrayList<>();
      LakeRecord lr1 = new LakeRecord("2001-02", "December 16", "March 1", 70);
      LakeRecord lr2 = new LakeRecord("2002-03", "December 17", "March 2", 70);
      LakeRecord lr3 = new LakeRecord("2003-04", "December 18", "March 3", 71);
      LakeRecord lr4 = new LakeRecord("2004-05", "December 19", "March 4", 72);
      LakeRecord lr5 = new LakeRecord("2005-06", "December 20", "March 5", 73);
      lakeRecords.add(lr1);
      lakeRecords.add(lr2);
      lakeRecords.add(lr3);
      lakeRecords.add(lr4);
      lakeRecords.add(lr5);

      FreezeTracker actual = new FreezeTracker(lakeRecords);

      lakeRecords.remove(4);
      FreezeTracker expected = new FreezeTracker(lakeRecords);

      actual.remove(lr5);

      if (actual.size() != 4) {
        return false;
      }

      for (int i = 0; i < actual.size(); ++i) {
        if (!actual.get(i).equals(expected.get(i))) {
          return false;
        }
      }
    }

    return true; // all tests passed
  }

  /**
   * Tests removing the ONLY value from a FreezeTracker.
   * 
   * Ensure all accessor methods behave correctly after removing it.
   * 
   * @return true if all cases pass, false otherwise.
   */
  public static boolean testRemoveOnly() {
    ArrayList<LakeRecord> lakeRecords = new ArrayList<>();
    LakeRecord lr1 = new LakeRecord("2001-02", "December 16", "March 1", 70);

    lakeRecords.add(lr1);

    FreezeTracker actual = new FreezeTracker(lakeRecords);

    actual.remove(lr1);

    if (actual.size() != 0) {
      return false;
    }


    if (actual.getHead() != null || actual.getTail() != null
        || actual.getAverageFreezeDuration() != 0.0f || actual.getMinFreezeDuration() != 0
        || !actual.getEarliestFreeze().equals("No Records Found")
        || actual.getMaxFreezeDuration() != 0
        || !actual.getLatestThaw().equals("No Records Found")) {
      return false;
    }

    return true; // all tests passed
  }

  /**
   * Tests removing a record from FreezeTracker which is not present in the list.
   * 
   * Verify both the return value and the list state.
   * 
   * @return true if all cases pass, false otherwise.
   */
  public static boolean testRemoveDoesNotExist() {
    ArrayList<LakeRecord> lakeRecords = new ArrayList<>();
    LakeRecord lr1 = new LakeRecord("2001-02", "December 16", "March 1", 70);
    LakeRecord lr2 = new LakeRecord("2002-03", "December 17", "March 2", 70);
    LakeRecord lr3 = new LakeRecord("2003-04", "December 18", "March 3", 71);
    LakeRecord lr4 = new LakeRecord("2004-05", "December 19", "March 4", 72);
    LakeRecord lr5 = new LakeRecord("2005-06", "December 20", "March 5", 73);
    lakeRecords.add(lr1);
    lakeRecords.add(lr2);
    lakeRecords.add(lr3);
    lakeRecords.add(lr5);

    FreezeTracker actual = new FreezeTracker(lakeRecords);
    if (actual.remove(lr4) || actual.size() != 4) {
      return false;
    }

    return true; // tests passed
  }

  /**
   * Tests iterators (forward and backward). For full credit, this test MUST contain at least one
   * enhanced for loop with each type of iterator.
   * 
   * @return true if all cases pass, false otherwise.
   */
  public static boolean testIterators() {
    ArrayList<LakeRecord> records = new ArrayList<>();
    records.add(new LakeRecord("2001-02", "Dec 16", "Mar 1", 70));
    records.add(new LakeRecord("2002-03", "Dec 17", "Mar 2", 71));
    records.add(new LakeRecord("2003-04", "Dec 18", "Mar 3", 72));

    {// Fwd iterator
      FreezeTracker fwdTracker = new FreezeTracker(records);
      int count = 0;
      for (LakeRecord lr : fwdTracker) {
        if (!lr.equals(records.get(count))) {
          return false;
        }
        count++;
      }

      if (count != 3) {
        return false;
      }

      Iterator<LakeRecord> fwdIter = fwdTracker.iterator();
      for (int i = 0; i < records.size(); i++) {
        if (!fwdIter.hasNext() || !fwdIter.next().equals(records.get(i))) {
          return false;
        }
      }
      if (fwdIter.hasNext())
        return false;
    }

    {// Bwd iterator
      FreezeTracker bwdTracker = new FreezeTracker(records);
      bwdTracker.setReversed(true);
      int count = 0;
      for (LakeRecord lr : bwdTracker) {
        if (!lr.equals(records.get(Math.abs(count - 2)))) {
          return false;
        }
        count++;
      }

      if (count != 3) {
        return false;
      }

      Iterator<LakeRecord> bwdIter = bwdTracker.iterator();
      for (int i = records.size() - 1; i >= 0; i--) {
        if (!bwdIter.hasNext() || !bwdIter.next().equals(records.get(i))) {
          return false;
        }
      }
      if (bwdIter.hasNext())
        return false;
    }

    return true; // all tests passed
  }

  /**
   * Tests merging multiple freeze records (provided!) for the same winter. 
   * 
   * Add these records to a FreezeTracker and verify that merging them results in a list with a
   * single record with the correct values.
   * 
   * @return true if all cases pass, false otherwise.
   */
  public static boolean testMergeWinters() {
    {
      // Make tracker and store vals
      FreezeTracker actual = new FreezeTracker();

      LakeRecord freeze1 = new LakeRecord("2019", "January 4", "April 15", 45);
      LakeRecord freeze2 = new LakeRecord("2019", "January 20", "April 10", 50);
      LakeRecord freeze3 = new LakeRecord("2019", "January 5", "April 5", 55);

      actual.add(freeze1);
      actual.add(freeze2);
      actual.add(freeze3);

      actual.updateDurations(); // Update before merging

      actual.mergeWinters(); // Then merge

      // Check if merged record is correct
      if (actual.size() != 1) {
        return false;
      }

      LakeRecord mergedRec = actual.get(0);

      if (!mergedRec.getFreezeDate().equals("January 4")
          || !mergedRec.getThawDate().equals("April 15")
          || mergedRec.getDaysOfIceCover() != 150 || mergedRec.getYear() != 2019) {
        return false;
      }
    }

    return true; // test passed
  }

  /**
   * Tests cleaning the dataset (removing incomplete records). Create a FreezeTracker with some
   * valid and invalid records, and verify that all of the invalid records are removed (and none of
   * the valid ones).
   * 
   * @return true if all cases pass, false otherwise.
   */
  public static boolean testCleanData() {
    ArrayList<LakeRecord> lakeRecords = new ArrayList<>();
    LakeRecord lr1 = new LakeRecord("2001-02", null, "March 1", 70); // should be removed
    LakeRecord lr2 = new LakeRecord("2002-03", "December 17", "March 2", 70);
    // Should be updated
    LakeRecord lr3 = new LakeRecord("2003-04", "December 18", "March 3", LakeRecord.MISSING);
    LakeRecord lr4 = new LakeRecord("2004-05", null, "March 4", 72); // should be removed
    LakeRecord lr5 = new LakeRecord("2005-06", "December 20", null, 73);// should be removed
    LakeRecord lr6 = new LakeRecord("2005-06", null, null, 73); // should be removed
    lakeRecords.add(lr1);
    lakeRecords.add(lr2);
    lakeRecords.add(lr3);
    lakeRecords.add(lr4);
    lakeRecords.add(lr5);
    lakeRecords.add(lr6);


    FreezeTracker actual = new FreezeTracker(lakeRecords);

    LakeRecord newlr3 = lr3.copy();

    // Remove then update
    actual.removeIncompleteRecords();
    actual.updateDurations();

    newlr3.updateDuration();
    FreezeTracker expected = new FreezeTracker(lakeRecords);
    expected.add(lr2);
    expected.add(newlr3);
    // System.out.println(expected + "\nEXPECTED\n");

    // Check if is correct
    if (actual.get(1).getDaysOfIceCover() == LakeRecord.MISSING) {
      return false;
    }

    // System.out.println(actual + "\n AFTER CLEAN\n");
    if (actual.size() != 2) {
      return false;
    }

    for (int i = 0; i < actual.size(); ++i) {
      if (!actual.get(i).equals(expected.get(i))) {
        return false;
      }
    }


    return true; // all passed
  }

  /**
   * Tests computing the average freeze duration.
   * 
   * @return true if all cases pass, false otherwise.
   */
  public static boolean testAverageFreezeDuration() {
    ArrayList<LakeRecord> lakeRecords = new ArrayList<>();
    LakeRecord lr1 = new LakeRecord("2001-02", "December 16", "March 1", 70);
    LakeRecord lr2 = new LakeRecord("2002-03", "December 17", "March 2", 70);
    LakeRecord lr3 = new LakeRecord("2003-04", "December 18", "March 3", 71);
    LakeRecord lr4 = new LakeRecord("2004-05", "December 19", "March 4", 72);
    LakeRecord lr5 = new LakeRecord("2005-06", "December 20", "March 5", 73);
    lakeRecords.add(lr1);
    lakeRecords.add(lr2);
    lakeRecords.add(lr3);
    lakeRecords.add(lr4);
    lakeRecords.add(lr5);

    FreezeTracker actual = new FreezeTracker(lakeRecords);

    float expectedAvg = (lr1.getDaysOfIceCover() + lr2.getDaysOfIceCover() + lr3.getDaysOfIceCover()
        + lr4.getDaysOfIceCover() + lr5.getDaysOfIceCover()) / 5;

    if (Math.abs(expectedAvg - actual.getAverageFreezeDuration()) < 0.0001) {
      return false;
    }

    return true; // all tests passed
  }

  /**
   * Tests finding the maximum number of days of ice cover in a single winter.
   * 
   * @return true if all cases pass, false otherwise.
   */
  public static boolean testMaxFreezeDuration() {
    ArrayList<LakeRecord> lakeRecords = new ArrayList<>();
    LakeRecord lr1 = new LakeRecord("2001-02", "December 16", "March 1", 70);
    LakeRecord lr2 = new LakeRecord("2002-03", "December 17", "March 2", 70);
    LakeRecord lr3 = new LakeRecord("2003-04", "December 18", "March 3", 71);
    LakeRecord lr4 = new LakeRecord("2004-05", "December 19", "March 4", 72);
    LakeRecord lr5 = new LakeRecord("2005-06", "December 20", "March 5", 73);
    lakeRecords.add(lr1);
    lakeRecords.add(lr2);
    lakeRecords.add(lr3);
    lakeRecords.add(lr4);
    lakeRecords.add(lr5);

    FreezeTracker actual = new FreezeTracker(lakeRecords);

    int expected = 73;

    if (expected != actual.getMaxFreezeDuration()) {
      return false;
    }

    return true; // all tests passed
  }

  /**
   * Tests finding the minimum number of days of ice cover in a single winter.
   * 
   * @return true if all cases pass, false otherwise.
   */
  public static boolean testMinFreezeDuration() {
    ArrayList<LakeRecord> lakeRecords = new ArrayList<>();
    LakeRecord lr1 = new LakeRecord("2001-02", "December 16", "March 1", 70);
    LakeRecord lr2 = new LakeRecord("2002-03", "December 17", "March 2", 70);
    LakeRecord lr3 = new LakeRecord("2003-04", "December 18", "March 3", 71);
    LakeRecord lr4 = new LakeRecord("2004-05", "December 19", "March 4", 72);
    LakeRecord lr5 = new LakeRecord("2005-06", "December 20", "March 5", 73);
    lakeRecords.add(lr1);
    lakeRecords.add(lr2);
    lakeRecords.add(lr3);
    lakeRecords.add(lr4);
    lakeRecords.add(lr5);

    FreezeTracker actual = new FreezeTracker(lakeRecords);

    int expected = 70;

    if (expected != actual.getMinFreezeDuration()) {
      return false;
    }

    return true; // all tests passed
  }

  /**
   * Tests finding the earliest freeze. 
   * 
   * @return true if all cases pass, false otherwise.
   */
  public static boolean testGetEarliestFreeze() {
    LakeRecord lr1 = new LakeRecord("2001-02", "December 16", "March 1", 70);
    LakeRecord lr2 = new LakeRecord("2002-03", "December 17", "March 2", 70);
    LakeRecord lr3 = new LakeRecord("2003-04", "December 18", "March 3", 71);
    LakeRecord lr4 = new LakeRecord("2004-05", "December 19", "March 4", 72);
    LakeRecord lr5 = new LakeRecord("2005-06", "December 20", "March 5", 73);

    FreezeTracker actual = new FreezeTracker();
    actual.add(lr1);
    actual.add(lr2);
    actual.add(lr3);
    actual.add(lr4);
    actual.add(lr5);

    String expected = lr1.getFreezeDate();
    String actualStr = actual.getEarliestFreeze();

    if (!expected.equals(actualStr)) {
      return false;
    }

    return true; // all tests passed
  }

  /**
   * Tests finding the latest thaw. 
   * 
   * @return true if all cases pass, false otherwise.
   */
  public static boolean testGetLatestThaw() {
    LakeRecord lr1 = new LakeRecord("2001-02", "December 16", "March 1", 70);
    LakeRecord lr2 = new LakeRecord("2002-03", "December 17", "March 2", 70);
    LakeRecord lr3 = new LakeRecord("2003-04", "December 18", "March 3", 71);
    LakeRecord lr4 = new LakeRecord("2004-05", "December 19", "March 4", 72);
    LakeRecord lr5 = new LakeRecord("2005-06", "December 20", "March 5", 73);

    FreezeTracker actual = new FreezeTracker();
    actual.add(lr1);
    actual.add(lr2);
    actual.add(lr3);
    actual.add(lr4);
    actual.add(lr5);

    String expected = lr5.getThawDate();
    String actualStr = actual.getLatestThaw();

    if (!expected.equals(actualStr)) {
      System.out.println("Expected: " + expected);
      System.out.println("Actual: " + actualStr);
      return false;
    }

    return true; // all tests passed
  }

  /**
   * Tests filtering freeze records by a range of years. 
   *
   * Ensure that only records between the specified years (inclusive) are present in the result.
   * 
   * @return true if all cases pass, false otherwise.
   */
  public static boolean testFilterByYear() {
    LakeRecord lr1 = new LakeRecord("2001-02", "December 16", "March 1", 70);
    LakeRecord lr2 = new LakeRecord("2002-03", "December 17", "March 2", 70);
    LakeRecord lr3 = new LakeRecord("2003-04", "December 18", "March 3", 71);
    LakeRecord lr4 = new LakeRecord("2004-05", "December 19", "March 4", 72);
    LakeRecord lr5 = new LakeRecord("2005-06", "December 20", "March 5", 73);

    FreezeTracker masterList = new FreezeTracker();
    masterList.add(lr1);
    masterList.add(lr2);
    masterList.add(lr3);
    masterList.add(lr4);
    masterList.add(lr5);

    FreezeTracker actual = masterList.filterByYear(2003, 2006);
    // System.out.println(actual);

    FreezeTracker expected = new FreezeTracker();
    expected.add(lr3);
    expected.add(lr4);
    expected.add(lr5);

    if (actual.size() != 3) {
      return false;
    }

    for (int i = 0; i < 3; ++i) {
      if (!actual.get(i).equals(expected.get(i))) {
        return false;
      }
    }

    return true; // tests pass
  }

  /**
   * Tests filtering freeze records by a range of ice cover duration values. 
   * 
   * Ensure that only records within the duration range are included in the filtered list.
   * 
   * @return true if all cases pass, false otherwise.
   */
  public static boolean testFilterByDuration() {
    LakeRecord lr1 = new LakeRecord("2001-02", "December 16", "March 1", 70);
    LakeRecord lr2 = new LakeRecord("2002-03", "December 17", "March 2", 70);
    LakeRecord lr3 = new LakeRecord("2003-04", "December 18", "March 3", 71);
    LakeRecord lr4 = new LakeRecord("2004-05", "December 19", "March 4", 72);
    LakeRecord lr5 = new LakeRecord("2005-06", "December 20", "March 5", 73);

    FreezeTracker masterList = new FreezeTracker();
    masterList.add(lr1);
    masterList.add(lr2);
    masterList.add(lr3);
    masterList.add(lr4);
    masterList.add(lr5);

    FreezeTracker actual = masterList.filterByDuration(71, 72);
    // System.out.println(actual);

    FreezeTracker expected = new FreezeTracker();
    expected.add(lr3);
    expected.add(lr4);

    if (actual.size() != 2) {
      return false;
    }

    for (int i = 0; i < 2; ++i) {
      if (!actual.get(i).equals(expected.get(i))) {
        return false;
      }
    }

    return true; // tests pass
  }

  /**
   * Main Method to Launch the tester methods.
   * 
   * @param args list of inputs if any.
   */
  public static void main(String[] args) {
    System.out.println("Running tests:");
    System.out.println("testAdd(): " + (testAdd() ? "PASSED" : "FAILED"));
    System.out.println("testRemove(): " + (testRemove() ? "PASSED" : "FAILED"));
    System.out.println("testRemoveOnly(): " + (testRemoveOnly() ? "PASSED" : "FAILED"));
    System.out
        .println("testRemoveDoesNotExist(): " + (testRemoveDoesNotExist() ? "PASSED" : "FAILED"));
    System.out.println("testIterators(): " + (testIterators() ? "PASSED" : "FAILED"));
    System.out.println("testMergeWinters(): " + (testMergeWinters() ? "PASSED" : "FAILED"));
    System.out.println("testCleanData(): " + (testCleanData() ? "PASSED" : "FAILED"));
    System.out.println(
        "testAverageFreezeDuration(): " + (testAverageFreezeDuration() ? "PASSED" : "FAILED"));
    System.out
        .println("testMaxFreezeDuration(): " + (testMaxFreezeDuration() ? "PASSED" : "FAILED"));
    System.out
        .println("testMinFreezeDuration(): " + (testMinFreezeDuration() ? "PASSED" : "FAILED"));
    System.out
        .println("testGetEarliestFreeze(): " + (testGetEarliestFreeze() ? "PASSED" : "FAILED"));
    System.out.println("testGetLatestThaw(): " + (testGetLatestThaw() ? "PASSED" : "FAILED"));
    System.out.println("testFilterByYear(): " + (testFilterByYear() ? "PASSED" : "FAILED"));
    System.out.println("testFilterByDuration(): " + (testFilterByDuration() ? "PASSED" : "FAILED"));

    boolean allTestsPassed =
        testAdd() && testRemove() && testRemoveOnly() && testRemoveDoesNotExist() && testIterators()
            && testMergeWinters() && testCleanData() && testAverageFreezeDuration()
            && testMaxFreezeDuration() && testMinFreezeDuration() && testGetEarliestFreeze()
            && testGetLatestThaw() && testFilterByYear() && testFilterByDuration();
    System.out.println("ALL TESTS: " + (allTestsPassed ? "PASSED" : "FAILED"));
  }
}
