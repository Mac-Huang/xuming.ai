import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.NoSuchElementException;
import java.util.Scanner;
import java.io.File;

/**
 * Set of utility methods that extract lake records from the provided csv file.
 * @author Rahul Choudhary
 */
public class LakeRecordReader {
  
  /**
   * Retrieves the list of lake records from the given  file.
   * @param fileName the name of the file to read from
   * @return list of LakeRecord for the given fileName
   */
  public static ArrayList<LakeRecord> getLakeRecords(String fileName) {
    ArrayList<LakeRecord> records = new ArrayList<>();

    try (Scanner fileIn = new Scanner(new File(fileName))) {

      fileIn.nextLine();  //skip the header

      String data;
      try {
        while ((data = fileIn.nextLine()) != null) {
          String[] fields = data.split(",");

          // Expect exactly 4 columns based on the provided CSV format:
          // 1) Winter
          // 2) Freeze-Over Date
          // 3) Thaw Date
          // 4) Days of Ice Cover
          if (fields.length == 4) {
            String winter = removeSurroundingQuotes(fields[0]).trim();
            String freezeDate = removeSurroundingQuotes(fields[1]).trim();
            String thawDate = removeSurroundingQuotes(fields[2]).trim();
            String daysOfIceCoverStr = removeSurroundingQuotes(fields[3]).trim();

            // Convert incorrectly formatted freeze/thaw to null
            if (freezeDate.split(" ").length != 2) {
              freezeDate = null;
            }

            if (thawDate.split(" ").length != 2) {
              thawDate = null;
            }

            int daysOfIceCover = LakeRecord.MISSING; // default value
            if (!daysOfIceCoverStr.isEmpty()) {
              try {
                daysOfIceCover = Integer.parseInt(daysOfIceCoverStr);
              } catch (NumberFormatException e) {}
            }

            // Create and add the LakeRecord to the list
            LakeRecord record = new LakeRecord(winter, freezeDate, thawDate, daysOfIceCover);
            records.add(record);
          }
        }
      }
      catch (NoSuchElementException e) {}

      return reverse(records); // Default list order should be chronological
    } catch (FileNotFoundException e) {
      throw new RuntimeException(e);
    }
  }



  /**
   * Removes leading and trailing quotes if they exist.
   *
   * @param value The string value possibly surrounded by quotes
   * @return The unquoted string
   */
  private static String removeSurroundingQuotes(String value) {
    String trimmed = value.trim();
    if (trimmed.startsWith("\"") && trimmed.endsWith("\"") && trimmed.length() >= 2) {
      return trimmed.substring(1, trimmed.length() - 1);
    }
    return trimmed;
  }

  /**
   * Reverses the order of the given ArrayList in place
   * @param records the list to be reversed
   * @return reference to the input list
   */
  private static ArrayList<LakeRecord> reverse(ArrayList<LakeRecord> records) {
    for (int i = 0; i < records.size()/2; i++) {
      LakeRecord temp = records.get(i);
      int j = records.size()-1-i;
      records.set(i, records.get(j));
      records.set(j, temp);
    }
    return records;
  }

}