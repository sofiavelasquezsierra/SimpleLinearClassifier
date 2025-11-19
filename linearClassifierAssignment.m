%% Linear Classifier Main Script

%This is the main script for the linear classifier assignment/demo. You
%should also have received the "assignmentData.mat" file and 
%"linearClassifierFx.m" function along with this script.
clear; close all; clc;
%% Part 1a: Load Data

%Load data
load("assignmentData.mat")

assert(exist('signal','var')==1, 'Variable ''signal'' not found.');
assert(exist('targets','var')==1, 'Variable ''targets'' not found.');
assert(exist('fs','var')==1, 'Variable ''fs'' not found.');
assert(exist('labels','var')==1, 'Variable ''labels'' not found.');

%Select one trial
trial = signal{2};

%Stop here and open "linearClassifierFx.m" for parts 1b to 4
%Once you have finished Part 4, continue below:

%% Part 5: Normalizer

%Run the linear classifier on all of the trials
rawOutputs = {};
for i = 1:length(signal)
    trial = signal{i};
    rawOutputs{end+1} = linearClassifierFx(trial,labels,fs);
end

%Compute the average of all the outputs
normalizerMean = mean(cellfun(@mean,rawOutputs));

%Normalize the outputs (subtract the mean from each output)
normOutputs = cellfun(@(x) x - normalizerMean, rawOutputs,'UniformOutput',0);

%Calculate position
rawPosition = cellfun(@cumsum,rawOutputs,'UniformOutput',0);
normPosition = cellfun(@cumsum,normOutputs,'UniformOutput',0);

% 6a. Raw output plot
figure;
subplot(2,1,1)
plot(rawOutputs{1},'b')
ylabel('Velocity')
title('Raw Velocity Output')
subplot(2,1,2)
plot(rawPosition{1},'g')
ylabel('Position')
title('Raw Position Output')

%6b. Normalized output plot
figure;
subplot(2,1,1)
plot(normOutputs{1},'b')
ylabel('Velocity')
title('Normalized Velocity Output')
subplot(2,1,2)
plot(normPosition{1},'g')
ylabel('Position')
title('Normalized Position Output')


%% Part 6: Evaluation
% 6c. Normalized output signal for every window.
figure;
title('Normalized Position Output')
numOfTrials = length(signal);
for i = 1:numOfTrials
    subplot(numOfTrials,1,i)
    plot(normPosition{i},'g')
    ylabel(strcat('Trial ',num2str(i),' Position'))
end


%Based on Figure 3, which side of the screen is target 1 on? Target 2?

%6d. 
figure;
title('Normalized Velocity Output')
numOfTrials = length(signal);
for i = 1:numOfTrials
    subplot(numOfTrials,1,i)
    plot(normOutputs{i},'g')
    ylabel(strcat('Trial ',num2str(i),' Position'))
end

