// Customisable Latching Broom Holder by GregFrost
// Licensed under the Creative Commons - Attribution - Non-Commercial - Share Alike license
// © 2017 by GregFrost
// http://www.thingiverse.com/thing:2029895
//
// Modified to add GOEWS cleat 2025-01-25 @andrew_3d
// Modified to add printed hinge pins 2025-01-26 @andrew_3d

//The diameter of the broom to be mounted. consider adding a small clearance.
broom_diameter=22;

//Total height of the hinge.
hinge_height=22;

//Include printed hinge pins
use_printed_pins = true; // [true, false]

//Diameter of the holes for the hinge pins.
hinge_pin_hole_diameter=4;

//Horizontal clearance around printed hinge pins
hinge_pin_horizontal_clearance = 0.3;

//The vertical gap where the layers should break.
vertical_clearance=0.31;

//Your printer's extruded width.
extruded_width=0.5;

//Number of passes of filament surrounding hinge holes. 
//The the thickness of the rest of the model is about double this.
num_filament_passes=4;

//Space around hinge parts.
hinge_clearance=1;


/////////////////////////////////////////////////////////////////////////////////////////////////

// The arbitrary part with first layer inset. 
module inset_first_layer(inset_height=0.31,inset_width=0.2)
{ 
    difference()
    { 
        children();

        translate([0,0,-1])
        linear_extrude(height=inset_height+1)
        difference()
        {
            offset(r = inset_width) 
            projection(cut=true) 
            translate([0,0,-inset_height])
            children();

            offset(r = -inset_width) 
            projection(cut=true) 
            translate([0,0,-inset_height])
            children();
        }
    } 
} 

show_cross_section=false;

//This controls the angle of the hinge loop. 
//For small diameters it is necessary to reduce the angle so it doesnt join the front support arm.
x=(broom_diameter >= 12)?48:(48-(12-broom_diameter)*4);
t=extruded_width*num_filament_passes;
$fn=64;
epsilon=0.01;
final_angle=78;

spacing=3;

A=[0,broom_diameter/2+t+hinge_pin_hole_diameter/2];
B=(broom_diameter/2+t*2+hinge_pin_hole_diameter/2)*[sin(x),cos(x)];
B2=[B[0]+hinge_pin_hole_diameter/2+t,B[1]];
C=[B2[0],A[1]-t];
D=[C[0]+t+hinge_pin_hole_diameter/2,C[1]];
E=[D[0]+t+hinge_pin_hole_diameter/2,D[1]];
F=[E[0],broom_diameter/2*0.6];
F2=[F[0]+hinge_pin_hole_diameter/2,F[1]];
G=[broom_diameter/2+t+hinge_pin_hole_diameter/2,0];

I=F2+(2*t+spacing)*[1,1];
J=[I[0],A[1]+hinge_pin_hole_diameter/2+t+spacing+t];

K=(broom_diameter/2+t)*[cos(final_angle),-sin(final_angle)];

/* [Hidden] */
default_cleat_height = 11.15;
real_cleat_height = min(default_cleat_height, hinge_height - 13.15);

// Locate key design waypoints.
*translate(B)
color("blue")
cylinder(d=1,h=hinge_height*1.5);

module arc(r1=1,r2=2,angle=45)
{
	difference()
	{
		intersection()
		{
			circle(r=r2);
			translate([-r2*3/2,0])
			square(3*r2);
			rotate(angle-180)
			translate([-r2*3/2,0])
			square(3*r2);
		}
		circle(r=r1);
	}
}

module hinge1()
{
	translate(A) 
	circle(d=hinge_pin_hole_diameter);
	
	rotate(90-x)
	arc(r1=broom_diameter/2+t,r2=broom_diameter/2+t+epsilon,angle=x);
}

module hinge2()
{
	translate(B)
	rotate(-x-90)
	arc(r1=t+hinge_pin_hole_diameter/2,r2=t+hinge_pin_hole_diameter/2+epsilon,angle=90+x);

	translate(B2)
	square([epsilon,C[1]-B2[1]]);

	translate(D)
	arc(r1=t+hinge_pin_hole_diameter/2,r2=t+hinge_pin_hole_diameter/2+epsilon,angle=180);
}

module hinge3()
{
	translate(F)
	square([epsilon,E[1]-F[1]]);

	hull()
	{
		translate(F+[hinge_pin_hole_diameter/2,0])
		circle(d=hinge_pin_hole_diameter);
	
		translate(G)
		circle(d=hinge_pin_hole_diameter);
	}

	rotate(-final_angle)
	arc(r1=broom_diameter/2+t,r2=broom_diameter/2+t+epsilon,angle=final_angle);
}

module hinge_holes()
{
        translate(A)
        circle(d=hinge_pin_hole_diameter);
        translate(F2)
        circle(d=hinge_pin_hole_diameter);
}

module hinge_pins()
{
        translate(A)
        circle(d=hinge_pin_hole_diameter - hinge_pin_horizontal_clearance * 2.0);
        translate(F2)
        circle(d=hinge_pin_hole_diameter - hinge_pin_horizontal_clearance * 2.0);
}

module hinge()
{
    difference ()
    {
        z=3;
    
        union()
        {
            offset(r=-z)
            offset(r=t+z)
            hinge1();
            
            offset(r=t)
            hinge2();
    
            offset(r=-z)
            offset(r=t+z)
            hinge3();
        }
    }
}

module hinge_clearance()
{
    offset(r=hinge_clearance)
    hinge();

    translate(F2)
    rotate(90)
    translate(-F2)
    offset(r=hinge_clearance)
    hinge();
}

module hinge_cone()
{
    cylinder(d1=hinge_pin_hole_diameter+2*t-2.1*extruded_width,d2=0,h=hinge_pin_hole_diameter+2*t-2.1*extruded_width);
}

module right_hinge()
{
    union() {
    if (use_printed_pins == true) 
    {    
        translate([0,0,1 + vertical_clearance])
        linear_extrude(height=hinge_height - 1 - vertical_clearance,convexity=4)
        hinge_pins();
    }
    difference()
    {
        linear_extrude(height=hinge_height,convexity=4)
        hinge();
        
        translate([0,0,1])
        linear_extrude(height=hinge_height,convexity=4)
        hinge_holes();
 
        translate([0,0,hinge_height/4-vertical_clearance/2])
        linear_extrude(height=hinge_height/2+vertical_clearance,convexity=4)
        union()
        {
            mount_clearance();
            translate(A)
            circle(d=hinge_pin_hole_diameter+2*t+2*hinge_clearance);
        }

        translate([0,0,hinge_height*3/4+vertical_clearance/2-epsilon])
        translate(A)
        hinge_cone();
        
        translate([0,0,hinge_height*3/4+vertical_clearance/2-epsilon])
        translate(F2)
        hinge_cone();
    }}
}

module left_hinge()
{
    mirror([1,0,0])
    union() {
    if (use_printed_pins == true) 
    {
    translate([0,0,1 + vertical_clearance])
        linear_extrude(height=hinge_height - 1 - vertical_clearance,convexity=4)
        hinge_pins();
    }
    difference()
    {
        linear_extrude(height=hinge_height,convexity=4)
        hinge();
 
        translate([0,0,1])
        linear_extrude(height=hinge_height,convexity=4)
        hinge_holes();
        
        for (z=[-1,hinge_height*3/4-vertical_clearance/2])
        translate([0,0,z])
        linear_extrude(height=hinge_height/4+vertical_clearance/2+1,convexity=4)
        union()
        {
            mount_clearance();
            translate(A)
            circle(d=hinge_pin_hole_diameter+2*t+2*hinge_clearance);
        }
        
        translate([0,0,hinge_height/4+vertical_clearance/2-epsilon])
        translate(F2)
        hinge_cone();

        translate([0,0,hinge_height/4+vertical_clearance/2-epsilon])
        translate(A)
        hinge_cone();
    }
}
}

module mount1()
{
    translate(F2)
    circle(d=hinge_pin_hole_diameter+2*t);
}
module mount2()
{
    translate(I)
    circle(d=hinge_pin_hole_diameter+2*t);
}
module mount3()
{
    translate(J+[0,0])
    square([hinge_pin_hole_diameter+2*t,t*2],center=true);
}
module mount4()
{
    translate([0,J[1]-t])
    square([hinge_pin_hole_diameter+2*t,t*2]);
}

module half_mount()
{
    hull()
    {
        mount1();
        mount2();
    }
    
    hull()
    {
        mount2();
        mount3();
    }
    
    hull()
    {
        mount3();
        mount4();
    }
}

module mount_profile()
offset(r=-3)
offset(delta=3)
{
    half_mount();
    mirror([1,0,0])
    half_mount();
    
}

module mount_outline()
{
    difference()
    {
        mount_profile();
        offset(r=-0.5)
        mount_profile();
    }
}

*mount_outline();

module mount_clearance()
{
    offset(r=hinge_clearance)
    mount_profile();

    translate(F2)
    rotate(-90)
    translate(-F2)
    offset(r=hinge_clearance)
    mount_profile();
}

*mount_clearance();

module mount(assembled=false)
{ 
    difference()
    {
        union(){
            linear_extrude(height=hinge_height,convexity=4)
            mount_profile();
            translate([0, (hinge_pin_hole_diameter - 3) + (broom_diameter - 22) / 2.0 + 25, hinge_height - real_cleat_height])
                rotate([0, 0, 180])
                    GOEWSCleatTool();
        }
        
        translate(v = [0, (hinge_pin_hole_diameter - 3) + (broom_diameter - 22) / 2.0 + 25 + 0.1, hinge_height + 0.46 - real_cleat_height + 11.24]) {
            rotate([90, 0, 0])
                cylinder(h = 14 + 0.2, r = 7, $fn = 256);
        }
        
        translate(v = [0, (hinge_pin_hole_diameter - 3) + (broom_diameter - 22) / 2.0 + 25 - 6, hinge_height + 0.46 - real_cleat_height + 11.24]) {
            rotate([-90, 0, 0])
                cylinder(h = 4.1, r = 10, $fn = 256);
        }
        
        mirror([1,0,0])
        translate([0,0,hinge_height/4-vertical_clearance/2])
        linear_extrude(height=hinge_height/2+vertical_clearance,convexity=4)
        hinge_clearance();
        
        translate([0,0,-1])
        linear_extrude(height=hinge_height/4+vertical_clearance/2+1,convexity=4)
        hinge_clearance();

        translate([0,0,hinge_height-hinge_height/4-vertical_clearance/2])
        linear_extrude(height=hinge_height/4+vertical_clearance/2+1,convexity=4)
        hinge_clearance();
        
        translate(F2)
        translate([0,0,1])
        cylinder(d=hinge_pin_hole_diameter,h=hinge_height+2);

        mirror([1,0,0])
        translate(F2)
        translate([0,0,1])
        cylinder(d=hinge_pin_hole_diameter,h=hinge_height+2);

        translate([0,0,hinge_height/4+vertical_clearance/2-epsilon])
        translate(F2)
        hinge_cone();
        
        mirror([1,0,0])
        translate([0,0,hinge_height*3/4+vertical_clearance/2-epsilon])
        translate(F2)
        hinge_cone();
    }
}

//Create GOEWS cleats
module GOEWSCleatTool() {
    difference() {
        // main profile
        rotate(a = [180,0,0]) 
            linear_extrude(height = 13.15) 
                let (cleatProfile = [[0,0],[15.1,0],[17.6,2.5],[15.1,5],[0,5]])
                union(){
                    polygon(points = cleatProfile);
                    mirror([1,0,0])
                        polygon(points = cleatProfile);
                };
        // angled slice off bottom
        translate([-17.6, -8, -26.3])
            rotate([45, 0, 0])
                translate([0, 5, 0])
                    cube([35.2, 10, 15]);
        // cutout
        translate([0, -0.005, 2.964])
            rotate([90, 0, 0])
                cylinder(h = 6, r = 9.5, $fn = 256);
    }
}

module assembled()
{
    left_hinge();
    right_hinge();
    
    mount(assembled=true);

    if (!show_cross_section)
    {
        // The broom handle.
        translate([0,0,-hinge_height/2])
        %cylinder(d=broom_diameter,h=hinge_height*2);
    }
}


module assembled_and_inset()
{
    assembled();
}

if (show_cross_section)
{
    intersection()
    {
        assembled_and_inset();
        translate([0,F[1]])
        cube(100);
    }
}
else
{
    assembled_and_inset();
}
