use <Write.scad>

$fn=50;
wall = 3; 
PCB_l = 72;   		
PCB_w = 125; 
PCB_ofst_l = 1.5;
PCB_ofst_w = 1.5; 
Height = 15;	// 15
Cover_h = 3;
Top_Thickness = 2;
Post_Height = 10;
debug = 0; 

module POST(){
	difference(){	
		translate([0 ,0,-0.5])
		minkowski()												
		cylinder(r=2.5,h=Post_Height); 		// post
		cylinder(r=1.5,h=Post_Height+1);		// drill shaft / inner hole
	}
}

module ANT(){	
	translate([0 ,0,-4])
	rotate([-90,0,0])
	cylinder(r=2.5,h=wall); 
}

module POSTS(){
	offset_w = 5.5;
	offset_l = 4.5;
	h = -Post_Height;

	translate([PCB_w/2 - offset_w + PCB_ofst_w ,PCB_l/2 - offset_l - PCB_ofst_l,h])
	POST();

	translate([PCB_w/2 - offset_w + PCB_ofst_w,-(PCB_l/2) + offset_l - PCB_ofst_l,h])
	POST();

	translate([-PCB_w/2 + offset_w + PCB_ofst_w,PCB_l/2 - offset_l - PCB_ofst_l,h])
	POST();

	translate([-PCB_w/2 + offset_w + PCB_ofst_w,-(PCB_l/2) + offset_l - PCB_ofst_l,h])
	POST();
}

module USB(){
	translate([0,-(PCB_l+wall)/2 - PCB_ofst_l,7/2+0.5]) 
	cube([15,wall,7],center = true); 
}

module MUSB(){
	translate([18+PCB_ofst_w,-(PCB_l+wall)/2 - PCB_ofst_l,3/2+0.5]) 
	cube([8,wall,3],center = true); 
}

module RJ(){
	translate([43+PCB_ofst_w,-(PCB_l+wall)/2 - PCB_ofst_l,13/2+1]) 
	cube([16,wall,13],center = true); 
}

module PWR(){
	translate([(PCB_w+wall)/2+PCB_ofst_w,-PCB_ofst_l-6,11/2+0.5]) 
	cube([wall,9,11],center = true); 
}

module ANTS(){
	translate([-PCB_w/2+PCB_ofst_w+4 + 20,PCB_l/2+1.5,0]) 
	ANT();

	translate([-PCB_w/2+PCB_ofst_w+4 + 35,PCB_l/2+1.5,0]) 
	ANT();
}

module PCB(){
	translate([PCB_ofst_w,-PCB_ofst_l,0]) 
	cube([PCB_w,PCB_l,1],center = true); 
}

module IO(){
	USB();
	MUSB();
	RJ();
	PWR();
	ANTS();
}

module BOTTOM(){
	if (debug == 1){
		IO();
		PCB();
	}

	POSTS();

	margin = 3; // negative margin

	difference(){
		translate([-(PCB_w+wall-margin)/2,-(PCB_l+wall-margin)/2,-Post_Height-Top_Thickness])
		minkowski(){												//Body
 			cube([PCB_w+wall-margin,PCB_l+wall-margin,Height]);
 			cylinder(r=3.5,h=Height);
		}

		translate([-(PCB_w-margin)/2,-(PCB_l-margin)/2,-Post_Height-2])
		minkowski(){												// inner cavity
 			cube([PCB_w-margin,PCB_l-margin,Height+2]);
 			cylinder(r=3.5,h=Height+2);
		}	

		IO();
		PCB();
	}
}

module COVER(){
	wedge_h=2;		
	margin = 3; // negative margine

	// cover top section
	difference(){
		translate([-(PCB_w+wall-margin)/2,-(PCB_l+wall-margin)/2,23])
		minkowski(){												//Body
 			cube([PCB_w+wall-margin,PCB_l+wall-margin,1]);
 			cylinder(r=3.5,h=1);
		}

		translate([0,0,26])
		write("Intel",t=4,h=20,center=true, rotate=[180,180,180],font = "orbitron.dxf");
	}

	// cover wedge
	difference(){
		translate([-(PCB_w+wall-margin)/2+1.5,-(PCB_l+wall-margin)/2+1.5,19])
		minkowski(){												//Body
 			cube([PCB_w+wall-margin-3,PCB_l+wall-margin-3,wedge_h]);
 			cylinder(r=3.5,h=wedge_h);
		}

		translate([-(PCB_w-margin)/2+1,-(PCB_l-margin)/2+1,19])
		minkowski(){												//Inner cavity
 			cube([PCB_w-margin-2,PCB_l-margin-2,wedge_h]);
 			cylinder(r=3.5,h=wedge_h);
		}
	}
}

// BOTTOM();
COVER();
