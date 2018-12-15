%get surface area of skull and ventricle
addpath Patient1-4181
%head


[skull_v, skull_f] = stlReadver2("skull_one_layer-patient1.stl");
%lateral ventricle
[lateral_v, lateral_f] = stlReadver2("lateral_ventricle-patient1.stl");

%ventricle volume and area
[vol_l,area_l] = triangulationVolume(lateral_f,lateral_v(:,1),lateral_v(:,2),lateral_v(:,3))

%skull area
[vol_s,area_s] = triangulationVolume(skull_f,skull_v(:,1),skull_v(:,2),skull_v(:,3))