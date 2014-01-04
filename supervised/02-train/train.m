% Title:
%   train.m
%
% Desc:
%   trains black box on data
%
%


addpath('src/');

% DATA FORMATTING
display(sprintf('loading data...'));
load ../data/batch_files/full_batch.mat
load ../data/labelled_data/full_batch_labels.mat

inputLabels = rolled_labels;
inputData = full_batch;
clear rolled_labels;
clear full_batch;
inputLabels(inputLabels==0) = 3; % Remap 0 to 3



%numTrain = round(numel(inputLabels)/1.5);
numTrain = 120000;
numTest = 9000;
%numTrain = 12000;
%numTest = 3000;


% RANDOMIZE DATA SAMPLE
one_indices = find(inputLabels==1);
one_indices = one_indices(randperm(length(one_indices)));
two_indices = find(inputLabels==2);
two_indices = two_indices(randperm(length(two_indices)));
three_indices = find(inputLabels==3);
three_indices = three_indices(randperm(length(three_indices)));

trainIndices = [one_indices(1:numTrain/3)', two_indices(1:numTrain/3)', ...
    three_indices(1:numTrain/3)'];
testIndices = [one_indices((numTrain/3) + 1:(numTrain/3)+(numTest/3))', ...
    two_indices((numTrain/3) + 1:(numTrain/3)+(numTest/3))', ...
    three_indices((numTrain/3) + 1:(numTrain/3)+(numTest/3))' ];


% NORMALIZE DATA
%max_data1 = max(max(inputData(:,1:60)'));
%max_data2 = max(max(inputData(:,61:120)'));
%max_data3 = max(max(inputData(:,121:180)'));
%max_data4 = max(max(inputData(:,181:240)'));
%max_data5 = max(max(inputData(:,241:300)'));
%max_data6 = max(max(inputData(:,301:360)'));
%max_data7 = max(max(inputData(:,361:420)'));
%max_data8 = max(max(inputData(:,421:480)'));
%max_data9 = max(max(inputData(:,481:540)'));
 
%normalizedData = zeros(size(inputData));
%normalizedData(:,1:60) = inputData(:,1:60) ./ max_data1;
%normalizedData(:,61:120) = inputData(:,61:120) ./ max_data2;
%normalizedData(:,121:180) = inputData(:,121:180) ./ max_data3;
%normalizedData(:,181:240) = inputData(:,181:240) ./ max_data4;
%normalizedData(:,241:300) = inputData(:,241:300) ./ max_data5;
%normalizedData(:,301:360) = inputData(:,301:360) ./ max_data6;
%normalizedData(:,361:420) = inputData(:,361:420) ./ max_data7;
%normalizedData(:,421:480) = inputData(:,421:480) ./ max_data8;
%normalizedData(:,481:540) = inputData(:,481:540) ./ max_data9;


trainLabelsCols = inputLabels(trainIndices);
testLabelsCols = inputLabels(testIndices);
% trainData = normalizedData(trainIndices,1:240);
% testData = normalizedData(testIndices,1:240);
trainData = inputData(trainIndices,:);
testData = inputData(testIndices,:);


% TRY NORMALIZED DERIVATIVES
%zero_vec = zeros(length(trainIndices),1);
%deriv_trainData = [ zero_vec , diff(trainData(:,1:60),1,2), ...
%    zero_vec, diff(trainData(:,61:120),1,2), zero_vec, diff(trainData(:,121:180),1,2), ...
%    zero_vec, diff(trainData(:,181:240),1,2), zero_vec, diff(trainData(:,241:300),1,2), ...
%    zero_vec, diff(trainData(:,301:360),1,2), zero_vec, diff(trainData(:,361:420),1,2), ...
%    zero_vec, diff(trainData(:,421:480),1,2), zero_vec, diff(trainData(:,481:540),1,2) ];
%zero_vec = zeros(length(testIndices),1);
%deriv_testData = [ zero_vec , diff(testData(:,1:60),1,2), ...
%    zero_vec, diff(testData(:,61:120),1,2), zero_vec, diff(testData(:,121:180),1,2), ...
%    zero_vec, diff(testData(:,181:240),1,2), zero_vec, diff(testData(:,241:300),1,2), ...
%    zero_vec, diff(testData(:,301:360),1,2), zero_vec, diff(testData(:,361:420),1,2), ...
%    zero_vec, diff(testData(:,421:480),1,2), zero_vec, diff(testData(:,481:540),1,2) ];
%
%max_data1 = max(max([ deriv_trainData(:,1:60)', deriv_testData(:,1:60)' ]));
%max_data2 = max(max([ deriv_trainData(:,61:120)', deriv_testData(:,61:120)' ]));
%max_data3 = max(max([ deriv_trainData(:,121:180)', deriv_testData(:,121:180)' ]));
%max_data4 = max(max([ deriv_trainData(:,181:240)', deriv_testData(:,181:240)' ]));
%max_data5 = max(max([ deriv_trainData(:,241:300)', deriv_testData(:,241:300)' ]));
%max_data6 = max(max([ deriv_trainData(:,301:360)', deriv_testData(:,301:360)' ]));
%max_data7 = max(max([ deriv_trainData(:,361:420)', deriv_testData(:,361:420)' ]));
%max_data8 = max(max([ deriv_trainData(:,421:480)', deriv_testData(:,421:480)' ]));
%max_data9 = max(max([ deriv_trainData(:,481:540)', deriv_testData(:,481:540)' ]));
%min_data1 = abs(min(min([ deriv_trainData(:,1:60)', deriv_testData(:,1:60)' ])));
%min_data2 = abs(min(min([ deriv_trainData(:,61:120)', deriv_testData(:,61:120)' ])));
%min_data3 = abs(min(min([ deriv_trainData(:,121:180)', deriv_testData(:,121:180)' ])));
%min_data4 = abs(min(min([ deriv_trainData(:,181:240)', deriv_testData(:,181:240)' ])));
%min_data5 = abs(min(min([ deriv_trainData(:,241:300)', deriv_testData(:,241:300)' ])));
%min_data6 = abs(min(min([ deriv_trainData(:,301:360)', deriv_testData(:,301:360)' ])));
%min_data7 = abs(min(min([ deriv_trainData(:,361:420)', deriv_testData(:,361:420)' ])));
%min_data8 = abs(min(min([ deriv_trainData(:,421:480)', deriv_testData(:,421:480)' ])));
%min_data9 = abs(min(min([ deriv_trainData(:,481:540)', deriv_testData(:,481:540)' ])));
%
% deriv_trainData = [ (deriv_trainData(:,1:60)+min_data1) ./ (max_data1+min_data1), ...
%     (deriv_trainData(:,61:120)+min_data2) ./ (max_data2+min_data2), ...
%     (deriv_trainData(:,121:180)+min_data3) ./ (max_data3+min_data3), ...
%     (deriv_trainData(:,181:240)+min_data4) ./ (max_data4+min_data4), ...
%     (deriv_trainData(:,241:300)+min_data5) ./ (max_data5+min_data5), ...
%     (deriv_trainData(:,301:360)+min_data6) ./ (max_data6+min_data6), ...
%     (deriv_trainData(:,361:420)+min_data7) ./ (max_data7+min_data7), ...
%     (deriv_trainData(:,421:480)+min_data8) ./ (max_data8+min_data8), ...
%     (deriv_trainData(:,481:540)+min_data9) ./ (max_data9+min_data9) ];

% deriv_testData = [ (deriv_testData(:,1:60)+min_data1) ./ (max_data1+min_data1), ...
%     (deriv_testData(:,61:120)+min_data2) ./ (max_data2+min_data2), ...
%     (deriv_testData(:,121:180)+min_data3) ./ (max_data3+min_data3), ...
%     (deriv_testData(:,181:240)+min_data4) ./ (max_data4+min_data4), ...
%     (deriv_testData(:,241:300)+min_data5) ./ (max_data5+min_data5), ...
%     (deriv_testData(:,301:360)+min_data6) ./ (max_data6+min_data6), ...
%     (deriv_testData(:,361:420)+min_data7) ./ (max_data7+min_data7), ...
%     (deriv_testData(:,421:480)+min_data8) ./ (max_data8+min_data8), ...
%     (deriv_testData(:,481:540)+min_data9) ./ (max_data9+min_data9) ];


%trainData = deriv_trainData;
%testData = deriv_testData;

trainLabels = zeros(numTrain,3);
testLabels = zeros(numTest,3);
for i=1:numTrain
    trainLabels(i,trainLabelsCols(i)) = 1;
end
for i=1:numTest
    testLabels(i,testLabelsCols(i)) = 1;
end



% MATLAB NN
hiddenLayerSize = 360;
net = patternnet(hiddenLayerSize);

[net,tr] = train(net,trainData',trainLabels');

outputs = net(testData');
errors = gsubtract(testLabels',outputs);
performance = perform(net,testLabels',outputs)

save('net.mat', 'net');


% CONSTRUCTING DBN
%nodes = [540 360 3];
%bbdbn = randDBN( nodes, 'GBRBM' );
%nrbm = numel(bbdbn.rbm);

%opts.MaxIter = 100;
%opts.BatchSize = 100;
%opts.Verbose = true;
%opts.StepRatio = 0.1;
%opts.object = 'CrossEntropy';

%opts.Layer = nrbm-1;
%display('Pretraining DBN...');
%bbdbn = pretrainDBN(bbdbn, trainData, opts);
%display('Setting Linear Mapping...');
%bbdbn= SetLinearMapping(bbdbn, trainData, trainLabels);

%opts.Layer = 0;
%display('Training DBN...');
%bbdbn = trainDBN(bbdbn, trainData, trainLabels, opts);

%save('bbdbn.mat', 'bbdbn' );




% TEST
%rmse= CalcRmse(bbdbn, trainData, trainLabels);
%ErrorRate= CalcErrorRate(bbdbn, trainData, trainLabels);
%fprintf( 'Train rmse: %g\n', rmse );
%fprintf( 'Train ErrorRate: %g\n', ErrorRate );

%rmse= CalcRmse(bbdbn, testData, testLabels);
%ErrorRate= CalcErrorRate(bbdbn, testData, testLabels);
%fprintf( 'Test rmse: %g\n', rmse );
%fprintf( 'Test ErrorRate: %g\n', ErrorRate );
