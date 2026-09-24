import java.time.DateTimeException;
import java.time.LocalDateTime;

/**
 * This class models an Event for the CS300 P10 project Priority Events. These objects are comparable
 * to other Event objects, for inclusion in a priority queue.
 */
public class Event implements Comparable<Event> {
  
  /**
   * The year in which all Events occur; effectively constant
   */
  private static int year = 2025;
  /**
   * The month in which all Events occur; can be updated using the setMonth() class method
   */
  private static int month = 4;
  
  /**
   * Change the Event class month to the given month. This will NOT modify the date/time
   * associated with any previously-constructed Events, which store ALL date/time information in an
   * instance variable.
   * 
   * @param month an integer 1-12 corresponding to the month of the year 2025
   * @throws IllegalArgumentException if month is not 1-12
   */
  public static void setMonth(int month) throws IllegalArgumentException{  
    if (month < 1 || month > 12) 
      throw new IllegalArgumentException("Invalid month: "+month);
    Event.month = month;
  }
  
  /**
   * The description of this Event, which may not be null or blank
   */
  private String description;
  /**
   * A Java-provided object containing the start time of this event
   */
  private LocalDateTime date;
  /**
   * Indicates whether this event has been completed
   */
  private boolean complete;
  
  /**
   * Attempts to create a new Event object with the provided description, on the given day/time.
   * 
   * @param description a text description of this event
   * @param day an integer representing the day of the month that this event occurs
   * @param hour an integer representing the hour (0-23) that this event starts
   * @param min in integer representing the minute (0-59) that this event starts
   * @throws DateTimeException if the provided day/time does not correspond to a valid date
   * @throws IllegalArgumentException if the provided description is null or blank
   */
  public Event(String description, int day, int hour, int min) 
      throws DateTimeException, IllegalArgumentException {
    if (description == null || description.isBlank()) 
      throw new IllegalArgumentException("Invalid description: "+description);
    
    this.description = description;
    this.date = LocalDateTime.of(year, month, day, hour, min); // throws exception
    this.complete = false;
  }

  /**
   * Returns the String representation of this Event's starting timestamp
   * @return the toString() representation of this Event's date
   */
  public String getStartTimeAsString() {
    return this.date.toString();
  }
  
  /**
   * Returns this Event's description
   * @return the Event's description
   */
  public String getDescription() {
    return this.description;
  }
  
  /**
   * The day of the month (1-31) of this Event
   * @return the day of the month of this Event
   */
  public int getDay() {
    return this.date.getDayOfMonth();
  }
  
  /**
   * The month number (1-12) of this Event; may not correspond to the current value of Event.month
   * if that has been changed since this Event was created
   * @return the month number of this Event
   */
  public int getMonth() {
    return this.date.getMonthValue();
  }
  
  /**
   * Reports whether this Event has been completed
   * @return {@code true} if this Event has been completed, {@code false} otherwise
   */
  public boolean isComplete() {
    return this.complete;
  }
  
  /**
   * Sets this Event's completion status to true; this cannot be undone
   */
  public void markAsComplete() {
    this.complete = true;
  }
  
  /**
   * Tests for equality of this Event and another Object. If the other object is an Event with the
   * same description and start time, the two are considered equal regardless of completion status.
   * @return {@code true} if this Event is the same as the object in o, {@code false} otherwise
   */
  @Override
  public boolean equals(Object o) {
    if (o instanceof Event) {
      Event other = (Event) o;
      return this.description.equals(other.description) && this.date.equals(other.date);
    }
    return false;
  }
  
  /**
   * Provided method - Returns a String representation of this Event
   *
   * @return a String representation of this event
   */
    @Override
    public String toString() {
      return this.description + " at " + this.date.getHour() + ":" + this.date.getMinute() 
              + (complete ? " completed on Day " + getDay() :  "");
    }
  
  /**
   * Compares two Event objects with respect to their day/time information only
   * @return a negative number, 0, or a positive number if this Event happens before, at the same
   * time, or after o
   */
  @Override
  public int compareTo(Event o) {
    return this.date.compareTo(o.date);
  }

}
