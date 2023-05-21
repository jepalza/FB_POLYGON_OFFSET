'
'    This Code Was Created By Jeff Molofee 2000
'    A HUGE Thanks To Fredric Echols For Cleaning Up
'    And Optimizing The Base Code, Making It More Flexible!
'    If You've Found This Code Useful, Please Let Me Know.
'    Visit My Site At nehe.gamedev.net

' version para FREEBASIC por Joseba Epalza, 23 (con mejoras)


#Include once "GL/glut.bi"

	
Print "crea una esfera solida y seguido OTRA en modo alambre pero "
Print "paralela, de modo que queda por fuera y se vea sobre el solido"
Print
Print "Usar boton medio e izquierdo del raton para giros simples"
Print "boton derecho del raton para salir"
Print
Print "WASD movimientos (aceleracion)"
Print "Q y E distancia al objeto"
Print "Z o X modos de sombreado"
Print 
Print "1 y 2 espesor: distancia al solido desde el alambre"
Print "3 y 4 unidad de desplazamiento del espesor"




Dim Shared As GLuint 	list

Dim shared As GLfloat 	zdist      = 2.0  ' distancia visual al objeto
Dim Shared As GLfloat 	PolyOffset = 1.0  ' distancia entre el alambre y el solido
Dim Shared As GLfloat 	polyunits  = 1.0  ' factor de poligonos
Dim Shared As GLfloat 	thickline  = 5.0  ' espesor de linea
Dim Shared As GLfloat   xrot       = 0.0  ' X Rot
Dim Shared As GLfloat   yrot       = 0.0  ' Y Rot
Dim Shared As GLfloat   xspeed     =-0.1  ' X Rot Accel
Dim Shared As GLfloat   yspeed     = 0.1  ' Y Rot Accel

	
' color de la esfera
Dim Shared As GLfloat color_solid(3) = { 0.2, 0.0, 0.2, 1.0 }
' color de la zona sombreada
Dim Shared As GLfloat color_shade(3) = { 0.4, 0.0, 0.4, 1.0 }


Sub display cdecl()
    
    glClear (GL_COLOR_BUFFER_BIT Or GL_DEPTH_BUFFER_BIT)
    glPushMatrix ()
    glTranslatef (0.0, 0.0, zdist)
    glRotatef ( Cast(GLfloat, xrot), 1.0, 0.0, 0.0)
    glRotatef ( Cast(GLfloat, yrot), 0.0, 1.0, 0.0)

    glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @color_solid(0))
    glMaterialfv(GL_FRONT, GL_SPECULAR, @color_shade(0))
    glMaterialf (GL_FRONT, GL_SHININESS, 0.0)
    
    glEnable(GL_LIGHTING)
    glEnable(GL_LIGHT0)
    glEnable(GL_POLYGON_OFFSET_FILL)
    
    ' aqui aplicamos el espesor
    glPolygonOffset(PolyOffset, polyunits)
    
    ' el grosor de la linea
    glLineWidth(thickline)
    
    glCallList (list)
    glDisable(GL_POLYGON_OFFSET_FILL)

    glDisable(GL_LIGHTING)
    glDisable(GL_LIGHT0)
    glColor3f (1.0, 1.0, 1.0) ' color del alambre
    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
    glCallList (list)
    glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)

    glPopMatrix ()
    glFlush ()

End Sub


Sub gfxinit cdecl()
    Dim As GLfloat light_ambient (3) = { 0.0, 0.0, 0.0, 1.0 }
    Dim As GLfloat light_diffuse (3) = { 1.0, 1.0, 1.0, 1.0 }
    Dim As GLfloat light_specular(3) = { 1.0, 1.0, 1.0, 1.0 }
    Dim As GLfloat light_position(3) = { 1.0, 1.0, 1.0, 0.0 }
    Dim As GLfloat global_ambient(3) = { 0.2, 0.2, 0.2, 1.0 }

    glClearColor (0.0, 0.0, 0.0, 1.0)

    list = glGenLists(1)
    glNewList (list, GL_COMPILE)
       glutSolidSphere(1.0, 20, 12)
    glEndList ()

    glEnable(GL_DEPTH_TEST)

    glLightfv (GL_LIGHT0, GL_AMBIENT,  @light_ambient (0) )
    glLightfv (GL_LIGHT0, GL_DIFFUSE,  @light_diffuse (0) )
    glLightfv (GL_LIGHT0, GL_SPECULAR, @light_specular(0) )
    glLightfv (GL_LIGHT0, GL_POSITION, @light_position(0) )
    glLightModelfv (GL_LIGHT_MODEL_AMBIENT, @global_ambient(0) )
End Sub

Sub reshape cdecl(width_ as integer, height as integer)
    glViewport (0, 0, width_, height)
    glMatrixMode (GL_PROJECTION)
    glLoadIdentity ()
    gluPerspective(45.0, width_/height, 1.0, 10.0)
    glMatrixMode (GL_MODELVIEW)
    glLoadIdentity ()
    gluLookAt (0.0, 0.0, 5.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0)
End Sub

' futura version
'Sub mouse Cdecl( button as integer , state as integer, x as integer , y as integer)
'	
'   Select Case (button) 
'	case GLUT_LEFT_BUTTON:
'	    Select Case (state) 
'	    	case GLUT_DOWN:
'		    
'		end select
'            
'	case GLUT_MIDDLE_BUTTON:
'	    Select Case (state) 
'	    	case GLUT_DOWN:
'		    
'		end select
'            
'	case GLUT_RIGHT_BUTTON:
'	    Select Case (state) 
'			case GLUT_UP:
'				
'	    End select
'          
'   end Select
'
'end sub

sub keyboard cdecl(key as ubyte, x as integer, y as integer)
   select case (key) 
   	
   	' rotaciones
   	Case Asc("a"), Asc("A") ' izq
   		yspeed-=.1 : If yspeed<-10 Then yspeed=-10
   		
   	Case Asc("d"), Asc("D") 'der 
   		yspeed+=.1 : If yspeed>10 Then yspeed=10
   		
   	Case Asc("w"), Asc("W") ' arriba
   		 xspeed-=.1 : If xspeed<-10 Then xspeed=-10
   		
   	Case Asc("s"), Asc("S") ' abajo
   		xspeed+=.1 : If xspeed>10 Then xspeed=10
   	


   	' modo sombreado o vacio 
   	case asc("z"),Asc("Z"): ' sombras
			color_solid(0) = 0.2
			color_solid(1) = 0.0
			color_solid(2) = 0.2
			color_shade(0) = 0.4
			color_shade(1) = 0.0
			color_shade(2) = 0.4

   	case asc("x"),Asc("X"): ' vacio
			color_solid(0) = 0.0
			color_solid(1) = 0.0
			color_solid(2) = 0.0
			color_shade(0) = 0.0
			color_shade(1) = 0.0
			color_shade(2) = 0.0
                  
   	
   	
   	' acercamiento a la figura 
   	case asc("q"),Asc("Q"):
         if (zdist < 4.0) Then zdist = (zdist + 0.03)
         
   	case asc("e"),Asc("E"):
         if (zdist > -5.0) Then zdist = (zdist - 0.03)
         
         
         
      ' distancia al solido desde el alambre   
   	case asc("1"):
         PolyOffset = PolyOffset + 1.1
			Print "PolyOffset ", PolyOffset
         
   	case asc("2"):
         PolyOffset = PolyOffset - 1.1
			Print "PolyOffset ", PolyOffset
         
         
         
      ' unidades de desplazamiento respecto al espesor
   	case asc("3"):
         PolyUnits = polyunits + 10.0
			Print "PolyUnits ", polyunits
         
   	case asc("4"):
         PolyUnits = polyunits - 10.0
			Print "PolyUnits ", polyunits
         
         
   	Case 27
   		end

   end Select
   
End sub

Sub TimerFunc cdecl (v as integer)
	xrot = xrot + xspeed  ' aceleracion X
	yrot = yrot + yspeed  ' aceleracion Y
  	glutTimerFunc(1,@TimerFunc,0)
  	glutPostRedisplay()
End Sub

    glutInit 1, strptr( " " )    
    
    glutInitDisplayMode(GLUT_SINGLE Or GLUT_RGB Or GLUT_DEPTH)
    glutInitWindowPosition 0, 0
    glutInitWindowSize 1024, 768
    glutCreateWindow "FreeBASIC OpenGL OFFSET example"
    
    glutReshapeFunc (@reshape)
    glutDisplayFunc (@display)
    'glutMouseFunc   (@mouse) ' futura version
    glutKeyboardFunc(@keyboard)
    glutTimerFunc (1,@TimerFunc,0) ' llamadas cada milisegundo para refrescar pantalla
    
    gfxinit()
    
    glutMainLoop()
	
