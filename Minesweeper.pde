import de.bezier.guido.*;
private final static int NUM_ROWS=20; int NUM_COLS=20;   //Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined
//private String losingMessage;
boolean isLost = false;


void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
   
    // make the manager
    Interactive.make( this );
   
    //initialize losingMessage
    //losingMessage = "You Lose!";

    //your code to initialize buttons goes here
   
    buttons = new MSButton[NUM_ROWS][NUM_COLS];

    for (int i=0; i<buttons.length; i++) {
        for (int j=0; j<buttons[i].length; j++) {
            buttons[i][j] = new MSButton(i,j);
        }
    }
   
    mines = new ArrayList <MSButton> ();
    for (int i=0; i<(NUM_ROWS*NUM_COLS/7); i++)
        setMines();
}
public void setMines()
{
    //your code
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if (!mines.contains(buttons[r][c]))
        mines.add(buttons[r][c]);
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    //return true;
    //your code here
    //loop checks if all the buttons that are not mines are clicked, then you win
    for (int r=0; r<buttons.length; r++) {
        for (int c=0; c<buttons[r].length; c++) {
            if (mines.contains(buttons[r][c]))
                r++;
                c++;
            if (!buttons[r][c].clicked) return false;
        }
    }
    return true;
}
public void displayLosingMessage()
{

    String losingMessage = "You lose!";
    for (int i=5; i<5+losingMessage.length(); i++) {
        fill(255);
        buttons[9][i].myLabel = losingMessage.substring(i-5,i-4);
    }
   
}
public void displayWinningMessage()
{
   
    String winningMessage = "You win!";
    for (int i=5; i<5+winningMessage.length(); i++) {
        buttons[9][i].myLabel = winningMessage.substring(i-5,i-4);
    }
   
   
}
public boolean isValid(int r, int c)
{
    if (r<NUM_ROWS&&r>-1&&c<NUM_COLS&&c>-1)
        return true;
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    //your code here
    for (int r=row-1; r<row+2; r++)
        for (int c=col-1; c<col+2; c++)
            if (isValid(r,c)&&mines.contains(buttons[r][c]))
                numMines++;

    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
   
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col;
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed ()
    {
        clicked = true;
        //your code here
        if (mouseButton==RIGHT&&myLabel==""){
            flagged = !flagged;
             if (flagged==false)
                 clicked = false;
         }
        else if (mines.contains(this)) {
            isLost = true;
            displayLosingMessage();
        }
        else if (countMines(myRow,myCol)>0)
            myLabel = ""+(countMines(myRow,myCol));

        else {
            for (int r=myRow-1; r<myRow+2; r++)
                for (int c=myCol-1; c<myCol+2; c++)
                    if (isValid(r,c)&&!buttons[r][c].clicked)
                    {
                   
                        buttons[r][c].mousePressed();
                    }

        }
       
           
    }
    public void draw ()
    {    

 

        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) )
            fill(255,0,0);
        else if(clicked)
            fill(200);
        else
            fill(100);

        rect(x, y, width, height);
        fill(0);
        if (isWon()) fill(0,255,0);
        if (isLost) fill(0,0,255);
       
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {

        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
