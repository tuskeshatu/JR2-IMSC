close all;
clear all;
clc;

% Paraméterek SI
R = 10;            % Ellenállás (ohm)
L = 1e-6;          % Induktivitás (H)
C0 = 1e-9;         % Alapkapacitás (F)
c = 0.1;           % Kapacitás változás amplitúdója
U0 = 5;            % Kezdő feszültség (V)
omega_0 = 1/sqrt(L*C0); % Rezonancia körfrekvencia (rad/s)
omega_p = 2*omega_0;   % Pumpálás körfrekvenciája (rad/s)

disp(omega_p);

% Időtartomány
tspan = [0, 1e-6]; % Szimuláció időtartama (s)

% Differenciálegyenlet megoldása
% Állapotváltozók: x(1) = U_C (kondenzátor feszültsége), x(2) = I (áram)

C_t = @(t) C0 * (1 + c * sin(omega_p * t)); % Kapacitás időfüggvénye
dC_dt = @(t) c * omega_p * C0 * cos(omega_p * t); % Kapacitás időderiváltja

dxdt = @(t, x) [
    1/C_t(t) * x(2) - dC_dt(t)/C_t(t) * x(1); % dU_C/dt = 1/C(t) * I - dC/dt/C(t) * U_C
    -x(1)/L - R/L * x(2)                      % dI/dt = -U_C/L - R/L * I

%    1/C0 * x(2); % dU_C/dt = 1/C * I
%    -1/L * x(1) - R/L * x(2) % dI/dt = -1/L * U_C - R/L * I
    ];

% Kezdeti feltételek
x0 = [U0; 0]; % U_C(0) = U0, I(0) = 0

options = odeset('RelTol',1e-8,'AbsTol',1e-10,'MaxStep',1e-9);

% Megoldás ode45-tel
[t, x] = ode45(dxdt, tspan, x0, options);

% Ábrázolása
figure;
subplot(2, 1, 1);
plot(t, x(:, 1));
grid on;
title('Kondenzátor feszültsége (U_C)');
xlabel('Idő (s)');
ylabel('Feszültség (V)');

subplot(2, 1, 2);
plot(t, arrayfun(C_t, t));
grid on;
title('Kapacitás időfüggvénye (C(t))');
xlabel('Idő (s)');
ylabel('Kapacitás (F)');