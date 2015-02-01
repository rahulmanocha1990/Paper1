%Paper 1 Fractal Dimension Based ,OLGA SOURINA, YISI LIU
% http://www.ntu.edu.sg/home/eosourina/Papers/OSBIOSIGNALS_66_CR.pdf
% Channel FC6 for arousal level classification
% Channel F4 and AF3 for valence level
% sliding window, 99% overlap
% SVM poly kernel size 5
%%
%labels has 1st column as Valence and second as Arousal
%Test Arousal level classification . Arousal < 5 , class 0 , Arousal > 5
%Class 1.
% subject 1
load ../data_matlab/s01.mat
Arousal=labels(:,2);
VideoClass0=find(Arousal<5);
VideoClass1=find(Arousal>=5);
Fs=128;
channel={'FC6'};
method='F';
wlen=256;
wshft=16;
for i=1:length(VideoClass0)
    X=squeeze(data(VideoClass0(i),:,:));
    FeatureClass0(:,i)=FeatureGen(X,channel,method,Fs,wlen,wshft);
end

for i=1:length(VideoClass1)
    X=squeeze(data(VideoClass1(i),:,:));
    FeatureClass1(:,i)=FeatureGen(X,channel,method,Fs,wlen,wshft);
end

%%
%SVM classification
Data=[[zeros(length(FeatureClass0(:)),1) FeatureClass0(:)];[ones(length(FeatureClass1(:)),1) FeatureClass1(:)]];
%%
[B,C,O]=Classifier(Data,'svm',0.7,4);

