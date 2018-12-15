function [max_density,min_density,avg_density] = get_sphere_loc_for_intersections(sphere_points, radius, center, not_at_risk_intersecting_face_centers, skull_tri, x, y, z)
    
%reverse_rot_angle = 30;
%rot_matrix = [1 0 0; 0 cosd(reverse_rot_angle) -sind(reverse_rot_angle); 0 sind(reverse_rot_angle) cosd(reverse_rot_angle)];
%rotate all the points
sphere_points_origin = sphere_points - center;

% go through all the sphere points (the intersection points) and convert
% them to longitude and latitude coordinates using arctan
sphere_vertices_with_intersections =  [0 0 0];
sphere_face_with_intersections = [0 0 0 0];
vertex_num_so_far = 2;

face_vertex_table = [];

for i = 1:size(sphere_points_origin,1)
    longitude = atan2d(sphere_points_origin(i,2), sphere_points_origin(i,1));
    latitude = atan2d(sphere_points_origin(i,3), sqrt(sphere_points_origin(i,1).^2 + sphere_points_origin(i,2).^2));
   
    %convert that back into x,y,z coordinates and plot it to confirm we've
    %got the right points
    %theta is longitude
    %phi is latitude
    x_point = radius*cosd(latitude)*cosd(longitude);
    y_point = radius*cosd(latitude)*sind(longitude);
    z_point = radius*sind(latitude);
    %figure out what bin the point belongs to - the corner extremities
    % this is the number of faces on the sphere (20x20)
    default_sphere_number = 20;
    
    longitude_range = 360;
    longitude_interval = longitude_range/default_sphere_number;
    bin_num_longitude = longitude/longitude_interval;
    max_bin_longitude = ceil(bin_num_longitude);
    min_bin_longitude = floor(bin_num_longitude);
    max_longitude = max_bin_longitude*longitude_interval;
    min_longitude = min_bin_longitude*longitude_interval;
    
    latitude_range = 180;
    latitude_interval = latitude_range/default_sphere_number;
    bin_num_latitude = latitude/latitude_interval;
    max_bin_latitude = ceil(bin_num_latitude);
    min_bin_latitude = floor(bin_num_latitude);
    max_latitude = max_bin_latitude*latitude_interval;
    min_latitude = min_bin_latitude*latitude_interval;
    
    %corner 1 - max long, max lat
  
    x_point1 = radius*cosd(max_latitude)*cosd(max_longitude);
    y_point1 = radius*cosd(max_latitude)*sind(max_longitude);
    z_point1 = radius*sind(max_latitude);
   
    
    %corner 2 - max long, min lat
    x_point2 = radius*cosd(min_latitude)*cosd(max_longitude);
    y_point2 = radius*cosd(min_latitude)*sind(max_longitude);
    z_point2 = radius*sind(min_latitude);
    
    
    %corner 3 - min long, max lat
    x_point3 = radius*cosd(max_latitude)*cosd(min_longitude);
    y_point3 = radius*cosd(max_latitude)*sind(min_longitude);
    z_point3 = radius*sind(max_latitude);
    
    %corner 4 - min long, min lat
    x_point4 = radius*cosd(min_latitude)*cosd(min_longitude);
    y_point4 = radius*cosd(min_latitude)*sind(min_longitude);
    z_point4 = radius*sind(min_latitude);
    
    %identify the face the intersection points belongs to.
    new_face = [];
    [bool_array1, index1] = ismember([x_point1 y_point1 z_point1], sphere_vertices_with_intersections,'rows');
    if any(bool_array1)
        new_face = [new_face index1];
    else
        sphere_vertices_with_intersections = [sphere_vertices_with_intersections; x_point1 y_point1 z_point1];
        new_face = [new_face vertex_num_so_far];
        vertex_num_so_far = vertex_num_so_far + 1;
    end
    [bool_array2, index2] = ismember([x_point2, y_point2, z_point2], sphere_vertices_with_intersections,'rows');
    if any(bool_array2)
        new_face = [new_face index2];
    else
        sphere_vertices_with_intersections = [sphere_vertices_with_intersections; x_point2 y_point2 z_point2];
        new_face = [new_face vertex_num_so_far];
        vertex_num_so_far = vertex_num_so_far + 1;
    end
    [bool_array3, index3] = ismember([x_point3, y_point3, z_point3], sphere_vertices_with_intersections,'rows');
    if any(bool_array3)
        new_face = [new_face index3];
    else
        sphere_vertices_with_intersections = [sphere_vertices_with_intersections; x_point3 y_point3 z_point3];
        new_face = [new_face vertex_num_so_far];
        vertex_num_so_far = vertex_num_so_far + 1;
    end
    [bool_array4, index4] = ismember([x_point4,y_point4, z_point4], sphere_vertices_with_intersections, 'rows');
    if any(bool_array4)
        new_face = [new_face index4];
    else
        sphere_vertices_with_intersections = [sphere_vertices_with_intersections; x_point4 y_point4 z_point4];
        new_face = [new_face vertex_num_so_far];
        vertex_num_so_far = vertex_num_so_far + 1;
    end
    % check to see if new face already exists - if it does don't bother
    % adding it again.
    [bool_array, face_index] = ismember(new_face, sphere_face_with_intersections, 'rows');
    if any(bool_array)
        face_vertex_table = [face_vertex_table; face_index-1 not_at_risk_intersecting_face_centers(i,:)];
    else
        sphere_face_with_intersections = [sphere_face_with_intersections; new_face];
        face_vertex_table = [face_vertex_table; size(sphere_face_with_intersections,1)-1 not_at_risk_intersecting_face_centers(i,:)];

    end
    %update the face_vertex index [face index, sphere_points_origin];
end

%find the max density, min density, avg density
sphere_face_with_intersections = sphere_face_with_intersections(2:end,:);
[sphere_face_with_intersections_unique,~,ic] = unique(sphere_face_with_intersections,'rows');
tally = accumarray(ic,1);
result = [sphere_face_with_intersections_unique tally];
%max density
max_density = max(result(:,end));
%min density 
min_density = min(result(:,end));

%avg density
avg_density = mean(result(:,end));

%find the max area, min area, avg area

% 1. identify the top and bottom edges of the trapezoids - to get the area
% of the faces on the sphere

areas = [];
intersections_per_area = [];
for i = 1:size(sphere_face_with_intersections_unique,1)
    pt1 = [sphere_vertices_with_intersections(sphere_face_with_intersections_unique(i,1),1), sphere_vertices_with_intersections(sphere_face_with_intersections_unique(i,1),2), sphere_vertices_with_intersections(sphere_face_with_intersections_unique(i,1),3)];
    pt2 = [sphere_vertices_with_intersections(sphere_face_with_intersections_unique(i,3),1), sphere_vertices_with_intersections(sphere_face_with_intersections_unique(i,3),2), sphere_vertices_with_intersections(sphere_face_with_intersections_unique(i,3),3)];
    pt3 = [sphere_vertices_with_intersections(sphere_face_with_intersections_unique(i,2),1), sphere_vertices_with_intersections(sphere_face_with_intersections_unique(i,2),2), sphere_vertices_with_intersections(sphere_face_with_intersections_unique(i,2),3)];
    pt4 = [sphere_vertices_with_intersections(sphere_face_with_intersections_unique(i,4),1), sphere_vertices_with_intersections(sphere_face_with_intersections_unique(i,4),2), sphere_vertices_with_intersections(sphere_face_with_intersections_unique(i,4),3)];
    length1 = pdist2(pt1, pt2,'euclidean');
    length2 = pdist2(pt3, pt4,'euclidean');
    height = DistBetween2Segment(pt1,pt2,pt3,pt4);
    area = ((length1+length2)/2)*(height);
    areas = [areas; area];
    intersections_per_area = [intersections_per_area; tally(i)/area*10];
end

% based on the ratio of intersections/cm^2 - pick out the faces with the
% highest ratios
tolerance = 0.05;
figure;
trisurf(skull_tri);
title("Intersections in the densest areas")
hold on
for i = 1:size(intersections_per_area)
    if intersections_per_area(i) >= 0.05
        index = find(face_vertex_table(:,1) == i);
        plot3(face_vertex_table(index,2), face_vertex_table(index,3), face_vertex_table(index,4),'om','MarkerSize',5,'MarkerFaceColor','m')

    end
end

% max_area 
max_area = max(areas);
% min area
min_area = min(areas);

%average area
avg_area = mean(areas);

%plot all the points from the vertices list as well as the intersections to
%confirm you have them all
figure;

surf(x*radius,y*radius,z*radius);
title("face corners and sphere intersections")
hold on
plot3(sphere_points_origin(:,1), sphere_points_origin(:,2), sphere_points_origin(:,3),'om','MarkerSize',5,'MarkerFaceColor','m')
hold on
plot3(sphere_vertices_with_intersections(:,1), sphere_vertices_with_intersections(:,2), sphere_vertices_with_intersections(:,3),'ok','MarkerSize',5,'MarkerFaceColor','k');