%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Lab 2: Filtering of the ECG for Noise and Artifact Removal     %
%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all               % clears all active variables
close all

% the ECG signal in the file is sampled at 1000 Hz
% lowpass filter the signal at 75 Hz and downsample by a factor of 5
% this will retain the 60 Hz noise but cause some aliasing artifacts
%
usecg = load('ecg_60hz.dat');
fs = 1000;          %sampling rate
fsh = fs/2;         %half the sampling rate
[b,a] = butter(12, 75/fsh);

% Butterworth filter frequency response
figure;
M = 512;
freqz(b, a, M, fs);
title('12th Order Buttoworth Frequency Response');

lpusecg = filter(b, a, usecg);
usecg = lpusecg;
clear lpusecg;

len = length(usecg);
k = 1;
for i = 1 : length(usecg)
if (rem(i,5) == 0)
ecg(k) = usecg(i);
k = k+1;
end;
end;

fs = 200; %effective sampling rate after downsampling

% Plot of the ECG before filtering
slen = length(ecg);
t = [1:slen]/fs;
figure
plot(t, ecg)
xlabel('Time in seconds');
ylabel('ECG');
axis tight;


% Plot of the spectrum of the ECG before filtering
ecgft = fft(ecg);
ff= fix(slen/2) + 1;
maxft = max(abs(ecgft));
f = [1:ff]*fs/slen; % frequency axis up to fs/2.
ecgspec = 20*log10(abs(ecgft)/maxft);
figure
plot(f, ecgspec(1:ff));
xlabel('Frequency in Hz');
ylabel('Log Magnitude Spectrum (dB)');
title('Spectrum of the original ECG');
axis tight;

%% PART 1 Notch filter
% define notch filter coefficient arrays a and b

b_notch = 0.38*[1 0.618 1];     % Numerator coefficients
a_notch = [1 0 0];              % Denominator Coefficients

M = 128;

% Notch filter frequency response
figure;
freqz(b_notch, a_notch, M, fs);
title('Notch Filter Frequency Response');

% Output of the notch filter
ecg_notch = filter(b_notch, a_notch, ecg);

% Plot of the ECG after filtering
figure;
subplot(211)
plot(t, ecg); 
xlabel('Time (s)'); ylabel('Amplitude'); title('Original ECG'); axis tight;

subplot(212)
plot(t, ecg_notch); 
xlabel('Time in seconds'); ylabel('ECG'); title('Notch Filtered ECG'); axis tight;

% Plot of the spectrum of the ECG after filtering
ecgft_notch = fft(ecg_notch);
ff= fix(slen/2) + 1;
maxft = max(abs(ecgft_notch));
f = [1:ff]*fs/slen; % frequency axis up to fs/2.
ecgspec_notch = 20*log10(abs(ecgft_notch)/maxft);

figure;
subplot(211);
plot(f, ecgspec(1:ff));
xlabel('Frequency in Hz'); ylabel('Log Magnitude Spectrum (dB)'); 
title('Spectrum of Original ECG'); axis tight;

subplot(212)
plot(f, ecgspec_notch(1:ff));
xlabel('Frequency in Hz'); ylabel('Log Magnitude Spectrum (dB)');
title('Spectrum of Notch Filtered ECG'); axis tight;

%% Part 2 Hanning filter
b_han = [0.25 0.5 0.25];  % Numerator Coeffecients
a_han = [1 0 0];          % Denominator Coefficients

% Hanning Window Frequency Response
figure;
freqz(b_han, a_han, M, fs);
title('Hanning Window Frequency Response');

% ECG output with hanning window
ecg_han = filter(b_han, a_han, ecg);

% Plot Filtered Output
figure;
subplot(211)
plot(t, ecg); 
xlabel('Time (s)'); ylabel('Amplitude'); title('Original ECG'); axis tight;

subplot(212)
plot(t, ecg_han);
title('Hanning Window Filtered ECG'); xlabel('Time (s)'); ylabel('ECG');

% Frequency Spectrum of ECG after filtering
ecgft_han = fft(ecg_han);
maxft = max(abs(ecgft_han));
ecgspec_han = 20*log10(abs(ecgft_han)/maxft);
figure;
subplot(211);
plot(f, ecgspec(1:ff));
xlabel('Frequency in Hz'); ylabel('Log Magnitude Spectrum (dB)'); 
title('Spectrum of Original ECG'); axis tight;

subplot(212)
plot(f, ecgspec_han(1:ff));
xlabel('Frequency in Hz'); ylabel('Log Magnitude Spectrum (dB)');
title('Spectrum of Hanning Window Filtered ECG'); axis tight;

%% Part 3 Derivative filter
b_der = [1 -1];           % Numerator Coeffecients
a_der = [1 -0.995];        % Denominator Coeffecients

% Derivative Filter Frequency Response
figure;
freqz(b_der, a_der, M, fs);
title('Derivative Filter Frequency Response');

% Output of Derivative Filter
ecg_der = filter(b_der, a_der, ecg);

% Plot Filtered Output
figure;
subplot(211)
plot(t, ecg); 
xlabel('Time (s)'); ylabel('Amplitude'); title('Original ECG'); axis tight;

subplot(212)
plot(t, ecg_der);
xlabel('Time (s)'); ylabel('ECG'); title('Derivated Filtered ECG'); axis tight;

% Frequency Spectrum of ECG after Filtering
ecgft_der = fft(ecg_der);
maxft = max(abs(ecgft_der));
ecgspec_der = 20*log10(abs(ecgft_der)/maxft);

figure;
subplot(211);
plot(f, ecgspec(1:ff));
xlabel('Frequency in Hz'); ylabel('Log Magnitude Spectrum (dB)'); 
title('Spectrum of Original ECG'); axis tight;

subplot(212)
plot(f, ecgspec_der(1:ff));
xlabel('Frequency in Hz'); ylabel('Log Magnitude Spectrum (dB)');
title('Spectrum of the Derivative Filtered ECG'); axis tight;

%% Part 4 Combined Filters
% Convolute filters
b1 = conv(b_notch, b_han);
b2 = conv(b_der, b1);

a1 = conv(a_notch, a_han);
a2 = conv(a_der, a1);

figure;
freqz(b2, a2, M, fs);
title('Combined Filters Frequency Response');

% Output of Combined Filter ECG
ecg_comb = filter(b2, a2, ecg);

% Plot Filtered Output
figure;
subplot(211)
plot(t, ecg); 
xlabel('Time (s)'); ylabel('Amplitude'); title('Original ECG'); axis tight;

subplot(212)
plot(t, ecg_comb);
xlabel('Time (s)'); ylabel('ECG'); title('Combined Filtered ECG'); axis tight;

% Frequency Spectrum of ECG after Filtering
ecgft_comb = fft(ecg_comb);
maxft = max(abs(ecgft_comb));
ecgspec_comb = 20*log10(abs(ecg_comb)/maxft);

figure;
subplot(211);
plot(f, ecgspec(1:ff));
xlabel('Frequency in Hz'); ylabel('Log Magnitude Spectrum (dB)'); 
title('Spectrum of Original ECG'); axis tight;

subplot(212)
plot(f, ecgspec_comb(1:ff));
xlabel('Frequency in Hz'); ylabel('Log Magnitude Spectrum (dB)');
title('Spectrum of Combined Filtered ECG'); axis tight;