// DO NOT SUBMIT THIS JAVA FILE TO GRADESCOPE
// DO NOT MAKE CHANGES TO THIS PROVIDED CLASS
/**
 * A class to model a book as part of an inventory.
 */
public class Book {

  // Instance fields
  /**
   * Unique identifier of this book
   */
  private final int ID; // unique identifier of this book

  /**
   * Next unique identifier not yet assigned to a book
   */
  private static int nextBookID = 0; // next unique identifier not yet assigned to a book

  /**
   * Name of the author of this book
   */
  private String author; // name of the author of this book

  /**
   * Title of this book
   */
  private String title; // title of this book

  /**
   * card bar code of the borrower of this book.  When borrowerCardBarCode == null,
   * the book is available (no one has the book).
   */
  private Integer borrowerCardBarCode; // card bar code of the borrower of this book
                                       // When borrowerCardBarCode == null, the book is available
                                       // (no one has the book)

  /**
   * Helper method to generate a unique identifier
   *
   * @return the next unique identifier
   */
  private static int getNextBookID() {
    nextBookID++;
    return nextBookID;
  }

  /**
   * Constructs a new Book object and initializes its instance fields
   * 
   * @param title title of this book
   * @param author author of this book
   */
  public Book(String title, String author) {
    this.title = title;
    this.author = author;
    borrowerCardBarCode = null; // initially, no one has the book
    this.ID = getNextBookID();
  }

  /**
   * Returns the author of this book
   * 
   * @return the author
   */
  public String getAuthor() {
    return author;
  }

  /**
   * Returns the title of this book
   * 
   * @return the title
   */
  public String getTitle() {
    return title;
  }

  /**
   * Returns the borrower's card bar code of this book if the book has been checked out or null
   * if not
   * 
   * @return the borrowerCardBarCode
   */
  public Integer getBorrowerCardBarCode() {
    return borrowerCardBarCode;
  }


  /**
   * Returns the ID of this Book object
   * 
   * @return the ID of this Book object
   */
  public int getID() {
    return ID;
  }

  /**
   * Assigns the specified borrower's card bar code to this book, indicating that it has been borrowed,
   * but only if the book is currently available. If the book is not available, this method makes no changes.
   *
   * @param borrowerCardBarCode the card bar code of the borrower attempting to borrow the book
   */
  public void borrowBook(Integer borrowerCardBarCode) {
    if (isAvailable())
      this.borrowerCardBarCode = borrowerCardBarCode;
  }

  /**
   * Marks this book as available by setting the borrowerCardBarCode to {@code null}, indicating that
   * it is no longer being borrowed.
   */
  public void returnBook() {
    this.borrowerCardBarCode = null;
  }

  /**
   * Checks whether this book is available
   * 
   * @return true if no one is borrowing this book, false otherwise
   */
  public boolean isAvailable() {
    return borrowerCardBarCode == null;
  }

  /**
   * This method resets the book identifier generation process. It is recommended to call this
   * method for testing purposes ONLY.
   */
  protected static void resetBookId() {
    nextBookID = 0;
  }

  /**
   * Returns a String representation of this book
   *
   * @return a String representation of this book
   */
  @Override
  public String toString(){
    return "<Book ID>: " + this.ID + " " + "<Title>: " + this.title + " " + "<Author>: " +
        this.author + " " + "<Is Available>: " + this.isAvailable();
  }
}
