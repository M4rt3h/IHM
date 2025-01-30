import processing.video.*;
import topcodes.*;
import java.awt.image.BufferedImage;
import java.util.List;
import java.util.ArrayList;

Capture c;
PImage img;
BufferedImage b;

protected Scanner scanner;
List<topcodes.TopCode> codes;
List<Integer> detectedCodes;
List<Integer> tableDejeux;

List<Integer> CROIX = new ArrayList<Integer>();
List<Integer> RONDS = new ArrayList<Integer>();

void setup() {
  size(640, 480);
  scanner = new Scanner();
  codes = null;
  c = new Capture(this, 640, 480);
  c.start();
  
  detectedCodes = new ArrayList<Integer>();
  tableDejeux = new ArrayList<Integer>();

  CROIX.add(55);
  CROIX.add(79);
  CROIX.add(93);
  CROIX.add(31);
  CROIX.add(91);

  RONDS.add(107);
  RONDS.add(167);
  RONDS.add(211);
  RONDS.add(331);
  RONDS.add(283);
  
  //pour la taille, couleur et police du texte
  textSize(48); // Taille du texte (plus grande)
  textFont(createFont("Verdana", 48)); // Police en gras
  fill(0); // Couleur du texte (noir)
  //
}

void draw() {
  
  try {
    img = c.copy();
    image(img, 0, 0);

    b = (BufferedImage) img.getImage();
    codes = scanner.scan(b);
  } catch (Exception e) {}
    afficherMessage(0); //##########################################################

  if (codes != null) {
    if (detectedCodes.size() < 9) {
      for (topcodes.TopCode top : codes) {
        String code = String.valueOf(top.getCode());
        fill(255);
        float size = top.getDiameter();

        int codeInt = Integer.parseInt(code);
        if (!CROIX.contains(codeInt) && !RONDS.contains(codeInt)) {
          rect(top.getCenterX() - size / 2, top.getCenterY() - size / 2, size, size);
        }
        
        fill(0);
        text(code, top.getCenterX(), top.getCenterY());

        if (detectedCodes.size() < 9 && !detectedCodes.contains(codeInt)) {
          detectedCodes.add(codeInt);
        }
      }
    }

    if (detectedCodes.size() == 9 && tableDejeux.size() == 0) {
      tableDejeux.addAll(detectedCodes);
    }
    
    for (topcodes.TopCode top : codes) {
      String code = String.valueOf(top.getCode());
      float size = top.getDiameter();

      int codeInt = Integer.parseInt(code);
      if (CROIX.contains(codeInt)) {
        drawCross(top.getCenterX(), top.getCenterY(), size);
      }
      
      if (RONDS.contains(codeInt)) {
        drawCircle(top.getCenterX(), top.getCenterY(), size);
      }
    }
  }
  
  println("Codes détectés (tableDejeux) : " + tableDejeux);
}

void captureEvent(Capture c) {
  c.read();
}

void drawCross(float x, float y, float size) {
  stroke(255, 0, 0);
  strokeWeight(3);
  line(x - size / 2, y - size / 2, x + size / 2, y + size / 2);
  line(x - size / 2, y + size / 2, x + size / 2, y - size / 2);
  noFill();
}

void drawCircle(float x, float y, float size) {
  stroke(0, 0, 255);
  strokeWeight(3);
  noFill();
  ellipse(x, y, size, size);
}

void afficherMessage(int gagnant) {
  // gagnant = 1 pour les ronds
  //         = 2 pour les croix
  //         = 0 pour egalité
  String message = "il y a un bug";
  if(gagnant == 0){
    message = "C'est une égalité\nparfaite !!";
  }
  else if (gagnant == 1){
    message = "Les ronds ont gagnés !\nFélicitations";
  }
  else if (gagnant == 2){
    message = "Les croix ont gagnés !\nFélicitations";
  }
    
  
  textAlign(CENTER, CENTER); // Aligner le texte au centre
  text(message, width / 2, height / 2); // Afficher le message
  delay(2000);
}


public PImage getAsImage(BufferedImage bimg) {
  try { 
    PImage img = new PImage(bimg.getWidth(), bimg.getHeight(), PConstants.ARGB);
    bimg.getRGB(0, 0, img.width, img.height, img.pixels, 0, img.width);
    img.updatePixels();
    return img;
  } catch (Exception e) {
    System.err.println("Can't create image from buffer");
    e.printStackTrace();
  }
  return null;
}
