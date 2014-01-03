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
numTrain = 100000;
numTest = 20000;
max_data = max(max(inputData(1:numTrain+numTest,:)));
trainLabelsCols = inputLabels(1:numTrain);
testLabelsCols = inputLabels(numTrain+1:numTrain+numTest);
trainData = inputData(1:numTrain,:) ./ max_data;
testData = inputData(numTrain+1:numTrain+numTest,:) ./ max_data;

trainLabels = zeros(numTrain,3);
testLabels = zeros(numTest,3);
for i=1:numTrain
    trainLabels(i,trainLabelsCols(i)) = 1;
end
for i=1:numTest
    testLabels(i,testLabelsCols(i)) = 1;
end




% CONSTRUCTING DBN
nodes = [540 700 700 3];
bbdbn = randDBN( nodes, 'BBDBN' );
nrbm = numel(bbdbn.rbm);

opts.MaxIter = 20;
opts.BatchSize = 100;
opts.Verbose = true;
opts.StepRatio = 0.1;
opts.object = 'CrossEntropy';

opts.Layer = nrbm-1;
display('Pretraining DBN...');
bbdbn = pretrainDBN(bbdbn, trainData, opts);
display('Setting Linear Mapping...');
bbdbn= SetLinearMapping(bbdbn, trainData, trainLabels);

opts.Layer = 0;
display('Training DBN...');
bbdbn = trainDBN(bbdbn, trainData, trainLabels, opts);

save('bbdbn.mat', 'bbdbn' );




% TEST
rmse= CalcRmse(bbdbn, trainData, trainLabels);
ErrorRate= CalcErrorRate(bbdbn, trainData, trainLabels);
fprintf( 'rmse: %g\n', rmse );
fprintf( 'ErrorRate: %g\n', ErrorRate );
