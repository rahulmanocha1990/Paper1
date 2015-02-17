%%
%Paper 5 EEG database for emotion Recognition
% http://ieeexplore.ieee.org/lpdocs/epic03/wrapper.htm?arnumber=6680130
% Channels used FC5,F4,F7,AF3
% Feature Vector is a combination of HOC, FD and STAT features normalised
% accross 4 channels
% SVM with gamma=1, poly kernel,coef =1 , d=5,
%Emotions are determined by threshold of 5 for valence,arousal,dominance
%PLL,PLH,NHH...total 8 emotions
%%
%Collect all File names
clc
clear all;
cd ../data_matlab
Direc=dir('s*.mat');
for i=1:length(Direc)
MatFiles(i,:)=Direc(i).name;%get all file names
end
cd ../common
%%
% Try 2 emotions PHH and NLL (Valence>5,Arousal>5,Dominance>5 ; Valence<5,Arousal<5,Dominance<5)
channels={'FC5','F4','F7','AF3'};
Cind=channel2ind('../data_matlab/channels.txt',channels);%Indices of all channels
%ExperimentId='../Paper1/Exp_10_Feb_2015.csv';
%fid=fopen(ExperimentId,'w');
%fprintf(fid,'Paper 5\n');
for filenum=1:size(MatFiles,1)
    FeatureClass0=[];
    FeatureClass1=[];
  name=sprintf('../data_matlab/%s',MatFiles(filenum,:));
  load(name);
  Valence=labels(:,1);
  Arousal=labels(:,2);
  Dominance=labels(:,3);
  VideoClass0=find(Arousal<5 & Valence<5 & Dominance<5);
  VideoClass1=find(Arousal>5 & Valence>5 & Dominance>5);
  Fs=128;
  wlen=512;
  wshft=128;
  for i=1:length(VideoClass0)
     X=squeeze(data(VideoClass0(i),:,1:8096-384));
     FeatureClass0=[FeatureClass0;FeatureGen(X,Cind,wlen,wshft,Fs,'Fractal',8,'HOC',5,'STAT','msdefg')];
  end 

  for i=1:length(VideoClass1)
     X=squeeze(data(VideoClass1(i),:,1:8096-384));
     FeatureClass1=[FeatureClass1;FeatureGen(X,Cind,wlen,wshft,Fs,'Fractal',8,'HOC',5,'STAT','msdefg')];
  end
  outfile=sprintf('../Paper1/Features/%s.mat',name(16:end-4));
  save(outfile,'FeatureClass1','FeatureClass0');
  
  
%SVM classification
  % Data=[[zeros(length(FeatureClass0(:)),1) FeatureClass0(:)];[ones(length(FeatureClass1(:)),1) FeatureClass1(:)]];
%    [B,C,O]=Classifier(Data,'svm',0.7,4);
%    clear data
%    clear labels
%    fprintf(fid,'Subject%d\n',filenum);
%    fprintf(fid,'Accuracy,%f\n',B);
%    fprintf(fid,'ConfMat\n');
%    fprintf(fid,'%f,%f\n',C(1,:));
%    fprintf(fid,'%f,%f\n',C(2,:));
end
%fclose(fid);

%%
clear all;
cd ../Paper1/Features
Direc=dir('*.mat');
for i=1:length(Direc)
FeatFiles(i,:)=Direc(i).name;%get all file names
end
cd ../../common

%%
%Load saved Features and classify them with SVM
% normalise each feature type across 4 channels
ExperimentId='../Paper1/Exp_10_Feb_2015_class2.csv';
fid=fopen(ExperimentId,'w');
fprintf(fid,'Paper5\n');

for filenum=1:size(FeatFiles,1)
    name=sprintf('../Paper1/Features/%s',FeatFiles(filenum,:));
    load(name);
    for i=1:size(FeatureClass0,1)
        A=[];
         for j=1:size(FeatureClass0,2)
                 A=[A squeeze(FeatureClass0(i,j,:))'./norm(squeeze(FeatureClass0(i,j,:)))];
         end
         FC0(i,:)=A;
    end
    for i=1:size(FeatureClass1,1)
        A=[];
         for j=1:size(FeatureClass1,2)
                 A=[A squeeze(FeatureClass1(i,j,:))'./norm(squeeze(FeatureClass1(i,j,:)))];
         end
         FC1(i,:)=A;
    end
    %SVM classification
   Data=[[zeros(size(FC0,1),1) FC0];[ones(size(FC1,1),1) FC1]];
   [B,C,O]=Classifier(Data,'svm',0.7,4);
   clear FeatureClass0
   clear FeatureClass1
   fprintf(fid,'Subject%d\n',filenum);
   fprintf(fid,'Accuracy,%f\n',B);
   fprintf(fid,'ConfMat\n');
   fprintf(fid,'%f,%f\n',C(1,:));
   fprintf(fid,'%f,%f\n',C(2,:));
  
end
fclose(fid);


%%
% Try 4 emotions PLL,PHH,NLL,NHH (V>5,A<5,D<5; V>5,A>5,D>5 ; V<5,A<5,D<5; V<5,A>5,D>5)
channels={'FC5','F4','F7','AF3'};
Cind=channel2ind('../data_matlab/channels.txt',channels);%Indices of all channels
%ExperimentId='../Paper1/Exp_10_Feb_2015.csv';
%fid=fopen(ExperimentId,'w');
%fprintf(fid,'Paper 5\n');
for filenum=1:size(MatFiles,1)
    FC0=[];
    FC1=[];
    FC2=[];
    FC3=[];
  name=sprintf('../data_matlab/%s',MatFiles(filenum,:));
  load(name);
  Valence=labels(:,1);
  Arousal=labels(:,2);
  Dominance=labels(:,3);
  VideoClass0=find(Valence >5 & Arousal<5 & Dominance<5); %PLL
  VideoClass1=find(Valence >5 & Arousal>5 & Dominance>5); %PHH
  VideoClass2=find(Valence <5 & Arousal<5 & Dominance<5); %NLL
  VideoClass3=find(Valence <5 & Arousal>5 & Dominance>5); %NHH
  Fs=128;
  wlen=512;
  wshft=128;
  for i=1:length(VideoClass0)
     X=squeeze(data(VideoClass0(i),:,1:8096-384));
     FC0=[FC0;FeatureGen(X,Cind,wlen,wshft,Fs,'Fractal',8,'HOC',5,'STAT','msdefg')];
  end 

  for i=1:length(VideoClass1)
     X=squeeze(data(VideoClass1(i),:,1:8096-384));
     FC1=[FC1;FeatureGen(X,Cind,wlen,wshft,Fs,'Fractal',8,'HOC',5,'STAT','msdefg')];
  end
  for i=1:length(VideoClass2)
     X=squeeze(data(VideoClass2(i),:,1:8096-384));
     FC2=[FC2;FeatureGen(X,Cind,wlen,wshft,Fs,'Fractal',8,'HOC',5,'STAT','msdefg')];
  end 

  for i=1:length(VideoClass3)
     X=squeeze(data(VideoClass3(i),:,1:8096-384));
     FC3=[FC3;FeatureGen(X,Cind,wlen,wshft,Fs,'Fractal',8,'HOC',5,'STAT','msdefg')];
  end
  
  
  outfile=sprintf('../Paper1/Features_4class/%s.mat',name(16:end-4));
  save(outfile,'FC0','FC1','FC2','FC3');
  
  
%SVM classification
  % Data=[[zeros(length(FeatureClass0(:)),1) FeatureClass0(:)];[ones(length(FeatureClass1(:)),1) FeatureClass1(:)]];
%    [B,C,O]=Classifier(Data,'svm',0.7,4);
%    clear data
%    clear labels
%    fprintf(fid,'Subject%d\n',filenum);
%    fprintf(fid,'Accuracy,%f\n',B);
%    fprintf(fid,'ConfMat\n');
%    fprintf(fid,'%f,%f\n',C(1,:));
%    fprintf(fid,'%f,%f\n',C(2,:));
end
%fclose(fid);

%%
clear all;
cd ../Paper1/Features_4class
Direc=dir('*.mat');
for i=1:length(Direc)
FeatFiles(i,:)=Direc(i).name;%get all file names
end
cd ../../common

%%
ExperimentId='../Paper1/Exp_10_Feb_2015_class4.csv';
fid=fopen(ExperimentId,'w');
fprintf(fid,'Paper5\n');

for filenum=1:size(FeatFiles,1)
    name=sprintf('../Paper1/Features_4class/%s',FeatFiles(filenum,:));
    load(name);
    if(~isempty(FC0) && ~isempty(FC1) && ~isempty(FC2) && ~isempty(FC3))
    for i=1:size(FC0,1)
        A=[];
         for j=1:size(FC0,2)
                 A=[A squeeze(FC0(i,j,:))'./norm(squeeze(FC0(i,j,:)))];
         end
         FV0(i,:)=A;
    end
    for i=1:size(FC1,1)
        A=[];
         for j=1:size(FC1,2)
                 A=[A squeeze(FC1(i,j,:))'./norm(squeeze(FC1(i,j,:)))];
         end
         FV1(i,:)=A;
    end
    for i=1:size(FC2,1)
        A=[];
         for j=1:size(FC2,2)
                 A=[A squeeze(FC2(i,j,:))'./norm(squeeze(FC2(i,j,:)))];
         end
         FV2(i,:)=A;
    end
    for i=1:size(FC3,1)
        A=[];
         for j=1:size(FC3,2)
                 A=[A squeeze(FC3(i,j,:))'./norm(squeeze(FC3(i,j,:)))];
         end
         FV3(i,:)=A;
    end
    %SVM classification
   Data=[[zeros(size(FV0,1),1) FV0];[ones(size(FV1,1),1) FV1];[2*ones(size(FV2,1),1) FV2];[3*ones(size(FV3,1),1) FV3]];
   [B,C,O]=Classifier(Data,'svm',0.7,4);

   fprintf(fid,'Subject%d\n',filenum);
   fprintf(fid,'Accuracy,%f\n',B);
   fprintf(fid,'ConfMat\n');
     for con=1:4
         fprintf(fid,'%f,%f,%f,%f\n',C(con,:));
     end
    end
   clear FC0
   clear FC1
   clear FC2
   clear FC3
end
fclose(fid);
%%
% USE only HOC Features and combination of HOC and STAT
%%
% Try 4 emotions PLL,PHH,NLL,NHH (V>5,A<5,D<5; V>5,A>5,D>5 ; V<5,A<5,D<5; V<5,A>5,D>5)
channels={'FC5'};%,'F4','F7','AF3'};
Cind=channel2ind('../data_matlab/channels.txt',channels);%Indices of all channels
%ExperimentId='../Paper1/Exp_10_Feb_2015.csv';
%fid=fopen(ExperimentId,'w');
%fprintf(fid,'Paper 5\n');
for filenum=1:size(MatFiles,1)
    FC0=[];
    FC1=[];
    FC2=[];
    FC3=[];
  name=sprintf('../data_matlab/%s',MatFiles(filenum,:));
  load(name);
  Valence=labels(:,1);
  Arousal=labels(:,2);
  Dominance=labels(:,3);
  VideoClass0=find(Valence >5 & Arousal<5 & Dominance<5); %PLL
  VideoClass1=find(Valence >5 & Arousal>5 & Dominance>5); %PHH
  VideoClass2=find(Valence <5 & Arousal<5 & Dominance<5); %NLL
  VideoClass3=find(Valence <5 & Arousal>5 & Dominance>5); %NHH
  Fs=128;
  wlen=512;
  wshft=128;
  for i=1:length(VideoClass0)
     X=squeeze(data(VideoClass0(i),:,1:8096-384));
     FC0=[FC0;FeatureGen(X,Cind,wlen,wshft,Fs,'STAT','msdefg')];
  end 

  for i=1:length(VideoClass1)
     X=squeeze(data(VideoClass1(i),:,1:8096-384));
     FC1=[FC1;FeatureGen(X,Cind,wlen,wshft,Fs,'STAT','msdefg')];
  end
  for i=1:length(VideoClass2)
     X=squeeze(data(VideoClass2(i),:,1:8096-384));
     FC2=[FC2;FeatureGen(X,Cind,wlen,wshft,Fs,'STAT','msdefg')];
  end 

  for i=1:length(VideoClass3)
     X=squeeze(data(VideoClass3(i),:,1:8096-384));
     FC3=[FC3;FeatureGen(X,Cind,wlen,wshft,Fs,'STAT','msdefg')];
  end
  
  
  outfile=sprintf('../Paper1/Features_4class_stat_1chan/%s.mat',name(16:end-4));
  save(outfile,'FC0','FC1','FC2','FC3');
  
  
%SVM classification
  % Data=[[zeros(length(FeatureClass0(:)),1) FeatureClass0(:)];[ones(length(FeatureClass1(:)),1) FeatureClass1(:)]];
%    [B,C,O]=Classifier(Data,'svm',0.7,4);
%    clear data
%    clear labels
%    fprintf(fid,'Subject%d\n',filenum);
%    fprintf(fid,'Accuracy,%f\n',B);
%    fprintf(fid,'ConfMat\n');
%    fprintf(fid,'%f,%f\n',C(1,:));
%    fprintf(fid,'%f,%f\n',C(2,:));
end
%fclose(fid);

%%
clear all;
cd ../Paper1/Features_4class_stat_1chan
Direc=dir('*.mat');
for i=1:length(Direc)
FeatFiles(i,:)=Direc(i).name;%get all file names
end
cd ../../common

%%
ExperimentId='../Paper1/Exp_16_Feb_2015_class4_stat.csv';
fid=fopen(ExperimentId,'w');
fprintf(fid,'Paper5\n');

for filenum=1:size(FeatFiles,1)
    name=sprintf('../Paper1/Features_4class_stat_1chan/%s',FeatFiles(filenum,:));
    load(name);
    if(~isempty(FC0) && ~isempty(FC1) && ~isempty(FC2) && ~isempty(FC3))
%     for i=1:size(FC0,1)
%         A=[];
%          for j=1:size(FC0,2)
%                  A=[A squeeze(FC0(i,j,:))'./norm(squeeze(FC0(i,j,:)))];
%          end
%          FV0(i,:)=A;
%     end
%     for i=1:size(FC1,1)
%         A=[];
%          for j=1:size(FC1,2)
%                  A=[A squeeze(FC1(i,j,:))'./norm(squeeze(FC1(i,j,:)))];
%          end
%          FV1(i,:)=A;
%     end
%     for i=1:size(FC2,1)
%         A=[];
%          for j=1:size(FC2,2)
%                  A=[A squeeze(FC2(i,j,:))'./norm(squeeze(FC2(i,j,:)))];
%          end
%          FV2(i,:)=A;
%     end
%     for i=1:size(FC3,1)
%         A=[];
%          for j=1:size(FC3,2)
%                  A=[A squeeze(FC3(i,j,:))'./norm(squeeze(FC3(i,j,:)))];
%          end
%          FV3(i,:)=A;
%     end
    %SVM classification
   Data=[[zeros(size(FC0,1),1) FC0];[ones(size(FC1,1),1) FC1];[2*ones(size(FC2,1),1) FC2];[3*ones(size(FC3,1),1) FC3]];
   [B,C,O]=Classifier(Data,'svm',0.7,4);

   fprintf(fid,'Subject%d\n',filenum);
   fprintf(fid,'Accuracy,%f\n',B);
   fprintf(fid,'ConfMat\n');
     for con=1:4
         fprintf(fid,'%f,%f,%f,%f\n',C(con,:));
     end
    end
   clear FC0
   clear FC1
   clear FC2
   clear FC3
end
fclose(fid);

