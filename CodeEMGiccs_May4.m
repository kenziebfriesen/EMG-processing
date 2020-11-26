%Kenzie Friesen
%April 15, 2020
%Reorganize EMG Data: Find Average of 3 Muscle On Times

%Read in data
%Find mean of columns 3 and 4 beginning row 10
%Divide every cell in columns 3 and 4 by mean
%Find absolute value of each cell: Rectify
%Find events
%Find average value of cells between events 1-2, 3-4, 5-6
%Find average of thee averages
%Report in row for each participant's set of 24 trials

%%%%

Data = dir('*.xlsm'); %Read in data
numFiles = length(Data); %Find number of data files
fileMaster = char({Data.name}); %Find order of output

%%%%

numEvents = 6; %number of events

%%%%

master = []; %Creating master array for final output excel spreadsheet

%%%%


f = 1; %file
p = 1; %participant
rowHold = numEvents + 1; %creating a rows of space
numParticipants = (numFiles)/24; % numParticipants based on how many files are in current folder divided by number of files per participant

%%%%
for p = 1:numParticipants
    c = 1;%counter. Need this here bc we will be repeated this for each participant
for c = 1:1 %Do this for each file 
     filename = fileMaster(f, :); %Retrieves whole (:) file name for which you are working on
     num = readmatrix(filename); %Separates number and text values within a file
      currentTrial = num; %Current trial we are going to do work on is using only number data
      [rowsTrial, columnsTrial] = size(currentTrial); %Finds the  # of rows, columns in the trial we are working on "currentTrial"
      currentTrial = currentTrial(8:(rowsTrial-50), [1:columnsTrial]); %We will only be using rows from 8 down and all columns 
      [rowsTrial, columnsTrial] = size(currentTrial); %Re-sizes the currentTrial based on the row above specifications
      


%Find mean of raw column 
        mRaw = mean(currentTrial); %Finding the mean of the rawdata 
        
        
%Subtract every cell in raw column by mean
        correctRaw = currentTrial-mRaw;


%Find absolute value of each cell: Rectify
        rectifyRaw = abs(correctRaw);
        
%Combine clean EMG data with EventMark column
%Create new array
 correctedEMG = [];
 
 correctedEMG(:,1) = currentTrial(:,1); %Taking the first column of data from currentTrial/ sampling #
 correctedEMG(:,2) = rectifyRaw(:,3); %Taking 3rd column of data from rectifyRaw
 correctedEMG(:,3) = currentTrial(:,4); %Taking 4th column of data from currentTrial
  
     
% Needed to find events
      rowNum = 1; %A coutner used to let us know where we are in the matrix
      variableData = zeros(rowHold, 3); %It is a temporary matrix for each event. Adds zeros to the matrix "variableData"
      i = 1; %Counter variable for the next while statement
     
     
%Find events
 while i < rowsTrial %repeat for every row of data
                if correctedEMG(i, 3) == 1 %Using 3 bc thats the # of columns we have 
                    variableData(rowNum, :) = correctedEMG(i, :); %Creating variableData using all rows of our datasheet (correctedEMG)
                    rowNum = rowNum + 1; %repeat for the next row
                    i = i + 1; 
                end
                if correctedEMG(i, 3) ~= 1 %if correctedEMG doesn't equal 1
                    i = i + 1; %just move onto the next row of data
                end
 end

            
 %Extracting 1st column of data from correctedEMG for each events
 T1 = variableData(1,1);
 T2 = variableData(2,1); 
 T3 = variableData(3,1);
 T4 = variableData(4,1);
 T5 = variableData(5,1);

 %Find average value of cells between events 1-2, 3-4, 5-6
 master(p,f,:) = 
 
 meanOne = mean(correctedEMG(T1:T2,2)); %Looking at the corData matrix, finding mean of 2nd column between T1 and T2
 meanTwo = mean(correctedEMG(T3:T4,2));
 meanThree = mean(correctedEMG(T5:T6,2));
 
 %Find average of thee averages
 averageMean = ((meanOne + meanTwo + meanThree)/3);
 
 %Report in row for each participant's set of 24 trials
 master(p,c) = averageMean;
 
 c = c+1; %Repeat for the next file
 f = f +1; %Repeat for the next file
 
end

p = p +1; %Repeat for the next participant

end

