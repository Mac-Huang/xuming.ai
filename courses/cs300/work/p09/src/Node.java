/**
 * // DO NOT SUBMIT THIS SOURCE FILE TO GRADESCOPE
 *
 * Generic class implementing a Binary Node of a Binary Search Tree (BST)
 *
 * @param <T> type of the data carried by this binary node
 */
public class Node<T extends Comparable<T>> {
  private T data; // data in the node field
  private Node<T> left; // reference to the left child
  private Node<T> right; // reference to the right child


  /** 
   * Creates a Node with a given data value
   *
   * @param data data carried by this binary node
   * @throws NullPointerException if data is null
   */
  public Node(T data) {
    if (data == null)
      throw new NullPointerException("Invalid data: CANNOT be null.");
    this.data = data;
  }

  /**
   * Creates a Node with given data value, a reference to a left child (left BST subtree) and a
   * reference to a right child (right BST sub-tree).
   *
   * @param data  element held by this binary node
   * @param left  reference to the left child
   * @param right reference to the right child
   * @throws NullPointerException if data is null
   */
  public Node(T data, Node<T> left, Node<T> right) {
    if (data == null)
      throw new NullPointerException("Invalid data: CANNOT be null.");
    this.data = data;
    this.left = left;
    this.right = right;
  }

  /**
   * Getter of the data field
   *
   * @return the data stored in this node
   */
  public T getData() {
    return data;
  }

  /**
   * Getter of the left child
   *
   * @return the left child of this node
   */
  public Node<T> getLeft() {
    return left;
  }

  /**
   * Setter for the left child
   *
   * @param left the left to set
   */
  public void setLeft(Node<T> left) {
    this.left = left;
  }

  /**
   * Getter of the right child
   *
   * @return the right child of this node
   */
  public Node<T> getRight() {
    return right;
  }

  /**
   * Setter for the right child
   *
   * @param right the right to set
   */
  public void setRight(Node<T> right) {
    this.right = right;
  }

  /**
   * Indicates whether some other object is of type Node and is "deeply equal to" this one.
   * @param obj the reference object with which to compare.
   * @return true if the reference object is instance of LinkedNode and is the same as this node;
   *         false otherwise.
   */
  @Override
  public boolean equals(Object obj) {
    // ensures obj is instance of Node
    if(!(obj instanceof Node))
      return false;
    // ensure this node is deeply equal to the node represented by obj
    return equalsHelper((Node)obj);
  }

  /**
   * Recursive Helper method to compare this node to another node.
   * @param other other node to which this node is compared to.
   * @return true if this node is deeply equal to other node, false otherwise.
   */
  private boolean equalsHelper(Node<T> other){
    // ensure data stored at both nodes are equal
    if(other == null || !this.data.equals(other.data) )
      return false;

    // this node is a leaf node
    if(this.left == null && this.right == null)
      return other.left == null && other.right == null;

    // this node has only one child (right child)
    if(this.left == null)
      return other.left == null && this.right.equalsHelper(other.right);

    // this node has only one child (left child)
    if(this.right == null)
      return other.right == null && this.left.equalsHelper(other.left);

    // this node has two children
    return this.left.equalsHelper(other.left) && this.right.equalsHelper(other.right);
  }

}
