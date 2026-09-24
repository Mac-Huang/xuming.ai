//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: Playlist Generator
// Course: CS 300 Spring 2025
//
// Author: Jake Christofferson
// Email: ejchristoffe@wisc.edu
// Lecturer: Mouna Kacem
//
//////////////////// PAIR PROGRAMMERS COMPLETE THIS SECTION ///////////////////
//
// Partner Name: Sri Chirumanilla
// Partner Email: chirumanilla@wisc.edu
// Partner Lecturer's Name: Mouna Kacem
//
// VERIFY THE FOLLOWING BY PLACING AN X NEXT TO EACH TRUE STATEMENT:
// _x_ Write-up states that pair programming is allowed for this assignment.
// _x_ We have both read and understand the course Pair Programming Policy.
// _x_ We have registered our team prior to the team registration deadline.
//
//////////////////////// ASSISTANCE/HELP CITATIONS ////////////////////////////
//
// Persons: none
// Online Sources:
// https://www.geeksforgeeks.org/introduction-to-backtracking-2/
// - Helped understand what backtracking is and how we should implement it in
// our program
//
// Zybooks chapter 7.8
// - Helped us understand how to create all permutations of a list
//
///////////////////////////////////////////////////////////////////////////////

import java.util.ArrayList;

/**
 * A class to test the functionality of the {@code Playlist} and {@code PlaylistGenerator} classes.
 * It includes tests for simple, permutation-based, and optimal playlist generation methods.
 */
public class PlaylistTester {

  /**
   * Tests the base cases for the simple playlist generator. Ensures that an empty song list and a
   * playlist already at max duration are handled correctly.
   *
   * @return true if all base cases pass, false otherwise
   */
  public static boolean simpleGeneratorBaseCaseTest() {
    // Base Case 1: Empty song list
    {
      ArrayList<Song> empty = new ArrayList<Song>();

      // Want them to be the same reference to eventually compare referenecs, should be the same
      Playlist expected = new Playlist();
      Playlist actual = expected;

      actual = PlaylistGenerator.simplePlaylist(empty, actual, 100);

      if (actual != expected) {
        return false;
      }
    }

    // Base Case 2: Existing playlist already meets max duration
    {
      Song a = new Song("title a", "genre", 67);
      Song b = new Song("title b", "genre", 25);
      Song c = new Song("title c", "genre", 92);
      ArrayList<Song> allSongs = new ArrayList<>();
      allSongs.add(a);
      allSongs.add(b);
      allSongs.add(c);

      Playlist expected = new Playlist();
      expected = expected.addSong(a);
      expected = expected.addSong(b);
      expected = expected.addSong(c);

      Playlist actual = expected; // Again, want the same reference to compare references

      actual = PlaylistGenerator.simplePlaylist(allSongs, actual, 100); // Playlist already at max

      if (actual != expected) {
        return false;
      }
    }

    return true; // All tests pass
  }

  /**
   * Tests the simple playlist generator with one song adding to a non-empty playlist. Ensures that
   * a song fitting within the duration limit is added, and one exceeding the limit is not added.
   *
   * @return true if all tests pass, false otherwise
   */
  public static boolean simpleGeneratorOneStepTest() {
    // Case 1: One song that fits
    {
      Song a = new Song("title a", "genre", 25);
      ArrayList<Song> song = new ArrayList<>();
      song.add(a);

      Playlist list = new Playlist();
      list = list.addSong(new Song("title b", "genre", 25));
      list = list.addSong(new Song("title c", "genre", 25));

      int maxDuration = 75;

      list = PlaylistGenerator.simplePlaylist(song, list, maxDuration);

      if (list.getSongs().size() != 3) { // Size should be 3 if correct
        return false;
      }

    }

    // Case 2: One song that does not fit
    {
      Song a = new Song("title a", "genre", 25);
      ArrayList<Song> song = new ArrayList<>();
      song.add(a);

      Playlist list = new Playlist();
      list = list.addSong(new Song("title b", "genre", 25));
      list = list.addSong(new Song("title c", "genre", 25));

      int maxDuration = 50;

      list = PlaylistGenerator.simplePlaylist(song, list, maxDuration);

      if (list.getSongs().size() != 2) { // Size should be 2 if correct
        return false;
      }

    }

    return true; // All tests passed
  }

  /**
   * Tests the recursive functionality of the simple playlist generator. Ensures that multiple songs
   * are added without exceeding the duration limit.
   *
   * @return true if the recursive addition works correctly, false otherwise
   */
  public static boolean simpleGeneratorRecursiveTest() { // TODO
    // Test Case: Multiple songs, ensuring correct recursive addition
    {
      Song a = new Song("title a", "genre", 67);
      Song b = new Song("title b", "genre", 25);
      Song c = new Song("title c", "genre", 92);
      ArrayList<Song> allSongs = new ArrayList<>();
      allSongs.add(a);
      allSongs.add(b);
      allSongs.add(c);

      Song d = new Song("title d", "genre", 100);

      Playlist actual = new Playlist();
      actual = actual.addSong(d);
      actual = PlaylistGenerator.simplePlaylist(allSongs, actual, 284);

      if (actual.getTotalDuration() != 284) {
        return false;
      }

      Playlist expected = new Playlist();
      expected = expected.addSong(d);
      expected = expected.addSong(a);
      expected = expected.addSong(b);
      expected = expected.addSong(c);



      if (!actual.toString().equals(expected.toString())) {
        return false;
      }

      if (actual.getTotalDuration() != expected.getTotalDuration()) {
        return false;
      }
    }

    // Playlist already full and tries adding a song that will exceed maximum
    {
      Song a = new Song("title a", "genre", 200); // This song exceeds maxDuration
      ArrayList<Song> allSongs = new ArrayList<>();
      allSongs.add(a);

      Playlist actual = new Playlist();
      actual = PlaylistGenerator.simplePlaylist(allSongs, actual, 100); // maxDuration is 100


      if (actual.getSongs().size() != 0) {
        return false;
      }

      // Check that the total duration is 0
      if (actual.getTotalDuration() != 0) {
        return false;
      }
    }
    
    return true; // Test Passed
  }

  /**
   * Tests the permutation generation method for song lists. Verifies that all permutations are
   * generated correctly. You may consider checking the size of results and the size of each
   * permutation in results.
   *
   * @return true if this tester verifies a correct functionality, false otherwise
   */
  public static boolean generatePermutationsTest() {
    // Case 1: empty song list
    {
      ArrayList<Song> empty = new ArrayList<Song>();
      ArrayList<ArrayList<Song>> allResults = new ArrayList<>();
      int permInd = 0;

      PlaylistGenerator.generatePermutations(empty, permInd, allResults);

      if (!allResults.isEmpty()) {
        return false;
      }
    }

    // Case 2: normal case (not empty song list)
    {
      Song a = new Song("title a", "genre", 67);
      Song b = new Song("title b", "genre", 25);
      Song c = new Song("title c", "genre", 92);
      ArrayList<Song> allSongs = new ArrayList<>();
      allSongs.add(a);
      allSongs.add(b);
      allSongs.add(c);
      allSongs.add(a);
      allSongs.add(b);
      allSongs.add(c);
      allSongs.add(a);
      allSongs.add(b);
      allSongs.add(c);
      allSongs.add(a);
      allSongs.add(b);
      allSongs.add(c);
      allSongs.add(a);
      allSongs.add(b);
      allSongs.add(c);
      allSongs.add(a);
      allSongs.add(b);
      allSongs.add(c);
      allSongs.add(a);
      allSongs.add(b);
      allSongs.add(c);
      allSongs.add(a);
      allSongs.add(b);
      allSongs.add(c);
      

      

      ArrayList<ArrayList<Song>> allResults = new ArrayList<>();
      int permInd = 0;

      PlaylistGenerator.generatePermutations(allSongs, permInd, allResults);

      int expectedPerms = 6; // expecting 6 permutations in allResults
      if (allResults.size() != expectedPerms) {
        return false;
      }

      for (ArrayList<Song> perm : allResults) {
        if (perm.size() != allSongs.size()) {
          return false;
        }
      }

      for (int i = 0; i < allResults.size() - 1; ++i) {

        for (int j = i + 1; j < allResults.size(); ++j) {

          if (allResults.get(i).toString().equals(allResults.get(j).toString())) {
            return false;
          }

        }
      }
    }

    return true;
  }

  /**
   * Tests the permutation-based playlist generation method. Ensures that multiple songs (at least
   * three) are permuted and the best playlist is selected without exceeding the maximum duration.
   *
   * @return true if the permutation-based playlist is generated correctly, false otherwise
   */
  public static boolean bestPermutationPlaylistRecursiveTest() {
    Song a = new Song("title a", "genre", 67);
    Song b = new Song("title b", "genre", 25);
    Song c = new Song("title c", "genre", 92);
    Song d = new Song("title d", "genre", 145);
    Song e = new Song("title e", "genre", 87);
    Song f = new Song("title f", "genre", 21);
    Song g = new Song("title g", "genre", 50);
    ArrayList<Song> allSongs = new ArrayList<>();
    allSongs.add(a);
    allSongs.add(b);
    allSongs.add(c);
    allSongs.add(d);
    allSongs.add(e);
    allSongs.add(f);
    allSongs.add(g);

    Playlist expected = new Playlist();
    expected = expected.addSong(b);
    expected = expected.addSong(f);
    expected = expected.addSong(g);

    Playlist actual = PlaylistGenerator.bestPermutationPlaylist(allSongs, 100);

    ArrayList<Song> expectedSongs = expected.getSongs();
    ArrayList<Song> actualSongs = actual.getSongs();

    for (int i = 0; i < expected.size(); ++i) {

      if (expectedSongs.get(i) != actualSongs.get(i)) {
        return false;
      }

    }
    return true;
  }

  /**
   * Tests the optimal playlist generation with base cases. Ensures correct handling of empty song
   * lists and playlists already at max duration.
   *
   * @return true if base cases are handled correctly, false otherwise
   */
  public static boolean optimalPlaylistBaseCaseTest() {
    // Base Case 1: Empty song list
    {
      ArrayList<Song> emptyList = new ArrayList<>();
      Playlist pList = new Playlist();
      pList = pList.addSong(new Song("Title a", "Genre", 120));
      ArrayList<Song> beforeOperation = pList.getSongs();

      pList = PlaylistGenerator.optimalPlaylist(emptyList, pList, 400);

      if (pList.getSongs().isEmpty() || (!pList.getSongs().get(0).equals(beforeOperation.get(0)))) {
        return false;
      }
    }
    // Base Case 2: Existing playlist already meets max duration
    {
      ArrayList<Song> emptyList = new ArrayList<>();
      Playlist pList = new Playlist();
      pList = pList.addSong(new Song("Title a", "Genre", 120));
      ArrayList<Song> beforeOperation = pList.getSongs();

      pList = PlaylistGenerator.optimalPlaylist(emptyList, pList, 120);

      if (pList.getSongs().isEmpty() || (!pList.getSongs().get(0).equals(beforeOperation.get(0)))) {
        return false;
      }
    }
    return true;
  }

  /**
   * Tests the optimal playlist generation method with one-step cases adding to a nonempty playlist.
   * Ensures that a song fitting within the maximum duration is added, and a song exceeding the
   * limit is not added.
   *
   * @return true if the optimal playlist handles one-step cases correctly, false otherwise
   */
  public static boolean optimalPlaylistOneStepTest() {
    Playlist playlist = new Playlist();
    playlist = playlist.addSong(new Song("Song a", "genre", 120));

    // Case 1: One song that fits
    ArrayList<Song> fits = new ArrayList<>();
    fits.add(new Song("Song b", "genre", 160));

    playlist = PlaylistGenerator.optimalPlaylist(fits, playlist, 300);

    // Case 2: One song that does not fit
    ArrayList<Song> noFit = new ArrayList<>();
    fits.add(new Song("Song c", "genre", 30));

    playlist = PlaylistGenerator.optimalPlaylist(noFit, playlist, 300);

    ArrayList<Song> songsInPL = playlist.getSongs();

    // Should only have 2 songs, the second being "Song b"
    if (songsInPL.size() != 2) {
      return false;
    } else {
      if (!songsInPL.get(1).getTitle().equals("Song b")) {
        return false;
      }
      return true;
    }
  }

  /**
   * Tests the optimal playlist generation method with multiple songs. Ensures that recursive
   * backtracking selects the best playlist without exceeding the maximum duration.
   *
   * @return true if the optimal playlist is generated correctly, false otherwise
   */
  public static boolean optimalPlaylistRecursiveTest() {
    // Case: Multiple songs, ensuring permutations are checked
    // Best playlist set up will be a "middle path" with some songs included and some excluded
    Song a = new Song("title a", "genre", 67);
    Song b = new Song("title b", "genre", 25);
    Song c = new Song("title c", "genre", 92);
    Song d = new Song("title d", "genre", 145);
    Song e = new Song("title e", "genre", 87);
    Song f = new Song("title f", "genre", 21);
    Song g = new Song("title g", "genre", 50);
    ArrayList<Song> allSongs = new ArrayList<>();
    allSongs.add(a);
    allSongs.add(b);
    allSongs.add(c);
    allSongs.add(d);
    allSongs.add(e);
    allSongs.add(f);
    allSongs.add(g);

    Playlist expected = new Playlist();
    expected = expected.addSong(e);
    expected = expected.addSong(f);

    Playlist actual = new Playlist();
    actual = PlaylistGenerator.optimalPlaylist(allSongs, actual, 108);

    ArrayList<Song> expectedSongs = expected.getSongs();
    ArrayList<Song> actualSongs = actual.getSongs();

    // Compare each song to see if they match.
    for (int i = 0; i < actual.getSongs().size(); ++i) {
      if (!expectedSongs.get(i).getTitle().equals(actualSongs.get(i).getTitle())) {
        return false;
      }
    }

    return true; // true if equal, false otherwise
  }

  /**
   * The main method runs all test cases for the playlist generator.
   *
   * @param args command-line arguments (not used)
   */
  public static void main(String[] args) {
    System.out.println("-----------------------------------------------------------");
    System.out.println(
        "simpleGeneratorBaseCaseTest: " + (simpleGeneratorBaseCaseTest() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println(
        "simpleGeneratorOneStepTest: " + (simpleGeneratorOneStepTest() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println(
        "simpleGeneratorRecursiveTest: " + (simpleGeneratorRecursiveTest() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out
        .println("generatePermutationsTest: " + (generatePermutationsTest() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println("bestPermutationPlaylistRecursiveTest: "
        + (bestPermutationPlaylistRecursiveTest() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println(
        "optimalPlaylistBaseCaseTest: " + (optimalPlaylistBaseCaseTest() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println(
        "optimalPlaylistOneStepTest: " + (optimalPlaylistOneStepTest() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println(
        "optimalPlaylistRecursiveTest: " + (optimalPlaylistRecursiveTest() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
  }


}
