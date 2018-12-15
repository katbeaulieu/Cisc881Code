% set up gradient operator in 3d
clear
close all
% import the dicom files
%addpath CTBrainDicom
addpath Patient6-4231278
addpath nrrd



%% Hough transform in 3D

[ct_data, ct_metadata] = nrrdread('4 Gap Corrected BRAIN Head 3.000  BRAINAxial Axial MPR FC64.nrrd');
save('ct_data.mat','ct_data','ct_metadata');
%{
filename = 'ct_data.mat';
myVars = {'ct_data','ct_metadata'};
S = load(filename,myVars{:});
ct_data = S.ct_data;
ct_metadata = S.ct_metadata;
%}
ct_data = double(ct_data);
X_one_col = reshape(ct_data, [size(ct_data,1)*size(ct_data,2)*size(ct_data,3),1]);
max_intensity = max(X_one_col);
high_intensity_indices = find(abs(ct_data) > (max_intensity-40));
ct_data(high_intensity_indices) = 0.00000000001;

figure;
ct_data_wide = reshape(ct_data, size(ct_data,1), size(ct_data,2), 1, size(ct_data,3));
montage(ct_data_wide,[])

%get edges of 2D image
thresh= 0.7;
slice_edges = edge3(ct_data,'approxcanny',thresh);

%reshape edges to plot montage
reshaped_edges = reshape(slice_edges, size(slice_edges,1), size(slice_edges,2), 1, size(slice_edges,3));
figure;
imshow(slice_edges(:,:,20));
%montage(reshaped_edges,[])

[r,c,v] = ind2sub(size(slice_edges),find(slice_edges == 1));

%calculate the gradients
[gmag,gaz,gelev] = imgradient3(ct_data);
[gx,gy,gz] = imgradientxyz(ct_data);

figure;
imshow(gmag(:,:,20),[])

%calculate center of image to find the outward pointing gradients
center_of_the_image = [size(ct_data,1)/2 size(ct_data,2)/2 size(ct_data,3)/2];

filename = 'stored_edges.mat';
myVars = {'stored_indices'};
S = load(filename,myVars{:});
stored_indices = S.stored_indices;

%size of edges
num_edges = size(stored_indices,1);

one_fourth = num_edges*40;
a = 1;
b = num_edges;
rand_edges_indices = randi(b,one_fourth,a);
second_rand_edges_indices = randi(b,one_fourth,a);
rand_edges = stored_indices(rand_edges_indices,:);
second_rand_edges = stored_indices(second_rand_edges_indices,:);


%apply hough transform
%only intersect lines that are 50 degrees apart

centers = [];
figure;
slice(ct_data,size(ct_data,1)/2, size(ct_data,2)/2, size(ct_data,3)/2);
hold on;
for i= 1:size(rand_edges,1)
    pt1 = rand_edges(i,:);
    pt2 = second_rand_edges(i,:);
    pt1_dir_x = gx(rand_edges(i,1), rand_edges(i,2), rand_edges(i,3));
    pt1_dir_y = gy(rand_edges(i,1), rand_edges(i,2), rand_edges(i,3));
    pt1_dir_z = gz(rand_edges(i,1), rand_edges(i,2), rand_edges(i,3));
    pt2_dir_x = gx(second_rand_edges(i,1), second_rand_edges(i,2), second_rand_edges(i,3));
    pt2_dir_y = gy(second_rand_edges(i,1), second_rand_edges(i,2), second_rand_edges(i,3));
    pt2_dir_z = gz(second_rand_edges(i,1), second_rand_edges(i,2), second_rand_edges(i,3));
    pt1_dir_normed = [pt1_dir_x pt1_dir_y pt1_dir_z]/norm([pt1_dir_x pt1_dir_y pt1_dir_z]);
    pt2_dir_normed = [pt2_dir_x pt2_dir_y pt2_dir_z]/norm([pt2_dir_x pt2_dir_y pt2_dir_z]);
    
    %get the angle between the two lines
    angle = atan2d(norm(cross(pt1_dir_normed,pt2_dir_normed)), dot(pt1_dir_normed,pt2_dir_normed));
           
    end_pt1 = [pt1(1) pt1(2) pt1(3)] + pt1_dir_normed*(100);
    end_pt2 = [pt2(2) pt2(2) pt2(3)] + pt2_dir_normed*(-120);
    start_pts = [pt1(1) pt1(2) pt1(3); pt2(1) pt2(2) pt2(3)];
    end_pts = [end_pt1; end_pt2];
       
    if angle > -50 && angle < 50 
        [point,~] = lineIntersect3D(start_pts,end_pts);
        if point(3) > 0 && point(3) < size(ct_data,3)
            if point(2) > 0 && point(2) < size(ct_data,2)
                if point(1) > 0 && point(1) < size(ct_data,1)
                    centers = [centers; point(1) point(2) point(3)];
                end
            end
        end
      
    end
    
end
centers_first_col = centers(:,1);
[bins_first_dim, centers_1] = hist(centers_first_col,64);
%get bin with the highest value
[bins_sec_dim, centers_2] = hist(centers(:,2),64);
[bins_third_dim, centers_3] = hist(centers(:,3),64);

%now plot the point
[~,ind_x] = max(bins_first_dim);
[~,ind_y] = max(bins_sec_dim);
[~,ind_z] = max(bins_third_dim);

%plot the middle slices and the point
figure;
slice(ct_data,size(ct_data,1)/2, size(ct_data,2)/2, size(ct_data,3)/2);

hold on;
plot3(centers_2(ind_y),centers_1(ind_x),centers_3(ind_z),'ob','MarkerSize',20,'MarkerFaceColor','b')





