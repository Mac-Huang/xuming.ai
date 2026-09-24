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
// Online Sources:  NONE
//
///////////////////////////////////////////////////////////////////////////////

import java.text.ParseException;
import java.util.ArrayList;
import java.util.NoSuchElementException;
import java.util.Arrays;


/**
 * This class is responsible for testing the addBook(), removeBook(), findBooks(), addSubscriber(),
 * and parsePinCode() methods in the ExceptionalLibrary.java class. The output should show all tests
 * passed if everything is working as expected.
 */
public class ExceptionalLibraryTester {

  /**
   * Checks the addBook() method for correct exception throws
   * 
   * @return true if the test passes, false otherwise
   */
  public static boolean testAddBookInvalidInputs() {
    // Scenario 1: Testing a null title param
    {
      ExceptionalLibrary.resetLibrarySystem();
      String title = null;
      String author = "Michael Jackson";

      // Trying and catching exception
      try {
        ExceptionalLibrary.addBook(title, author);
        return false;
      } catch (IllegalArgumentException e) {
        if (!e.getMessage().equals("Error: Invalid inputs!")) {
          return false;
        }
      }
    }

    // Scenario 2: Testing a null author param
    {
      ExceptionalLibrary.resetLibrarySystem();
      String title = "Book Name";
      String author = null;

      // Trying and catching exception
      try {
        ExceptionalLibrary.addBook(title, author);
        return false;
      } catch (IllegalArgumentException e) {
        if (!e.getMessage().equals("Error: Invalid inputs!")) {
          return false;
        }
      }
    }

    // Scenario 3: Testing a null author and title params
    {
      ExceptionalLibrary.resetLibrarySystem();
      String title = null;
      String author = null;

      // Trying and catching exception
      try {
        ExceptionalLibrary.addBook(title, author);
        return false;
      } catch (IllegalArgumentException e) {
        if (!e.getMessage().equals("Error: Invalid inputs!")) {
          return false;
        }
      }
    }

    // All tests Passed
    return true;
  }

  /**
   * Checks the addBook() method for correct behavior when adding a book
   * 
   * @return true if the test passes, false otherwise
   */
  public static boolean testAddBookValidInputs() {
    // Scenario 1: Testing adding one book
    {
      ExceptionalLibrary.resetLibrarySystem();
      String title = "Horseshoe";
      String author = "Blacksmith";
      Book[] actualBookList;


      try {

        ExceptionalLibrary.addBook(title, author);
        actualBookList = ExceptionalLibrary.getBooks();
        Book.resetBookId();

      } catch (IllegalArgumentException e) {
        return false;
      }

      Book expected = new Book(title, author);
      Book actual = actualBookList[0];

      if (!expected.toString().equals(actual.toString())) {
        return false;
      }

    }
    // Scenario 2: Testing adding more than one book
    {
      ExceptionalLibrary.resetLibrarySystem();
      String title1 = "Horseshoe";
      String author1 = "Blacksmith";
      String title2 = "Cow";
      String author2 = "Farmer";
      String title3 = "No Title";
      String author3 = "No Author";
      Book[] actualAr;


      try {

        ExceptionalLibrary.addBook(title1, author1);
        ExceptionalLibrary.addBook(title2, author2);
        ExceptionalLibrary.addBook(title3, author3);
        actualAr = ExceptionalLibrary.getBooks();
        Book.resetBookId();

      } catch (IllegalArgumentException e) {
        return false;
      }

      Book[] expectedAr =
          {new Book(title1, author1), new Book(title2, author2), new Book(title3, author3)};

      String[] actualSt = bookArrToStringArr(actualAr);
      String[] expectedSt = bookArrToStringArr(expectedAr);

      if (!Arrays.deepEquals(expectedSt, actualSt)) {
        return false;
      }

    }
    // All tests pass
    return true;
  }

  /**
   * Checks the removeBook() method for intended behavior when the book is not present.
   * 
   * @return true if the test passes, false otherwise
   */
  public static boolean testRemoveBookInvalidInputs() {
    // Scenario 1: Trying to locate a book when there is no book with given identifier
    {
      ExceptionalLibrary.resetLibrarySystem();
      int tryingId = 99;

      ExceptionalLibrary.addBook("Book1 Title", "Book1 Author");
      ExceptionalLibrary.addBook("Book2 Title", "Book3 Author");
      ExceptionalLibrary.addBook("Book3 Title", "Book3 Author");


      try {
        // Try to remove a book without the Id given
        ExceptionalLibrary.removeBook(tryingId);

        return false;
      } catch (NoSuchElementException e) {
        if (!e.getMessage().equals("Book not found")) {
          return false;
        }
      }


    }

    // Scenario 2: Trying to remove a book that was checked out and not yet returned
    {
      ExceptionalLibrary.resetLibrarySystem();

      ExceptionalLibrary.addBook("Book1 Title", "Book1 Author");
      ExceptionalLibrary.addBook("Book2 Title", "Book2 Author");
      ExceptionalLibrary.addBook("Book3 Title", "Book3 Author");
      Book[] primary = ExceptionalLibrary.getBooks();
      Book.resetBookId();


      // Checking out the second book
      try {
        Subscriber sub = new Subscriber("Jeff", 999, "Address");
        primary[1].borrowBook(sub.getCARD_BAR_CODE()); // Book is now "borrowed"

        try {
          // Try to remove a book that was checked out
          ExceptionalLibrary.removeBook(primary[1].getID());

          return false; // exception should have been thrown

        } catch (IllegalStateException e) {

          if (!e.getMessage()
              .equals("Book unavailable. It was checked out and not yet returned.")) {
            return false;
          }
        }

      } catch (InstantiationException e) {

        // Only occurs if creating a new Subscriber creates an error
        System.out.println(e.getMessage());
        return false;
      }
    }

    return true; // All tests passed
  }

  /**
   * Checks the removeBook() method for intended behavior when the book is present.
   * 
   * @return true if the test passes, false otherwise
   */
  public static boolean testRemoveBookValidInputs() {
    // Scenario 1: Removes book from the list and correctly assigns it to Book Object without
    // throwing any exceptions
    {
      ExceptionalLibrary.resetLibrarySystem();

      // Setting Up a book Library
      String title1 = "Title 1";
      String title2 = "Title 2";
      String title3 = "Title 3";
      String author1 = "Author 1";
      String author2 = "Author 2";
      String author3 = "Author 3";

      ExceptionalLibrary.addBook(title1, author1);
      ExceptionalLibrary.addBook(title2, author2);
      ExceptionalLibrary.addBook(title3, author3);
      Book.resetBookId();

      Book expected = new Book(title1, author1);
      Book actual = null;

      try {
        actual = ExceptionalLibrary.removeBook(0);
        if (!expected.toString().equals(actual.toString())) {
          return false;
        }
      } catch (NoSuchElementException e) {
        System.out.println(e.getMessage());
      } catch (IllegalArgumentException e) {
        System.out.println(e.getMessage());
      }
    }

    return true; // All tests passed
  }

  /**
   * Tests the various methods for finding books (ID, author) and whether they are throwing
   * exceptions properly
   * 
   * @return true if the test passes, false otherwise
   */
  public static boolean testFindBooksInvalidInputs() {
    // Scenario 1: Search for a book with an ID that does not correspond to any book
    {
      ExceptionalLibrary.resetLibrarySystem();

      // Setting Up a book Library
      String title1 = "Title 1";
      String title2 = "Title 2";
      String title3 = "Title 3";
      String author1 = "Author 1";
      String author2 = "Author 2";
      String author3 = "Author 3";

      ExceptionalLibrary.addBook(title1, author1);
      ExceptionalLibrary.addBook(title2, author2);
      ExceptionalLibrary.addBook(title3, author3);

      int searchId = 100;

      try {
        ExceptionalLibrary.findBookById(searchId);
        return false;
      } catch (NoSuchElementException e) {
        if (!e.getMessage().equals("Book not found")) {
          return false;
        }
      }
    }

    // Scenario 2: Seach using an author which does not have a book assigned to it
    {
      ExceptionalLibrary.resetLibrarySystem();

      // Setting Up a book Library
      String title1 = "Title 1";
      String title2 = "Title 2";
      String title3 = "Title 3";
      String author1 = "Author 1";
      String author2 = "Author 2";
      String author3 = "Author 3";

      ExceptionalLibrary.addBook(title1, author1);
      ExceptionalLibrary.addBook(title2, author2);
      ExceptionalLibrary.addBook(title3, author3);

      ArrayList<Book> expected = new ArrayList<>();
      ArrayList<Book> actual = ExceptionalLibrary.findBookByAuthor("Author 4");

      if (!expected.equals(actual)) {
        return false;
      }
    }

    // Scenario 3: Seach by author that is a null reference
    {
      ExceptionalLibrary.resetLibrarySystem();

      // Setting Up a book Library
      String title1 = "Title 1";
      String title2 = "Title 2";
      String title3 = "Title 3";
      String author1 = "Author 1";
      String author2 = "Author 2";
      String author3 = "Author 3";

      ExceptionalLibrary.addBook(title1, author1);
      ExceptionalLibrary.addBook(title2, author2);
      ExceptionalLibrary.addBook(title3, author3);

      ArrayList<Book> expected = new ArrayList<>();
      ArrayList<Book> actual = ExceptionalLibrary.findBookByAuthor(null);

      if (!expected.equals(actual)) {
        return false;
      }
    }

    return true; // All Tests Passed
  }

  /**
   * Tests the various methods for finding books (ID, author) in the case where the books are
   * present
   * 
   * @return true if the test passes, false otherwise
   */
  public static boolean testFindBooksValidInputs() {
    // Scenario 1: Find book using a correct ID
    {
      ExceptionalLibrary.resetLibrarySystem();

      String title1 = "Title 1";
      String title2 = "Title 2";
      String title3 = "Title 3";
      String author1 = "Author 1";
      String author2 = "Author 2";
      String author3 = "Author 3";

      ExceptionalLibrary.addBook(title1, author1);
      ExceptionalLibrary.addBook(title2, author2);
      ExceptionalLibrary.addBook(title3, author3);

      try {
        int bookId = 2;
        Book[] booksTotal = ExceptionalLibrary.getBooks();
        Book expected = booksTotal[1];
        Book actual = ExceptionalLibrary.findBookById(bookId);

        if (!expected.toString().equals(actual.toString())) {
          return false;
        }
      } catch (NoSuchElementException e) {
        return false;
      }
    }

    // Scenario 2: Fond book using correct Author
    {
      ExceptionalLibrary.resetLibrarySystem();

      String title1 = "Title 1";
      String title2 = "Title 2";
      String title3 = "Title 3";
      String author1 = "Author 1";
      String author3 = "Author 3";

      ExceptionalLibrary.addBook(title1, author1);
      ExceptionalLibrary.addBook(title2, author1); // Books 1 and 2 have the same author
      ExceptionalLibrary.addBook(title3, author3);
      Book.resetBookId();

      ArrayList<Book> expected = new ArrayList<>();
      expected.add(new Book(title1, author1));
      expected.add(new Book(title2, author1));

      ArrayList<Book> actual = ExceptionalLibrary.findBookByAuthor(author1);

      if (!expected.toString().equals(actual.toString())) {
        return false;
      }
    }

    return true; // All Checks Passed
  }

  /**
   * Checks the addSubscriber() method for correct exception throws
   * 
   * @return true if the test passes, false otherwise
   */
  public static boolean testAddSubscriberInvalidInputs() {
    // Scenario 1: Invalid Pin Provided (not between 1000-9999 inclusive)
    {
      ExceptionalLibrary.resetLibrarySystem();

      String name = "Tom Jefferson";
      String pin = "0987";
      String address = "1234 America St.";

      try {

        ExceptionalLibrary.addSubscriber(name, pin, address);

        return false;
      } catch (InstantiationException e) {

        return false;
      } catch (ParseException e) {
        // Wanted outcome
      } catch (IllegalArgumentException e) {

        return false;
      }
    }

    // Scenario 2: Name param is blank
    {
      ExceptionalLibrary.resetLibrarySystem();

      String name = "";
      String pin = "0987";
      String address = "1234 America St.";

      try {

        ExceptionalLibrary.addSubscriber(name, pin, address);

        return false;
      } catch (InstantiationException e) {

        return false;
      } catch (ParseException e) {

        return false;
      } catch (IllegalArgumentException e) {

        // Wanted Outcome
      }
    }

    // Scenario 3: Name param is null
    {
      ExceptionalLibrary.resetLibrarySystem();

      String name = null;
      String pin = "0987";
      String address = "1234 America St.";

      try {

        ExceptionalLibrary.addSubscriber(name, pin, address);

        return false;
      } catch (InstantiationException e) {

        return false;
      } catch (ParseException e) {

        return false;
      } catch (IllegalArgumentException e) {

        // Wanted Outcome
      }
    }

    // Scenario 4: Address param is blank
    {
      ExceptionalLibrary.resetLibrarySystem();

      String name = "Tom Jefferson";
      String pin = "0987";
      String address = "";

      try {

        ExceptionalLibrary.addSubscriber(name, pin, address);

        return false;
      } catch (InstantiationException e) {

        return false;
      } catch (ParseException e) {

        return false;
      } catch (IllegalArgumentException e) {

        // Wanted Outcome
      }

    }

    // Scenario 5: Address param is null
    {
      ExceptionalLibrary.resetLibrarySystem();

      String name = "Tom Jefferson";
      String pin = "0987";
      String address = null;

      try {

        ExceptionalLibrary.addSubscriber(name, pin, address);

        return false;
      } catch (InstantiationException e) {

        return false;
      } catch (ParseException e) {

        return false;
      } catch (IllegalArgumentException e) {

        // Wanted Outcome
      }

    }

    return true; // All tests Passed
  }

  /**
   * Checks the addSubscriber() method for correct behavior (when exceptions aren't thrown)
   * 
   * @return true if the test passes, false otherwise
   */
  public static boolean testAddSubscriberValidInputs() {
    // Scenario 1: Subscriber is correctly created and added to array
    {
      ExceptionalLibrary.resetLibrarySystem();

      String name = "Tom Jefferson";
      String pin = "1776";
      String address = "1234 America St.";
      try {
        // Only difference between subscribers should be their cardBarCodes
        Subscriber[] expected = {new Subscriber("Tom Jefferson", 1776, "1234 America St.")};
        ExceptionalLibrary.addSubscriber(name, pin, address);
        Subscriber[] actual = ExceptionalLibrary.getSubscribers(); // No way to directly access subs
                                                                   // other than a Subscriber array

        // Testing if all testable elements are the same
        if (!expected[0].getName().equals(actual[0].getName())) {
          return false;
        }

        if (expected[0].getPin() != actual[0].getPin()) {
          return false;
        }

        if (!expected[0].getAddress().equals(actual[0].getAddress())) {
          return false;
        }

      } catch (InstantiationException e) {
        System.out.println(e.getMessage());
        return false;
      } catch (ParseException e) {
        System.out.println(e.getMessage());
        return false;
      } catch (IllegalArgumentException e) {
        System.out.println(e.getMessage());
        return false;
      }
    }

    return true; // All Scenarios work correctly
  }

  /**
   * Tests the parsePinCode() method for correct exception throws
   * 
   * @return true if the test passes, false otherwise
   */
  public static boolean testParsePinCodeInvalidInputs() {
    // Scenario 1: Not a 4-digit number in the range
    {
      try {
        ExceptionalLibrary.parsePinCode("130");
        return false;
      } catch (ParseException e) {
        System.out.println(e.getMessage());

      }
    }

    // Scenario 2: String with no integers to be parsed
    {
      try {
        ExceptionalLibrary.parsePinCode("Germany");
        return false;
      } catch (ParseException e) {
        System.out.println(e.getMessage());

      }
    }

    return true; // All tests pass
  }

  /**
   * Tests the parsePinCode() method for intended behavior
   * 
   * @return true if the test passes, false otherwise
   */
  public static boolean testParsePinCodeValidInputs() {
    // Scenario 1: String of 4 integers in range
    {
      try {
        ExceptionalLibrary.parsePinCode("2351");

      } catch (ParseException e) {
        return false;

      }
    }
    
    return true; // All Tests pass
  }

  /**
   * This is a helper array for comparing arrays of books by converting them into arrays of Strings
   * to be compared.
   * 
   * @param books, the book array to be converted
   * @return an array of String representations of the Books in the Book array input.
   */
  private static String[] bookArrToStringArr(Book[] books) {

    String[] strings = new String[books.length];
    for (int i = 0; i < books.length; ++i) {
      strings[i] = books[i].toString();
    }

    return strings;
  }

  public static void main(String[] args) {
    System.out.println("Running tests:");
    System.out.println(
        "testAddBookInvalidInputs(): " + (testAddBookInvalidInputs() ? "PASSED" : "FAILED"));
    System.out
        .println("testAddBookValidInputs(): " + (testAddBookValidInputs() ? "PASSED" : "FAILED"));
    System.out.println(
        "testRemoveBookInvalidInputs(): " + (testRemoveBookInvalidInputs() ? "PASSED" : "FAILED"));
    System.out.println(
        "testRemoveBookValidInputs(): " + (testRemoveBookInvalidInputs() ? "PASSED" : "FAILED"));
    System.out.println(
        "testFindBooksInvalidInputs(): " + (testFindBooksInvalidInputs() ? "PASSED" : "FAILED"));
    System.out.println(
        "testFindBooksValidInputs(): " + (testFindBooksValidInputs() ? "PASSED" : "FAILED"));
    System.out.println("testAddSubscriberInvalidInputs(): "
        + (testAddSubscriberInvalidInputs() ? "PASSED" : "FAILED"));
    System.out.println("testAddSubscriberValidInputs(): "
        + (testAddSubscriberValidInputs() ? "PASSED" : "FAILED"));
    System.out.println("testParsePinCodeInvalidInputs(): "
        + (testParsePinCodeInvalidInputs() ? "PASSED" : "FAILED"));
    System.out.println(
        "testParsePinCodeValidInputs(): " + (testParsePinCodeValidInputs() ? "PASSED" : "FAILED"));
    System.out.println("ALL TESTS: " + (testAddBookInvalidInputs() && testAddBookValidInputs()
        && testRemoveBookInvalidInputs() && testRemoveBookValidInputs()
        && testFindBooksInvalidInputs() && testFindBooksValidInputs()
        && testAddSubscriberInvalidInputs() && testAddSubscriberValidInputs()
        && testParsePinCodeInvalidInputs() && testParsePinCodeValidInputs() ? "PASSED" : "FAILED"));
  }
}
