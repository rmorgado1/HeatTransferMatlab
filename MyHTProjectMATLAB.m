% Project 1 - Numerical Solution
%clc   %To check and compare with previous solutions you did dont comment
clear all

%Solver stop criteria
max_iter = 5000;      %number of iterations stop criteria
keep_changing = true;  %boolean control for stop if field change is small
precision = 0.01;    %value to assume convergence of the whole model

%Boundary Conditions (distances in centimeters)
wide = 40;
height = 20;
delta = 0.1; %dx = dy = delta

%Initializing temperature profile
j = wide/delta;
i = height/delta;
temp = zeros(i,j);
n = 0;
criteria2 = temp;
for x = 1:i         %Loop varing vertical of the lateral boundary
    temp(x,1) = 20; %BC of the left side
    temp(x,j) = 20; %BC of the right side
end
%BC of the bottom
for y = 1:j         %y varing from 1 to j=wide*delta (/100 to use meters)
    temp(i,y) = 20*(1+((delta*y/100)^3)*(wide-delta*y/100));
end

%Main Loop
while and(n <= max_iter , keep_changing)  %first stop criteria
    criteria2 = temp;
    n = n + 1;

    %loops acessing and updating the temperature of the plate
    for x = 1:(i-1)   %loop varing vertical
        for y = 2:(j-1)
            if x == 1 %if selecting what case: upper edge or interior
                temp(x,y)=(temp(x,y+1)+temp(x,y-1)+2*temp(x+1,y))/4;
            else
                temp(x,y) = (temp(x+1,y)+temp(x,y+1)+temp(x-1,y)+...
                    temp(x,y-1))/4;   %internal nodal temperature update
            end
        end
    end
    
    change = max(max(temp-criteria2)); %pick max change between iterations
    if change<precision   %second stop criteria 
        keep_changing = false;
    end
end

%Once the profile temperature converge, we start the output

%Getting values to the plot
x1_axis = linspace(1,wide,i);
y1_axis = linspace(1,height,j);
%Loop to invert the vertical of temperature profile
for k = 1:i
    z1_axis(k,:) = temp(i-k+1,:);
end

%Creating plot
figure
imagesc(x1_axis,y1_axis,z1_axis)
grid on
axis image
title('Temperature Profile','Fontsize',16);
xlabel({'x'},'FontWeight','bold','FontSize',12);
ylabel({'y'},'FontWeight','bold','FontSize',12);
set(gca,'YDir','normal')
caxis([20 max(max(temp))])
colorbar('SouthOutside');

%Displaying the results in numbers
if n >= max_iter
    stopped_by = 'iterations overflow';
else
    stopped_by = 'convergence criteria';
end

disp(' ');
disp('Performance factors:');
fprintf('%d iterations\nstopped by: %s\nprecision criteria: %1.5f\nguaranteed precision: %1.5f\n\n',...
    n,stopped_by,precision,change);

%END