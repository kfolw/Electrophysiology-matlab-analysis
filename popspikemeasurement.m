%% M-SCRIPT FOR MEASURING POPULATION SPIKE AMPLITUDES FROM EXTRACELLUAR FIELD RECORDINGS %% 
% Written by Kait Folweiler, A. Cohen Lab 2016
%
% Summary: Loads a pClamp file containing pop spike traces and measures
% the amplitude of that pop spike for a series of I/O traces. 

%%

% Load File
[filename pathname] = uigetfile('S:\Kait\fEPSPs from VSD rig','Find your file');

% load abf file into matlab variables
% variable "d" is a 3d array of size <data pts per sweep> by <number of chans> by <number of sweeps>.
% variable "si" is a scalar representing the sampling interval in
% microseconds (usec). 
[d,si] = abfload([pathname filename(1:end-4) '.abf']);



% use si variable to convert time into milliseconds. 
time_ms = [si:si:si.*length(d)]; 
time_ms =time_ms';
time_ms =time_ms./1000;


%% parameters to manually fill out
maximumResponseSize1 = 4; %about how big is your biggest field in mV? (magnitude)
maximumResponseSize2 = 4;
%%

numSweeps = length(d(1,1,:)); % determines the number of sweeps 
numChans = length(d(1,:,1));  % determines the number of channels (i.e., the number of recording electrodes)

meanbase1 = mean(d(1:10,1,5));  % gets an average of the initial baseline (used for centering the trace in the figure window)
meanbase2 = mean(d(1:10,2,5)); 

popspikes_chan1 = zeros(10,1); % channel 1 contains GCL traces
popspikes_chan2 = zeros(10,1); % channel 2 contains CA3 PCL traces

%% plot traces and find points for calculations

% NOTE: when mouse clicking on the trace, you should click 4 points. Click
% #1 is the peak preceding the pop spike, Click #2 is the peak following
% the pop spike, Click #3 is the base (trough) of the pop spike. Click #4
% (which you should double click to finish the shape) should be on the line
% drawn between the 2 peaks that creates a straight vertical line with the
% point specified by Click #3. I.e., Click #3 and Click #4 create a
% straight vertical line that connects to the peak line. This distance is
% the pop spike amplitude.
   
for k = 1:numChans  % Loop through the number of channels
    if k == 1 
        for i = 1:numSweeps        
            f=figure(1); %create figure instance
            set(f, 'Position', [100 10 1200 800]) % sets the size and position of the figure window on your computer screen
            plot(time_ms,d(:,k,i));   % plot the trace
            xlabel('Time ms')
            ylabel('Millivolts')
            set(gca,'YLim',[meanbase1+((maximumResponseSize1*-1)-.2) meanbase1+3.5])%.5
            set(gca, 'XLim', [90 150]) % for the 4 pulses at 1Hz protocol, this focuses on the 2nd pulse response
            title('CHANNEL 1 (DG GCL)')
   
            h = impoly;                 % allows you to click your points on the trace
            pos = getPosition(h);       % variable that stores the x,y coordinates of your mouse clicks
            if size(pos,1) == 1         % if only one x,y coordinate is present in the pos variable, this means there was no pop spike detectable in the trace and the user double-clicked to pass to the next trace
                popspikes_chan1(i) = 0; 
            else 
                popspikes_chan1(i) =  pdist(pos(3:4,:));
            end
            delete(h)
          
        end
    end
     if k == 2                  % repeats above for channel 2 
         for i = 1:numSweeps
            f=figure(1); %create figure instance
            set(f, 'Position', [100 10 1200 800]) 
            plot(time_ms,d(:,k,i));
            xlabel('Time ms')
            ylabel('Millivolts')
            set(gca,'YLim',[meanbase2+((maximumResponseSize2*-1)-.2) meanbase2+3.5])%.5
            set(gca, 'XLim', [90 150]) % for the 4 pulses at 1Hz protocol, this focuses on the 2nd pulse response
            title('CHANNEL 2 (CA3 PCL)')
   
            h = impoly;
            pos = getPosition(h);
            if size(pos,1) == 1
                popspikes_chan2(i) = 0; 
            else
                popspikes_chan2(i) =  pdist(pos(3:4,:));
            end
            delete(h)
         end
     end
end

close all


        
    
 
    
    
    