%% --Generate features of all types and store them
%pll -> protected  nll -> sad
%plh -> satisfied  nlh -> unconcerned
% phl -> surprise  nhl -> frightened
% phh -> happy     nhh -> angry
classes=cell(8,1);
classes{1}='PLL';  classes{5}='NLL';
classes{2}='PLH';  classes{6}='NLH';
classes{3}='PHL';  classes{7}='NHL';
classes{4}='PHH';  classes{8}='NHH';
%%
cd ../data_matlab
Direc=dir('s*.mat');
for i=1:length(Direc)
MatFiles(i,:)=Direc(i).name;%get all file names
end
cd ../common
%%
Cind=1:32;
Fs=128;
wlen=512;
wshft=128;
%%
% for filenum=1:size(MatFiles,1)
%   name=sprintf('../data_matlab/%s',MatFiles(filenum,:));
%   load(name);
%   Valence=labels(:,1);
%   Arousal=labels(:,2);
%   Dominance=labels(:,3);
%   VideoClass=sortclassindices(Arousal,Valence,Dominance,classes);
%   FeatVect=cell(length(VideoClass),2);
%   for i=1:length(VideoClass)
%       FeatVect{i,1}=VideoClass{i,1};
%       indices=VideoClass{i,2};
%       for j=1:length(indices)
%         X=squeeze(data(indices(j),:,1:8096-384));
%         FeatVect{i,2}=[FeatVect{i,2};FeatureGen(X,Cind,wlen,wshft,Fs,'Fractal',8)];
%       end
%   end 
%   outfile=sprintf('../Paper1/Features_Fractal/%s.mat',name(16:end-4));
%   save(outfile,'FeatVect');
% end
%%
% for filenum=1:size(MatFiles,1)
%   name=sprintf('../data_matlab/%s',MatFiles(filenum,:));
%   load(name);
%   Valence=labels(:,1);
%   Arousal=labels(:,2);
%   Dominance=labels(:,3);
%   VideoClass=sortclassindices(Arousal,Valence,Dominance,classes);
%   FeatVect=cell(length(VideoClass),2);
%   FeatVect2=cell(length(VideoClass),2);
%   for i=1:length(VideoClass)
%       FeatVect{i,1}=VideoClass{i,1};
%       FeatVect2{i,1}=VideoClass{i,1};
%       indices=VideoClass{i,2};
%       for j=1:length(indices)
%         X=squeeze(data(indices(j),:,1:8096-384));
%         FeatVect{i,2}=[FeatVect{i,2};FeatureGen(X,Cind,wlen,wshft,Fs,'HOC',5)];
%         FeatVect2{i,2}=[FeatVect2{i,2};FeatureGen(X,Cind,wlen,wshft,Fs,'STAT','msdefg')];
%       end
%   end 
%   outfile=sprintf('../Paper1/Features_HOC/%s.mat',name(16:end-4));
%   save(outfile,'FeatVect');
%   outfile2=sprintf('../Paper1/Features_STAT/%s.mat',name(16:end-4));
%   save(outfile2,'FeatVect2');
%   
% end

%%
%%
for filenum=1:size(MatFiles,1)
  name=sprintf('../data_matlab/%s',MatFiles(filenum,:));
  load(name);
  Valence=labels(:,1);
  Arousal=labels(:,2);
  Dominance=labels(:,3);
  VideoClass=sortclassindices(Arousal,Valence,Dominance,classes);
  FeatVect=cell(length(VideoClass),2);
  for i=1:length(VideoClass)
      FeatVect{i,1}=VideoClass{i,1};
      indices=VideoClass{i,2};
      for j=1:length(indices)
        X=squeeze(data(indices(j),:,1:8096-384));
        FeatVect{i,2}=[FeatVect{i,2};FeatureGen(X,Cind,wlen,wshft,Fs,'PowSpec',{4,7,'-',8,13,'-',14,29,'-',30,47})];
      end
  end 
  outfile=sprintf('../Paper1/Features_BinPow/%s.mat',name(16:end-4));
  save(outfile,'FeatVect');
end


