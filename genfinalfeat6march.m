%% --Generate each type of Features Fractal,HOC and STAT
% Save these Features along with labels for further analysis
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
epoch=[385,8064];
Cind=[1:32];
wlen=384;
wshft=128;
Fs=128;
kf=8;%fractal parameter
kh=5;%number of HOC
ks='msdefg';%6 statistical features

%%
%Fractal Features

for filenum=1:size(MatFiles,1)
  name=sprintf('../data_matlab/%s',MatFiles(filenum,:));
  load(name);
  FracFeat=cell(40,1);
  HocFeat=cell(40,1);
  StatFeat=cell(40,1);
  for video=1:40
      X=squeeze(data(video,:,epoch(1):epoch(2)));
      FracFeat{video}=FeatureGen(X,Cind,wlen,wshft,Fs,'Fractal',kf);
      HocFeat{video}=FeatureGen(X,Cind,wlen,wshft,Fs,'HOC',kh);
      StatFeat{video}=FeatureGen(X,Cind,wlen,wshft,Fs,'STAT',ks);
  end
  outfile=sprintf('../Paper1/FinalFeat/%s.mat',name(16:end-4));
  save(outfile,'FracFeat','HocFeat','StatFeat','labels');
end