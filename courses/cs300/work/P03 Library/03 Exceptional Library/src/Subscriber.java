// DO NOT SUBMIT THIS JAVA FILE TO GRADESCOPE
// DO NOT MAKE CHANGES TO THIS PROVIDED CLASS

import java.util.ArrayList;

/**
 * This class models a public library subscriber. A subscriber is a card holder who can borrow
 * (checkout) and return library books
 */
public class Subscriber {
  /**
   * initial card bar code assigned
   */
  private final static int CARD_BAR_CODE_INIT = 2025000001; // initial card bar code assigned

  /**
   * last card bar code that can be issued
   */
  private final static int CARD_BAR_CODE_LAST = 2025999999; // last card bar code that can be assigned

  /**
   * maximum number of books to be borrowed by one subscriber
   */
  private final static int MAX_BOOKS_CHECKED_OUT = 10; // maximum number of books to be borrowed by one subscriber

  /**
   * The card bar code to be assigned to the next subscriber to be created
   */
  private static int nextCardBarCode = CARD_BAR_CODE_INIT; // class variable that represents the
  // card bar
  // code of the next subscriber to be created

  // 4-digits Personal Identification Number to verify the identity of this subscriber.
  // The most significant digit (the digit at the 4th position from the right) MUST NOT be zero
  /**
   * 4-digits Personal Identification Number to verify the identity of this subscriber.
   */
  private int pin;

  /**
   * Bar code of the library card of this subscriber
   */
  private final Integer CARD_BAR_CODE; // bar code of the library card of this subscriber

  /**
   * Name of this subscriber
   */
  private String name; // name of this subscriber

  /**
   * Home address of this subscriber
   */
  private String address; // address of this subscriber

  /**
   * list of books checked out by this subscriber and not yet returned.
   * A subscriber can borrow at most MAX_BOOKS_CHECKED_OUT books.
   */
  private ArrayList<Book> booksCheckedOut; // list of books checked out by this subscriber
  // and not yet returned. A subscriber can have at most MAX_BOOKS_CHECKED_OUT books checked out

  /**
   * History list of the books returned by this subscriber
   */
  private ArrayList<Book> booksReturned; // history list of the books returned by this
  // subscriber

  /**
   * Creates a new subscriber with given name, address, and phone number, and initializes its other
   * instance fields
   *
   * @param name    name of this subscriber
   * @param pin     4-digits personal information number of this subscriber
   * @param address address of this subscriber
   * @throws InstantiationException if no new card CARD_BAR_CODE can be issued to the new potential
   *                                subscriber
   */
  public Subscriber(String name, int pin, String address) throws InstantiationException {
    // if no new library card can be issued, throw an exception
    if (nextCardBarCode > CARD_BAR_CODE_LAST) {
      throw new InstantiationException(
          "Error: CANNOT create a new subscriber. No more card can be issued.");
    }
    // create a new Subscriber and assign the instance fields
    this.name = name;
    this.pin = pin;
    this.address = address;
    CARD_BAR_CODE = nextCardBarCode;
    nextCardBarCode++;
    booksCheckedOut = new ArrayList<Book>(MAX_BOOKS_CHECKED_OUT);
    booksReturned = new ArrayList<Book>();

  }

  /**
   * Returns this subscriber's address
   *
   * @return the home address of this subscriber
   */
  public String getAddress() {
    return address;
  }

  /**
   * Updates this subscriber's address
   *
   * @param address the address to set
   */
  public void setAddress(String address) {
    this.address = address;
  }

  /**
   * Returns this subscriber PIN (4-digits Personal Identification Number)
   *
   * @return the pin
   */
  public int getPin() {
    return pin;
  }

  /**
   * Returns this subscriber's card bar code
   *
   * @return the CARD_BAR_CODE
   */
  public Integer getCARD_BAR_CODE() {
    return CARD_BAR_CODE;
  }

  /**
   * Returns this subscriber's name
   *
   * @return the name
   */
  public String getName() {
    return name;
  }


  /**
   * Checks out an available book. The checkout operation fails if the maximum number of checked out
   * books by this subscriber is already reached
   *
   * @param book reference to the book to be checked out by this subscriber
   */
  public void checkoutBook(Book book) {
    if (book.isAvailable()) // check if the book is available
      // If the subscriber did not exceed the limit of MAX_BOOKS_CHECKED_OUT -> checkout the book
      if (booksCheckedOut.size() < MAX_BOOKS_CHECKED_OUT) {
        booksCheckedOut.add(book);
        book.borrowBook(this.CARD_BAR_CODE);
      } else { // maximum number of books checked out reached
        System.out.println(
            "Checkout Failed: You cannot check out more than " + MAX_BOOKS_CHECKED_OUT + "books.");
      }
    else { // book is not available
      if (booksCheckedOut.contains(book)) // the subscriber has already checked out the book
        System.out.println("You have already checked out " + book.getTitle() + " book.");
      else // another subscriber has checked out the book
        System.out.println("Sorry, " + book.getTitle() + " is not available.");
    }
  }

  /**
   * Returns a library book. The method prints an error message and returns false if the subscriber
   * attempts to return a book they did not borrow.
   *
   * @param book reference to the book to return by this subscriber
   * @return true if the specified book was successfully returned, and false if the subscriber
   * attempts to return a book they did not borrow.
   */
  public boolean returnBook(Book book) {
    // subscriber attempts to return a book they did not borrow
    if (!hasCheckedOut(book)) {
      // display an error message and return false
      System.out.println(
          "Sorry, you cannot return this book. It is not in your booksCheckedOut list.");
      return false;
    }
    // return the borrowed book and update the inventory accordingly
    booksReturned.add(book);
    booksCheckedOut.remove(book);
    book.returnBook();
    return true;

  }

  /**
   * Checks if this subscriber has already checked out a given book
   *
   * @param book book to check if it is within this subscriber booksCheckedOut list
   * @return true if booksCheckedOut contains book, false otherwise
   */
  public boolean hasCheckedOut(Book book) {
    return booksCheckedOut.contains(book);
  }

  /**
   * Checks if this subscriber has returned a given book
   *
   * @param book book to check if it is within this subscriber booksReturned list
   * @return true if booksReturned contains book, false otherwise
   */
  public boolean hasReturned(Book book) {
    return booksReturned.contains(book);
  }

  /**
   * Returns a perfect-size array that contains the list of books currently borrowed (meaning, books
   * checked out by this subscriber, and not yet returned)
   *
   * @return a perfect-size array that contains the list of books checked out by this subscriber,
   * and null if this subscriber have no books checked out and not yet returned
   */
  public Book[] getBorrowedBooks() {
    // return null if the list of booksCheckedOut is empty
    if (this.booksCheckedOut.isEmpty()) {
      return null;
    }
    // booksCheckedOut not empty -> traverse the list and copy its contents into an array of books
    Book[] books = new Book[this.booksCheckedOut.size()];
    for (int i = 0; i < booksCheckedOut.size(); i++) {
      books[i] = booksCheckedOut.get(i);
    }
    return books;
  }

  /**
   * Returns a perfect-size array that contains the list of books returned this subscriber
   *
   * @return a perfect-size array that contains the list of books returned by this subscriber, and
   * null if this subscriber have not returned any book yet
   */
  public Book[] getReturnedBooks() {
    // return null if the list of returned books is empty
    if (this.booksReturned.isEmpty()) {
      return null;
    }
    // booksReturned not empty -> traverse the list and copy its contents into an array of books
    Book[] books = new Book[this.booksReturned.size()];
    for (int i = 0; i < booksReturned.size(); i++) {
      books[i] = booksReturned.get(i);
    }
    return books;
  }


  /**
   * Returns a String representation of this subscriber in the following format:
   *
   * name (CARD_BAR_CODE): address
   *
   * @return a String representation of this Subscriber
   */
  @Override
  public String toString() {
    return this.name + " (" + this.CARD_BAR_CODE + " ): " + this.address;
  }

}
