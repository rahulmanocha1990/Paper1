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

  