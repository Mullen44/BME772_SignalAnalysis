function [num_beats, BPM, RR, std_RR] = ECG_Data(indices)
%ECG_DATA Summary of this function goes here
    % Input - indices - array of the indexes where R peak locations
    %           occur
    % Output - num_beats = number of beats in the signal
    %        - BPM = beats per minute of the individual
    %        - RR = Average time length between R peaks
    %        - std_RR
    
    % Number of beat calculations
    num_beats = length(indices);
    
    % Calculate time period between R peaks
    for i = 2:length(indices) 
        RR_period(i-1) = (indices(i) - indices(i-1));
    end
    
    RR_period = RR_period.*(1000/200);
    
    RR = mean(RR_period);
    std_RR = std(RR_period);
    BPM = (60/RR)*1000;

end

