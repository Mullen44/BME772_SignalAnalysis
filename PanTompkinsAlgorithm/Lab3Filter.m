function [ECG_output] = Lab3Filter(ECG_input, time, num)
% Applies all the filters applicable to Lab 3
% Bandpass, Derivative, Squaring, Moving Window
    % Inputs - ECG signal and its number
    % Output - Filtered Signals (4000, 4)
        % Order is 1-Bandpass 2-Derivative 3-Sqaring 4-Moving Window
    
    % Preallocate ECG_Output
    ECG_output = zeros(length(ECG_input), 4);
        
    % Low Pass Filter Coefficients
    b_low = [1,0,0,0,0,0,-2,0,0,0,0,0,1];
    a_low = [1,-2,1,0,0,0,0,0,0,0,0,0,0];
    
    % High Pass Filter Coefficients
    b_high = [-1/32,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1/32];
    a_high = [1,-1];
    
    % Band Pass Filter Coefficients
    b_band = conv(b_low, b_high);
    a_band = conv(a_low, a_high);
    
    % Derivate Filter Coefficients
    b_der = [0.25, 0.125, 0, -0.125, -0.25];
    a_der = [1,0,0,0,0];
    
    % Moving Window Filter Coefficients
    b_mw = ones(1,30)./30;
    a_mw = 1;
    
    % Filtering
    ECG_output(:,1) = filter(b_band, a_band, ECG_input); % Band Pass applied to ECG input
    ECG_output(:,2) = filter(b_der, a_der, ECG_output(:,1)); % Derivative applied to bandpass output
    ECG_output(:,3) = ECG_output(:,2).^2; % Squaring applied to derivative output
    ECG_output(:,4) = filter(b_mw, a_mw, ECG_output(:,3)); % Moving Window applied to squaring output
    
    % Plot
    figure;
    subplot(411);
    plot(time, ECG_output(:,1)); title(['ECG',num,' Bandpass Filter']);
    xlabel('Time(s)'); ylabel('Amplitude');
    
    subplot(412);
    plot(time, ECG_output(:,2)); title(['ECG',num,' Derivative Filter']);
    xlabel('Time(s)'); ylabel('Amplitude');
    
    subplot(413);
    plot(time, ECG_output(:,3)); title(['ECG',num,' Squaring']);
    xlabel('Time(s)'); ylabel('Amplitude');
    
    subplot(414);
    plot(time, ECG_output(:,4)); title(['ECG',num,' Moving Window']);
    xlabel('Time(s)'); ylabel('Amplitude');    
end

