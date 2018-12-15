function [intersecting_face_centers, intersecting_lines, intersecting_faces] = get_intersecting_lines(skull_tri,skip,lateral_v,lateral_f,skull_f) 

%get the face normal for all faces
face_normals_using_tri = faceNormal(skull_tri);
face_centers_using_tri = incenter(skull_tri);

%plot the normals on the surface of the skull cap
%{
figure;
trisurf(skull_tri);
hold on;
quiver3(face_centers_using_tri(:,1), face_centers_using_tri(:,2), face_centers_using_tri(:,3), ...
    face_normals_using_tri(:,1), face_normals_using_tri(:,2), face_normals_using_tri(:,3),'color','r');
%}
%Replot but with only the normals that intersect the skull cap
%figure;
%pcshow(lateral_v)
%hold on;
%trisurf(skull_cap_tri)
%title("Skull cap with intersecting normals CT")
%hold on;
%this will count the number of lines that actually intersect with the
%lateral ventricle
count = 0;
intersecting_lines = [];

intersecting_face_centers = [];
unsuccessful_lines = [];
intersecting_faces = [];
unsuccessful_points = [];
successful_points= [];
total_tried = 0;
%this is where you change how many lines are tried
for i = 1:skip:size(face_normals_using_tri,1)
    ventricle_intersection = intersectLineMesh3d([face_centers_using_tri(i,:) face_normals_using_tri(i,:)], lateral_v, lateral_f);
    if ~isempty(ventricle_intersection)
        intersecting_lines = [intersecting_lines; face_normals_using_tri(i,:)];
        face_normal_normed = face_normals_using_tri(i,:)/norm(face_normals_using_tri(i,:));
        first_pt = face_normal_normed*(20) + face_centers_using_tri(i,:);
        second_pt = face_normal_normed*(-150) + face_centers_using_tri(i,:);
        successful_points = [successful_points; first_pt second_pt];
        %plot3([first_pt(1) second_pt(1)], [first_pt(2) second_pt(2)], [first_pt(3) second_pt(3)],'-r')
        %hold on;
        %plot3(ventricle_intersection(:,1), ventricle_intersection(:,2), ventricle_intersection(:,3),'or','MarkerFaceColor','m','MarkerSize',5)
        intersecting_faces = [intersecting_faces; skull_f(i,:)];
        intersecting_face_centers = [intersecting_face_centers; face_centers_using_tri(i,:)];
        count = count + 1;
    else
        unsuccessful_lines = [unsuccessful_lines; face_normals_using_tri(i,:)];
        face_normal_normed = face_normals_using_tri(i,:)/norm(face_normals_using_tri(i,:));
        first_pt = face_normal_normed*(20) + face_centers_using_tri(i,:);
        second_pt = face_normal_normed*(-150) + face_centers_using_tri(i,:);
        unsuccessful_points = [unsuccessful_points; first_pt second_pt];
    end
    
    
    total_tried = total_tried +1;
end 


num_intersecting_lines = count
total_tried
figure;
trisurf(skull_tri)
title("Successful trajectories ")
hold on;
%trisurf(midline_tri)
%hold on;
%trisurf(sensory_tri)
%hold on;
%trisurf(motor_tri)
%hold on;
%hold on;
lateral_tri = triangulation(lateral_f,lateral_v);
trisurf(lateral_tri)
hold on;
for i = 1:size(successful_points,1)
    plot3([successful_points(i,1) successful_points(i,4)], [successful_points(i,2) successful_points(i,5)], [successful_points(i,3) successful_points(i,6)],'-', 'color',[0 0.6 0])
end
%hold on;
%for i = 1:size(unsuccessful_points,1)
%    plot3([unsuccessful_points(i,1) unsuccessful_points(i,4)], [unsuccessful_points(i,2) unsuccessful_points(i,5)], [unsuccessful_points(i,3) unsuccessful_points(i,6)], '-c')
%end
