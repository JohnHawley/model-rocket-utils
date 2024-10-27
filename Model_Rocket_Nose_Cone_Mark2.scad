// Model rocket nose cone by Lutz Paelke (lpaelke)
// CC BY-NC-SA 3.0
// Model modified by John Hawley

// change fill% of print to alter weight

// Inner diameter of the rocket body
Diameter_In = 23.4;

// Outer diameter of the rocket body
Diameter_Out = 25.6;

radius_in = Diameter_In / 2;   // inside radius of rocket tube, should be >= 7
radius_out = Diameter_Out / 2; // ouside radius of rocket tube / nose cone, should be > radius_in

// Length/Height of nose cone
Length = 150;

// Thickness of the cone wall
Cone_Wall_Thickness = 1.2;

// Enter "parabolic", "power_series", "haack" or "<blank>" to default to Lutz Paelke (lpaelke) cone design
Cone_Shape = "";

// How many sides to render for the cone
Cone_Render_Resolution = 120;

// Length of the shoulder section (insertion to rocket body)
Shoulder_Length = 20;

// Wall thickness of the shoulder
Shoulder_Wall_Thickness = 0.8;

// Thickness of the bottom wall of the shoulder
Shoulder_Bottom_Thickness = 1.5;

// Height of the mating rings on the shoulder
Shoulder_Ring_Heights = 5;

// Thickness of the shoulder that inserts into the cone
Shoulder_to_Cone_Insert_Thickness = 1.5;

// Length of the shoulder that inserts into the cone
Shoulder_to_Cone_Insert_Length = 4;

// Tolerance for the shoulder of the cone as it meets the cone top, should be a snug fit
Shoulder_to_Cone_Insert_Tolerance = 0.1;

// Recovery Hole Border / Distance from the edge of the cone to the recovery hole
Recovery_Hole_Border = 5;

// Diameter of the recovery rod (Min 2, Max 6)
Recovery_Rod_Diameter = 4;
constrained_recovery_rod_diameter = min(max(Recovery_Rod_Diameter, 2), 6);

// Recovery hole size. How deep the cavity is.
Recovery_Hole_Height = 8;

inner_radius = radius_in - Shoulder_Wall_Thickness;
base_radius = radius_in - Recovery_Hole_Border;
recovery_hole_cone_top_radius = Shoulder_Wall_Thickness;
recovery_ring_recess = Shoulder_Wall_Thickness / 2;
recovery_hole_size = inner_radius * 2;

// Model: Shoulder
translate([ Diameter_Out, Diameter_Out, 0 ])
union()
{
	// Shoulder insertion, mating with the cone
	translate([ 0, 0, Shoulder_Length - Shoulder_to_Cone_Insert_Length ])
	difference()
	{
		// Outer cylinder (sides of the cup)

		cylinder(h = (Shoulder_to_Cone_Insert_Length * 2), r = radius_in - 1 - Shoulder_to_Cone_Insert_Tolerance,
		         center = false, $fn = Cone_Render_Resolution);

		// Inner cylinder (hollow part)
		translate([ 0, 0, -0.1 ])
		cylinder(h = (Shoulder_to_Cone_Insert_Length * 2) + 0.22,
		         r = inner_radius - recovery_ring_recess - Shoulder_to_Cone_Insert_Thickness, center = false,
		         $fn = Cone_Render_Resolution);

		// Chamfer at the bottom edge
		translate([ 0, 0, -0.1 ])
		cylinder(h = Shoulder_to_Cone_Insert_Length, r1 = radius_in - Shoulder_to_Cone_Insert_Thickness,
		         r2 = inner_radius - recovery_ring_recess - Shoulder_to_Cone_Insert_Thickness, center = false,
		         $fn = Cone_Render_Resolution);
	}

	// Top ring of the shoulder
	translate([ 0, 0, Shoulder_Length - Shoulder_Ring_Heights - 3 ])
	difference()
	{
		// Outer cylinder (sides of the cup)

		cylinder(h = Shoulder_Ring_Heights, r = radius_in, center = false, $fn = Cone_Render_Resolution);

		// Inner cylinder (hollow part)
		translate([ 0, 0, -0.1 ])
		cylinder(h = Shoulder_Ring_Heights + 0.22, r = inner_radius - recovery_ring_recess, center = false,
		         $fn = Cone_Render_Resolution);
	}

	// Full shoulder height
	difference()
	{
		// Outer cylinder (sides of the cup)
		cylinder(h = Shoulder_Length, r = radius_in - recovery_ring_recess, center = false,
		         $fn = Cone_Render_Resolution);

		// Inner cylinder (hollow part)
		translate([ 0, 0, -0.1 ])
		cylinder(h = Shoulder_Length + 0.22, r = inner_radius - recovery_ring_recess, center = false,
		         $fn = Cone_Render_Resolution);
	}

	// Bottom ring of the shoulder
	difference()
	{
		// Outer cylinder (sides of the cup)
		cylinder(h = Shoulder_Ring_Heights, r = radius_in, center = false, $fn = Cone_Render_Resolution);

		// Inner cylinder (hollow part)
		translate([ 0, 0, -0.1 ])
		cylinder(h = Shoulder_Ring_Heights + 0.22, r = inner_radius - recovery_ring_recess, center = false,
		         $fn = Cone_Render_Resolution);
	}

	difference()
	{
		union()
		{
			// Inner cone
			cylinder(h = Recovery_Hole_Height, r1 = base_radius, r2 = recovery_hole_cone_top_radius, center = false,
			         $fn = Cone_Render_Resolution);

			// Bottom wall of the cone
			difference()
			{
				// Outer cylinder (sides of the ring/washer)
				cylinder(h = Shoulder_Bottom_Thickness, r = radius_in, center = false, $fn = Cone_Render_Resolution);

				// Inner cylinder (hollow part of the ring/washer)
				translate([ 0, 0, -0.1 ])
				cylinder(h = 1 + 0.22, r = 4, center = false, $fn = Cone_Render_Resolution);
			}
		}

		// Subtract the inner cone from cone
		translate([ 0, 0, -1 ])
		cylinder(h = Recovery_Hole_Height, r1 = base_radius, r2 = recovery_hole_cone_top_radius, center = false,
		         $fn = Cone_Render_Resolution);

		// Small pinhole at the top
		translate([ 0, 0, Recovery_Hole_Height - 1 ])
		cylinder(h = 2, r = (Shoulder_Wall_Thickness), center = false, $fn = Cone_Render_Resolution);
	}

	{
		difference()
		{
			translate([ 0, recovery_hole_size / 2, 1 ])
			rotate([ 90, 0, 0 ])
			cylinder(h = recovery_hole_size, r = constrained_recovery_rod_diameter / 2, $fn = 60);
			translate([ 0, 0, -10 ])
			cylinder(h = 10, r = radius_in, $fn = 60); // Saftey cynlinder to cut off bottom
		}
		translate([ -constrained_recovery_rod_diameter / 2, recovery_hole_size / 2, 0 ])
		rotate([ 90, 0, 0 ])
		cube(size = [ constrained_recovery_rod_diameter, 1, recovery_hole_size ]);
	}
}

// ----------------------------------

union()
{
	// Cone section
	if (Cone_Shape == "parabolic")
	{
		// Hoolow out cone with "Cone_Wall_Thickness" to save on material
		difference()
		{
			cone_parabolic(R = radius_out, L = Length, K = 1, s = Cone_Render_Resolution);
			cone_parabolic(R = radius_out - Cone_Wall_Thickness, L = Length - Cone_Wall_Thickness, K = 1,
			               s = Cone_Render_Resolution);
			// Cylinder to cut into where the shoulder will be inserted into
			translate([ 0, 0, -0.1 ])
			cylinder(h = Shoulder_to_Cone_Insert_Length, r = radius_in - 1 + Shoulder_to_Cone_Insert_Tolerance,
			         center = false, $fn = Cone_Render_Resolution);
		}
	}
	if (Cone_Shape == "power_series")
	{
		// Hoolow out cone with "Cone_Wall_Thickness" to save on material
		difference()
		{
			cone_power_series(n = 0.5, R = radius_out, L = Length, s = Cone_Render_Resolution);
			cone_power_series(n = 0.5, R = radius_out - Cone_Wall_Thickness, L = Length - Cone_Wall_Thickness,
			                  s = Cone_Render_Resolution);
			// Cylinder to cut into where the shoulder will be inserted into
			translate([ 0, 0, -0.1 ])
			cylinder(h = Shoulder_to_Cone_Insert_Length, r = radius_in - 1 + Shoulder_to_Cone_Insert_Tolerance,
			         center = false, $fn = Cone_Render_Resolution);
		}
	}

	if (Cone_Shape == "haack")
	{
		// Hoolow out cone with "Cone_Wall_Thickness" to save on material
		difference()
		{
			cone_haack(C = 0.3333, R = radius_out, L = Length, s = Cone_Render_Resolution);
			cone_haack(C = 0.3333, R = radius_out - Cone_Wall_Thickness, L = Length - Cone_Wall_Thickness,
			           s = Cone_Render_Resolution);
			// Cylinder to cut into where the shoulder will be inserted into
			translate([ 0, 0, -0.1 ])
			cylinder(h = Shoulder_to_Cone_Insert_Length, r = radius_in - 1 + Shoulder_to_Cone_Insert_Tolerance,
			         center = false, $fn = Cone_Render_Resolution);
		}
	}
	if (Cone_Shape != "parabolic" && Cone_Shape != "power_series" && Cone_Shape != "haack")
	{
		// Hoolow out cone with "Cone_Wall_Thickness" to save on material
		difference()
		{
			scale([ 1, 1, Length / radius_out ]) difference()
			{
				sphere(r = radius_out, $fn = Cone_Render_Resolution); // Adjust the sphere radius
				translate([ 0, 0, -radius_out / 2 ])
				cube(size = [ 2 * radius_out, 2 * radius_out, radius_out ], center = true);
			}
			scale([ 1, 1, Length / (radius_out - Cone_Wall_Thickness) ]) difference()
			{
				sphere(r = radius_out - Cone_Wall_Thickness, $fn = Cone_Render_Resolution); // Adjust the sphere radius
				translate([ 0, 0, -radius_out / 2 ])
				cube(size =
				         [ 2 * (radius_out - Cone_Wall_Thickness), 2 * (radius_out - Cone_Wall_Thickness), radius_out ],
				     center = true);
			}
			// Cylinder to cut into where the shoulder will be inserted into
			translate([ 0, 0, -0.1 ])
			cylinder(h = Shoulder_to_Cone_Insert_Length, r = radius_in - 1 + Shoulder_to_Cone_Insert_Tolerance,
			         center = false, $fn = Cone_Render_Resolution);
		}
	}

	// Cone Ring to mate with shoulder
	translate([ 0, 0, 0 ])
	difference()
	{
		// Outer cylinder (sides of the cup)

		cylinder(h = Shoulder_to_Cone_Insert_Length, r = radius_out - Cone_Wall_Thickness, center = false,
		         $fn = Cone_Render_Resolution);

		// Inner cylinder (hollow part)
		translate([ 0, 0, -0.1 ])
		cylinder(h = Shoulder_to_Cone_Insert_Length + 0.22, r = radius_in - 1 + Shoulder_to_Cone_Insert_Tolerance,
		         center = false, $fn = Cone_Render_Resolution);
	}
}

// Thank you: ggoss (https://www.thingiverse.com/thing:2004511)
// For translating the math into OpenSCAD!
// Nose Cone Design: https://en.wikipedia.org/wiki/Nose_cone_design

module cone_haack(C = 0, R = 5, L = 10, s = 500)
{

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

	TORAD = PI / 180;
	TODEG = 180 / PI;

	inc = 1 / s;

	rotate_extrude(convexity = 10, $fn = s) for (i = [1:s])
	{
		x_last = L * (i - 1) * inc;
		x = L * i * inc;

		theta_last = TORAD * acos((1 - (2 * x_last / L)));
		y_last = (R / sqrt(PI)) *
		         sqrt(theta_last - (sin(TODEG * (2 * theta_last)) / 2) + C * pow(sin(TODEG * theta_last), 3));

		theta = TORAD * acos(1 - (2 * x / L));
		y = (R / sqrt(PI)) * sqrt(theta - (sin(TODEG * (2 * theta)) / 2) + C * pow(sin(TODEG * theta), 3));

		rotate([ 0, 0, -90 ])
		polygon(points = [[x_last - L, 0], [x - L, 0], [x - L, y], [x_last - L, y_last]], convexity = 10);
	}
}

module cone_parabolic(R = 5, L = 10, K = 0.5, s = 500)
{
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

	if (K >= 0 && K <= 1)
	{

		inc = 1 / s;

		rotate_extrude(convexity = 10, $fn = s) for (i = [1:s])
		{

			x_last = L * (i - 1) * inc;
			x = L * i * inc;

			y_last = R * ((2 * ((x_last) / L)) - (K * pow(((x_last) / L), 2))) / (2 - K);
			y = R * ((2 * (x / L)) - (K * pow((x / L), 2))) / (2 - K);

			polygon(points = [[y_last, 0], [y, 0], [y, L - x], [y_last, L - x_last]], convexity = 10);
		}
	}
	else
		echo(str("ERROR: K = ", K, ", but K must fall between 0 and 1 (inclusive)."));
}

module cone_power_series(n = 0.5, R = 5, L = 10, s = 500)
{
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

	inc = 1 / s;

	rotate_extrude(convexity = 10, $fn = s) for (i = [1:s])
	{

		x_last = L * (i - 1) * inc;
		x = L * i * inc;

		y_last = R * pow((x_last / L), n);
		y = R * pow((x / L), n);

		rotate([ 0, 0, 90 ])
		polygon(points = [ [ 0, y_last ], [ 0, y ], [ L - x, y ], [ L - x_last, y_last ] ], convexity = 10);
	}
}
