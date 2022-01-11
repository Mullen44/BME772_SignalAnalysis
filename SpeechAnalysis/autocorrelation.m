function [output] = autocorrelation(input)

for k = 1:length(input) 
    for i = 1:length(input)-k 
        temp(i) = input(k+i-1)*input(i);
    end
    output(k) = sum(temp);
    temp = 0;
end
output = output./max(abs(output));
end

