function ras = ijk2ras(ijk,meta)
%IJK2RAS Transfer a point from IJK system using meta in LPS
% * ijk in matlab is [row, col, depth]

% parse meta data
C = textscan(meta.sizes,'%d');
s = double(C{1});
C = textscan(meta.spacedirections,'(%f,%f,%f)');
D = [C{1} C{2} C{3}];
C = textscan(meta.spaceorigin,'(%f,%f,%f)'); % original in LPS
d = [-(s(1)*D(1,1)+C{1}) -(s(2)*D(2,2)+C{2}) C{3}]'; % original in RAS

% transfrom ras
ijk = ijk - 1; % MATLAB start at index 1
tmp = [s(2)-ijk(2) s(1)-ijk(1) ijk(3)]';
ras = D*tmp+d;

end

