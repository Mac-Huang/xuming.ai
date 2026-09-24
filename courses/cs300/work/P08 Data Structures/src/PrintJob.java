/**
 * The class represents a print job with information about the document being printed, such as the
 * document's name, and page count.
 */
public class PrintJob {
  /**
   * The name of the document to be printed.
   */
  private String documentName; // document name


  /**
   * The number of pages in the document.
   */
  private int pageCount; // number of pages in the document

  /**
   * Constructs a new PrintJob with the specified document name and page count.
   *
   * @param documentName The name of the document to be printed.
   * @param pageCount    The number of pages in the document.
   * @throws IllegalArgumentException if documentName is null or blank or pageCount is less or equal
   *                                  to zero
   */
  public PrintJob(String documentName, int pageCount) {
    // Check for validity of inputs
    if(documentName == null || documentName.isBlank())
      throw new IllegalArgumentException("Invalid document name!");
    if(pageCount <= 0)
      throw new IllegalArgumentException("Invalid page count!");

    // assign instance fields
    this.documentName = documentName;
    this.pageCount = pageCount;
  }

  /**
   * Returns the document type of this print job.
   *
   * @return The DocumentType of the document being printed.
   */
  public String getDocumentName() {
    return this.documentName;
  }


  /**
   * Returns a string representation of the PrintJob in the format:
   *
   * "documentName: pageCount pages"
   *
   * @return A string representation of this print job.
   */
  @Override
  public String toString() {
    return documentName + ": " + pageCount + " pages";
  }

  /**
   * Compares this PrintJob to the specified object. The result is true if and only
   * if the argument is a PrintJob object with the same document name (case-insensitive) and
   * pageCount as this one.
   *
   * @param anObject The object to compare this PrintJob against.
   * @return true if the specified object is equal to this PrintJob; false otherwise.
   */
  @Override
  public boolean equals(Object anObject) {
    // Ensure anObject is instance of PrintJob
    if (anObject instanceof PrintJob) {
      PrintJob p = (PrintJob) anObject;
      // Check for equality of the two printJob objects
      return this.documentName.equalsIgnoreCase(p.documentName) &&
          this.pageCount == p.pageCount;
    }
    return false;
  }
}
