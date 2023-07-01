function E = Ev(q, r0, rp)
%Electric field caused on test particle by a charged particle at a certain
%position

k = 9e9; % Coulomb's constant (Nm^2/C^2)

% rp is the direction vector of the test particle
% r0 is the particle vector

r = rp - r0; % direction vector
mr = norm(r); % magnitude of distance between the points
E = k * q * r / mr^3; % Electric field from charge 0 to charge p

end