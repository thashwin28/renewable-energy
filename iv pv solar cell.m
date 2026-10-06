clear; clc; close all;

%% Constants
K = 1.3806503e-23;     % Boltzmann constant [J/K]
q = 1.60217646e-19;    % Electron charge [C]

%% Module Datasheet Parameters (replace with your module's values)
Ns    = 36;            % Number of series-connected cells
Iscn  = 8.21;           % Short-circuit current at STC [A]
Vocn  = 32.9;           % Open-circuit voltage at STC [V]
Ki    = 0.0032;         % Temperature coefficient of Isc [A/K]
%% Operating Conditions
T  = 25 + 273;          % Operating Temperature [K]
Tn = 25 + 273;          % Temperature at STC [K]   (STC is 25°C, not 30°C)
Gn = 1000;               % Irradiance at STC [W/m^2]
G  = 1000;               % Actual Irradiance [W/m^2]

%% Model Parameters
a  = 1.3;               % Diode Ideality Constant [1 < a < 2]
Eg = 1.2;                % Band gap of silicon at STC [eV]
Rs = 0.221;              % Series Resistance [Ohm]
Rp = 415.405;            % Parallel Resistance [Ohm]

%% Derived Quantities
Vtn = Ns * (K * Tn) / q;                                   % Thermal voltage at STC (Eq. 2)
I0n = Iscn / (exp(Vocn / (a * Vtn)) - 1);                   % Reverse saturation current at STC (Eq. 5)
I0  = I0n * (Tn/T)^3 * exp((q*Eg/(a*K)) * (1/Tn - 1/T));    % Reverse saturation current at T (Eq. 4)

Ipvn = Iscn;
Ipv  = (G/Gn) * (Ipvn + Ki*(T - Tn));                       % Photocurrent (Eq. 3)

Vt = Ns * (K * T) / q;                                      % Thermal voltage at operating T

%% I-V Curve Generation (iterative solution of implicit Eq. 1)
i = 1;
I(1) = 0;

for V = Vocn:-0.1:0
    I_term1 = I0 * (exp((V + I(i)*Rs) / (Vt*a)) - 1);   % Diode current term
    I_term2 = (V + I(i)*Rs) / Rp;                        % Shunt resistor term
    I(i+1)  = Ipv - (I_term1 + I_term2);                 % Eq. 1

    if I(i) > 0                                          % Clamp negative current to zero
        I(i) = I(i);
    else
        I(i) = 0;
    end

    Pi(i) = V * I(i);
    Vi(i) = V;
    i = i + 1;
end

%% Plots
figure(1)
plot(Vi(1:i-1), I(1:i-1), 'r', 'LineWidth', 2.5)
xlabel('Voltage (V)');
ylabel('Current (A)');
title('I-V Characteristics');
grid on;

figure(2)
plot(Vi(1:i-1), Pi(1:i-1), 'k', 'LineWidth', 2.5)
xlabel('Voltage (V)');
ylabel('Power (W)');
title('P-V Characteristics');
grid on;
