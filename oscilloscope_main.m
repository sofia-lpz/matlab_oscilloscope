clc; clear; close all;
%Osciloscope

Av = 2e3; %Potential difference in electron gun (V)
me = 9.1e-31; %mass of electron (kg)
qe = 1.602e-19;  %electron charge in absolute value (C)
n = 40; %step size
 
eps0=8.85e-12;%vacumm permitivity (F/m)
d = 0.02; %Separation distance between plates (m)

L = 0.04; %plate length (m)
yp = 0.01; %electron gun length (m)

ts = 0:2*pi/n:2*pi; %signal time
% to see a clearer image
% decrease signal time step size

fprintf("Final velocity of each electron upon hitting the screen: \n")
 
 for i = 1: length(ts)

% TO CHANGE FUNCTIONS ON THE SCREEN:
% change the time functions
% in the potential difference

Vsandwich = 1e3*(sin(2*ts(i))); 
% Potential difference on the first deflecting plate
% graphed in the y-axis on the screen

Vhotdog = 2e3*(sin(3*ts(i)));
% Potential difference on the second deflecting plate
% graphed in the x-axis on the screen

% % Heart graph:
% Vhotdog = 10e1*(16*sin(ts(i))^3); 
% Vsandwich = 10e1*(13*cos(ts(i))-5*cos(2*ts(i))-2*cos(3*ts(i))-cos(4*ts(i)));

ssandwich = (Vsandwich*eps0)/d;
% Charge density on the first deflecting plate (C/m^2)
shotdog = (Vhotdog*eps0)/d;
% Charge density on the second deflecting plate (C/m^2)

% Section 1
% Electron gun

r01 = [0 0 0]; % Initial position of section 1 (m)
v01 = [0 0 0]; % Initial velocity of section 1 (m/s)
a1 = [0 qe*Av/(yp*me) 0]; % Initial acceleration of section 1 (m/s^2)

tc = sqrt(2*yp/a1(2)); % Time it takes for the electron to exit the gun (s)
t1 = 0:tc/n:tc; % Time division steps

% Calculation of positions and velocities within the gun
[x1, vx1] = UARM(r01(1), v01(1), a1(1), t1);
[y1, vy1] = UARM(r01(2), v01(2), a1(2), t1);
[z1, vz1] = UARM(r01(3), v01(3), a1(3), t1);

% Section 2
% First deflecting plate (sandwich)

r02 = [x1(end), y1(end), z1(end)]; % Initial position of section 2 (m)
v02 = [vx1(end), vy1(end), vz1(end)]; % Initial velocity of section 1 (m/s)

tf2 = L/v02(2); % Time it takes for the electron to exit the plates (s) 
dt2 = tf2/n; % Time division within the gun steps

j = 1; % Counter


while r02(2) < L+yp % while it is within the first deflecting plate

    E = EFPsandwich(r02, ssandwich, L, d, yp); % electric field (V/m)

    a2 = [(-qe)*E(1)/me (-qe)*E(2)/me (-qe)*E(3)/me]; % acceleration in section 2 (m/s^2)

    % calculation of positions and velocities within the plates
    [x2, vx2] = UARM(r02(1), v02(1), a2(1), dt2);
    [y2, vy2] = UARM(r02(2), v02(2), a2(2), dt2);
    [z2, vz2] = UARM(r02(3), v02(3), a2(3), dt2);

    r02 = [x2(end), y2(end), z2(end)]; % position of the next point (m)
    v02 = [vx2(end), vy2(end), vz2(end)]; % velocity of the next point (m/s)

    % creation of position vectors for plotting
    X2(j) = x2;
    Y2(j) = y2;
    Z2(j) = z2;

    j = j + 1; % counter
end


% Section 3
% Second deflecting plate (hotdog)

r03 = [X2(end) Y2(end) Z2(end)]; % initial position of section 3 (m)
v03 = [vx2(end), vy2(end), vz2(end)]; % initial velocity of section 1 (m/s)

tf3 = L/v03(2); % time it takes for the electron to exit the plates (s)
dt3 = tf3/n; % time division in steps

k = 1; % counter
while r03(2) < L*2+yp % while it is within the second deflecting plate

    E1 = EFPhotdog(r03, shotdog, L, d, yp); % electric field (V/m)
    a3 = [(-qe)*E1(1)/me (-qe)*E1(2)/me (-qe)*E1(3)/me]; % acceleration in section 2 (m/s^2)

    % calculation of positions and velocities within the plates
    [x3, vx3] = UARM(r03(1), v03(1), a3(1), dt3);
    [y3, vy3] = UARM(r03(2), v03(2), a3(2), dt3);
    [z3, vz3] = UARM(r03(3), v03(3), a3(3), dt3);

    r03 = [x3(end), y3(end), z3(end)]; % position of the next point (m)
    v03 = [vx3(end), vy3(end), vz3(end)]; % velocity of the next point (m/s)

    % creation of position vectors for plotting
    X3(k) = x3;
    Y3(k) = y3;
    Z3(k) = z3;

    k = k + 1; % counter
end


% Section 4
% Path to the screen

l4 = 0.12; % distance to the screen (m)

r04 = [X3(end) Y3(end) Z3(end)]; % m
v04 = [vx3(end) vy3(end) vz3(end)]; % m/s
a4 = [0 0 0]; % acceleration in section 3
tf4 = l4/v04(2); % final time in section 3
t4 = 0:tf4/n:tf4; % time division in steps

% calculation of positions and velocities
[x4, vx4] = UARM(r04(1), v04(1), a4(1), t4);
[y4, vy4] = UARM(r04(2), v04(2), a4(2), t4);
[z4, vz4] = UARM(r04(3), v04(3), a4(3), t4);

v04 = [vx4(end), vy4(end), vz4(end)]; % final velocity of the electron


% Graphs

% coordinates of the corners of the deflecting plates
xpp = [L+yp yp yp L+yp];
ypp = [-L/2 -L/2 L/2 L/2];
zpp = [d/2 d/2 d/2 d/2];
xsp = [2*L+yp L+yp L+yp 2*L+yp];
ysp = [d/2 d/2 d/2 d/2];
zsp = [-L/2 -L/2 L/2 L/2];

figure(1)

% side view
subplot(3,6,1)
hold on

plot3(x1, y1, z1) % comet section 1 cannon
plot3(X2, Y2, Z2) % comet section 2 sandwich
plot3(X3, Y3, Z3) % comet section 3 hotdog
plot3(x4, y4, z4) % comet section 4 screen

view(90,0)
title('Side view')

% top view
subplot(3,6,2)
hold on

plot3(x1, y1, z1) % comet section 1 cannon
plot3(X2, Y2, Z2) % comet section 2 sandwich
plot3(X3, Y3, Z3) % comet section 3 hotdog
plot3(x4, y4, z4) % comet section 4 screen

view(0,90)
title('Top view')

% true view
subplot(3,6,[3,4,5,6,9,10,11,12,15,16,17,18])
hold on
axis equal

plot3(x1, y1, z1) % comet section 1 cannon
plot3(X2, Y2, Z2) % comet section 2 sandwich
plot3(X3, Y3, Z3) % comet section 3 hotdog
plot3(x4, y4, z4) % comet section 4 screen

% plot sandwich deflecting plates
fill3(ypp, xpp, zpp, 'r', ypp, xpp, -zpp, 'k', 'FaceAlpha', 0.5);
% plot hotdog deflecting plates
fill3(ysp, xsp, zsp, 'r', -ysp, xsp, -zsp, 'k', 'FaceAlpha', 0.5);

view(120,30)
title('True view')

% screen view
subplot(3,6,[7,8,13,14])
hold on

axis([-0.12 0.12 -0.12 0.12])
% coordinates of the corners of the screen

axis square

set(gca, 'Color', 'k')
plot(x4(end), z4(end), 'ghexagram') % plot screen

hold on
title('Screen')

fprintf("%5.2f m/s \n", norm(v04)) % print final velocity of each electron

end


