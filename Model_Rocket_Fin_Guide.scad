/*

Based on the original SCAD file by garyacrowellsr at https://www.thingiverse.com/thing:4292667.
All drop-down menus and slider controls (except Tube Clearance mm) have been removed and replaced with open-ended fields to customize as you please.
Note: If your fin guides are not showing up on a larger outer diameter tube, increase the Guide Span mm until they begin showing again.
Original documentation remains below this line.

=============================================================================================

Fin positioning guides like this are not new, but it was done in a nice printed impelementation
by Dave Juliano in this thread on TRF:
https://www.rocketryforum.com/threads/3d-printer-plunge.146985/page-4

I liked it, so I stole it, with the OpenSCAD Customizer implementation here.


Usage is pretty much self-explanitory, and the best way to figure it out is just to play around
with the slider controls a bit.  See the blurb below, if you haven't used the Customizer before.

One difference I've made from the original is the addition of an optional flange at the 'fin tips'
of the guide, where I think there might be a weakness.  Also, since the sections are only held
together by a small web, I've included the option to thicken this web, though it might interfere
with the placement of the guide.


=============================================================================================
=================================  OpenSCAD Customizer ======================================
This file has been created with the intention to use the OpenSCAD 'Customizer', which allows 
the use of Windows-style selection tools to set parameters of the component.  The use of this
feature requires the following steps:

1.  You must be using the OpenScad 'Development Snapshot' version, available at:
    http://www.openscad.org/downloads.html  
    Scroll down to Development Snapshots,  use version OperSCAD 2018.09.05 or later.
      
2.  Open this file with OpenSCAD.

3.  In the OpenSCAD [Edit] menu, select [Preferences] then open tab [Features], check
    [Customizer], then close the window when the check is shown.
  
4.  In the OpenSCAD [View] menu, uncheck the option [Hide Customizer].  The Customizer
    window should open at the right side of the screen.

5.  At the top of the Customizer window, check 'Automatic Preview' and select 'Show Details'
    in the dropdown box.

6.  If you are comfortable with the instructions above, then also in the [View] menu, you can 
	check the option [Hide editor], which will allow the full screen to view the model.  You 
	can also check to [Hide Console].

*/



/* [Fin Guide Parameters] */
// Body Tube Diameter 
//Tube_Diameter_mm = 25;

Tube_Outer_Diameter_mm=24.8;

// Guide-to-Tube Clearance
Tube_Clearance_mm = 0.4; // [0:0.1:1.0]

Number_of_Fins = 3;

Fin_Thickness_mm = 1.6;

Guide_Span_mm = 25;

Guide_Height_mm = 15;

Guide_Wall_Thickness_mm = 2;

Guide_Foot_Thickness_mm = 2;

Guide_Foot_Width_mm = 4;
//
Include_End_Flange = true;
End_Foot_Thickness_mm = 4;


/* [Hidden] */ 
$fn = 180;
Guide_Tube_ID_mm = Tube_Outer_Diameter_mm + 2*Tube_Clearance_mm;

difference() { 
	union () { 
		// basic tube
		cylinder (h = Guide_Height_mm, d = Guide_Tube_ID_mm + 2*Guide_Wall_Thickness_mm);
		// foot cylinder
		cylinder (h = Guide_Foot_Thickness_mm, 
			d = Guide_Tube_ID_mm + 2*Guide_Wall_Thickness_mm + 2*Guide_Foot_Width_mm);
		for (j = [0 : 360/Number_of_Fins : 360-360/Number_of_Fins]) {
			rotate (a = [0, 0, j]) {
				// fin walls	
				hull () { 
					translate ([Guide_Span_mm/2, 0, Guide_Height_mm/4]) 
						cube (size = [Guide_Span_mm, Fin_Thickness_mm + 2*Guide_Wall_Thickness_mm, 
							Guide_Height_mm/2], center = true);
					translate ([Guide_Span_mm - Guide_Foot_Width_mm/2, 0, 
						Guide_Height_mm - Guide_Foot_Width_mm/2]) 
						rotate (a = [90, 0, 0]) 
						cylinder (h = Fin_Thickness_mm + 2*Guide_Wall_Thickness_mm,
							d = Guide_Foot_Width_mm, center = true);
					translate ([0, 0, Guide_Height_mm - Guide_Foot_Width_mm/2]) 
						rotate (a = [90, 0, 0]) 
						cylinder (h = Fin_Thickness_mm + 2*Guide_Wall_Thickness_mm,
							d = Guide_Foot_Width_mm, center = true);		
				}		
				// fin foot
				hull () { 
					translate ([Guide_Span_mm/2 + Guide_Foot_Width_mm/2, 0, Guide_Foot_Thickness_mm/2]) 
						cube (size = [Guide_Span_mm, 
							Fin_Thickness_mm + 2*Guide_Wall_Thickness_mm + 2*Guide_Foot_Width_mm, Guide_Foot_Thickness_mm], 
							center = true);
					translate ([Guide_Span_mm + Guide_Foot_Width_mm - Guide_Foot_Width_mm/4,
						Fin_Thickness_mm/2 + Guide_Wall_Thickness_mm + Guide_Foot_Width_mm -
						Guide_Foot_Width_mm/2, 0]) 
						cylinder (h = Guide_Foot_Thickness_mm, d = Guide_Foot_Width_mm);	
					translate ([Guide_Span_mm + Guide_Foot_Width_mm - Guide_Foot_Width_mm/4,
						-(Fin_Thickness_mm/2 + Guide_Wall_Thickness_mm + Guide_Foot_Width_mm -
						Guide_Foot_Width_mm/2), 0]) 
						cylinder (h = Guide_Foot_Thickness_mm, d = Guide_Foot_Width_mm);
				}
			
				// end web
				if (Include_End_Flange == true ) {
					difference() { 
						hull () { 
							translate ([Guide_Span_mm + Guide_Foot_Width_mm - Guide_Foot_Width_mm/4,
								Fin_Thickness_mm/2 + Guide_Wall_Thickness_mm + Guide_Foot_Width_mm -
								Guide_Foot_Width_mm/2, 0]) 
								cylinder (h = Guide_Foot_Thickness_mm, d = Guide_Foot_Width_mm);	
							translate ([Guide_Span_mm + Guide_Foot_Width_mm - Guide_Foot_Width_mm/4,
								-(Fin_Thickness_mm/2 + Guide_Wall_Thickness_mm + Guide_Foot_Width_mm -
								Guide_Foot_Width_mm/2), 0]) 
								cylinder (h = Guide_Foot_Thickness_mm, d = Guide_Foot_Width_mm);
							translate ([Guide_Span_mm - Guide_Foot_Width_mm/2, 0, 
								Guide_Height_mm - Guide_Foot_Width_mm/2]) 
								rotate (a = [90, 0, 0]) 
								cylinder (h = Fin_Thickness_mm + 2*Guide_Wall_Thickness_mm,
									d = Guide_Foot_Width_mm, center = true);						
						}
						translate ([Guide_Span_mm, 0, Guide_Height_mm/2+End_Foot_Thickness_mm]) 
							cube (size = [Guide_Span_mm, Fin_Thickness_mm, Guide_Height_mm], 
							center = true);
					}
				} 
			}
		}
	}
	// subtract center tube
	cylinder (h = 3*Guide_Height_mm, d = Guide_Tube_ID_mm, center = true);
	// subtract fins
	for (j = [0 : 360/Number_of_Fins : 360-360/Number_of_Fins]) {
		rotate (a = [0, 0, j]) {	
			translate ([Guide_Span_mm/2 + 0.01, 0, 0]) 
			cube (size = [Guide_Span_mm, Fin_Thickness_mm, 3*Guide_Height_mm], center = true);
		}
	}
}
	
