%% --single trial classificatin of stat features
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
ExperimentId='../Paper1/Exp_7_March_2015_full_feat_nb_svm_nf30.csv';
fid=fopen(ExperimentId,'w');
fprintf(fid,'Single Trial Classification with [FD HOC STAT] features Nf 30 \n');
Nf=30;
fprintf(fid,'Subject,Val.Acc,Aro.Acc,Dom.Acc,Val.F1,Aro.F1,Dom.F1,,Val.Acc,Aro.Acc,Dom.Acc,Val.F1,Aro.F1,Dom.F1\n');
for filenum=1:size(FeatFiles,1)
  name=sprintf('../Paper1/FinalFeat/%s',FeatFiles(filenum,:));
  load(name);
  FeatVect=[];
  for vid=1:40
      F1=squeeze(mean(StatFeat{vid}));
      F1=F1(:)';
      F2=squeeze(mean(HocFeat{vid}));
      F2=F2(:)';
      F3=mean(squeeze(FracFeat{vid}));
      FeatVect=[FeatVect;[F1 F2 F3]];
  end   
  Valence=labels(:,1)>5;
  Arousal=labels(:,2)>5;
  Dominance=labels(:,3)>5;

  [J,J1]=sort(fishercriterion(FeatVect,Valence),'descend');
  [J,J2]=sort(fishercriterion(FeatVect,Arousal),'descend');
  [J,J3]=sort(fishercriterion(FeatVect,Dominance),'descend');
  %Cross Validation with Leave one out using Naive Bayes
  % Seperate models for arousal , valence, dominance
  if(J1==1)
      Loss1_nb=100;
      C1_nb=zeros(2,2);
      Loss1_svm=100;
      C1_svm=zeros(2,2);
  else
    Mdl1_nb=fitcnb(FeatVect(:,J1(1:Nf)),Valence,'Leaveout','on');
    Loss1_nb=kfoldLoss(Mdl1_nb);
    C1_nb=confusionmat(Valence,kfoldPredict(Mdl1_nb));
    Mdl1_svm=fitcsvm(FeatVect(:,J1(1:Nf)),Valence,'KernelFunction','polynomial',...
        'PolynomialOrder',5,'Leaveout','on');
    Loss1_svm=kfoldLoss(Mdl1_svm);
    C1_svm=confusionmat(Valence,kfoldPredict(Mdl1_svm));
  end
  if(J2==1)
      Loss2_nb=100;
      C2_nb=zeros(2,2);
      Loss2_svm=100;
      C2_svm=zeros(2,2);
  else
    Mdl2_nb=fitcnb(FeatVect(:,J2(1:Nf)),Arousal,'Leaveout','on');
    Loss2_nb=kfoldLoss(Mdl2_nb);
    C2_nb=confusionmat(Arousal,kfoldPredict(Mdl2_nb));
    Mdl2_svm=fitcsvm(FeatVect(:,J2(1:Nf)),Valence,'KernelFunction','polynomial',...
        'PolynomialOrder',5,'Leaveout','on');
    Loss2_svm=kfoldLoss(Mdl2_svm);
    C2_svm=confusionmat(Valence,kfoldPredict(Mdl2_svm));
  end
  if(J3==1)
      Loss3_nb=100;
      C3_nb=zeros(2,2);
      Loss3_svm=100;
      C3_svm=zeros(2,2);
  else
      Mdl3_nb=fitcnb(FeatVect(:,J3(1:Nf)),Dominance,'Leaveout','on');
      Loss3_nb=kfoldLoss(Mdl3_nb);
      C3_nb=confusionmat(Dominance,kfoldPredict(Mdl3_nb));
      Mdl3_svm=fitcsvm(FeatVect(:,J3(1:Nf)),Valence,'KernelFunction','polynomial',...
        'PolynomialOrder',5,'Leaveout','on');
      Loss3_svm=kfoldLoss(Mdl3_svm);
      C3_svm=confusionmat(Valence,kfoldPredict(Mdl3_svm));
  end
  
   result=[(1-Loss1_nb)*100,(1-Loss2_nb)*100,(1-Loss3_nb)*100,...
      (2*C1_nb(2,2))/((2*C1_nb(2,2))+C1_nb(1,2)+C1_nb(2,1)),...
      (2*C2_nb(2,2))/((2*C2_nb(2,2))+C2_nb(1,2)+C2_nb(2,1)),...
      (2*C3_nb(2,2))/((2*C3_nb(2,2))+C3_nb(1,2)+C3_nb(2,1)),...
      (1-Loss1_svm)*100,(1-Loss2_svm)*100,(1-Loss3_svm)*100,...
      (2*C1_svm(2,2))/((2*C1_svm(2,2))+C1_svm(1,2)+C1_svm(2,1)),...
      (2*C2_svm(2,2))/((2*C2_svm(2,2))+C2_svm(1,2)+C2_svm(2,1)),...
      (2*C3_svm(2,2))/((2*C3_svm(2,2))+C3_svm(1,2)+C3_svm(2,1))];
   fprintf(fid,'%d,%f,%f,%f,%f,%f,%f,,%f,%f,%f,%f,%f,%f\n',filenum,result);
   
end

fclose(fid);

