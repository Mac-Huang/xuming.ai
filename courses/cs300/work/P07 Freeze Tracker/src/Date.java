import java.time.LocalDate;
// import java.time.Month;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.Map;

/**
 * Simple static class for processing string representations of dates
 */
public class Date {
  private static final Map<String, Integer> MONTHS = new HashMap<>();

  static {
    MONTHS.put("January", 1);
    MONTHS.put("February", 2);
    MONTHS.put("March", 3);
    MONTHS.put("April", 4);
    MONTHS.put("May", 5);
    MONTHS.put("June", 6);
    MONTHS.put("July", 7);
    MONTHS.put("August", 8);
    MONTHS.put("September", 9);
    MONTHS.put("October", 10);
    MONTHS.put("November", 11);
    MONTHS.put("December", 12);
  }

  /**
   * Converts a date string into a LocalDate object.
   * 
   * @param winter The winter season (e.g., "2024-25").
   * @param date   The freeze or thaw date (e.g., "December 22").
   * @return A LocalDate object or null if invalid.
   */
  public static LocalDate convertToDate(String winter, String date) {
    if (date == null || date.isEmpty())
      return null;

    String[] parts = date.split(" ");
    if (parts.length != 2)
      return null;

    int month = MONTHS.getOrDefault(parts[0], -1);
    int day = Integer.parseInt(parts[1]);
    int year = Integer.parseInt(winter.substring(0, 4));

    // If the first recorded freeze is August or later, it's the current year.
    // Otherwise, it belongs to the next year.
    if (month < 8)
      year++;

    return LocalDate.of(year, month, day);
  }

  /**
   * Extracts the starting year from the winter string.
   * 
   * @param winter The winter season (e.g., "2024-25").
   * @return The starting year as an integer.
   */
  public static int extractYear(String winter) {
    return Integer.parseInt(winter.substring(0, 4));
  }

  /**
   * Compares two dates in the same winter. Dates in August and later are
   * assumed to be from the previous year, e.g. March is later than August but
   * earlier than July.
   * 
   * @param date1  The first date (e.g., "December 15").
   * @param date2  The second date (e.g., "January 5").
   * @return -1 if date1 is earlier, 1 if date1 is later, 0 if equal.
   */
  public static int compareDates(String date1, String date2) {
    String winter = "2024-25"; // actual value doesn't matter for our purposes
    LocalDate d1 = convertToDate(winter, date1);
    LocalDate d2 = convertToDate(winter, date2);
    if (d1 == null || d2 == null)
      return 0;

    return d1.compareTo(d2);
  }

  /**
   * Calculates the number of days between two dates in the same winter season.
   * 
   * @param winter    The winter season (e.g., "2024-25").
   * @param startDate The starting date (e.g., "December 15").
   * @param endDate   The ending date (e.g., "March 1").
   * @return The number of days between the two dates, or -1 if invalid.
   */
  public static int daysBetween(String winter, String startDate, String endDate) {
    LocalDate start = convertToDate(winter, startDate);
    LocalDate end = convertToDate(winter, endDate);

    if (start == null || end == null)
      return -1;

    return (int) ChronoUnit.DAYS.between(start, end);
  }
}
