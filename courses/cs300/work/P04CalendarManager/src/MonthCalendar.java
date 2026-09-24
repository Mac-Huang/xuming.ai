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

import java.time.DateTimeException;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.NoSuchElementException;

/**
 * This class represents a monthly canedar that manages events for a specific year and month. It
 * keeps track of scheduled(uncompleted) events and completed events for the month.
 * 
 * @author Jake Christofferson
 */
public class MonthCalendar {

  // Fields
  private ArrayList<Event> completedEvents; // A list that stores all completed events for this
                                            // month

  private int daysCount; // The number of days in the month

  private ArrayList<Event>[] events; // An array of ArrayLists where each index is a day of the
                                     // month and each list stores the uncompleted events for that
                                     // day.

  private final YearMonth MONTH; // The year and month represented by this calendar in the format
                                 // YYYY-MM

  /**
   * Creates the MonthCalendar object for the month of a specified year. If the year or month is
   * invalid a DateTimeException is thrown.
   * 
   * @param year  the year in YYYY format
   * @param month the month as an int from 1-12 for each month of the year.
   * @throws DateTimeException if either field value is invalid
   */
  public MonthCalendar(int year, int month) throws DateTimeException {
    MONTH = YearMonth.of(year, month);

    daysCount = MONTH.lengthOfMonth();

    // Making events and initializing all elements of the array
    events = new ArrayList[daysCount];
    for (int i = 0; i < daysCount; ++i) {
      events[i] = new ArrayList<Event>();
    }

    completedEvents = new ArrayList<>();
  }

  /**
   * Returns the representation of the month as a String in full style format, such as 'December'
   * 
   * @return the String representation of the month as text.
   */
  public String getMonthName() {
    return MONTH.getMonth().name();
  }

  /**
   * Gets the month-of-year field as an int from 1 to 12 of this MonthCalendar.
   * 
   * @return the month as an int from 1 to 12.
   */
  public int getMonthNumber() {
    return MONTH.getMonthValue();
  }

  /**
   * Gets the number of days in the current month calendar.
   * 
   * @return number of days in the current calendar.
   */
  public int getDaysCount() {
    return this.daysCount;
  }

  /**
   * Adds an event to the specified day's list of events in the correct position, maintaining
   * ascending order based on the Event.compareTo(Event) method. If two events are equal to
   * 'Event.compareTo()', the newly (most recently) added event will be placed after existing ones,
   * preserving insertion order.
   * 
   * @param day       The day of the month (1 - the number of days in the given month)
   * @param desc      A short description of the event (Must not be null or blank)
   * @param startHour The Hour the event starts (0-23)
   * @param startMin  The minute the event starts (0-59)
   * @return True if the event was successfully added, false if the day, the start hour, or the
   *         start minute are out of range, or an equivelent event already exists.
   */
  public boolean addEvent(int day, String desc, int startHour, int startMin) {
    // Make sure day is in range
    if (day < 1 || day > this.daysCount) {
      return false;
    }

    boolean foundEqual = false;

    try {
      Event toAdd = new Event(desc, day, startHour, startMin);
      ArrayList<Event> eventsToday = events[day - 1]; // Shallow copy of ArrayList of this day

      int index = 0;
      for (Event e : eventsToday) {
        if ((toAdd.compareTo(e) == 0) && (toAdd.getDescription().equals(e.getDescription()))) {
          foundEqual = true;
          break;
        }
        if (toAdd.compareTo(e) < 0) { // Found correct index to add to
          break;
        }
        index++; // otherwise increment index
      }

      eventsToday.add(index, toAdd);
      if (foundEqual) { // correct events happened, just determining if events are equal or not
        return false;
      } else {
        return true;
      }


    } catch (IllegalArgumentException e) {
      return false;
    }
  }

  /**
   * Cancels or removes an event from the specified day if a matching event exists. A matching event
   * is identified by its description, start hour, and start minute.
   * 
   * @param desc      the description of the event to be cancelled
   * @param day       the day the event is on, must be between the number 1 and number of days in
   *                  specified month.
   * @param startHour must be between 0-23 inclusive.
   * @param startMin  must be between 0-59 inclusive.
   * @throws IllegalArgumentException if description is null or blank, day is <= or > number of days
   *                                  in the month, start hour or start minute is out of respective
   *                                  ranges.
   * @throws NoSuchElementException   with an error message if no event with the matching parameters
   *                                  is found on the given day.
   */
  public void cancelEvent(String desc, int day, int startHour, int startMin) {
    // IllegalArgumnetExceptions dealt with when creating this new Event object.
    Event testEv = new Event(desc, day, startHour, startMin);
    boolean foundMatch = false;
    int dayIndex = day - 1;

    // Searches for matching event in specific day then removes it.
    for (int i = events[dayIndex].size() - 1; i >= 0; i = i - 1) {

      if (events[dayIndex].get(i).equals(testEv)) {
        foundMatch = true;
        events[dayIndex].remove(i);
      }
    }

    // No match found means throw exception
    if (!foundMatch) {
      throw new NoSuchElementException("Error: event not found in CalendarMonth events list.");
    }
  }

  /**
   * Marks the event complete if e is found in the list of events. Removes the matching event from
   * the list of events and adds it to index 0 of the list of completed events.
   * 
   * @param e a specific scheduled event at a valid day of the month
   * @throws IllegalArgumentException with an error message if e is null or scheduled for a
   *                                  non-valid day of the month.
   * @throws NoSuchElementException   with an error messge if no match event with e is found in the
   *                                  list of events.
   */
  public void markEventAsComplete(Event e) {
    // Make sure e is not void and is in the events list
    if (e == null) {
      throw new IllegalArgumentException("Error: e is null");
    } else if (e.getDay() > daysCount) {
      throw new IllegalArgumentException("Error: e is scheduled for a non-valid day of the month.");
    }

    int dayIndex = e.getDay() - 1;

    if (events[dayIndex].contains(e)) {
      e.markAsComplete();
      events[dayIndex].remove(e);
      completedEvents.add(0, e);
    } else {
      throw new NoSuchElementException(
          "Error: e is not found on the specified day in list of events.");
    }
  }

  /**
   * Returns a deep copy of the array of events in this MonthCalendar. The deep copy of events
   * stores deep copies of the list events at each day and does not expose the original references.
   * 
   * @return a deep copy of the list of uncompleted events in this MonthCalendar
   */
  public ArrayList<Event>[] getEvents() {
    // Setting up the new deep copy arrayList array
    ArrayList<Event>[] deepCopy = new ArrayList[this.daysCount];
    for (int i = 0; i < daysCount; ++i) {
      deepCopy[i] = new ArrayList<>();
    }

    // For each 'day' in the original
    for (int i = 0; i < daysCount; ++i) {

      // Copy each event over to deepCopy
      for (Event ev : events[i]) {
        deepCopy[i].add(ev.copy()); // Using copy method to create deep copies
      }
    }

    return deepCopy;
  }

  /**
   * Returns a deep copy of the completedEvents ArrayList of this MonthCalendar.
   * 
   * @return a deep copy of the list of completed events scheduled for this MonthCalendar.
   */
  public ArrayList<Event> getCompletedEvents() {
    ArrayList<Event> deepCopy = new ArrayList<>();

    // copying every event in this object's completedEvents and assigning it to deepCopy.
    for (Event ev : completedEvents) {
      deepCopy.add(ev.copy());
    }

    return deepCopy;
  }

  /**
   * Clears all completed events stored in the completedEvents ArrayList.
   */
  public void clearAllCompletedEvents() {
    this.completedEvents = new ArrayList<>();
  }

  /**
   * Provided method -- Returns a String representation of all completed events
   *
   * @return a String containing all completed events with their completed days on separate lines,
   *         and an empty string if the list of completed events is empty.
   */
  public String getCompletedEventsAsString() {
    String retval = "";
    for (Event e : completedEvents) {
      retval += e.toString() + "\n";
    }
    return retval.strip();
  }

  /**
   * Provided method -- Returns a String representation of all uncompleted events.
   *
   * Events scheduled on the same day must be in the increasing order.
   *
   * @return a String representation of All the events stored in the events list, and an empty
   *         string if the list of events is empty.
   */
  @Override
  public String toString() {
    String retval = "";
    for (int i = 0; i < events.length; i++) {
      if (!events[i].isEmpty()) {
        retval += "Events for Day " + (i + 1) + ":\n";
        for (Event e : events[i]) {
          retval += e.toString() + "\n";
        }
      }
    }
    return retval.strip();
  }
}

