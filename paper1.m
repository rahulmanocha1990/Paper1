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
%%
cd ../data_matlab
Direc=dir('*.mat');
for i=1:length(Direc)
MatFiles(i,:)=Direc(i).name;%get all file names
end
cd ../common
%%
%Arousal Level Recognition with channel FC6, 1 Fractal Feature , SVM Poly
ExperimentId='../Paper1/Exp_1_Feb_2015.txt';
fid=fopen(ExperimentId,'w');
for filenum=1:size(MatFiles,1)
  name=sprintf('../data_matlab/%s',MatFiles(filenum,:));
  load(name);
  Arousal=labels(:,2);
  VideoClass0=find(Arousal<=4);
  VideoClass1=find(Arousal>=5);
  Fs=128;
  channel={'FC6'};
  method='F';
  wlen=512;
  wshft=64;
  for i=1:length(VideoClass0)
     X=squeeze(data(VideoClass0(i),:,1:8096-384));
     FeatureClass0(:,i)=FeatureGen(X,channel,method,Fs,wlen,wshft);
  end 

  for i=1:length(VideoClass1)
     X=squeeze(data(VideoClass1(i),:,1:8096-384));
     FeatureClass1(:,i)=FeatureGen(X,channel,method,Fs,wlen,wshft);
  end
%SVM classification
   Data=[[zeros(length(FeatureClass0(:)),1) FeatureClass0(:)];[ones(length(FeatureClass1(:)),1) FeatureClass1(:)]];
   [B,C,O]=Classifier(Data,'svm',0.7,4);
   clear data
   clear labels
   fprintf(fid,'Subject%d \n',filenum);
   fprintf(fid,'Accuracy=%f \n',B);
   fprintf(fid,'ConfMat= \n');
   fprintf(fid,'%f %f \n',C);
end
fclose(fid);

%%
%Arousal Level classifi with two channels FC6 and F7 and fractal dimension
%as features
ExperimentId='../Paper1/Exp_2_Feb_2015.txt';
fid=fopen(ExperimentId,'w');
for filenum=1:size(MatFiles,1)
  name=sprintf('../data_matlab/%s',MatFiles(filenum,:));
  load(name);
  Arousal=labels(:,2);
  VideoClass0=find(Arousal<=4);
  VideoClass1=find(Arousal>=5);
  Fs=128;
  channel={'FC6';'F7'};
  method='F';
  wlen=512;
  wshft=64;
  for i=1:length(VideoClass0)
     X=squeeze(data(VideoClass0(i),:,1:8096-384));
     FeatureClass0=[FeatureClass0;squeeze(FeatureGen(X,channel,method,Fs,wlen,wshft))];
  end 

  for i=1:length(VideoClass1)
     X=squeeze(data(VideoClass1(i),:,1:8096-384));
     FeatureClass1=[FeatureClass1;squeeze(FeatureGen(X,channel,method,Fs,wlen,wshft))];
  end
%SVM classification
   Data=[[zeros(size(FeatureClass0,1),1) FeatureClass0];[ones(size(FeatureClass1,1),1) FeatureClass1]];
   [B,C,O]=Classifier(Data,'svm',0.7,4);
   clear data
   clear labels
   fprintf(fid,'Subject%d \n',filenum);
   fprintf(fid,'Accuracy=%f \n',B);
   fprintf(fid,'ConfMat= \n');
   fprintf(fid,'%f %f \n',C);
end
fclose(fid);



