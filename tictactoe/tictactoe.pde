import processing.video.*;
import topcodes.*;
import java.awt.image.BufferedImage;
import java.util.List;
import java.util.ArrayList;

Capture c;
PImage img;
BufferedImage b;
int [][] matriceDeJeu = new int [3][3]; // La matrice 3*3 pour stocker l'état du plateau
boolean nonInitialise = true; //Faux si on a pas encore detecté toutes les cases du plateau, vrai sinon


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
  
  //pour la taille, police et couleur du texte
  textSize(48);
  textFont(createFont("Verdana", 48));
  fill(0);
  //
}

void draw() {
  if ((tableDejeux.size() == 9) && nonInitialise){
    int[][] matriceDeJeu = initialiserMatriceDeJeu();
    nonInitialise = false;
  }
  try {
    img = c.copy();
    image(img, 0, 0);

    b = (BufferedImage) img.getImage();
    codes = scanner.scan(b);
  } catch (Exception e) {}
    
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


  afficherMatrice(matriceDeJeu);
 // println(tableDejeux.get(2)) ;

  //afficherMessage(0); //##########################################################

}

void captureEvent(Capture c) {
  c.read();
}

void afficherMatrice(int[][] matrice) { //fais planter le logiciel pour outOfMemoryError
  for (int ligne = 0; ligne < 3; ligne++) {
    String ligneString = ""; // Créer une chaîne vide pour chaque ligne
    for (int colonne = 0; colonne < 3; colonne++) {
      ligneString += matrice[ligne][colonne] + " "; // Ajouter chaque élément à la ligne
    }
    println(ligneString); // Afficher la ligne dans la console
  }
}

int[][] initialiserMatriceDeJeu(){
  int[][] matriceDeJeu = new int [3][3];
  for (int ligne = 0; ligne <3; ligne ++){
    for(int colonne =0; colonne <3; colonne ++){
     matriceDeJeu[ligne][colonne] = tableDejeux.get(colonne+ligne) ; 
    }
  }
  return matriceDeJeu;
}

//int etatJeu(){
  //Vérifier si il y a une ligne de croix ou de rond
  // retourne 1 s'il y a ligne de rond
  //          2 s'il y a ligne de croix
  //          3 s'il n'y a pas de ligne
  //          0 s'il n'y a plus de case libre sur le plateau mais pas de gagnant
  //modifie matriceDeJeu en fonction du plateau
  
 // return 0;}
 
 
// il y a 8 lignes différetes pour gagner
//detecter alignement sur 8 lignes différentes
//On a une matrice a créer

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
  String redemarrer = "\nPress to restart";
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
  text(message+redemarrer, width / 2, height / 2); // Afficher le message
  while(!keyPressed){ //bloquer l'affichage tant que l'utilisateur n'est pas pret
    delay(1);
  }
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
