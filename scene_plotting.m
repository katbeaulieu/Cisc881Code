%function to display all the elements with different colors 
%necessary elements so far: head, ventricles, arteries, motor cortex,
%sensory cortex, midline

%% read in the various meshes
addpath stl_files_scene
%head
[skull_v, skull_f] = stlReadver2("skulll_surface.stl");
%lateral ventricle
[lateral_v, lateral_f] = stlReadver2("lateral_ventricle.stl");
%midline
[midline_v, midline_f] = stlReadver2("midline.stl");
%arteries
[artery_v, artery_f] = stlReadver2("subependymal_arteries_bigger.stl");
%motor cortex
[motor_v, motor_f] = stlReadver2("primary_motor_cortex.stl");
%sensory cortex
[sensory_v, sensory_f] = stlReadver2("primary_sensory_cortex.stl");

%% create triangulation object for all meshes
skull_tri = triangulation(skull_f, skull_v);
lateral_tri = triangulation(lateral_f, lateral_v);
midline_tri = triangulation(midline_f, midline_v);
artery_tri = triangulation(artery_f, artery_v);
motor_tri = triangulation(motor_f, motor_v);
sensory_tri = triangulation(sensory_f, sensory_v);

%% plot the meshes
figure;
trisurf(skull_tri,'FaceColor','g')
hold on
trisurf(lateral_tri,'FaceColor','r')
hold on
trisurf(midline_tri, 'FaceColor','c')
hold on
trisurf(artery_tri, 'FaceColor', 'm')
hold on
trisurf(motor_tri, 'FaceColor', 'b')
hold on
trisurf(sensory_tri, 'FaceColor','y') 


