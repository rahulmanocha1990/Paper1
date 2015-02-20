cd ../Paper1/Features_4class
Direc=dir('*.mat');
for i=1:length(Direc)
FeatFiles(i,:)=Direc(i).name;%get all file names
end
cd ../../common

%%
ExperimentId='../Paper1/Exp_20_Feb_2015_class4_allfeat.csv';
fid=fopen(ExperimentId,'w');
fprintf(fid,'Paper5 4classes  PLL PHH NLL NHH and features [Fractal HOC STAT] \n');

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
   %[B,C,O]=Classifier(Data,'svm',0.7,4);
   [loss,stats] = utl_nested_crossval({Data(:,2:end),Data(:,1)}, 'args',{{'svm' 'kernel' 'poly' 'gamma' 1 'degree' 5}});
   
   Pred=stats.per_fold(2).pred{1,2};
   Pred_labels=(Pred(:,1)+Pred(:,2)*2+Pred(:,3)*3+Pred(:,4)*4)-1;
   C=confusionmat(stats.per_fold(2).targ,Pred_labels);
   fprintf(fid,'Subject%d\n',filenum);
   fprintf(fid,'Accuracy,%f\n',(1-loss)*100);
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

cd ../Paper1/Features_4class_HOC
Direc=dir('*.mat');
for i=1:length(Direc)
FeatFiles(i,:)=Direc(i).name;%get all file names
end
cd ../../common

%%
ExperimentId='../Paper1/Exp_20_Feb_2015_class4_hoc.csv';
fid=fopen(ExperimentId,'w');
fprintf(fid,'Paper5 4classes  PLL PHH NLL NHH and features [HOC] \n');

for filenum=1:size(FeatFiles,1)
    name=sprintf('../Paper1/Features_4class_HOC/%s',FeatFiles(filenum,:));
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
   %[B,C,O]=Classifier(Data,'svm',0.7,4);
   [loss,stats] = utl_nested_crossval({Data(:,2:end),Data(:,1)}, 'args',{{'svm' 'kernel' 'poly' 'gamma' 1 'degree' 5}});
   
   Pred=stats.per_fold(2).pred{1,2};
   Pred_labels=(Pred(:,1)+Pred(:,2)*2+Pred(:,3)*3+Pred(:,4)*4)-1;
   C=confusionmat(stats.per_fold(2).targ,Pred_labels);
   fprintf(fid,'Subject%d\n',filenum);
   fprintf(fid,'Accuracy,%f\n',(1-loss)*100);
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
cd ../Paper1/Features_4class_stat
Direc=dir('*.mat');
for i=1:length(Direc)
FeatFiles(i,:)=Direc(i).name;%get all file names
end
cd ../../common

%%
ExperimentId='../Paper1/Exp_20_Feb_2015_class4_stat.csv';
fid=fopen(ExperimentId,'w');
fprintf(fid,'Paper5 4classes  PLL PHH NLL NHH and features [HOC] \n');

for filenum=1:size(FeatFiles,1)
    name=sprintf('../Paper1/Features_4class_stat/%s',FeatFiles(filenum,:));
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
   %[B,C,O]=Classifier(Data,'svm',0.7,4);
   [loss,stats] = utl_nested_crossval({Data(:,2:end),Data(:,1)}, 'args',{{'svm' 'kernel' 'poly' 'gamma' 1 'degree' 5}});
   
   Pred=stats.per_fold(2).pred{1,2};
   Pred_labels=(Pred(:,1)+Pred(:,2)*2+Pred(:,3)*3+Pred(:,4)*4)-1;
   C=confusionmat(stats.per_fold(2).targ,Pred_labels);
   fprintf(fid,'Subject%d\n',filenum);
   fprintf(fid,'Accuracy,%f\n',(1-loss)*100);
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
cd ../Paper1/Features_4class_hoc_stat
Direc=dir('*.mat');
for i=1:length(Direc)
FeatFiles(i,:)=Direc(i).name;%get all file names
end
cd ../../common

%%
ExperimentId='../Paper1/Exp_20_Feb_2015_class4_hoc_stat.csv';
fid=fopen(ExperimentId,'w');
fprintf(fid,'Paper5 4classes  PLL PHH NLL NHH and features [HOC] \n');

for filenum=1:size(FeatFiles,1)
    name=sprintf('../Paper1/Features_4class_hoc_stat/%s',FeatFiles(filenum,:));
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
   %[B,C,O]=Classifier(Data,'svm',0.7,4);
   [loss,stats] = utl_nested_crossval({Data(:,2:end),Data(:,1)}, 'args',{{'svm' 'kernel' 'poly' 'gamma' 1 'degree' 5}});
   
   Pred=stats.per_fold(2).pred{1,2};
   Pred_labels=(Pred(:,1)+Pred(:,2)*2+Pred(:,3)*3+Pred(:,4)*4)-1;
   C=confusionmat(stats.per_fold(2).targ,Pred_labels);
   fprintf(fid,'Subject%d\n',filenum);
   fprintf(fid,'Accuracy,%f\n',(1-loss)*100);
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
