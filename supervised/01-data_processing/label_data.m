% Title:
%   label_data.m
% 
% Desc:
%   MATLAB script that reads data loaded and saved in full_batch.mat and
%   displays it via MATLAB GUI for the user to label
%   
%   Three Labels: 
%       0 - Neutral
%       1 - Troughs (BUY)
%       2 - Peaks (SELL)
%
% Example
%   label_data;

addpath('scripts/');

% const
DATA_INTERVAL = 1;
PLOT_INTERVAL = 60;
PRICE_INDEX = 1;




% load stock ticker names
try
    batch_listing = dir('../data/batch_files/*.mat');
    num_sets = size(batch_listing,1);
    
catch exception
    error('Error finding corresponding batch file names. Exiting...');
end

% retrieve group to label
% training data has 15 minute overlap
display(sprintf('\n-----------------------------'));
display(sprintf('BEGIN DATA LABELLING'));
display(sprintf('-----------------------------\n'));


for i=1:num_sets
    
    % retrieve current set
    try
        path = strcat('../data/batch_files/', batch_listing(i).name);
        load(path); % loaded into batch_data var
    catch exception
        error('Could not load data. Quitting...');
    end
        
    
    % check if labels already exist
    display(sprintf('Checking %s...', batch_listing(i).name));
    if exist(sprintf('../data/labelled_data/%s', batch_listing(i).name), 'file')
        display(sprintf('Labels for %s already exist. Skipping...', batch_listing(i).name));
        continue
    end
    
    display(sprintf('Would you like to continue and label %s data?', batch_listing(i).name));
    usr_input = input('Type "yes" or "no": ', 's');
    if strcmp(usr_input, 'no')
        display(sprintf('Quitting...'));
        return;
    end
    
    % begin labelling this stock
    display(sprintf('Building GUI...'));
    
    
    
    cur_set = batch_data;
    data_to_be_plotted = [];
    
    
    for j=1:size(cur_set,1)
        % init
        if j == 1
            cur_range = 1 + ((PRICE_INDEX - 1)*PLOT_INTERVAL):(PRICE_INDEX - 1)*PLOT_INTERVAL + 60;
            data_to_be_plotted = [data_to_be_plotted, cur_set(j, cur_range) ];
            continue;
        end
        
        % add in increments of DATA_INTERVAL
        cur_range = ((PRICE_INDEX - 1)*PLOT_INTERVAL + 60 - DATA_INTERVAL)+1:(PRICE_INDEX - 1)*PLOT_INTERVAL + 60;
        data_to_be_plotted = [data_to_be_plotted, cur_set(j, cur_range) ];
        
    end
    
    % create GUI and plot line
    smoothing = 5;
    peak_thresh = '15';
    
    %scrsz = get(0,'ScreenSize');
    %figure('Name', 'CONTROL', 'Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
    %spacing_handle = uicontrol('Style', 'popup', 'String', ...
    %    '1|5|10|15|20|30|60', 'Callback', peak_thresh);
    %OKbutton_handle = uicontrol('Style', 'pushbutton', 'String', 'Confirm');
    
    % plot original time series
    figure;
    X = 1:length(data_to_be_plotted);
    plot(data_to_be_plotted, 'Color', 'c');
    hold on;
    
    % adjust smoothing of time series
    yy = smoothn(data_to_be_plotted, smoothing*100);
    plot(yy, 'Color', 'b');
    
    % solve for peaks with GUI
    [peaks, peak_ind] = findpeaks(yy, 'minpeakdistance', str2num(peak_thresh));
    peak_ind_full = [peak_ind, peak_ind + 1, peak_ind + 2, peak_ind + 3, ...
        peak_ind - 1, peak_ind - 2, peak_ind - 3];
    DataInv = 1.01*max(yy) - yy;
    [min, min_ind] = findpeaks(DataInv, 'minpeakdistance', str2num(peak_thresh));
    min_ind_full = [min_ind, min_ind + 1, min_ind + 2, min_ind + 3, ...
        min_ind - 1, min_ind - 2, min_ind - 3];
    
    min_ind_full = unique(min_ind_full);
    peak_ind_full = unique(peak_ind_full);

    
    % make sure min and max peaks dont overlap each other
    intersection = intersect(min_ind_full, peak_ind_full);
    min_inter_ind = ismember(min_ind_full, intersection);
    peak_inter_ind = ismember(peak_ind_full, intersection);
    min_ind_full(min_inter_ind) = [];
    peak_ind_full(peak_inter_ind) = [];
    
        
    peak_ind_full(peak_ind_full<=0) = [];
    min_ind_full(min_ind_full<=0) = [];
    
    
    % plot points
    plot(peak_ind_full, yy(peak_ind_full), '*', 'Color', 'r');
    plot(min_ind_full, yy(min_ind_full), 'o', 'Color', 'g');
    %plot(peak_ind_full, data_to_be_plotted(peak_ind_full), '*', 'Color', 'r');
    %plot(min_ind_full, data_to_be_plotted(min_ind_full), 'o', 'Color', 'g');
    
    % remove first 60 points
    peak_ind_full(peak_ind_full<=60) = [];
    min_ind_full(min_ind_full<=60) = [];
    
    peak_ind_full = peak_ind_full - 1; %index reformatted for prediction
    min_ind_full = min_ind_full - 1;
    
    
    % generate label vector
    labels = zeros(size(data_to_be_plotted));
    labels(peak_ind_full) = 2;
    labels(min_ind_full) = 1;
    labels(1:59) = [];
    labels = labels';
    
    % export labels
    output_file = strcat('../data/labelled_data/', batch_listing(i).name);
    save(output_file, 'labels');
    close;
    
    
    
end


% roll all examples together
display(sprintf('Checking full batch labels...'));
if exist(sprintf('../data/labelled_data/full_batch_labels.mat'), 'file')
    display(sprintf('Labels for full batch already exist. Skipping...'));
else
    rolled_labels = [];
    for i=1:num_sets
        try
            display(sprintf('On Iteration: %i/%i', i, num_sets));
            path = strcat('../data/labelled_data/', batch_listing(i).name);
            load(path); % loaded into batch_data var
        catch exception
            error('Could not load data. Quitting...');
        end
        
        rolled_labels = [rolled_labels', labels']';
    end
    save('../data/labelled_data/full_batch_labels.mat', 'rolled_labels');
    
end


display(sprintf('Checking full batch data...'));
if exist(sprintf('../data/batch_files/full_batch.mat'), 'file')
    display(sprintf('Files for full batch already exist. Skipping...'));
else
    full_batch = [];
    for i=1:num_sets
        try
            display(sprintf('On Iteration: %i/%i', i, num_sets));
            path = strcat('../data/batch_files/', batch_listing(i).name);
            load(path); % loaded into batch_data var
        catch exception
            error('Could not load data. Quitting...');
        end
        
        full_batch = [full_batch; batch_data];
    end
    save('../data/batch_files/full_batch.mat', 'full_batch');
    
end