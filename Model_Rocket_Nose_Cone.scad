// Model rocket nose cone by Lutz Paelke (lpaelke)
// CC BY-NC-SA 3.0
// Model modified by John Hawley

// change fill% of print to alter weight

// Inner diameter of the rocket body
Diameter_In=25.65;

// Outer diameter of the rocket body
Diameter_Out=28.72;

radius_in=Diameter_In/2;	// inside radius of rocket tube, should be >= 7 
radius_out=Diameter_Out/2;	// ouside radius of rocket tube / nose cone, should be > radius_in

// Length of nose cone
Length=150;

// How many sides to render for the cone
Cone_Render_Resolution=120;

// Enter "parabolic", "power_series", "haack" or "<blank>" to default to Lutz Paelke (lpaelke) cone design
Cone_Shape="";

// Length of the adapter section (insertion to rocket body)
Adaptor_Length=20;
variable_adapter_Length=Adaptor_Length-2-2-2; // 9.25

// Recovery hole size (Y Axis)
Recovery_Hole_Size_Y=6;
// Recovery hole size (X Axis)
Recovery_Hole_Size_X=10; // (radius_in*2) - (radius_in*2)/3;
// Width/Strength of the recovery rod
Recovery_Rod_Girth=3;


union(){
    // Fastner section
    difference(){
        difference() {
        //     cylinder(h=15, r1=radius_in-taper, r2=radius_in,$fn=60);
            union(){
                translate ([0,0,variable_adapter_Length+4]) linear_extrude(2){
                    circle(r=radius_in-1, $fn=Cone_Render_Resolution);
                }
                translate ([0,0,variable_adapter_Length+2]) linear_extrude(2){
                    circle(r=radius_in, $fn=Cone_Render_Resolution);
                }
                translate ([0,0,2]) linear_extrude(variable_adapter_Length){
                    circle(r=radius_in-1, $fn=Cone_Render_Resolution);
                }
                linear_extrude(2){
                    circle(r=radius_in, $fn=Cone_Render_Resolution);
                }
            }
            translate ([-Recovery_Hole_Size_X/2,-Recovery_Hole_Size_Y/2,-1]) cube(size = [Recovery_Hole_Size_X,Recovery_Hole_Size_Y,2]);
            translate ([0,Recovery_Hole_Size_Y/2,1]) rotate ([90,0,0]) cylinder(h=Recovery_Hole_Size_Y,r=Recovery_Hole_Size_X/2,$fn=Cone_Render_Resolution);
        }
        
  }
 
    difference() {
        translate([0,Recovery_Hole_Size_Y/2,2]) rotate([90,0,0]) cylinder(h=Recovery_Hole_Size_Y,r=Recovery_Rod_Girth/2,$fn=60);
        translate ([0,0,-29]) cylinder(h=30,r=radius_in,$fn=60); // Saftey cynlinder to cut off bottom
    }
    translate([-Recovery_Rod_Girth/2,Recovery_Hole_Size_Y/2,0]) rotate([90,0,0]) cube(size = [Recovery_Rod_Girth,2,Recovery_Hole_Size_Y]);
    
    // Cone section
    if (Cone_Shape == "parabolic") {
        translate([0,0,Adaptor_Length]) cone_parabolic(R = radius_out, L = Length, K = 1, s = Cone_Render_Resolution);
    }
    if (Cone_Shape == "power_series") {
        translate([0,0,Adaptor_Length]) cone_power_series(n = 0.5, R = radius_out, L = Length, s = Cone_Render_Resolution);
    }
    
    if (Cone_Shape == "haack") {
        translate([0,0,Adaptor_Length]) cone_haack(C = 0.3333, R = radius_out, L = Length, s = Cone_Render_Resolution);
    }
    if (Cone_Shape != "parabolic" && Cone_Shape != "power_series" && Cone_Shape != "haack") {
        translate ([0,0,Adaptor_Length]) scale([1,1,Length/radius_out]) difference() {
            sphere(r = radius_out, $fn = Cone_Render_Resolution); // Adjust the sphere radius
            translate ([0,0,-radius_out/2]) cube(size=[2*radius_out,2*radius_out,radius_out],center=true);
        }
    }
}





// Thank you: ggoss (https://www.thingiverse.com/thing:2004511)
// For translating the math into OpenSCAD!
// Nose Cone Design: https://en.wikipedia.org/wiki/Nose_cone_design


module cone_haack(C = 0, R = 5, L = 10, s = 500){

// SEARS-HAACK BODY NOSE CONE:
//
// Parameters:
// C = 1/3: LV-Haack (minimizes supersonic drag for a given L & V)
// C = 0: LD-Haack (minimizes supersonic drag for a given L & D), also referred to as Von Kármán
//
// Formulae (radians):
// theta = acos(1 - (2 * x / L));
// y = (R / sqrt(PI)) * sqrt(theta - (sin(2 * theta) / 2) + C * pow(sin(theta),3));

echo(str("SEARS-HAACK BODY NOSE CONE"));
echo(str("C = ", C)); 
echo(str("R = ", R)); 
echo(str("L = ", L)); 
echo(str("s = ", s)); 

TORAD = PI/180;
TODEG = 180/PI;

inc = 1/s;

rotate_extrude(convexity = 10, $fn = s)
for (i = [1 : s]){
    x_last = L * (i - 1) * inc;
    x = L * i * inc;

    theta_last = TORAD * acos((1 - (2 * x_last/L)));
    y_last = (R/sqrt(PI)) * sqrt(theta_last - (sin(TODEG * (2*theta_last))/2) + C * pow(sin(TODEG * theta_last), 3));

    theta = TORAD * acos(1 - (2 * x/L));
    y = (R/sqrt(PI)) * sqrt(theta - (sin(TODEG * (2 * theta)) / 2) + C * pow(sin(TODEG * theta), 3));

    rotate([0, 0, -90]) polygon(points = [[x_last - L, 0], [x - L, 0], [x - L, y], [x_last - L, y_last]], convexity = 10);
}
}

module cone_parabolic(R = 5, L = 10, K = 0.5, s = 500){
// PARABOLIC NOSE CONE
//
// Formula: y = R * ((2 * (x / L)) - (K * pow((x / L),2)) / (2 - K);
//
// Parameters:
// K = 0 for cone
// K = 0.5 for 1/2 parabola
// K = 0.75 for 3/4 parabola
// K = 1 for full parabola

echo(str("PARABOLIC NOSE CONE"));
echo(str("R = ", R)); 
echo(str("L = ", L)); 
echo(str("K = ", K)); 
echo(str("s = ", s)); 
    
if (K >= 0 && K <= 1){

    inc = 1/s;

    rotate_extrude(convexity = 10, $fn = s)
    for (i = [1 : s]){
        
        x_last = L * (i - 1) * inc;
        x = L * i * inc;

        y_last = R * ((2 * ((x_last)/L)) - (K * pow(((x_last)/L), 2))) / (2 - K);
        y = R * ((2 * (x/L)) - (K * pow((x/L), 2))) / (2 - K);

        polygon(points = [[y_last, 0], [y, 0], [y, L - x], [y_last, L - x_last]], convexity = 10);
    }
} else echo(str("ERROR: K = ", K, ", but K must fall between 0 and 1 (inclusive)."));
}

module cone_power_series(n = 0.5, R = 5, L = 10, s = 500){
// POWER SERIES NOSE CONE:
//
// Formula: y = R * pow((x / L), n) for 0 <= n <= 1
//
// Parameters:
// n = 1 for a cone
// n = 0.75 for a 3/4 power
// n = 0.5 for a 1/2 power (parabola)
// n = 0 for a cylinder

echo(str("POWER SERIES NOSE CONE"));
echo(str("n = ", n)); 
echo(str("R = ", R)); 
echo(str("L = ", L)); 
echo(str("s = ", s)); 

inc = 1/s;

rotate_extrude(convexity = 10, $fn = s)
for (i = [1 : s]){

    x_last = L * (i - 1) * inc;
    x = L * i * inc;

    y_last = R * pow((x_last/L), n);
    y = R * pow((x/L), n);

    rotate([0, 0, 90]) polygon(points = [[0,y_last],[0,y],[L-x,y],[L-x_last,y_last]], convexity = 10);
}
}

