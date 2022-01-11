%% BME 672 Lab 1
clear all;
close all;
clc;

%% Load Signals
% Add Data path
%addpath('/Users/andrewmullen/Desktop/School/Fall 2020/BME 772/Lab1_data')

% Create empty signal matrix
sig_mat(24,511) = 0;

% Fill Array
for i = 1:24
    sig_mat(i,:) = load(strcat('E', num2str(i), num2str(i)));  
end

% Create Time Vector
Fs = 1000;
Ts = 1/Fs;
N = size(sig_mat, 2);
t = (0:N-1)*Ts;

%% Extract Features for certain signals
M1 = 13;         % First Signal
M2 = 24;         % Last Signal
M = M2-M1 + 1;  % Number of signals

% Allocate array filled with 0s
ybar = zeros(1, N);

% Calculate Average Signal
for i = M1:M2
    ybar = ybar + sig_mat(i, :);
end

ybar = ybar/M;

%% Calculate Noise Power
noise = 0;

for i = M1:M2
    temp = 0;
    for j = 1:N
        temp = temp + (sig_mat(i, j) - ybar(j))^2;       
    end 
    noise = noise + temp;
end

noise = noise / (N * Ts * (M-1));


%% Calculate Signal Power
pow = 0;

for i = 1:N
    pow = pow + ybar(i)^2;
end

pow = pow / (N*Ts) - (noise/M);

%% Signal to Noise ratio

SNR = pow / noise;

%% Calculate euclidean distance
D = 0;

for i = 1:M
    temp = 0;
    for j = 1:N
        temp = temp + (sig_mat(i, j) - ybar(j))^2;
    end    
    D = D + sqrt(temp);
end

D = D/M;

%% Plot Signals
figure;
subplot(211)
for i = M1:M2
    plot(t, sig_mat(i, :));
    hold on
end
a = 'Signals Number';
s = ' ';
b = num2str(M1);
c = 'to';
d = num2str(M2);

label = [a s b s c s d];
title(label);
xlabel('Time (s)');
ylabel('Amplitude');

subplot(212)
plot(t, ybar);
title('Synchronized Average Signal');
xlabel('Time (s)');
ylabel('Amplitude');
