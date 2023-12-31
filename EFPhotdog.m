function Ef = EFPhotdog(rp, s, L, d, yp)
% Electric field between two plates
% Second deflecting plates
% Horizontal deflection (hotdog)

% s: surface charge density (C/m^2)
% rp: point of interest coordinates
% d: plate separation distance (m)
% L: plate length (m)
% yp: initial y-coordinate of the electron gun (m)

n = 50; % step
A = L^2; % area of each plate (m^2)

q = s * A / (n^2); % electric charge (C)
x1 = -d/2; % coordinates of the first plate
x2 = d/2; % coordinates of the second plate

y = L + yp : L/n : (L*2) + yp; % y-coordinates of both plates
z = -L/2 : L/n : L/2; % z-coordinates of both plates

Ef = zeros(1, 3); % initialization of output result
Ef1 = zeros(1, 3); % initialization of electric field for the first plate
Ef2 = zeros(1, 3); % initialization of electric field for the second plate

% First plate, negative charge
for i = 1:length(y)
    for j = 1:length(z)
        r01 = [x1, y(i), z(j)]; % point of interest on the plate
        Ef1 = Ev(-q, r01, rp) + Ef1; % sum of electric fields at points of interest with negative charge
    end
end

% Second plate, positive charge
for i = 1:length(y)
    for j = 1:length(z)
        r02 = [x2, y(i), z(j)]; % point of interest on the plate
        Ef2 = Ev(q, r02, rp) + Ef2; % sum of electric fields at points of interest with positive charge
    end
end

Ef = Ef1 + Ef2; % total electric field output (sum of electric fields by superposition principle)

end