// DO NOT SUBMIT THIS FILE TO GRADESCOPE

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Queue;
import java.util.Random;
import processing.core.PApplet;
import processing.core.PImage;
import java.util.function.Function;
import javax.imageio.ImageIO;
import controlP5.*;


/**
 * The GUI for the Hobbedex.
 * 
 * Hobbemoun image credit: Alex Onsager
 * 
 * @author Kendall
 * 
 */
public class Hobbedex extends PApplet {

  // Final instance fields (CONSTANTS)
  private final int RED = color(207, 48, 86);
  private final int WHITE = color(238, 252, 234);
  private final int GRAY = color(140, 148, 164);
  private final int BLUE_WHITE = color(210, 254, 254);
  private final int GREEN = color(37, 183, 0);
  private final int YELLOW = color(245, 192, 13);
  private final int BLACK = color(0, 13, 43);
  private final int BLUE = color(48, 226, 251);

  // instance fields
  private HobbemounTree bst;
  private HashMap<Integer, PImage> imageMap;
  private final int NODE_DIAMETER = 100;
  private final int VERTICAL_SPACING = 175;
  private int root_x;
  private int root_y;

  private ControlP5 cp5;
  private Textfield id1Field;
  private Textfield id2Field;

  private Hobbemoun lookupHobbemoun;



  /**
   * Helps setting up the Hobbemoun Tree
   */
  private void setupTree() {
    this.bst = new HobbemounTree();

    this.insert();
    this.insert();
    this.insert();
  }

  /**
   * Returns the color associated with the specific HobbemounType
   * @param type hobbemoun type
   * @return the color of the input type
   */
  private int getTypeColor(HobbemounType type) {
    switch (type) {
      case NORMAL:
        return color(168, 167, 122);
      case FIRE:
        return color(238, 129, 48);
      case WATER:
        return color(99, 144, 240);
      case ELECTRIC:
        return color(247, 208, 44);
      case GRASS:
        return color(122, 199, 76);
      case ICE:
        return color(150, 217, 214);
      case FIGHTING:
        return color(194, 46, 40);
      case POISON:
        return color(163, 62, 161);
      case GROUND:
        return color(226, 191, 101);
      case FLYING:
        return color(169, 143, 243);
      case PSYCHIC:
        return color(249, 85, 135);
      case BUG:
        return color(166, 185, 26);
      case ROCK:
        return color(182, 161, 54);
      case GHOST:
        return color(115, 87, 151);
      case DRAGON:
        return color(111, 53, 252);
      default:
        return color(0, 0, 0);
    }
  }

  /**
   * Sets the size of the display window of this graphic application
   */
  @Override
  public void settings() {
    // make display size
    size(displayWidth, displayHeight);
  }

  /**
   * Defines the initial environment properties of this graphic application, loads media such as
   * images and fonts as the program starts.
   */
  @Override
  public void setup() {
    this.getSurface().setTitle("Hobbedex");
    this.imageMode(PApplet.CORNER);
    this.focused = true;
    this.textSize(20);

    this.root_x = width / 2;
    this.root_y = 100;

    // Initialize ControlP5
    cp5 = new ControlP5(this);

    // Create input fields
    id1Field = cp5.addTextfield("id1").setPosition(20, 20).setSize(60, 30)
        .setFont(createFont("Arial", 14)).setColor(color(255)).setColorBackground(color(60))
        .setColorForeground(color(100)).setLabel("First ID").setInputFilter(ControlP5.INTEGER);

    id2Field = cp5.addTextfield("id2").setPosition(100, 20).setSize(60, 30)
        .setFont(createFont("Arial", 14)).setColor(color(255)).setColorBackground(color(60))
        .setColorForeground(color(100)).setLabel("Second ID").setInputFilter(ControlP5.INTEGER);

    // Create buttons
    cp5.addButton("insert").setPosition(20, 70).setSize(60, 30).getValueLabel()
        .setFont(createFont("Arial", 12)).setText("Insert");

    cp5.getController("insert").setColorBackground(color(37, 183, 0));
    cp5.getController("insert").setColorForeground(color(27, 173, 0));
    cp5.getController("insert").setColorActive(color(47, 193, 10));

    cp5.addButton("remove").setPosition(100, 70).setSize(60, 30).getValueLabel()
        .setFont(createFont("Arial", 12)).setText("Remove");

    cp5.getController("remove").setColorBackground(color(207, 48, 86));
    cp5.getController("remove").setColorForeground(color(197, 38, 76));
    cp5.getController("remove").setColorActive(color(217, 58, 96));

    cp5.addButton("lookup").setPosition(180, 70).setSize(60, 30).getValueLabel()
        .setFont(createFont("Arial", 12)).setText("Lookup");

    cp5.getController("lookup").setColorBackground(color(48, 226, 251));
    cp5.getController("lookup").setColorForeground(color(38, 216, 241));
    cp5.getController("lookup").setColorActive(color(58, 236, 261));


    try {
      this.setupTree();

      // this.setupDummyTree();

    } catch (Exception e) {
      e.printStackTrace();
      this.exit();
    }
    this.imageMap = new HashMap<Integer, PImage>();
  }

  /**
   * Creates a Hobbemoun and inserts it into the HobbemounTree
   */
  public void insert() {
    lookupHobbemoun = null;
    // if id1Field is empty generate random ID from 1 to 151
    if (id1Field.getText().isEmpty()) {
      Random rand = new Random();
      id1Field.setText(Integer.toString(rand.nextInt(151) + 1));
    }
    // if id2Field is empty generate random ID from 1 to 151
    if (id2Field.getText().isEmpty()) {
      Random rand = new Random();
      int id2 = rand.nextInt(151) + 1;
      // make sure id2 is not the same as id1
      if (id1Field.getText().equals(Integer.toString(id2))) {
        id2 = (id2 + 1) % 151 + 1;
      }
      id2Field.setText(Integer.toString(id2));
    }
    int id1 = Integer.parseInt(id1Field.getText());
    int id2 = Integer.parseInt(id2Field.getText());
    Hobbemoun hobbemoun = new Hobbemoun(id1, id2);
    boolean success = this.bst.insert(hobbemoun);
    // clear the fields if the insertion was successful
    if (success) {
      id1Field.clear();
      id2Field.clear();
    }
  }

  /**
   * Removes a specific Hobbemoun
   */
  public void remove() {
    lookupHobbemoun = null;
    int id1 = Integer.parseInt(id1Field.getText());
    int id2 = Integer.parseInt(id2Field.getText());
    Hobbemoun hobbemoun = new Hobbemoun(id1, id2);
    boolean success = this.bst.remove(hobbemoun);
  }

  /**
   * Searches for a specific Hobbemoun
   */
  public void lookup() {
    lookupHobbemoun = null;
    int id1 = Integer.parseInt(id1Field.getText());
    int id2 = Integer.parseInt(id2Field.getText());
    lookupHobbemoun = this.bst.lookup(id1, id2);
  }

  /**
   * Setup a Dummy (random) Hobbemoun Tree
   */
  private void setupDummyTree() {
    ArrayList<Integer> usedIds = new ArrayList<>();
    Random rand = new Random();

    // Helper function to get a pair of unique random IDs
    Function<Void, Hobbemoun> getUniqueHobbemoun = (Void) -> {
      int id1, id2;
      do {
        id1 = rand.nextInt(151) + 1; // 1 to 151
        id2 = rand.nextInt(151) + 1; // 1 to 151
      } while (usedIds.contains(id1) || usedIds.contains(id2) || id1 == id2);
      usedIds.add(id1);
      usedIds.add(id2);
      return new Hobbemoun(id1, id2);
    };

    // Create root
    Node<Hobbemoun> rootNode = new Node<>(getUniqueHobbemoun.apply(null));

    // Create tree level by level
    Queue<Node<Hobbemoun>> queue = new LinkedList<>();
    queue.add(rootNode);

    while (!queue.isEmpty() && usedIds.size() < 30) {
      Node<Hobbemoun> current = queue.poll();

      // 70% chance to add children
      if (rand.nextDouble() < 0.7 && usedIds.size() < 30) {
        current.setLeft(new Node<>(getUniqueHobbemoun.apply(null)));
        queue.add(current.getLeft());
      }

      if (rand.nextDouble() < 0.7 && usedIds.size() < 30) {
        current.setRight(new Node<>(getUniqueHobbemoun.apply(null)));
        queue.add(current.getRight());
      }
    }

    this.bst = new HobbemounTree(rootNode);
  }

  /**
   * Continuously updates the contents of the display window
   */
  public void draw() {
    background(GRAY);
    drawTree(this.bst.getRoot(), root_x, root_y, width / 4); // width/3 determines the
    drawStats();
  }

  private void drawTree(Node<Hobbemoun> node, float x, float y, float hSpacing) {
    if (node == null)
      return;

    // Draw connections to children first (so they appear behind the nodes)
    if (node.getLeft() != null) {
      // Draw line from center to center
      stroke(BLACK);
      line(x, y, x - hSpacing, y + VERTICAL_SPACING);
      drawTree(node.getLeft(), x - hSpacing, y + VERTICAL_SPACING, hSpacing / 2);
    }

    if (node.getRight() != null) {
      // Draw line from center to center
      stroke(BLACK);
      line(x, y, x + hSpacing, y + VERTICAL_SPACING);
      drawTree(node.getRight(), x + hSpacing, y + VERTICAL_SPACING, hSpacing / 2);
    }

    // Draw current node
    stroke(BLACK);
    strokeWeight(2);
    fill(WHITE);
    if (lookupHobbemoun != null && node.getData().equals(lookupHobbemoun)) {
      fill(BLUE);
    }
    ellipse(x, y, NODE_DIAMETER, NODE_DIAMETER);

    // Draw Hobbemoun image in node
    PImage img = getHobbemounImage(node.getData());
    float imgSize = NODE_DIAMETER * 1.2f;
    image(img, x - imgSize / 2, y - imgSize / 2, imgSize, imgSize);


    float nameHeight = y + NODE_DIAMETER / 2 + 15;
    String name = node.getData().toString();
    float namePadding = 8;
    // draw gray rectangle over the text; no border
    fill(GRAY);
    noStroke();
    rect(x - textWidth(name) / 2 - namePadding, nameHeight - namePadding,
        textWidth(name) + namePadding * 2, 12 + namePadding);
    // draw text for the name
    fill(BLACK);
    textAlign(CENTER, CENTER);
    textSize(12);
    text(name, x, nameHeight);



    // Draw type information
    textSize(10);
    float typeY = y + NODE_DIAMETER / 2 + 25;
    float typeHeight = 20;
    float typePadding = 5;

    // Calculate widths and positions for types
    String primaryType = node.getData().getPrimaryType().toString();

    // Add enum value to the type text
    primaryType += " [" + node.getData().getPrimaryType().getValue() + "]";
    float primaryWidth = textWidth(primaryType) + 2 * typePadding;

    HobbemounType secondaryType = node.getData().getSecondaryType();
    float totalWidth = primaryWidth;
    float secondaryWidth = 0;

    if (secondaryType != null) {
      String secondaryTypeText = secondaryType.toString();
      secondaryTypeText += " [" + secondaryType.getValue() + "]";
      secondaryWidth = textWidth(secondaryTypeText) + 2 * typePadding;
      totalWidth += secondaryWidth + 5; // 5 pixels spacing between types
    }

    // Calculate starting x position to center both types
    float startX = x - totalWidth / 2;

    // Draw primary type
    noStroke();
    fill(getTypeColor(node.getData().getPrimaryType()));
    rect(startX, typeY, primaryWidth, typeHeight);
    fill(WHITE);
    text(primaryType, startX + primaryWidth / 2, typeY + typeHeight / 2);

    // Draw secondary type if it exists
    if (secondaryType != null) {
      String secondaryTypeText = secondaryType.toString();
      secondaryTypeText += " [" + secondaryType.getValue() + "]";
      fill(getTypeColor(secondaryType));
      rect(startX + primaryWidth + 5, typeY, secondaryWidth, typeHeight);
      fill(WHITE);
      text(secondaryTypeText, startX + primaryWidth + 5 + secondaryWidth / 2,
          typeY + typeHeight / 2);
    }

    // Add text for power
    // textSize(12);
    // float powerY = y + NODE_DIAMETER / 2 + 55;
    // text("Power: " + node.getData().getPower(), x, powerY);
  }


  private void drawStats() {
    int statsX = width - 250;
    int statsY = 20;
    int imageSize = 80;
    int textSpacing = 25;

    // Draw strongest Hobbemoun
    Hobbemoun strongest = this.bst.getStrongest();
    // Draw background circle
    fill(WHITE);
    stroke(GREEN);
    strokeWeight(3);
    ellipse(statsX + imageSize / 2, statsY + imageSize / 2, imageSize + 6, imageSize + 6);
    // Draw image
    if (strongest != null) {
      PImage strongestImg = getHobbemounImage(strongest);
      image(strongestImg, statsX, statsY, imageSize, imageSize);
    }
    // Draw label
    fill(WHITE);
    textAlign(CENTER, TOP);
    textSize(12);
    text("Strongest", statsX + imageSize / 2, statsY + imageSize + 5);

    // Draw weakest Hobbemoun
    Hobbemoun weakest = this.bst.getWeakest();
    // Draw background circle
    fill(WHITE);
    stroke(RED);
    strokeWeight(3);
    ellipse(statsX + imageSize + 50 + imageSize / 2, statsY + imageSize / 2, imageSize + 6,
        imageSize + 6);
    // Draw image
    if (weakest != null) {
      PImage weakestImg = getHobbemounImage(weakest);
      image(weakestImg, statsX + imageSize + 50, statsY, imageSize, imageSize);
    }
    // Draw label
    fill(WHITE);
    textAlign(CENTER, TOP);
    textSize(12);
    text("Weakest", statsX + imageSize + 50 + imageSize / 2, statsY + imageSize + 5);

    // Draw height and size stats
    fill(WHITE);
    textAlign(LEFT, TOP);
    textSize(16);
    int statsTextY = statsY + imageSize + 30;

    // Draw stat boxes with dark semi-transparent background
    fill(0, 0, 0, 150);
    noStroke();
    rect(statsX - 5, statsTextY - 5, 200, textSpacing * 2 + 5, 5);

    // Draw text
    fill(WHITE);
    text("Tree Size: " + this.bst.size(), statsX + 10, statsTextY + 5);
    text("Tree Height: " + this.bst.height(), statsX + 10, statsTextY + textSpacing + 5);
  }

  private int getHobbemounKey(Hobbemoun hobbemoun) {
    // https://en.wikipedia.org/wiki/Pairing_function#Cantor_pairing_function
    return ((hobbemoun.getFirstID() + hobbemoun.getSecondID())
        * (hobbemoun.getFirstID() + hobbemoun.getSecondID() + 1) / 2) + hobbemoun.getSecondID();
  }

  private PImage getHobbemounImage(Hobbemoun hobbemoun) {
    int hobbemounKey = getHobbemounKey(hobbemoun);
    if (this.imageMap.containsKey(hobbemounKey)) {
      return this.imageMap.get(hobbemounKey);
    }
    URL resourceUrl = HobbedexUtility.getImageURL(hobbemoun.getFirstID(), hobbemoun.getSecondID());

    BufferedImage buffImg = null;
    try {
      buffImg = ImageIO.read(resourceUrl);
    } catch (IOException e) {
      e.printStackTrace();
      return null; // Return null if the image cannot be loaded
    }

    PImage hobbemounImg = createImage(buffImg.getWidth(), buffImg.getHeight(), ARGB);
    buffImg.getRGB(0, 0, hobbemounImg.width, hobbemounImg.height, hobbemounImg.pixels, 0,
        hobbemounImg.width);
    hobbemounImg.updatePixels();

    this.imageMap.put(hobbemounKey, hobbemounImg);
    return hobbemounImg;
  }

  /**
   * Launches the application
   * 
   * @param args input arguments if any
   */
  public static void main(String[] args) {
    PApplet.main("Hobbedex");
  }

}
