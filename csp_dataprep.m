%% --Convert matlab data to a format for CSP analysis
% For Each 60 s recording last 30s is broken into 10s segments ,each with
% same label as entire video

clc
clear all;
cd ../data_matlab
Direc=dir('s*.mat');
for i=1:length(Direc)
MatFiles(i,:)=Direc(i).name;%get all file names
end
cd ../data_for_csp
%%
epoch=[1,8064];
for filenum=1:size(MatFiles,1)
  name=sprintf('../data_matlab/%s',MatFiles(filenum,:));
  load(name);
  cnt=[];
  mrk.pos=[];
  Valence=repmat((labels(:,1)>5),1,3)';
  Arousal=repmat(labels(:,2)>5,1,3)';
  Dominance=repmat(labels(:,3)>5,1,3)';
  for video=1:40
      temp=squeeze(data(video,1:32,epoch(1):epoch(2)))';
      cnt=[cnt;temp];
  end
  for index=1:40
      mrk.pos=[mrk.pos 8064*index-128*30+1 8064*index-128*20+1 8064*index-128*10+1];
  end
  mrk.arousal=Arousal(:)';
  mrk.valence=Valence(:)';
  mrk.dominance=Dominance(:)';
  outfile=sprintf('%s.mat',MatFiles(filenum,1:end-4));
  save(outfile,'cnt','mrk');
end
