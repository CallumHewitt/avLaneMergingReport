%% Import data.
filename = 'speedLimitResults.csv';
delimiter = ',';
startRow = 2;

formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);

speedLimitResults = [dataArray{1:end-1}];

clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Setup Parameters
% Create X Axis
mergeLaneSpeedLimit = speedLimitResults(:,1);
targetLaneSpeedLimit = speedLimitResults(:,2);

xAxis = cell(1, length(mergeLaneSpeedLimit));
for pairIndex = 1:length(mergeLaneSpeedLimit)
    xAxis{pairIndex} = strcat(num2str(mergeLaneSpeedLimit(pairIndex)),'/',num2str(targetLaneSpeedLimit(pairIndex)));
end

%% Colours
colour1 = [0.2 0.2 0.5];
colour2 = [0 0.7 0.7];

clearvars pairIndex

%% Create Average Delays Bar Charts
% Create Figure
figure

% Get Data
averageDelay = speedLimitResults(:,9);
averageTargetDelay = speedLimitResults(:,10);
averageMergeDelay = speedLimitResults(:,11);

delayStd = speedLimitResults(:,12);
targetDelayStd = speedLimitResults(:,13);
mergeDelayStd = speedLimitResults(:,14);

% Create Average Delay Plot
ax1 = subplot(3,1,1);

% Add bars
bar(ax1, categorical(xAxis), averageDelay, 0.5, 'FaceColor',colour1);
hold on;
bar(ax1, categorical(xAxis), delayStd, 0.25, 'FaceColor',colour2);
hold off;

% Add labels
grid on;
title(ax1,'Average Delay by Speed Limits');
xlabel('Speed Limit (Merge Lane / Target Lane) (Metres per second)');
ylabel('Delay (seconds)');
legend({'Average Delay','Standard Deviation Delay'});

% Create Average Target Delay Plot
ax2 = subplot(3,1,2);

% Add bars
bar(ax2, categorical(xAxis), averageMergeDelay, 0.5, 'FaceColor',colour1);
hold on;
bar(ax2, categorical(xAxis), mergeDelayStd, 0.25, 'FaceColor',colour2);
hold off;

% Add labels
grid on;
title(ax2,'Average Delay for Merge Lane by Speed Limits');
xlabel('Speed Limit (Merge Lane / Target Lane) (Metres per second)');
ylabel('Delay (seconds)');
legend({'Average Merge Lane Delay','Standard Deviation Merge Lane Delay'});

% Create Average Merge Delay Plot
ax3 = subplot(3,1,3);

% Add bars
bar(ax3, categorical(xAxis), averageTargetDelay, 0.5, 'FaceColor',colour1);
hold on;
bar(ax3, categorical(xAxis), targetDelayStd, 0.25, 'FaceColor',colour2);
hold off;

% Add labels
grid on;
title(ax3,'Average Delay for Target Lane by Speed Limits');
xlabel('Speed Limit (Merge Lane / Target Lane) (Metres per second)');
ylabel('Delay (seconds)');
legend({'Average Target Lane Delay','Standard Deviation Target Lane Delay'});

% Y limits
ylim manual;
maxVal = max(max(horzcat(ax1.YLim,ax2.YLim,ax3.YLim)));
minVal = min(min(horzcat(ax1.YLim,ax2.YLim,ax3.YLim)));

ylim(ax1,[minVal maxVal]);
ylim(ax2,[minVal maxVal]);
ylim(ax3,[minVal maxVal]);

clearvars -except xAxis speedLimitResults colour1 colour2

%% Create Throughput Bar Charts
% Create Figure
figure

% Get Data
throughputTarget = speedLimitResults(:,16);
throughputMerge = speedLimitResults(:,17);

% Transform Data
transformNumber = 3600;
throughputTargetHour = throughputTarget * transformNumber;
throughputMergeHour = throughputMerge * transformNumber;

% Add bars
vehiclesNumberChart = bar(categorical(xAxis), horzcat(throughputTargetHour, throughputMergeHour), 'stacked');
vehiclesNumberChart(1).FaceColor = colour1;
vehiclesNumberChart(2).FaceColor = colour2;

% Add labels
grid on;
title('Throughput by Speed Limits');
xlabel('Speed Limit (Merge Lane / Target Lane) (Metres per second)');
ylabel('Throughput (Vehicles per Hour)');
legend({'Target Lane Throughput','Merge Lane Throughput'});

clearvars -except xAxis speedLimitResults colour1 colour2

%% Create Number of Vehicles Bar Charts
% Create Figure
figure

% Get Data
vehiclesNumberTarget = speedLimitResults(:,19);
vehiclesNumberMerge = speedLimitResults(:,20);

% Add bars
vehiclesNumberChart = bar(categorical(xAxis), horzcat(vehiclesNumberTarget, vehiclesNumberMerge), 'stacked');
vehiclesNumberChart(1).FaceColor = colour1;
vehiclesNumberChart(2).FaceColor = colour2;

% Add labels
grid on;
title('Number of Vehicles Completed by Speed Limits');
xlabel('Speed Limit (Merge Lane / Target Lane) (Metres per second)');
ylabel('Number of Vehicles Completed');
legend({'Target Vehicles Complete','Merge Vehicles Complete'});

clearvars -except xAxis speedLimitResults