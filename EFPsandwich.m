function Ef = EFPsandwich(rp, s, L, d, yp)
% Electric field between two plates
% First deflecting plates
% Vertical deflection (sandwich)

% s: surface charge density (C/m^2)
% rp: point of interest coordinates
% d: plate separation distance (m)
% L: plate length (m)
% yp: initial y-coordinate of the cannon (m)

n = 50; % divisions
A = L^2; % area of each plate (m^2)

q = s * A / (n^2); % electric charge (C)
z1 = -d/2; % coordinates of the first plate (m)
z2 = d/2; % coordinates of the second plate (m)

y = yp : L/n : L + yp; % y-coordinates of both plates (m)
x = -L/2 : L/n : L/2; % x-coordinates of both plates (m)

Ef = zeros(1, 3); % initialization of output result
Ef1 = zeros(1, 3); % initialization of electric field for the first plate
Ef2 = zeros(1, 3); % initialization of electric field for the second plate

% First plate, negative charge
for i = 1:length(y)
    for j = 1:length(x)
        r01 = [x(j), y(i), z1]; % point of interest on the plate
        Ef1 = Ev(-q, r01, rp) + Ef1; % sum of electric fields at points of interest with negative charge
    end
end

% Second plate, positive charge
for i = 1:length(y)
    for j = 1:length(x)
        r02 = [x(j), y(i), z2]; % point of interest on the plate
        Ef2 = Ev(q, r02, rp) + Ef2; % sum of electric fields at points of interest with positive charge
    end
end

Ef = Ef1 + Ef2; % total electric field output (sum of electric fields by superposition principle)

end