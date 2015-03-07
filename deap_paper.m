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
% epoch=[4225,8064];
% Cind =[1:32]; % channel indices
% Fs=128;
% wlen=128;
% wshft=128;
% X=zeros(32,128);
% for filenum=1:size(MatFiles,1)
%   name=sprintf('../data_matlab/%s',MatFiles(filenum,:));
%   load(name); 
%   FeatVect=[];
%   X=[];
%   for video=1:40
%        fulldata=squeeze(data(video,:,epoch(1):epoch(2)));
%        for chann=1:32 %size(fulldata,1)
%            X(chann,:)=meanEpoch(fulldata(chann,:),wlen);%calculate average epoch window size 128
%        end
%       FeatVect=[FeatVect;FeatureGen(X,Cind,wlen,wshft,Fs,'PowSpec',{4,7,'-',8,13,'-',14,29,'-',30,47})];
%   end
%     rho=zeros(4,4,32);
%     pvalue=zeros(4,4,32);
%     for chann=1:32
%         for emo=1:4
%           for bin=1:4
%             [rho(emo,bin,chann),pvalue(emo,bin,chann)]=corr(squeeze(FeatVect(:,bin,chann)),labels(:,emo),'type','Spearman');
%           end
%         end
%     end
%   
%    outfile=sprintf('../Paper1/deap_binpower/%s.mat',name(16:end-4));
%    save(outfile,'FeatVect','labels','rho','pvalue');
% end
%%
 

%%
% calculate power in bins using pwelch
% power in theta, alpha,beta,gamma
% epoch=[4225,8064];
% Cind =[1:32]; % channel indices
% Fs=128;
% wlen=128;
% wshft=128;
% X=zeros(32,128);
% for filenum=1:size(MatFiles,1)
%   name=sprintf('../data_matlab/%s',MatFiles(filenum,:));
%   load(name); 
%   FeatVect=[];
%   X=[];
%   for video=1:40
%        fulldata=squeeze(data(video,:,epoch(1):epoch(2)));
%        for chann=1:32 %size(fulldata,1)
%            [A,f]=pwelch(fulldata(chann,:),hann(384),0,512,Fs);
%            theta=mean(A(find(f>=3 & f<=7)));
%            alpha=mean(A(find(f>=8 & f<=13)));
%            beta=mean(A(find(f>=14 & f<=29)));
%            gamma=mean(A(find(f>=30 & f<=45)));
%            FeatVect(video,:,chann)=[theta,alpha,beta,gamma];
%        end     
%   end
%   rho=zeros(4,4,32);
%     pvalue=zeros(4,4,32);
%     flag001=1;
%     flag01=1;
%     maxcorr005={};
%     maxcorr01={};
%     for chann=1:32
%         for emo=1:4
%           for bin=1:4
%             [rho(emo,bin,chann),pvalue(emo,bin,chann)]=corr(squeeze(FeatVect(:,bin,chann)),labels(:,emo),'type','Spearman','tail','left');
%             if(pvalue(emo,bin,chann)<=0.005)
%                 maxcorr005{flag001}=[emo,bin,chann,rho(emo,bin,chann)];
%                 flag001=flag001+1;
%             elseif(pvalue(emo,bin,chann)<=0.01)
%                 maxcorr01{flag01}=[emo,bin,chann,rho(emo,bin,chann)];
%                 flag01=flag01+1;
%             end
%           end
%         end
%     end
%    outfile=sprintf('../Paper1/deap_binpower_welch/%s.mat',name(16:end-4));
%    save(outfile,'FeatVect','labels','rho','pvalue','maxcorr005','maxcorr01');
% end


% 
%%
% %Single trial classification , using 4 frequency bins, 32 channels and 14
% %symmertric channels
epoch=[4225,8064];
%Cind =[1:32]; % channel indices
SymmChann=channel2ind('../data_matlab/channels.txt',{'Fp1','Fp2','AF3','AF4','F3',...
    'F4','F7','F8','C3','C4','FC1','FC2','FC5','FC6','T7','T8','CP5','CP6',...
    'CP1','CP2','P3','P4','P7','P8','PO3','PO4','O1','O2'});
Cind=[];
for chann=1:32
  if(~any(chann==SymmChann))
    Cind(end+1)=chann;
  end
end
%%
Fs=128;
wlen=128;
wshft=0;
ExperimentId='../Paper1/Exp_6_March_2015_deap_single_trial.csv';
fid=fopen(ExperimentId,'w');
fprintf(fid,'Single Trial Classification with Bin power features \n');
for filenum=1:size(MatFiles,1)
  name=sprintf('../data_matlab/%s',MatFiles(filenum,:));
  load(name); 
  FeatVect=[];
  for video=1:40
       fulldata=squeeze(data(video,:,epoch(1):epoch(2)));
       Vect=[];
       for chann=1:2:28 % bin power for each symmetric channel and difference of spectral power
           [A,f]=pwelch(fulldata(SymmChann(chann),:),hann(384),0,512,Fs);
           [B,f]=pwelch(fulldata(SymmChann(chann+1),:),hann(384),0,512,Fs);
           theta1=mean(A(find(f>=3 & f<=7)));theta2=mean(B(find(f>=3 & f<=7)));
           alpha1=mean(A(find(f>=8 & f<=13)));alpha2=mean(B(find(f>=8 & f<=13)));
           beta1=mean(A(find(f>=14 & f<=29)));beta2=mean(B(find(f>=14 & f<=29)));
           gamma1=mean(A(find(f>=30 & f<=45)));gamma2=mean(B(find(f>=30 & f<=45)));
           Vect=[Vect log10([theta1,alpha1,beta1,gamma1,theta2,alpha2,beta2,gamma2]) ...
               [log10(theta2)-log10(theta1),log10(alpha2)-log10(alpha1),log10(beta2)-log10(beta1),log10(gamma2)-log10(gamma1)]];
       end  
       for chann=1:4
           [A,f]=pwelch(fulldata(Cind(chann),:),hann(384),0,512,Fs);
           theta1=mean(A(find(f>=3 & f<=7)));
           alpha1=mean(A(find(f>=8 & f<=13)));
           beta1=mean(A(find(f>=14 & f<=29)));
           gamma1=mean(A(find(f>=30 & f<=45)));
           Vect=[Vect log10([theta1,alpha1,beta1,gamma1])];             
       end
       FeatVect(video,:)=Vect;
  end
  Valence=labels(:,1)>5;
  Arousal=labels(:,2)>5;
  Dominance=labels(:,3)>5;
  J1=fishercriterion(FeatVect,Valence);
  J2=fishercriterion(FeatVect,Arousal);
  J3=fishercriterion(FeatVect,Dominance);
  %Cross Validation with Leave one out using Naive Bayes
  % Seperate models for arousal , valence, dominance
  if(J1==0)
      Loss1=100;
      C1=zeros(2,2);
  else
    Mdl1=fitcnb(FeatVect(:,J1>1),Valence,'Leaveout','on');
    Loss1=kfoldLoss(Mdl1);
    C1=confusionmat(Valence,kfoldPredict(Mdl1));
  end
  if(J2==0)
      Loss2=100;
      C2=zeros(2,2);
  else
    Mdl2=fitcnb(FeatVect(:,J2>1),Arousal,'Leaveout','on');
    Loss2=kfoldLoss(Mdl2);
    C2=confusionmat(Arousal,kfoldPredict(Mdl2));
  end
  if(J3==0)
      Loss3=100;
      C3=zeros(2,2);
  else
      Mdl3=fitcnb(FeatVect(:,J3>1),Dominance,'Leaveout','on');
      Loss3=kfoldLoss(Mdl3);
      C3=confusionmat(Dominance,kfoldPredict(Mdl3));
  end
  
   fprintf(fid,'Subject%d\n',filenum);
   
   fprintf(fid,'Valence Accuracy,%f\n',(1-Loss1)*100);
   fprintf(fid,'Valence F1 score,%f\n',(2*C1(2,2))/((2*C1(2,2))+C1(1,2)+C1(2,1)));
   
   fprintf(fid,'Arousal Accuracy,%f\n',(1-Loss2)*100);
   fprintf(fid,'Arousal F1 score,%f\n',(2*C2(2,2))/((2*C2(2,2))+C2(1,2)+C2(2,1)));
   
   fprintf(fid,'Dominance Accuracy,%f\n',(1-Loss3)*100);
   fprintf(fid,'Dominance F1 score,%f\n',(2*C3(2,2))/((2*C3(2,2))+C3(1,2)+C3(2,1)));
   
   
   outfile=sprintf('../Paper1/deap_featvect/%s.mat',name(16:end-4));
   save(outfile,'FeatVect','labels');
end