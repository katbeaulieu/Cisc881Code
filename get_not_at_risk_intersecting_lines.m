function [not_at_risk_intersecting_lines, not_at_risk_intersecting_faces, not_at_risk_intersecting_face_centers, first_pts] = get_not_at_risk_intersecting_lines(intersecting_face_centers, intersecting_lines, intersecting_faces, midline_v,midline_f,lateral_v,lateral_f, motor_v, motor_f, skull_cap_tri)

%% Find intersecting lines that don't touch S.A.Rs

% need to find the triangles in which this happens - and label them.

% start by creating a wireframe representation of the skull - plot3 every
% edge in the mesh

not_at_risk_intersecting_lines = [];
not_at_risk_intersecting_faces = []; %<-
not_at_risk_intersecting_face_centers = [];
count_not_at_risk = 0;
%plot the skull surface and the lines that still intersect
figure;
pcshow(lateral_v)
hold on;
trisurf(skull_cap_tri)
title("Successful trajectories not intersecting structures at risk")
hold on;
first_pts = [];
second_pts = [];

for i = 1:size(intersecting_lines,1)
    midline_intersection = intersectLineMesh3d([intersecting_face_centers(i,:), intersecting_lines(i,:)], midline_v, midline_f);
    motor_intersection = intersectLineMesh3d([intersecting_face_centers(i,:), intersecting_lines(i,:)], motor_v, motor_f);
    %sensory_intersection = intersectLineMesh3d([intersecting_face_centers(i,:), intersecting_lines(i,:)], sensory_v, sensory_f);
    %don't actually need to calculate this, its just for visualization
    %purposes:
    ventricle_intersection = intersectLineMesh3d([intersecting_face_centers(i,:), intersecting_lines(i,:)], lateral_v, lateral_f);
    if isempty(midline_intersection) && isempty(motor_intersection) %%&& isempty(sensory_intersection) 
        %ventricle_intersection_points = [ventricle_intersection_points; ventricle_intersection];
        not_at_risk_intersecting_lines = [not_at_risk_intersecting_lines; intersecting_lines(i,:)];
        not_at_risk_intersecting_faces = [not_at_risk_intersecting_faces; intersecting_faces(i,:)];
        not_at_risk_intersecting_face_centers = [not_at_risk_intersecting_face_centers; intersecting_face_centers(i,:)];
        count_not_at_risk = count_not_at_risk + 1;
        %plot the line if it still doesn't touch a s.a.r.
        face_normal_normed = intersecting_lines(i,:)/norm(intersecting_lines(i,:));
        first_pt = face_normal_normed*(20) + intersecting_face_centers(i,:);
        second_pt = face_normal_normed*(-150) + intersecting_face_centers(i,:);  
        first_pts = [first_pts; first_pt];
        second_pts = [second_pts; second_pt];
        plot3([first_pt(1) second_pt(1)], [first_pt(2) second_pt(2)], [first_pt(3) second_pt(3)],'-k')
%        hold on;
%        plot3(ventricle_intersection(:,1), ventricle_intersection(:,2), ventricle_intersection(:,3),'or','MarkerFaceColor','m','MarkerSize',5)
    end
end

%plot the wireframe mesh and add the spots where the lines intersect
%figure;
%hold on;
%title("wireframe mesh skull surface")
%for i = 1:size(skull_f,1)
%    plot3([skull_v(skull_f(i,1),1) skull_v(skull_f(i,2),1)], [skull_v(skull_f(i,1),2) skull_v(skull_f(i,2),2)], [skull_v(skull_f(i,1),3) skull_v(skull_f(i,2),3)],'-k');
%    hold on;
%    plot3([skull_v(skull_f(i,2),1) skull_v(skull_f(i,3),1)], [skull_v(skull_f(i,2),2) skull_v(skull_f(i,3),2)], [skull_v(skull_f(i,2),3) skull_v(skull_f(i,3),3)],'-k');
%    hold on;
%    plot3([skull_v(skull_f(i,1),1) skull_v(skull_f(i,3),1)], [skull_v(skull_f(i,1),2) skull_v(skull_f(i,3),2)], [skull_v(skull_f(i,1),3) skull_v(skull_f(i,3),3)],'-k');
%end
%hold on
%plot3(not_at_risk_intersecting_face_centers(:,1), not_at_risk_intersecting_face_centers(:,2), not_at_risk_intersecting_face_centers(:,3),'or','MarkerFaceColor','r','MarkerSize',15)


%this is the amount out of the 250 lines that are still good
count_not_at_risk