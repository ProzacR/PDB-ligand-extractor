#!/usr/bin/perl
#
# 3D OpenGL example
#
# author: Vorsprung


use OpenGL qw/ :all /;
use constant ESCAPE => 27;
# Global variable for our window
my $window;
my $CubeRot = 0;
my $xCord = 1;
my $yCord = 1;
my $zCord = 0;
my $rotSpeed = 0.02 ;
($width, $height) = (1366,768);
@points = ( [ 30,40,40,[100,0,0]], #red
            [ 100,100,40,[0,100,0]], #green
            [ 100,10,60,[0,100,100]], #turquoise
            [ 200,200,100,[0,0,100]] #blue
            );
sub reshape  {  

glViewport(0, 0, $width, $height); # Set our viewport to the size of our window  
glMatrixMode(GL_PROJECTION); # Switch to the projection matrix so that we can manipulate how our scene is viewed  
glLoadIdentity(); # Reset the projection matrix to the identity matrix so that we don't get any artifacts (cleaning up)  
gluPerspective(60, $width / $height, 1.0, 100.0); # Set the Field of view angle (in degrees), the aspect ratio of our window, and the new and far planes  
glMatrixMode(GL_MODELVIEW); # Switch back to the model view matrix, so that we can start drawing shapes correctly  
glOrtho(0, $width, 0, $height, -1, 1);   # Map abstract coords directly to window coords. 
  glScalef(1, -1, 1);           # Invert Y axis so increasing Y goes down. 
  glTranslatef(0, -h, 0);       # Shift origin up to upper-left corner. 

}  
sub keyPressed {

    # Shift the unsigned char key, and the x,y placement off @_, in
    # that order.
    my ($key, $x, $y) = @_;
    # If escape is pressed, kill everything.
    if ($key == ESCAPE) 
    { 
        # Shut down our window 
        glutDestroyWindow($window); 

        # Exit the program...normal termination.
        exit(0);                   
    }
}

sub InitGL {              

    # Shift the width and height off of @_, in that order
    my ($width, $height) = @_;

    # Set the background "clearing color" to black
    glClearColor(0.0, 0.0, 0.0, 0.0);

    # Enables clearing of the Depth buffer 
    glClearDepth(1.0);                    

    glDepthFunc(GL_LESS);         
    # Enables depth testing with that type
    glEnable(GL_DEPTH_TEST);              

    # Enables smooth color shading
    glShadeModel(GL_SMOOTH);      

    # Reset the projection matrix
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity;
    # Reset the modelview matrix
    glMatrixMode(GL_MODELVIEW);
}
    sub display {  
    glClearColor(1.0,0.0,0.0,1.0); 
    glClear(GL_COLOR_BUFFER_BIT);
    glLoadIdentity;

    glTranslatef(0.0, 0.0, -5.0); # Push eveything 5 units back into the scene, otherwise we won't see the primitive  
    #glPushMatrix();
    #glRotatef($CubeRot, $xCord, $yCord, $zCord);

   # this is where the drawing happens, adjust glTranslate to match your coordinates
   # the centre is is 0,0,0
    for my $sphere ( @points ) {
        glPushMatrix();
        glColor3b( @{$sphere->[3]}) ;
        glRotatef($CubeRot, $xCord, $yCord, $zCord);
        glTranslatef($sphere->[0]/50 -2 ,$sphere->[1]/50 -2 ,$sphere->[2]/50 -2);
        glutWireSphere(1.0,24,24); # Render the primitive  
        glPopMatrix();
        }
    $CubeRot += $rotSpeed;
    glFlush; # Flush the OpenGL buffers to the window  
    }  

# Initialize GLUT state
glutInit;  

# Depth buffer */  
glutInitDisplayMode(GLUT_SINGLE);



# The window starts at the upper left corner of the screen
glutInitWindowPosition(0, 0);  

# Open the window  
$window = glutCreateWindow("Press escape to quit");

# Register the function to do all our OpenGL drawing.
glutDisplayFunc(\&display);  

# Go fullscreen.  This is as soon as possible. 
glutFullScreen;
glutReshapeFunc(\&reshape);
# Even if there are no events, redraw our gl scene.
glutIdleFunc(\&display);

# Register the function called when the keyboard is pressed.
glutKeyboardFunc(\&keyPressed);

# Initialize our window.
InitGL($width, $height);

# Start Event Processing Engine
glutMainLoop;  

return 1;
