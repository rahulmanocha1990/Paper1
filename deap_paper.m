%% --inferences to prove
%1. arousal -> negative correlation in theta,alpha,gamma band Central alpha
%power decrease with high arousal  CP6 -> theta, Cz -> alpha, FC2 -> beta

cd ../data_matlab
Direc=dir('s*.mat');
for i=1:length(Direc)
MatFiles(i,:)=Direc(i).name;%get all file names
end
cd ../common
%%