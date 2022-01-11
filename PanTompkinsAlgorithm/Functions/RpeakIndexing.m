function [index, pulse_train] = RpeakIndexing(signal, threshold)
%RPEAKINDEXING Summary of this function goes here
   % Input - Derivative filtered version of ECG
   %       - Initial value of the R peak threshold

   sig_length = length(signal);
   i = 50;
   index = [];
   
   while i <= sig_length
      if signal(i) > threshold
          if signal(i) < signal(i-1) && signal(i) > signal(i+1)
              index = [index, i];
              i = i+40;
          end
      end
      i = i+1;
   end
   pulse_train =  zeros(sig_length, 1);
   pulse_train(index) = 3500;
   
end

