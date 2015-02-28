%% --inferences to prove
%1. arousal -> negative correlation in theta,alpha,gamma band Central alpha
%power decrease with high arousal  CP6 -> theta, Cz -> alpha, FC2 -> beta
clc
cd ../data_matlab
Direc=dir('s*.mat');
for i=1:length(Direc)
MatFiles(i,:)=Direc(i).name;%get all file names
end
cd ../common
%%
%calculate mean epoch by aveaging the windows of size 128 and find bin
%power in theta, alpha,beta,gamma
epoch=[4225,8064];
Cind =[1:32]; % channel indices
Fs=128;
wlen=128;
wshft=128;
X=zeros(32,128);
for filenum=1:size(MatFiles,1)
  name=sprintf('../data_matlab/%s',MatFiles(filenum,:));
  load(name); 
  FeatVect=[];
  X=[];
  for video=1:40
       fulldata=squeeze(data(video,:,epoch(1):epoch(2)));
       for chann=1:32 %size(fulldata,1)
           X(chann,:)=meanEpoch(fulldata(chann,:),wlen);%calculate average epoch window size 128
       end
      FeatVect=[FeatVect;FeatureGen(X,Cind,wlen,wshft,Fs,'PowSpec',{4,7,'-',8,13,'-',14,29,'-',30,47})];
  end
    rho=zeros(4,4,32);
    pvalue=zeros(4,4,32);
    for chann=1:32
        for emo=1:4
          for bin=1:4
            [rho(emo,bin,chann),pvalue(emo,bin,chann)]=corr(squeeze(FeatVect(:,bin,chann)),labels(:,emo),'type','Spearman');
          end
        end
    end
  
   outfile=sprintf('../Paper1/deap_binpower/%s.mat',name(16:end-4));
   save(outfile,'FeatVect','labels','rho','pvalue');
end
%%
 

%%
% calculate power in bins using pwelch
% power in theta, alpha,beta,gamma
epoch=[4225,8064];
Cind =[1:32]; % channel indices
Fs=128;
wlen=128;
wshft=128;
X=zeros(32,128);
for filenum=1:size(MatFiles,1)
  name=sprintf('../data_matlab/%s',MatFiles(filenum,:));
  load(name); 
  FeatVect=[];
  X=[];
  for video=1:40
       fulldata=squeeze(data(video,:,epoch(1):epoch(2)));
       for chann=1:32 %size(fulldata,1)
           [A,f]=pwelch(fulldata(chann,:),hann(384),0,512,128);
           theta=sum(A(find(f==3):find(f==7)))/sum(A);
           alpha=sum(A(find(f==8):find(f==13)))/sum(A);
           beta=sum(A(find(f==14):find(f==29)))/sum(A);
           gamma=sum(A(find(f==30):find(f==45)))/sum(A);
           FeatVect(video,:,chann)=[theta,alpha,beta,gamma];
       end     
  end
  rho=zeros(4,4,32);
    pvalue=zeros(4,4,32);
    for chann=1:32
        for emo=1:4
          for bin=1:4
            [rho(emo,bin,chann),pvalue(emo,bin,chann)]=corr(squeeze(FeatVect(:,bin,chann)),labels(:,emo),'type','Spearman');
          end
        end
    end
   outfile=sprintf('../Paper1/deap_binpower_welch/%s.mat',name(16:end-4));
   save(outfile,'FeatVect','labels','rho','pvalue');
end
%%




