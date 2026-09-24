// Provided File -- DO NOT SUBMIT THIS FILE TO GRADESCOPE

import java.util.ArrayList;
import java.util.Random;

/**
 * This class provides helper methods that support the primary functions of a music application. It
 * includes utility functions for operations such as generating a random song data set.
 */
public class Utilities {
  // Predefined array of music genres that can be randomly assigned to generated songs.
  private static final String[] GENRES = {"Rock", "Jazz", "Pop", "Metal", "Classical"};

  // Random number generator used for assigning random attributes to songs.
  private static final Random RANDOM = new Random();

  /**
   * Generates and returns a list of randomly created Song objects. Each song has a randomly
   * assigned genre and a random duration between 100 and 300 seconds.
   *
   * @param count The number of songs to generate.
   * @return An ArrayList<Song> containing randomly generated song objects.
   */
  public static ArrayList<Song> generateRandomSongs(int count) {
    ArrayList<Song> songs = new ArrayList<>(); // List to store generated songs

    // Generate count Song objects with Randomly assigned attributes
    for (int i = 0; i < count; i++) {
      // Assign a title to Song objects as "Song 1", "Song 2", etc.
      String title = "Song " + (i + 1);
      // Randomly selects a genre
      String genre = GENRES[RANDOM.nextInt(GENRES.length)];
      int duration = RANDOM.nextInt(200) + 100; // Duration between 100-300 seconds
      // Add the generated song to the list
      songs.add(new Song(title, genre, duration));
    }
    return songs;
  }

}
