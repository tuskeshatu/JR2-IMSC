close all;
clear all;
clc;

% Parameterek SI-ben
R = 5;                      % Ellenallas (ohm)
L = 10e-3;                  % Induktivitas (H)
C0 = 10e-6;                 % Alapkapacitas (F)

c = 0.4;                    % Kapacitas valtozas (pumpalas) amplitudoja
U0 = 5;                     % Kezdo feszultseg (V)

omega_0 = 1/sqrt(L*C0);     % Rezonancia korfrekvencia (rad/s)
omega_p = 2 * omega_0;      % Pumpalas korfrekvencia (rad/s)

Q = omega_0 *L/R;           % Minosegi tenyezo

disp(omega_p);

% Differencialegyenlet megoldasa
% Allapotvaltozok: x(1) = U_C (kondenzator feszultsege), x(2) = I (aram)
C_t = @(t) C0 * (1 + c * sin(omega_p * t)); % Kapacitas idofuggvenye
dC_dt = @(t) c * omega_p * C0 * cos(omega_p * t); % Kapacitas idoderivaltja

dxdt = @(t, x) [
    1/C_t(t) * x(2) - dC_dt(t)/C_t(t) * x(1); % dU_C/dt = 1/C(t) * I - dC/dt/C(t) * U_C
    -x(1)/L - R/L * x(2)                      % dI/dt = -U_C/L - R/L * I
    ];

% Idotartomany
tspan = [0, 30e-3]; % Szimulacio idotartama (s)

% Kezdeti feltetelek
x0 = [U0; 0]; % U_C(0) = U0, I(0) = 0

% ode45 opciok (RelTol, AbsTol, MaxStep)
options = odeset('RelTol',1e-8,'AbsTol',1e-10,'MaxStep',1e-6, 'Stats', 'on', 'OutputFcn', @odeplot);

% Megoldas ode45-tel
[t, x] = ode45(dxdt, tspan, x0, options);

% Abrazolasa
figure;
plot(t, x(:, 1));
grid on;
title('Kondenzátor feszültsége (U_C)');
xlabel('Idő (s)');
ylabel('Feszültség (V)');