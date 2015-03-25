use <Write.scad>
$fn=50;
wall = 3; 
PCB_l = 50.7; // bottom 		
PCB_w = 40.7; // 
BREADB_x_offset = 1.5; // corner offset
LED_Matrix_l = 35;
LED_Matrix_w = 25;
PIR_lw = 23;
BREADB_l = 46; // change corners
BREADB_w = 35;// change corners						
Height = 40;									//total package height
Top_Thickness = 1;
Post_Height = 9;
Mount_h = 5;

Box_LED = 1;
Box_PIR = 2;
Box_LT = 3; // LightTemp

Box_Type = Box_LED;


module POST(){
	difference(){	
		minkowski()												
			cylinder(r=2.5,h=Post_Height); 		// post
			cylinder(r=1.5,h=Post_Height+1);		//Drill shaft / inner hole
	}
}

module LED_Matrix_Posts(){
	// for LED matrix we need only posts
	translate([LED_Matrix_w/2 ,LED_Matrix_l/2+4,Height-Post_Height-Top_Thickness])
	POST();

	translate([-LED_Matrix_w/2 ,-(LED_Matrix_l/2+4),Height-Post_Height-Top_Thickness])
	POST();
}



module MOUNT_CORNER(){
	difference(){
		cube([3,3,Mount_h],center = true); //body
		translate([-1 ,-1,0]) // move relativly to body
			cube([3,3,Mount_h],center = true); //cavity
	}
}

module MOUNT_CORNERS(){
	translate([BREADB_w/2-0.5,BREADB_l/2+BREADB_x_offset-0.5,-Mount_h/2])
	MOUNT_CORNER();

	translate([-BREADB_w/2+0.5,BREADB_l/2+BREADB_x_offset-0.5,-Mount_h/2])
	rotate([0,0,90])
	MOUNT_CORNER();

	translate([BREADB_w/2-0.5,-BREADB_l/2+BREADB_x_offset+0.5,-Mount_h/2])
	rotate([0,0,270])
	MOUNT_CORNER();

	translate([-BREADB_w/2+0.5 ,-BREADB_l/2+BREADB_x_offset+0.5,-Mount_h/2])
	rotate([0,0,180])
	MOUNT_CORNER();
		
}

module USB(){
	translate([0,PCB_l/2+2,13+2+2]) // 13 breadboard height till the usb bottom . 2 is 4(usb height)/2 . 2 is bottom panel. 
		cube([9,wall,4],center = true); 
}

module BREADB(){

	translate([0,BREADB_x_offset,-5]) 
		cube([BREADB_w,BREADB_l,9],center = true); 

	translate([0,BREADB_x_offset+1,-11]) 
		cube([18,43,1],center = true); 
}

module PIR(){
	// dome insert
	translate([0,0,(Height)]) 
		cube([PIR_lw,PIR_lw,4],center = true); 
}

module LT(){
	// LTR
	translate([0,5,(Height)-Top_Thickness]) // 5 distance from the center
		cylinder(r=2.5,h=Top_Thickness); // 2.5 radius for LTR
	// Temp
	translate([0,-5,(Height)-Top_Thickness]) 
		cylinder(r=2.5,h=Top_Thickness);// 2.5 radius for Temp
		
}

module TOP(){

	if (Box_Type == Box_LED)
		LED_Matrix_Posts();	

	difference(){
		translate([-(PCB_w+wall)/2,-(PCB_l+wall)/2,0])
		minkowski(){												//Body
 			cube([PCB_w+wall,PCB_l+wall,Height/2]);
 			cylinder(r=1.5,h=Height/2);
		}
//		translate([-PCB_w/2,-PCB_l/2,Height-1]) //
//		minkowski(){												//Detent
// 			cube([PCB_w,PCB_l,Height/2]);
// 			cylinder(r=1.5,h=Height/2);
//		}
		translate([-PCB_w/2,-PCB_l/2,Top_Thickness*-1])
		minkowski(){												//Inner cavity
 			cube([PCB_w,PCB_l,Height/2]);
 			cylinder(r=1.5,h=Height/2);
		}	
		USB();
	translate([PCB_l/2-7,PCB_w/2-3,Height])
// write("WiseUp",t=5,h=4,center=true, rotate=[180,180,90],font = "orbitron.dxf"); 


		if (Box_Type == Box_PIR)								
			PIR();
		if (Box_Type == Box_LT)								
			LT();

	}

}


module BOTTOM(){

	mirror([0,0,1]){
	//BREADB();         // *uncomment to simulate breadboard +arduino
	MOUNT_CORNERS();
	difference(){
		// bottom height is determined by the cube height + cylinder height
		translate([-PCB_w/2,-PCB_l/2,0])
		minkowski(){												//Base
 			cube([PCB_w,PCB_l,1]);
 			cylinder(r=1.3,h=1);
		}

		//translate([-BREADB_w/2,-BREADB_l/2,0])
//		minkowski(){												//Cavity
// 			cube([BREADB_w,BREADB_l,1]);
// 			cylinder(r=2,h=1);
//		}
	}
}
}


TOP();
// BOTTOM();