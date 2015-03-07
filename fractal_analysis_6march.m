%% --find correlation between fractal dimensions and emotions
cd ../Paper1/FinalFeat
Direc=dir('*.mat');
for i=1:length(Direc)
FeatFiles(i,:)=Direc(i).name;%get all file names
end
cd ../../common
load('../data_matlab/biosemi32chnn.mat');
classes=cell(8,1);
classes{1}='PLL';  classes{5}='NLL';
classes{2}='PLH';  classes{6}='NLH';
classes{3}='PHL';  classes{7}='NHL';
classes{4}='PHH';  classes{8}='NHH';
%%
for filenum=1:size(FeatFiles,1)
  name=sprintf('../Paper1/FinalFeat/%s',FeatFiles(filenum,:));
  load(name,'FracFeat','labels');
  FeatVect=[];
  for vid=1:40
      A=mean(squeeze(FracFeat{vid}));
      handl=figure;topoplot(rescale(A,1,-1),chann,'electrodes','labels');
      classname=sortclassindices(labels(vid,2),labels(vid,1),labels(vid,3),classes);
      title(classname{1},'FontSize',16);
      plotname=sprintf('../Paper1/fractal_analysis/spatial_patt/%s_%s_%d.fig',FeatFiles(filenum,1:end-4),classname{1},vid);
      saveas(handl,plotname);
      close(handl);
      FeatVect=[FeatVect;A];
  end
      
     rho=zeros(4,32);
     pvalue=zeros(4,32);
     flag005=1;
     flag01=1;
     maxcorr005=[];
     maxcorr01=[];
     for chan=1:32
        for emo=1:4
            [rho(emo,chan),pvalue(emo,chan)]=corr(squeeze(FeatVect(:,chan)),labels(:,emo),'type','Spearman');
            if(pvalue(emo,chan)<=0.005)
                maxcorr005(flag005,:)=[emo,chan,rho(emo,chan)];
                flag005=flag005+1;
            elseif(pvalue(emo,chan)<=0.01)
                maxcorr01(flag01,:)=[emo,chan,rho(emo,chan)];
                flag01=flag01+1;
            end
        end
    end
   outfile=sprintf('../Paper1/fractal_analysis/%s.mat',FeatFiles(filenum,1:end-4));
   save(outfile,'FeatVect','rho','pvalue','maxcorr005','maxcorr01');
end

  
%%
ExperimentId='../Paper1/Exp_6_March_2015_fractal_single_trial.csv';
fid=fopen(ExperimentId,'w');
fprintf(fid,'Single Trial Classification with Fractal features \n');
for filenum=1:size(FeatFiles,1)
  name=sprintf('../Paper1/FinalFeat/%s',FeatFiles(filenum,:));
  load(name,'FracFeat','labels');
  FeatVect=[];
  for vid=1:40
      A=mean(squeeze(FracFeat{vid}));
      FeatVect=[FeatVect;A];
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
end

fclose(fid);