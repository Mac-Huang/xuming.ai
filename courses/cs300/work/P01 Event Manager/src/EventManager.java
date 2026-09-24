//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title:    Event Manager
// Course:   CS 300 Spring 2025
//
// Author:   Jake Christofferson
// Email:    ejchristoffe@wisc.edu
// Lecturer: Mouna Kacem
//
//////////////////////// ASSISTANCE/HELP CITATIONS ////////////////////////////
//
// Persons:         none
// Online Sources:  none
//
///////////////////////////////////////////////////////////////////////////////


/**
 * Class for managing and storing events to be used in the EventManagerDriver class.
 * 
 * @author Jake Christofferson
 */
public class EventManager {


  /**
   * Adds an event to the 2-D array of events.
   * 
   * @param day    the day to which the event should be added (1-31).
   * @param event, the event to be added to the specific day.
   * @param events the 2-D array of days and events.
   * @return true if the event is successfully added, false if the day is full.
   */
  public static boolean addEvent(int day, String event, String[][] events) {
    int dayIndex = day - 1;
    if (addToCompactArray(event, events[dayIndex])) {
      return true;
    }

    return false;
  }



  /**
   * Adds a string value to the end of a compact array.
   * 
   * @param value,      the value to add
   * @param valueArray, the reference to an oversized compact perfect array.
   * @return true if value successfully added, false if not.
   */
  public static boolean addToCompactArray(String value, String[] valueArray) {
    int arrayLength = valueArray.length;

    for (int i = 0; i < arrayLength; ++i) {
      if (valueArray[i] == null) {
        valueArray[i] = value;
        return true;
      }
    }

    return false;
  }



  /**
   * Adds an element to a non-full compact array. If the array is full the original size is returned
   * and nothing is added
   * 
   * @param value,  the value to be appended to the array
   * @param values, the array to be added to
   * @param size,   the size of the oversize array
   * @return the size of the returned array.
   */
  public static int appendElement(String value, String[] values, int size) {
    // makes sure array isn't full
    if (values.length == size) {
      return size;
    }

    values[size] = value;
    size++;

    return size; // default return
  }

  /**
   * Removes an event from a day of the month
   * 
   * @param day,    the day from which the event is from
   * @param index,  the index of the event to remove
   * @param events, the 2-D array housing all events
   * @return A string containing the event deleted or null if the index is out of bounds.
   */
  public static String deleteEvent(int day, int index, String[][] events) {
    int dayIndex = day - 1;

    String removedEvent = removeFromCompactArrayAtIndex(index, events[dayIndex]);

    return removedEvent; // returns the removed element
  }

  /**
   * Represents all events in the schedule for each day as a String
   * 
   * @param events, the 2-D array of events
   * @return a string with the events all organized by day and easily readable.
   */
  public static String getAllEvents(String[][] events) {
    String outputString = "";

    // Loops each day
    for (int i = 1; i <= events.length; ++i) {
      if (!getEvents(i, events).equals("")) {
        outputString = outputString + getEvents(i, events) + "\n";
      }
    }

    return outputString;
  }

  public static String getCompletedEvents(String[] completedEvents, int size) {
    String outputString = "";

    if (size > 0) {

      for (int i = 0; i < size; ++i) {
        outputString = outputString + completedEvents[i];

      }
    }


    return outputString;
  }

  /**
   * Provides a String representation for all of the events of a given day
   * 
   * @param day,    the day which the printed events will come from.
   * @param events, the 2-D array which houses all of the given events.
   * @return A String Representation of the events of a given day or an empty string if no events
   *         are scheduled for that day.
   */
  public static String getEvents(int day, String[][] events) {
    int dayIndex = day - 1;
    String eventList = "";

    // Assuming a compact array, empty if first element is null
    if (events[dayIndex][0] == null) {
      return eventList;
    }

    eventList = "Events for Day " + day + ":";
    for (int i = 0; i < events[dayIndex].length; ++i) {
      if (events[dayIndex][i] != null) {
        eventList = eventList + "\n" + events[dayIndex][i];
      }
    }

    return eventList;
  }

  /**
   * Adds the specific event to the completed events array along with the tag " completed on Day X"
   * to show which events have been completed and on what days. If the completed events array is
   * full, the array is unchanged. <BR>
   * This also removes the specified event from the events list and events are shifted accordingly.
   * 
   * @param day,                  the day the completed event is housed in the 2-D array
   * @param index,                the index of the completed event housed in the 2-D array
   * @param events,               the 2-D array which houses events
   * @param completedEvents,      the 1-D oversize array housing the completed events
   * @param completedEventsCount, the number of entries in the completed events array
   * @return the updated size of the completed events array
   */
  public static int markEventAsComplete(int day, int index, String[][] events,
      String[] completedEvents, int completedEventsCount) {
    if (completedEvents.length == completedEventsCount) {
      return completedEventsCount;
    }

    String completedEventString = removeFromCompactArrayAtIndex(index, events[day - 1]);
    completedEventString = completedEventString + " completed on Day " + day;

    completedEventsCount =
        appendElement(completedEventString, completedEvents, completedEventsCount);

    return completedEventsCount; // returns the size of completedEvents
  }

  /**
   * Removes element at target index and compacts array.
   * 
   * @param index,  the index value to be removed from the list
   * @param values, the String[] of values which an element will be removed.
   * @return the String of the element that was removed.
   */
  public static String removeFromCompactArrayAtIndex(int index, String[] values) {
    // Checks if index is within correct bounds
    if ((index < 0) || (index >= values.length)) {
      return null;
    }

    // The string of the index that will be removed.
    String returnString = values[index];

    // Start at the removed index, end one before the last index shifting values down.
    for (int i = index; i < values.length - 1; ++i) {
      values[i] = values[i + 1];

    }

    // makes the last element null since at least 1 element will be removed
    values[values.length - 1] = null;


    return returnString; // default return
  }

  /**
   * Analyzes a compact array and returns the number of elements stored in the array.
   * 
   * @param values, the compact array to be sized
   * @return the size of the compact array.
   */
  public static int sizeCompactArray(String[] values) {
    int size = 0;

    for (int i = 0; i < values.length; ++i) {
      if (values[i] != null) {
        size++;
      }
    }

    return size; // default return
  }

  /**
   * Updates a specific event already written in calendar
   * 
   * @param day      - the day on which the event can be found (1-31)
   * @param index    - the index of the event on the given day
   * @param newEvent - the new event to replace the old
   * @param events   - the 2-D array which stores and holds all events for the month
   * @return true if the event is successfully updated, or false if an error arises
   */
  public static boolean updateEvent(int day, int index, String newEvent, String[][] events) {
    // Checks if index is correct
    if ((index < 0) || (index > events[day - 1].length)) {
      return false; // Out of bounds
    }

    // Updates event
    events[day - 1][index] = newEvent;

    return true; // default return
  }



}
