//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: Event Creator
// Course: CS 300 Spring 2025
//
// Author: Jake Christofferson
// Email: ejchristoffe@wisc.edu
// Lecturer: Mouna Kacem
//
//////////////////////// ASSISTANCE/HELP CITATIONS ////////////////////////////
//
// Persons: none
// Online Sources:
// https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java
// /lang/Comparable.html, helped understand the
// compareTo method and Comparable<> implementation.
//
// https://learn.zybooks.com/zybook/WISCCOMPSCI300Spring2025
// /chapter/5/section/12, helped me understand how to implement
// compareTo method.
//
// https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/time/
// YearMonth.html, Helped me understand what the YearMonth class was and how 
// it is used.
//
///////////////////////////////////////////////////////////////////////////////

// TODO Imports?

/**
 * Responsible for creating an event to be scheduled. It contains a description, date, and a start
 * time. It is possible for an event to be completed or incomplete.
 * 
 * @author Jake Christofferson
 */
public class Event implements Comparable<Event> {

  private int day; // Scheduled day of the event in the month (1-31)

  private String description; // Desc. of the event

  private boolean isComplete; // Status if the event is complete

  private int startHour; // Start hour of event (0-23)

  private int startMin; // Start minute of the event (0-59)

  private int startTime; // Start time of the event in HHMM format

  /**
   * Constructs a new Event object with the description, day, start hour and minute given.
   * Description must not be null or blank, day must be within range 1-31, startHour must be in the
   * range 0-23, and startMin must be in range 0-59.
   * 
   * @param description The brief description of the event.
   * @param day         The day of the month (1-31) of the event.
   * @param startHour   The hour the event starts in 24-hour format.
   * @param startMin    The minute the event starts.
   * @throw IllegalArgumentException If any param is null, blank, or out of range.
   */
  public Event(String description, int day, int startHour, int startMin) {

    // Making sure all params are filled
    if (description == null || description.isBlank()) {
      throw new IllegalArgumentException();

    } else if (day > 31 || day < 1) {
      throw new IllegalArgumentException();

    } else if (startHour > 23 || startHour < 0) {
      throw new IllegalArgumentException();

    } else if (startMin > 59 || startMin < 0) {
      throw new IllegalArgumentException();
    }

    this.description = description;
    this.day = day;
    this.startHour = startHour;
    this.startMin = startMin;

    this.isComplete = false;
    this.startTime = (startHour * 100) + startMin;
  }

  /**
   * Compares this Event with another specified other event to check the order of the Events.
   * Returns a negative integer, zero, or a positive integer if this event's start time is less
   * than, equal to, or greater than the specified event's start time. Events are expected to be on
   * the same day.
   * 
   * @param otherEvent The object to be compared.
   * @return A negative integer, zero, or a positive integer as this object is less than, equal to,
   *         or greater than the specified other event.
   * @throws NullPointerException If the specified object is null.
   */
  public int compareTo(Event otherEvent) {
    // Make sure compared event is not null.
    if (otherEvent == null) {
      throw new NullPointerException("Specified Event to compare to is null");
    }

    return this.startTime - otherEvent.startTime; // Works since startTime is a primitive int
  }

  /**
   * Creates a deep copy of the event.
   * 
   * @return a deep copy of the event with the same description, day, start hour, minute, and
   *         completion status as this event.
   */
  public Event copy() {
    Event newEv = new Event(this.description, this.day, this.startHour, this.startMin);

    if (isComplete) {
      newEv.markAsComplete();
    }

    return newEv;
  }

  /**
   * Determines if one object is "Equal" to another. To be equal, the object must be an instance of
   * Event and have the same day, description, and start time. Completion status is ignored.
   * 
   * @return true if this event is the same as the object, or false otherwise.
   */
  @Override
  public boolean equals(Object o) {
    // Make sure o is not null
    if (o == null) {
      return false;
    }

    // Make sure o is an Event
    if (o.getClass() != this.getClass()) {
      return false;
    }

    if (this.day != ((Event) o).getDay()) {
      return false;
    }

    if (!this.description.equals(((Event) o).getDescription())) {
      return false;
    }

    if (!this.getStartTimeAsString().equals(((Event) o).getStartTimeAsString())) {
      return false;
    }

    return true; // All Checks passed
  }

  /**
   * Get the day of the event
   * 
   * @return The day the event takes place (1-31).
   */
  public int getDay() {
    return this.day;
  }

  /**
   * Accesses the description of the event
   * 
   * @return the event's description.
   */
  public String getDescription() {
    return this.description; // Default
  }

  /**
   * Returns a String representation of the start time of the event in HH:MM format.
   * 
   * @return a String representation of the start time of this event in HH:MM format.
   */
  public String getStartTimeAsString() {
    return String.format("%02d:%02d", this.startHour, this.startMin);
  }

  /**
   * Reports whether the event is complete.
   * 
   * @return true if the event is complete, false otherwise.
   */
  public boolean isComplete() {
    return this.isComplete; // default
  }

  /**
   * Marks the event as complete
   */
  public void markAsComplete() {
    this.isComplete = true;
  }

  /**
   * Provided method - Returns a String representation of this Event
   *
   * @return a String representation of this event
   */
  @Override
  public String toString() {
    return this.description + " at " + this.startHour + ":" + this.startMin
        + (isComplete ? " completed on Day " + day : "");
  }



}
