%% Lab 3: QRS Detection and ECG Rhythm Analysis
% BME 772 Biomedical Signal Analysis
% Andrew Mullen

close all;
clear all;
clc;

%% Preprocessing
% Load Signals
ECG3 = load('ECG3.txt');
ECG4 = load('ECG4.txt');
ECG5 = load('ECG5.txt');
ECG6 = load('ECG6.txt');

% Create Time Vector
fs = 200;
time = 0:length(ECG3)-1;
time = time./fs;

% Plot Original Signals
subplot(411);
plot(time, ECG3); title('Original Signal 3'); 
xlabel('Time(s)'); ylabel('Amplitude');

subplot(412);
plot(time, ECG4); title('Original Signal 4');
xlabel('Time(s)'); ylabel('Amplitude');

subplot(413);
plot(time, ECG5); title('Original Signal 5');
xlabel('Time(s)'); ylabel('Amplitude');

subplot(414);
plot(time, ECG6); title('Original Signal 6');
xlabel('Time(s)'); ylabel('Amplitude');

% Filter and plot Signals
ECG3_filter = Lab3Filter(ECG3, time, '3');
ECG4_filter = Lab3Filter(ECG4, time, '4');
ECG5_filter = Lab3Filter(ECG5, time, '5');
ECG6_filter = Lab3Filter(ECG6, time, '6');

%% Pole Zero Plots
% Low Pass Filter Coefficients
b_low = [1,0,0,0,0,0,-2,0,0,0,0,0,1];
a_low = [1,-2,1,0,0,0,0,0,0,0,0,0,0];
figure;
zplane(b_low, a_low);
title('Low Pass Filter');

% High Pass Filter Coefficients
b_high = [-1/32,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1/32];
a_high = [1,-1];
figure;
zplane(b_high, a_high);
title('High Pass Filter');

% Band Pass Filter Coefficients
b_band = conv(b_low, b_high);
a_band = conv(a_low, a_high);
figure;
zplane(b_band, a_band);
title('Band Pass Filter');

% Derivate Filter Coefficients
b_der = [0.25, 0.125, 0, -0.125, -0.25];
a_der = [1,0,0,0,0];
figure;
zplane(b_der, a_der);
title('Derivative Filter');

% Moving Window Filter Coefficients
b_mw = ones(1,30)./30;
a_mw = 1;
figure;
zplane(b_mw, a_mw);
title('Moving Window Filter');

%% Visualize Single Heart Beat
org = ECG3(770:929);
band = ECG3_filter(770:929, 1);
der = ECG3_filter(770:929, 2);
sq = ECG3_filter(770:929, 3);
mw = ECG3_filter(770:929, 4);

figure;
subplot(511); plot(org); title('Original ECG');
subplot(512); plot(band); title('Bandpass Filtered ECG');
subplot(513); plot(der); title('Derivative filtered ECG');
subplot(514); plot(sq); title('Squaring');
subplot(515); plot(mw); title('Moving Window');


%% Feature Extraction
% R peak indexing
[ECG3_R_index, ECG3_pulse] = RpeakIndexing(ECG3_filter(:,2), 2000);
[ECG4_R_index, ECG4_pulse] = RpeakIndexing(ECG4_filter(:,2), 2000);
[ECG5_R_index, ECG5_pulse] = RpeakIndexing(ECG5_filter(:,2), 2000);
[ECG6_R_index, ECG6_pulse] = RpeakIndexing(ECG6_filter(:,2), 2000);

%% # of beats, BPM, RR interval, std RR interval 
[ECG3_num_beat, ECG3_BPM, ECG3_RR, ECG3_std_RR] = ECG_Data(ECG3_R_index);
[ECG4_num_beat, ECG4_BPM, ECG4_RR, ECG4_std_RR] = ECG_Data(ECG4_R_index);
[ECG5_num_beat, ECG5_BPM, ECG5_RR, ECG5_std_RR] = ECG_Data(ECG5_R_index);
[ECG6_num_beat, ECG6_BPM, ECG6_RR, ECG6_std_RR] = ECG_Data(ECG6_R_index);

%% Q detection
[ECG3_Q_val, ECG3_Q_loc] = Qidentification(ECG3_filter(:,4), ECG3_RR);
[ECG4_Q_val, ECG4_Q_loc] = Qidentification(ECG4_filter(:,4), ECG4_RR);
[ECG5_Q_val, ECG5_Q_loc] = Qidentification(ECG5_filter(:,4), ECG5_RR);
[ECG6_Q_val, ECG6_Q_loc] = Qidentification(ECG6_filter(:,4), ECG6_RR);

%% S detection
[ECG3_S_val, ECG3_S_loc] = Sidentification(ECG3_filter(:,4), ECG3_RR);
[ECG4_S_val, ECG4_S_loc] = Sidentification(ECG4_filter(:,4), ECG4_RR);
[ECG5_S_val, ECG5_S_loc] = Sidentification(ECG5_filter(:,4), ECG5_RR);
[ECG6_S_val, ECG6_S_loc] = Sidentification(ECG6_filter(:,4), ECG6_RR);

%% QRS Duration
ECG3_QRS = mean(ECG3_S_loc - ECG3_Q_loc')*5;
ECG4_QRS = mean(ECG4_S_loc - ECG4_Q_loc')*5;
ECG5_QRS = mean(ECG5_S_loc - ECG5_Q_loc')*5;
ECG6_QRS = mean(ECG6_S_loc - ECG6_Q_loc')*5;

%% Plot MA and label Q and S wave
time = 0:length(ECG3)-1;
time = time./fs;
norm = (ECG3_filter(:,4)-min(ECG3_filter(:,4)))/(max(ECG3_filter(:,4))-min(ECG3_filter(:,4)));
figure;
plot(time, norm);
xlabel('Time (sec)'); ylabel('Amplitude'); title('ECG3');
for i = 1:length(ECG3_Q_loc)
    text(ECG3_Q_loc(i)/fs, ECG3_Q_val(i), 'Q'); 
    text(ECG3_S_loc(i)/fs, ECG3_S_val(i), 'S');
end

norm = (ECG4_filter(:,4)-min(ECG4_filter(:,4)))/(max(ECG4_filter(:,4))-min(ECG4_filter(:,4)));
figure;
plot(time, norm);
xlabel('Time (sec)'); ylabel('Amplitude'); title('ECG4');
for i = 1:length(ECG4_Q_loc)
    text(ECG4_Q_loc(i)/fs, ECG4_Q_val(i), 'Q'); 
    text(ECG4_S_loc(i)/fs, ECG4_S_val(i), 'S');
end

norm = (ECG5_filter(:,4)-min(ECG5_filter(:,4)))/(max(ECG5_filter(:,4))-min(ECG5_filter(:,4)));
figure;
plot(time, norm);
xlabel('Time (sec)'); ylabel('Amplitude'); title('ECG5');
for i = 1:length(ECG5_Q_loc)
    text(ECG5_Q_loc(i)/fs, ECG5_Q_val(i), 'Q'); 
    text(ECG5_S_loc(i)/fs, ECG5_S_val(i), 'S');
end

norm = (ECG6_filter(:,4)-min(ECG6_filter(:,4)))/(max(ECG6_filter(:,4))-min(ECG6_filter(:,4)));
figure;
plot(time, norm);
xlabel('Time (sec)'); ylabel('Amplitude'); title('ECG6');
for i = 1:length(ECG6_Q_loc)
    text(ECG6_Q_loc(i)/fs, ECG6_Q_val(i), 'Q'); 
    text(ECG6_S_loc(i)/fs, ECG6_S_val(i), 'S');
end



