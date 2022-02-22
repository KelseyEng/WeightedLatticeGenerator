This code creates lattice STLs that are suitable for additive manufacturing. The code has the ability to make unique lattices that meet fill fraction targets and avoid stress concentrations. The user can select a lattice type (octet, octahedral, etc) and desired parameters (size of certain type of struts/joints/fill fraction). The code then creates a lattice that meets the design requirements and outputs as an STL. This code was initially developed for the KAB Lab at Boston University's Mechanical Engineering Department.

The code allows several different base lattice types, and it is possible to add more in the future. Currently, the following features are supported:

1. Select among 5 different lattice types:
-Octet
-Reinforce Octet
-Octahedral
-Reinforced Octahedral
-BCC
2. Move mass from different types of struts or joints while maintaining a constant fill fraction.
3. Add support structure and base that gets the lattice off the build plate, increasing printability on resin printers.
4. Vary fill fraction vertically. For example, struts and joints have more mass at the bottom and less at the top.
5. Distort struts into ovals.

It also comes with the following code features designed to increase speed:
1. Takes advantage of 3 fold symmetry of many lattices. Therefore, it calculates one eighth of the lattices and then mirrors it to the other 8 octants. 
2. When using batch mode, it orders your list into the order that requires the least amount of calculations. Essentially, lattices that share base matrices can be computed much quicker in sequence than lattices that have different base matrices.
3. Down samples unit cell and then duplicates across lattice.


Note, there are likely many optimizations still to be done. However, this was designed primarily for small lattices (e.g. 4x4x2). If you want lattices that are comprised of thousands of unit cells, this program will probably bog down.


Acknowledgements: 

This lattice generation method was heavily inspired by the work of Dr.  Raymond C. Rumpf from the University of Texas El %Paso. While ultimately it uses a different principle (combining weighted lattices vs. using Fourier series decomposition) to make the lattices, many of the variable names and coding conventions were copied from his excellent work. A few scripts are borrowed in whole or in part from his work, and these scripts are noted accordingly in their separate header. For more information, please check out his websites:
https://empossible.net/academics/svl-short-course/
https://raymondrumpf.com/research/

This work also uses STLWrite, a Matlab script created by Sven Holcombe and available on the Matlab File Exchange.


