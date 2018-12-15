%patient 1
%addpath bone_flap_original_patient1_with_implant_mold1_close_orientation
%patient3 bone flap
[v,f] = stlReadver2('ring_edited_sides_part1_filled.stl');
pcshow(v)
disp("top part")
[vol,area] = triangulationVolume(f,v(:,1),v(:,2),v(:,3))

[v,f] = stlReadver2('ring_edited_sides_part2_filled18.stl');
figure;
pcshow(v)
disp("bottom part")
[vol,area] = triangulationVolume(f,v(:,1),v(:,2),v(:,3))


%[v,f] = stlReadver2('bone_flap_from_mold2_first_try.stl');
%[vol,area] = triangulationVolume(f,v(:,1),v(:,2),v(:,3))