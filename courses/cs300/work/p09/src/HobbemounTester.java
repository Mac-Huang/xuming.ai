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

import java.util.NoSuchElementException;
import java.util.Iterator;

/**
 * Tester class to test the implementations of the HobbemounTree class.
 */
public class HobbemounTester {

  /**
   * Tests the compareTo method when comparing Hobbemouns with different type values
   *
   * @return true if test passes, false otherwise
   */
  public static boolean testCompareToByType() {
    { // Primary types differ

      // hobb1 should be larger
      Hobbemoun hobb1 = new Hobbemoun(HobbemounType.DRAGON, HobbemounType.GHOST, "hobb1");
      Hobbemoun hobb2 = new Hobbemoun(HobbemounType.BUG, HobbemounType.GHOST, "hobb2");

      if (hobb1.compareTo(hobb2) <= 0)
        return false;
      if (hobb2.compareTo(hobb1) > 0)
        return false;
    }

    { // Secondary types differ
      // hobb1 should be larger
      Hobbemoun hobb1 = new Hobbemoun(HobbemounType.DRAGON, HobbemounType.NORMAL, "hobb1");
      Hobbemoun hobb2 = new Hobbemoun(HobbemounType.DRAGON, HobbemounType.WATER, "hobb2");

      if (hobb1.compareTo(hobb2) <= 0)
        return false;
      if (hobb2.compareTo(hobb1) > 0)
        return false;
    }

    return true;

  }

  /**
   * Tests the compareTo method when comparing Hobbemouns with same type values but different names
   *
   * @return true if test passes, false otherwise
   */
  public static boolean testCompareToByName() {
    // hobb1 should be larger
    Hobbemoun hobb1 = new Hobbemoun(HobbemounType.DRAGON, HobbemounType.NORMAL, "hobb");
    Hobbemoun hobb2 = new Hobbemoun(HobbemounType.DRAGON, HobbemounType.NORMAL, "hob");

    if (hobb1.compareTo(hobb2) <= 0)
      return false;
    if (hobb2.compareTo(hobb1) > 0)
      return false;

    return true;
  }

  public static boolean testCompareToSame() {
    Hobbemoun hobb1 = new Hobbemoun(HobbemounType.DRAGON, HobbemounType.NORMAL, "hobb");
    Hobbemoun hobb2 = new Hobbemoun(HobbemounType.DRAGON, HobbemounType.NORMAL, "hobb");

    if (hobb1.compareTo(hobb2) < 0)
      return false;
    if (hobb2.compareTo(hobb1) > 0)
      return false;
    if (hobb1.compareTo(hobb1) != 0) {
      return false;
    }

    return true;

  }

  /**
   * Tests that isEmpty returns true for an empty tree and false for a non-empty tree.
   *
   * @return true if the test passes, false otherwise
   */
  public static boolean testIsEmpty() {
    { // Testing in an empty subtree
      HobbemounTree tree = new HobbemounTree();
      if (!tree.isEmpty()) {
        return false;
      }

    }

    { // Testing a non-empty subtree
      HobbemounTree tree = new HobbemounTree();
      tree.insert(new Hobbemoun("hobbert"));

      if (tree.isEmpty()) {
        return false;
      }
    }

    return true;
  }

  /**
   * Tests that size returns the correct number of Hobbemoun objects in the tree.
   *
   * @return true if the test passes, false otherwise
   */
  public static boolean testSize() {
    HobbemounTree tree = new HobbemounTree();

    if (tree.size() != 0)
      return false;
    tree.insert(new Hobbemoun("hobb1"));

    if (tree.size() != 1)
      return false;

    tree.insert(new Hobbemoun("hobb2"));
    tree.insert(new Hobbemoun("hobb3"));
    tree.insert(new Hobbemoun("hobb4"));
    tree.insert(new Hobbemoun("hobb5"));
    tree.insert(new Hobbemoun("hobb6"));

    if (tree.size() != 6)
      return false;

    return true;
  }

  /**
   * Tests that isValidBST returns true for an empty BST.
   *
   * @return true if the test passes, false otherwise
   */
  public static boolean testIsValidBSTEmpty() {
    return HobbemounTree.isValidBST(null);
  }

  /**
   * Tests that isValidBST returns true for a valid BST. Should use a tree with depth > 2.
   *
   * @return true if the test passes, false otherwise
   */
  public static boolean testIsValidBSTValid() {
    Hobbemoun hobb2 = new Hobbemoun(HobbemounType.DRAGON, null, "hobb2"); // Root
    Hobbemoun hobb3 = new Hobbemoun(HobbemounType.BUG, null, "hobb3"); // Should be left
    Hobbemoun hobb4 = new Hobbemoun(HobbemounType.NORMAL, null, "hobb4"); // Should be right

    Node<Hobbemoun> leftNode = new Node<>(hobb3);
    Node<Hobbemoun> rightNode = new Node<>(hobb4);
    Node<Hobbemoun> rootNode = new Node<>(hobb2);
    rootNode.setLeft(leftNode);
    rootNode.setRight(rightNode);


    HobbemounTree tree = new HobbemounTree(rootNode);

    boolean fullTest = HobbemounTree.isValidBST(tree.getRoot());
    return fullTest;
  }

  /**
   * Tests that isValidBST returns false for an invalid BST. Should use a tree with depth > 2 and
   * include a case where the left subtree contains a node greater than the right subtree.
   *
   * @return true if the test passes, false otherwise
   */
  public static boolean testIsValidBSTInvalid() {

    Hobbemoun root = new Hobbemoun(HobbemounType.DRAGON, null, "root"); // 3 (valid root)

    // Left subtree - should all be < 3
    // 1 (valid)
    Hobbemoun left = new Hobbemoun(HobbemounType.BUG, null, "left");
    // 5 (INVALID - should be < 3)
    Hobbemoun leftRight = new Hobbemoun(HobbemounType.NORMAL, null, "leftRight");

    // Right subtree - should all be > 3
    Hobbemoun right = new Hobbemoun(HobbemounType.NORMAL, null, "right"); // 5 (valid)
    // 1 (INVALID - should be > 3)
    Hobbemoun rightLeft = new Hobbemoun(HobbemounType.BUG, null, "rightLeft");


    // Build the tree structure with invalid nodes deeper in the tree
    Node<Hobbemoun> leftRightNode = new Node<>(leftRight);
    Node<Hobbemoun> leftNode = new Node<>(left, null, leftRightNode);

    Node<Hobbemoun> rightLeftNode = new Node<>(rightLeft);
    Node<Hobbemoun> rightNode = new Node<>(right, rightLeftNode, null);

    Node<Hobbemoun> rootNode = new Node<>(root, leftNode, rightNode);

    // Test should fail if the tree is incorrectly marked as valid
    return !HobbemounTree.isValidBST(rootNode);


  }

  /**
   * Tests that insert throws IllegalArgumentException when given null
   *
   * @return true if the test passes, false otherwise
   */
  public static boolean testInsertNullException() {

    try {
      HobbemounTree test = new HobbemounTree();
      test.insert(null);
      // need to catch IllegalArgumentException
      return false;
    } catch (IllegalArgumentException e) {
      // should happen
      return true;
    } catch (Exception e) {
      // wrong exception
      return false;
    }
  }

  /**
   * Tests that insert correctly adds a Hobbemoun to an empty tree.
   *
   * @return true if the test passes, false otherwise
   */
  public static boolean testInsertEmpty() {
    HobbemounTree test = new HobbemounTree();
    Hobbemoun hobb1 = new Hobbemoun(1, 2);

    // checks insert
    if (!test.insert(hobb1)) {
      return false;
    }

    // checks size
    if (test.size() != 1) {
      return false;
    }

    if (test.getRoot() == null || !test.getRoot().getData().equals(hobb1)) {
      return false;
    }

    return true;
  }

  /**
   * Tests that insert correctly adds multiple Hobbemoun objects to a non-empty tree.
   *
   * @return true if the test passes, false otherwise
   */
  public static boolean testInsertMultiple() {
    HobbemounTree test = new HobbemounTree();

    Hobbemoun hobb1 = new Hobbemoun(HobbemounType.BUG, null, "hobb1");
    Hobbemoun hobb2 = new Hobbemoun(HobbemounType.FIRE, null, "hobb2");
    Hobbemoun hobb3 = new Hobbemoun(HobbemounType.NORMAL, null, "hobb3");

    // checks insert
    if (!test.insert(hobb2) || !test.insert(hobb1) || !test.insert(hobb3)) {
      return false;
    }

    // checks size
    if (test.size() != 3) {
      return false;
    }

    // checks valid BST
    if (!HobbemounTree.isValidBST(test.getRoot())) {
      return false;
    }

    // verify node positons -- Gradescope tester specific fix
    Node<Hobbemoun> root = test.getRoot();
    if (root == null)
      return false;

    // This should be true
    if (root.getData().compareTo(hobb2) == 0) {
      Node<Hobbemoun> left = root.getLeft();
      Node<Hobbemoun> right = root.getRight();

      // should have a left and left should be hobb1
      if (left == null || !left.getData().equals(hobb1)) {
        return false;
      }
      // should have a right and right should be hobb3
      if (right == null || !right.getData().equals(hobb3)) {
        return false;
      }

    } else {
      return false;
    }

    // checks ordering
    if (!test.getWeakest().equals(hobb1)) {
      return false;
    }
    if (!test.getStrongest().equals(hobb3)) {
      return false;
    }

    return true;
  }

  /**
   * Tests that insert returns false when adding a duplicate Hobbemoun.
   *
   * @return true if the test passes, false otherwise
   */
  public static boolean testInsertDuplicate() {
    HobbemounTree test = new HobbemounTree();
    Hobbemoun hobb1 = new Hobbemoun(1, 2);

    // checks insert
    if (!test.insert(hobb1)) {
      return false;
    }

    // checks if duplicate insert works
    if (test.insert(hobb1)) {
      return false;
    }

    // checks size
    if (test.size() != 1) {
      return false;
    }

    return true;
  }

  /**
   * Tests the lookup method for finding existing and non-existing Hobbemoun objects.
   *
   * @return true if the test passes, false otherwise
   */
  public static boolean testLookup() {
    HobbemounTree tree = new HobbemounTree();

    Hobbemoun hobb1 = new Hobbemoun(1, 2);
    Hobbemoun hobb2 = new Hobbemoun(3, 4);

    tree.insert(hobb1);
    tree.insert(hobb2);

    // checks lookup
    Hobbemoun look1 = tree.lookup(1, 2);
    if (look1 == null || !look1.equals(hobb1)) {
      return false;
    }

    Hobbemoun look2 = tree.lookup(3, 4);
    if (look2 == null || !look2.equals(hobb2)) {
      return false;
    }


    // checks lookup for something not there
    Hobbemoun not = tree.lookup(5, 6);
    if (not != null) {
      return false;
    }

    return true;
  }

  /**
   * Tests the height method for an empty tree, a single node tree, and a multi-level tree.
   *
   * @return true if the test passes, false otherwise
   */
  public static boolean testHeight() {
    {// check empty tree
      HobbemounTree test1 = new HobbemounTree();
      if (test1.height() != 0) {
        return false;
      }
    }

    {// checks single node tree
      HobbemounTree test2 = new HobbemounTree();
      test2.insert(new Hobbemoun(1, 2));
      if (test2.height() != 1) {
        return false;
      }
    }

    {// checks multi-level tree
      HobbemounTree test3 = new HobbemounTree();
      test3.insert(new Hobbemoun(HobbemounType.FIRE, null, "hobb1")); // Value 2
      test3.insert(new Hobbemoun(HobbemounType.BUG, null, "hobb2")); // Value 1
      test3.insert(new Hobbemoun(HobbemounType.NORMAL, null, "hobb3")); // Value 5

      if (test3.height() != 2) {
        return false;
      }

      test3.insert(new Hobbemoun(HobbemounType.NORMAL, null, "hobb4"));
      if (test3.height() != 3) {
        return false;
      }
    }

    return true;
  }

  /**
   * Tests the getStrongest method.
   *
   * @return true if the test passes, false otherwise
   */
  public static boolean testGetStrongest() {
    // checks empty tree
    HobbemounTree test1 = new HobbemounTree();
    if (test1.getStrongest() != null) {
      return false;
    }

    // checks tree with multiple nodes
    HobbemounTree test2 = new HobbemounTree();
    Hobbemoun hobb1 = new Hobbemoun(HobbemounType.BUG, null, "hobb1");
    Hobbemoun hobb2 = new Hobbemoun(HobbemounType.FIRE, null, "hobb2");
    Hobbemoun hobb3 = new Hobbemoun(HobbemounType.NORMAL, null, "hobb3");

    test2.insert(hobb2);
    test2.insert(hobb1);
    test2.insert(hobb3);

    // checks getStrongest
    Hobbemoun strong = test2.getStrongest();
    if (strong == null || !strong.equals(hobb3)) {
      return false;
    }

    return true;
  }

  /**
   * Tests the getWeakest method.
   *
   * @return true if the test passes, false otherwise
   */
  public static boolean testGetWeakest() {
    // checks empty tree
    HobbemounTree test1 = new HobbemounTree();
    if (test1.getWeakest() != null) {
      return false;
    }

    // checks tree with multiple nodes
    HobbemounTree test2 = new HobbemounTree();
    Hobbemoun hobb1 = new Hobbemoun(HobbemounType.BUG, null, "hobb1");
    Hobbemoun hobb2 = new Hobbemoun(HobbemounType.FIRE, null, "hobb2");
    Hobbemoun hobb3 = new Hobbemoun(HobbemounType.NORMAL, null, "hobb3");

    test2.insert(hobb2);
    test2.insert(hobb1);
    test2.insert(hobb3);

    // checks getWeakest
    Hobbemoun weak = test2.getWeakest();
    if (weak == null || !weak.equals(hobb1)) {
      return false;
    }

    return true;
  }

  /**
   * Tests that next returns the successor of the given Hobbemoun.
   *
   * @return true if the test passes, false otherwise
   */
  public static boolean testNext() {
    // setting up hobbemoun
    Hobbemoun hobbVal3 = new Hobbemoun(HobbemounType.ICE, null, "val3");
    Hobbemoun hobbVal1 = new Hobbemoun(HobbemounType.BUG, null, "val1");
    Hobbemoun hobbVal2 = new Hobbemoun(HobbemounType.FIRE, null, "val2");
    Hobbemoun hobbVal4 = new Hobbemoun(HobbemounType.ELECTRIC, null, "val4");
    Hobbemoun hobbVal5 = new Hobbemoun(HobbemounType.NORMAL, null, "val5");

    Node<Hobbemoun> left = new Node(hobbVal1);

    Node<Hobbemoun> rightLeft = new Node(hobbVal3);
    Node<Hobbemoun> rightRight = new Node(hobbVal5);
    Node<Hobbemoun> right = new Node(hobbVal4, rightLeft, rightRight);

    Node<Hobbemoun> root = new Node(hobbVal2, left, right);

    HobbemounTree tree = new HobbemounTree(root);

    if (tree.next(root.getData()).compareTo(hobbVal3) != 0) {
      return false;
    }

    return true;
  }

  /**
   * Tests that next throws IllegalArgumentException when given a null argument.
   *
   * @return true if the test passes, false otherwise
   */
  public static boolean testNextExceptionEmpty() {
    HobbemounTree test = new HobbemounTree();

    try {
      test.next(null);
      // should throw exception
      return false;
    } catch (IllegalArgumentException e) {
      // should happen
      return true;
    } catch (Exception e) {
      // wrong exception
      return false;
    }
  }

  /**
   * Tests that next returns null when the Hobbemoun has no successor.
   *
   * @return true if the test passes, false otherwise
   */
  public static boolean testNextNoSuccessor() {
    HobbemounTree test = new HobbemounTree();

    Hobbemoun hobb1 = new Hobbemoun(HobbemounType.BUG, null, "hobb1");
    Hobbemoun hobb2 = new Hobbemoun(HobbemounType.FIRE, null, "hobb2");
    Hobbemoun hobb3 = new Hobbemoun(HobbemounType.NORMAL, null, "hobb3");

    test.insert(hobb2);
    test.insert(hobb1);
    test.insert(hobb3);

    // checks if there is successor
    Hobbemoun successor = test.next(hobb3);
    if (successor != null) {
      return false;
    }
    
    return true;
  }

  /**
   * Tests that the iterator works correctly by checking if it returns the correct elements in
   * order.
   *
   * @return true if the test passes, false otherwise
   */
  public static boolean testIterator() {
    HobbemounTree test = new HobbemounTree();

    Hobbemoun hobb1 = new Hobbemoun(HobbemounType.BUG, null, "hobb1");
    Hobbemoun hobb2 = new Hobbemoun(HobbemounType.FIRE, null, "hobb2");
    Hobbemoun hobb3 = new Hobbemoun(HobbemounType.NORMAL, null, "hobb3");

    test.insert(hobb1);
    test.insert(hobb2);
    test.insert(hobb3);

    Iterator<Hobbemoun> iterator = test.iterator();


    if (!iterator.hasNext() || !iterator.next().equals(hobb1)) {
      return false;
    }

    if (!iterator.hasNext() || !iterator.next().equals(hobb2)) {
      return false;
    }

    if (!iterator.hasNext() || !iterator.next().equals(hobb3)) {
      return false;
    }

    if (iterator.hasNext()) {
      return false;
    }

    return true;
  }

  /**
   * Tests that the iterator throws NoSuchElementException when there are no more elements to
   * return.
   *
   * @return true if the test passes, false otherwise
   */
  public static boolean testIteratorNoSuchElement() {
    HobbemounTree test = new HobbemounTree();

    test.insert(new Hobbemoun(1, 2));

    Iterator<Hobbemoun> iterator = test.iterator();
    iterator.next();

    try {
      iterator.next();
      return false;
    } catch (NoSuchElementException e) {
      // should happen
      return true;
    } catch (Exception e) {
      return false;
    }
  }

  /**
   * Tests that the iterator is empty when the tree is empty. hasNext should return false and next()
   * should throw NoSuchElementException.
   *
   * @return true if the test passes, false otherwise
   */
  public static boolean testIteratorEmpty() {
    HobbemounTree test = new HobbemounTree();

    Iterator<Hobbemoun> iterator = test.iterator();

    // empty so has no next
    if (iterator.hasNext()) {
      return false;
    }

    try {
      iterator.next();
      return false;
    } catch (NoSuchElementException e) {
      // should happen
      return true;
    } catch (Exception e) {
      return false;
    }
  }

  /**
   * Main method to run all tests
   */
  public static void main(String[] args) {

    System.out.println("Testing Hobbemoun implementation...");

    System.out.println("testCompareToByType: " + testCompareToByType());
    System.out.println("testCompareToByName: " + testCompareToByName());
    System.out.println("testCompareToSame: " + testCompareToSame());
    System.out.println("\nTesting HobbemounTree implementation...");
    System.out.println("testIsEmpty: " + testIsEmpty());
    System.out.println("testSize: " + testSize());
    System.out.println("testIsValidBSTEmpty: " + testIsValidBSTEmpty());
    System.out.println("testIsValidBSTValid: " + testIsValidBSTValid());
    System.out.println("testIsValidBSTInvalid: " + testIsValidBSTInvalid());
    System.out.println("testInsertNullException: " + testInsertNullException());
    System.out.println("testInsertEmpty: " + testInsertEmpty());
    System.out.println("testInsertMultiple: " + testInsertMultiple());
    System.out.println("testInsertDuplicate: " + testInsertDuplicate());
    System.out.println("testLookup: " + testLookup());
    System.out.println("testHeight: " + testHeight());
    System.out.println("testGetStrongest: " + testGetStrongest());
    System.out.println("testGetWeakest: " + testGetWeakest());
    System.out.println("testNext: " + testNext());
    System.out.println("testNextExceptionEmpty: " + testNextExceptionEmpty());
    System.out.println("testNextNoSuccessor: " + testNextNoSuccessor());
    System.out.println("testIterator: " + testIterator());
    System.out.println("testIteratorExceptions: " + testIteratorNoSuchElement());
    System.out.println("testIteratorEmpty: " + testIteratorEmpty());

  }
}
