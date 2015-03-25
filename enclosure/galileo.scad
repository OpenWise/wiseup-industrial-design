use <Write.scad>
$fn=50;
wall = 3; 
PCB_l = 72;   		
PCB_w = 122; 
PCB_ofst_l = 1.8;
PCB_ofst_w = 1.8; 
Height = 18;	// 15
Top_Thickness = 2;
Post_Height = 12;
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
	translate([40,PCB_l/2+1.5,0]) 
	ANT();

	translate([-40,PCB_l/2+1.5,0]) 
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

		translate([-(PCB_w-margin)/2,-(PCB_l-margin)/2,-Post_Height])
		minkowski(){												//Inner cavity
 			cube([PCB_w-margin,PCB_l-margin,Height]);
 			cylinder(r=3.5,h=Height);
		}	

		IO();
		PCB();
	}
}

BOTTOM();