// PROVIDED FILE -- DO NOT SUBMIT TO GRADESCOPE

/**
 * This class models a single element of a linked list. Every linked node has data and a reference to
 * the next node in the list.
 *
 * @param <T> the type of data stored in this node
 */
public class LinkedNode<T> {
  /**
   * data stored in this node
   */
  private T data; // Data contained within this node.

  /**
   * Reference to the next node in the list, or null if this is the last node.
   */
  private LinkedNode<T> next;// Reference to the next node in the list

  /**
   * Constructs a new LinkedNode with the specified data. The next reference is set by default to null.
   *
   * @param data the data to store in this node.
   */
  public LinkedNode(T data) {
    this.data = data;
  }

  /**
   * Constructs a new LinkedNode with the specified data and next node reference.
   *
   * @param data the data to store in this node.
   * @param next the reference to the next node in the list.
   */
  public LinkedNode(T data, LinkedNode<T> next) {
    this.data = data;
    this.next = next;
  }

  /**
   * Returns the data stored in this node.
   *
   * @return the data stored in this node
   */

  public T getData() {
    return data;
  }

  //

  /**
   * Returns the next node in the list
   *
   * @return the next node in the list
   */
  public LinkedNode<T> getNext() {
    return next;
  }


  /**
   * Sets the reference to the next node in the list
   *
   * @param next the next node to set
   */
  public void setNext(LinkedNode<T> next) {
    this.next = next;
  }

  /**
   * Compares this LinkedNode to the specified object for equality. The result is true if and only if: <BR>
   *   The argument is not null <BR>
   *   The argument is an instance of LinkedNode <BR>
   *   The data fields are equal <BR>
   *   The next fields are deeply equal
   *
   * @param o The object to compare this LinkedNode against
   * @return true if the given object represents a LinkedNode equivalent to this node, false
   *         otherwise
   */
  @Override
  public boolean equals(Object o) {
    // ensure o is an instance of LinkedNode
    if (o instanceof LinkedNode<?>) {
      LinkedNode<T> other = (LinkedNode) o;
      // check for deep equality
      return this.equalsHelper(other);
    }

    return false; // o is not a LinkedNode
  }

  /**
   * Recursively compares this node to another LinkedNode to check for deep equality.<BR>
   * Two nodes are deeply equal if: <BR>
   *  They contain equal data values, AND <BR>
   *  Both have next references that are either null or deeply equal
   *
   * @param other The LinkedNode to compare against
   * @return true if this node is deeply equal to the specified node, false otherwise.
   */
  protected boolean equalsHelper(LinkedNode<T> other) {
    // base case: this node has no next. Check if other is also a single-node equivalent
    if(this.next == null){
      return this.data.equals(other.data) && other.next == null;
    }

    // recursive case: This node has a non-null next node in the list
    // Ensure both nodes must have equal data and their next nodes must be deeply equal
    return this.data.equals(other.data) && other.next != null && this.next.equalsHelper(other.next);
  }

  /**
   * Return a string representation of this linked node.
   * @return a string representation of this linked node
   */
  @Override
  public String toString(){
    String s = this.data.toString();
    if(this.next != null) // node connected to next when in the list
      s += " -> ";
    return s;
  }

}
