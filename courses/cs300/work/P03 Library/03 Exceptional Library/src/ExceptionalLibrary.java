//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title:    Exceptional Library Utility
// Course:   CS 300 Spring 2025
//
// Author:   Jake Christofferson
// Email:    ejchristoffe@wisc.edu
// Lecturer: Mouna Kacem
//
//////////////////////// ASSISTANCE/HELP CITATIONS ////////////////////////////
//
// Persons:         NONE
// Online Sources:  
//  - https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/io/
//    PrintWriter.html#write(char%5B%5D)
//    Helped me with understanding the PrintWriter class and its instantiable 
//    methods and how to write to a File.
//
//  - https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/util/Scanner.html
//    Helped me with understanding the Scanner class and its instantiable 
//    methods like next() vs nextLine().
//
//  - https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/lang/
//    String.html#contains(java.lang.CharSequence)
//    Helped me with understanding the String class and its instantiable 
//    methods especially the trim() method for the loadBooks method.
//
///////////////////////////////////////////////////////////////////////////////

import java.text.ParseException;
import java.util.ArrayList;
import java.util.NoSuchElementException;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.util.Scanner;

/**
 * This is a Utility class makes and manages books and subscribers in a library system. 
 * 
 * @author Jake Christofferson
 */
public class ExceptionalLibrary {

  /**
   * The list of books in the library's Inventory
   */
  private static ArrayList<Book> books = new ArrayList<Book>();

  /**
   * The list of Subscribers in the Library's system
   */
  private static ArrayList<Subscriber> subscribers = new ArrayList<Subscriber>();

  /**
   * Resets Library System to complete defaults, initializes new, empty ArrayLists for books and
   * subscribers as well as calls Books.resetBookID() to reset book ids.
   */
  public static void resetLibrarySystem() {
    // Resets the arrayLists
    books = new ArrayList<Book>();
    subscribers = new ArrayList<Subscriber>();

    // Reset Book IDs
    Book.resetBookId();
  }

  /**
   * Returns a perfect-size compact array of all books found in the books ArrayList
   * 
   * @return the compact perfect size array of books or null if ArrayList is empty.
   */
  public static Book[] getBooks() {
    Book[] bookArray = new Book[books.size()];

    // Makes sure books has a book in it
    if (books.size() == 0) {
      return null;
    }

    // Loop through adding all books to the new compact perfect-size array
    for (int i = 0; i < bookArray.length; ++i) {
      bookArray[i] = books.get(i);
    }

    return bookArray;
  }

  /**
   * Returns a perfect-size compact array of all subscribers found in the subscribers ArrayList
   * 
   * @return the compact perfect size array of subsribers or null if ArrayList is empty.
   */
  public static Subscriber[] getSubscribers() {
    Subscriber[] subscriberArray = new Subscriber[subscribers.size()];

    // Makes sure bsubscribers has a subscirber in it
    if (subscribers.size() == 0) {
      return null;
    }

    // Loop through adding all subscribers to the new compact perfect-size array
    for (int i = 0; i < subscriberArray.length; ++i) {
      subscriberArray[i] = subscribers.get(i);
    }

    return subscriberArray;
  }

  /**
   * Returns a string represetnation of the list of books currently in the invintory. No newLine
   * character at the end of the book list and all books are represented as the string
   * representation of a Book.
   * 
   * @return a String representation of all of the books or an empty string if there are no books
   *         available.
   */
  public static String getLibraryInventoryAsString() {
    String invAsString = "";
    // Makes sure books is not empty
    if (books.isEmpty()) {
      return "";
    }

    // Adds all books except the last book in the Array List
    for (int i = 0; i < books.size() - 1; ++i) {
      invAsString = invAsString + books.get(i).toString() + "\n";
    }
    invAsString = invAsString + books.get(books.size() - 1).toString();

    return invAsString;
  }

  /**
   * Adds a new book to the books ArrayList. If the book is successfully added, the message is
   * displayed: "The book " + title + " is successfully added to the library."
   * 
   * @param title,  the title of the Book to be added to inventory
   * @param author, the author of the Book to be added to inventory
   * @throws IllegalArgumentException, if title or author is null exception is thrown
   */
  public static void addBook(String title, String author) throws IllegalArgumentException {
    // Checks to see if title or author is null, if true throw excpetion
    if (author == null || title == null || author.trim().equals("") || title.trim().equals("")) {
      throw new IllegalArgumentException("Error: Invalid inputs!");
    }

    // Adds new book to existing Array
    Book newBook = new Book(title, author);
    books.add(newBook);
    System.out.println("The book " + title + " is successfully added to the library.");
  }

  /**
   * Removes Book from Library ArrayList of the given bookId.
   * 
   * @param bookId, the ID of the book to be removed.
   * @return a reference to the returned book if the bok was removed correctly.
   * @throws NoSuchElementException
   * @throws IllegalStateException
   */
  public static Book removeBook(int bookId) throws NoSuchElementException, IllegalStateException {
    Book returnBook = null;
    boolean bookReturned = false;
    for (int i = 0; i < books.size(); ++i) {

      // Finds book
      if (books.get(i).getID() == bookId) {

        // Checks if Avail
        if (books.get(i).isAvailable()) {
          returnBook = books.get(i);
          books.remove(i);
          bookReturned = true;
        } else {
          throw new IllegalStateException(
              "Book unavailable. It was checked out and not yet returned.");
        }
      }
    }

    if (!bookReturned) {
      throw new NoSuchElementException("Book not found");
    }

    return returnBook;
  }

  /**
   * Finds a book with the given book ID, if no book is found in the library a
   * NoSuchElementException gets thrown.
   * 
   * @param bookId, the ID of the book to be found.
   * @return a reference to the book object with the wanted ID or null if no book is found.
   * @throws NoSuchElementException if there is no book with the given ID found.
   */
  public static Book findBookById(int bookId) throws NoSuchElementException {
    Book returnBook = null;

    // Finds book with ID and assigns reference to returnBook
    for (int i = 0; i < books.size(); ++i) {

      if (books.get(i).getID() == bookId) {
        returnBook = books.get(i);
      }
    }

    // if return book is null, no book was found so an exception should be thrown
    if (returnBook != null) {
      return returnBook;

    } else {
      throw new NoSuchElementException("Book not found");
    }
  }

  /**
   * Finds all books with the given author and stores them in an ArrayList which is then returned to
   * user. If no books with given author are found, an empty array list is returned.
   * 
   * @param author, the author of books the user is searching for.
   * @return an arrayList full of the books of the given author or an empty ArrayList if no books of
   *         the given author were found.
   */
  public static ArrayList<Book> findBookByAuthor(String author) {

    ArrayList<Book> returnArray = new ArrayList<>(); // The array which will contain author's books

    for (int i = 0; i < books.size(); ++i) {

      if (books.get(i).getAuthor().equals(author)) { // If authors match, add to returnArray
        returnArray.add(books.get(i));
      }
    }

    return returnArray;
  }

  /**
   * Adds a new subscriber to the subscriber library list and displays the following message upon a
   * successful creation "Library card with bar code " + card_bar_code + " is successfully issued to
   * the new subscriber " + name + "."
   * 
   * @param name    the name of the new subscriber
   * @param pin     the pin of the new subscriber
   * @param address the address of the new subscriber
   * @throws InstantiationException   if there is an error creating a new subscriber
   * @throws ParseException           if there is an error parsing the pin string
   * @throws IllegalArgumentException if the name or address is either null or blank
   */
  public static void addSubscriber(String name, String pin, String address)
      throws InstantiationException, ParseException, IllegalArgumentException {
    if (name == null || name.equals("")) {
      throw new IllegalArgumentException("Error: Name is blank or null");
    }
    if (address == null || address.equals("")) {
      throw new IllegalArgumentException("Error: Address is blank or null");
    }


    Subscriber newSub = new Subscriber(name, parsePinCode(pin), address);
    subscribers.add(newSub);
    System.out.println("Library card with bar code " + newSub.getCARD_BAR_CODE()
        + " is successfully issued to the new subscriber " + name + ".");

  }

  /**
   * Parses the string to see if it contains a valid Pin code which would be from 1000-9999
   * inclusive. If the integer is unable to be parsed or not in the bounds a ParseException is
   * thrown.
   * 
   * @param pinStr
   * @return
   * @throws ParseException
   */
  public static int parsePinCode(String pinStr) throws ParseException {
    if (pinStr == null) { // param cannot be null
      throw new ParseException("Error: null string passed", 0);
    }
    
    if (pinStr.length() > 4) { // Makes sure original String has only 4 digits
      throw new ParseException("Error: pin not 4 digits", 0);
    }
    
    try { // Will catch if pin string is not able to be parsed
      int pinCode = Integer.parseInt(pinStr);

      if (pinCode >= 1000 && pinCode <= 9999) { // Will catch if pin is not within range
        return pinCode;
      } else {
        throw new ParseException("Error: pin not within range 1000-9999 inclusive", 0);
      }

    } catch (NumberFormatException e) {
      throw new ParseException("Error: No numbers to be parsed", 0);
    }

  }

  /**
   * Finds a subscriber based on their cardBarCode and returns a reference to that subscriber. If
   * not subscriber can be found, a null reference is returned and the error message "Error: this
   * card bar code didn't match any of our records." is displayed.
   * 
   * @param cardBarCode, the cardBarCode to seach for a matching subscriber/
   * @return the subscriber reference if one is found, or a null reference
   */
  public static Subscriber findSubscriber(int cardBarCode) {
    Subscriber foundSub = null;

    for (int i = 0; i < subscribers.size(); ++i) { // Loop to find Subscriber
      if (subscribers.get(i).getCARD_BAR_CODE() == cardBarCode) {
        foundSub = subscribers.get(i);
      }
    }

    if (foundSub == null) { // If no subscriber was found print error
      System.out.println("Error: this card bar code didn't match any of our records.");
    }

    return foundSub; // Works either way since if no sub was found returns null
  }

  /**
   * Saves the available books in the books ArrayList to a file provided by the user. If no file is
   * available, "Error: File Not Found" is displayed.
   * 
   * @param file the file which the book list will get saved to.
   */
  public static void saveBooks(File file) {
    PrintWriter writer = null;

    try {
      writer = new PrintWriter(file);

      for (int i = 0; i < books.size(); ++i) {
        writer.println(books.get(i).getTitle() + ":" + books.get(i).getAuthor());

      }

    } catch (FileNotFoundException e) {
      System.out.println("Error: File Not Found");
    } finally {
      if (writer != null) {
        writer.close();
      }

    }
  }

  /**
   * Takes in a file of books formatted Book_Title:Book_Author and extracts the title and author.
   * Then, this method creates a new book using the title and author extracted and adds it to the
   * Library books ArrayList. If there is a line formatted incorrectly, an error is displayed to the
   * screen showcasing the line number and what went wrong while continuing on to the next line.
   * 
   * @param file the file which data will be extracted from.
   * @throws FileNotFoundException if the Scanner cannot find the file an exception will be thrown.
   */
  public static void loadBooks(File file) throws FileNotFoundException {
    Scanner scnr = new Scanner(file);
    int lineNum = 0;

    while (scnr.hasNext()) {

      if (scnr.hasNextLine()) {
        lineNum++;
        String fullLine = scnr.nextLine().trim();

        if (!fullLine.contains(":")) { // Makes sure there is a : on the line
          continue;
        }

        String[] titleAuthor = fullLine.split(":");

        if (titleAuthor.length < 2) { // Makes sure there is an author and title due to the way the
                                      // split() method works
          System.out.println("Error: Found incorrectly formatted line in file: " + lineNum);
          continue;
        }

        Book newBk = new Book(titleAuthor[0], titleAuthor[1]);
        books.add(newBk);
      }
    }

    scnr.close();
  }

}
