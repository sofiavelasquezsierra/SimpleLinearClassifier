%% Linear Classifier Assignment

function rawOutput = linearClassifierFx(trial,labels,fs)
%% Part 1b: Preprocessing

%Cut trial into windows
windowLength = 160e-3 * fs; %Window length in samples
windowStride = 40e-3 * fs; %How often to update the window in samples
numOfWindows = 1+((size(trial,2)-windowLength)/windowStride);               %Calculate number of windows
windows = [];                                                               
for i = 1:numOfWindows
    windowStart = windowStride*(i-1) + 1;                                   %The start index of the windows. For 40ms shift this is: (1, 41, 81, etc.)
    windowEnd = windowStart+windowLength-1;
    windows(end+1,:,:) = trial(:,windowStart:windowEnd);
end

%% Part 2: 

%Get electrode numbers from labels
c3LaplacianLabels = ["Fc3", "Cp3", "C5", "C1"]; %The labels of electrodes in the Laplcaian filter for C3 (use lowercase letters after the first: Fcz)
c3LaplacianNumbers = [];
for label = c3LaplacianLabels
    c3LaplacianNumbers(end+1) = find(strcmp(labels,label));                  %Find the corresponding electrode number in 'labels'
end
c4LaplacianLabels = ["Fc4", "Cp4", "C2", "C6"];
c4LaplacianNumbers = [];
for label = c4LaplacianLabels
    c4LaplacianNumbers(end+1) = find(strcmp(labels,label));
end
c3 = find(strcmp(labels,'C3'));
c4 = find(strcmp(labels,'C4'));

%Perform spatial filtering
c3Filt = [];
c4Filt = [];
for windowNumber = 1:size(windows,1)
    currentWindow = squeeze(windows(windowNumber,:,:));
    c3Filt(end+1,:) = currentWindow(c3,:) - mean(currentWindow(c3LaplacianNumbers,:),1); %C3 - average of Laplacian electrodes. Make sure to take the average across channels, not time
    c4Filt(end+1,:) = currentWindow(c4,:) - mean(currentWindow(c4LaplacianNumbers,:),1); %C4 - average of Laplacian electrodes
end

%% Part 3:

%Analyze one window at a time
c3alpha = [];
c4alpha = [];
for windowNumber = 1:size(windows,1)
    currentC3 = squeeze(c3Filt(windowNumber,:));
    currentC4 = squeeze(c4Filt(windowNumber,:));
    %Estimate power spectrum
    [spectrumC3,f] = pburg(currentC3,16,0:0.2:30,fs);                     %Estimate frequency spectrum using Burg's method
    [spectrumC4,f] = pburg(currentC4,16,0:0.2:30,fs);                     %16th order model, get frequencies from 0 to 30 at 0.2 Hz intervals
    %Calculate high alpha power
    c3alpha(end+1)=sum(spectrumC3(10.5<f & f<13.5));                        %Sum points between 10.5 and 13.5 Hz
    c4alpha(end+1)=sum(spectrumC4(10.5<f & f<13.5));
end

%% Part 4:

%Linear classifer
rawOutput = c4alpha(:) - c3alpha(:);