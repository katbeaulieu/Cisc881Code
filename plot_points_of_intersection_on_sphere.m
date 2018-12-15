%project the points of intersection on the head to the sphere
function [sphere_points] = plot_points_of_intersection_on_sphere(not_at_risk_intersecting_lines,not_at_risk_intersecting_face_centers,center,radius,first_pts,x,y,z)

sphere_points = [];
for i = 1:size(not_at_risk_intersecting_lines,1)
    line = [first_pts(i,1), first_pts(i,2), first_pts(i,3), not_at_risk_intersecting_lines(i,1), not_at_risk_intersecting_lines(i,2), not_at_risk_intersecting_lines(i,3)];
    sphere = [center(1) center(2) center(3) radius];    
    points = intersectLineSphere(line,sphere);
    if isequal(size(points,1),2)
        dist1 = pdist2(points(1,:), not_at_risk_intersecting_face_centers(i,:),'euclidean');
        dist2 = pdist2(points(2,:), not_at_risk_intersecting_face_centers(i,:),'euclidean');
        if dist1 < dist2
            sphere_points = [sphere_points; points(1,:)];
        else
            sphere_points = [sphere_points; points(2,:)];
        end
    else
        sphere_points = [sphere_points; points];
    end
end

%plot the sphere points
figure
surf(x*radius+center(1),y*radius+center(2),z*radius+center(3))
title("sphere with plotted intersections")
hold on
for i=1:size(sphere_points,1)
    plot3(sphere_points(i,1), sphere_points(i,2), sphere_points(i,3),'om','MarkerSize',5,'MarkerFaceColor','m');
end