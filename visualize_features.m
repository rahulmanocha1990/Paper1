%% --Generate Features using different approaches and visualize them using topoplot.
%Fractal Dimension Features

load('../data_matlab/biosemi32chnn.mat');
%% --Load feature vector files
cd ../Paper1/Features_Fractal
Direc=dir('*.mat');
for i=1:length(Direc)
FeatFiles(i,:)=Direc(i).name;%get all file names
end
cd ../
%%
for filenum=1:size(FeatFiles,1)
    name=sprintf('Features_Fractal/%s',FeatFiles(filenum,:));
    load(name);
    
    classes=size(FeatVect,1);
    for clas=1:classes
        dat=squeeze(FeatVect{clas,2});
        L=size(dat,1);
        avg_size=floor(L/5);
        count=1;
        classname=FeatVect{clas,1};
        for i=1:avg_size:L-avg_size
            handl=figure;topoplot(rescale(mean(dat(i:i+avg_size,:)),1,-1),chann,'electrodes','labels');
            title(classname,'FontSize',16);
            plotname=sprintf('Features_Fractal/spatial_patt/%s_%s_%d.fig',FeatFiles(filenum,1:end-4),classname,count);
            saveas(handl,plotname);
            count=count+1;
            close(handl);
        end
    end
end
%%

for filenum=1:size(FeatFiles,1)
    name=sprintf('Features_BinPow/%s',FeatFiles(filenum,:));
    load(name);
    
    classes=size(FeatVect,1);
    for clas=1:classes
        dat=FeatVect{clas,2};
        L=size(dat,1);
        avg_size=floor(L/5);
        count=1;
        classname=FeatVect{clas,1};
        P1=squeeze(dat(:,1,:));
        P2=squeeze(dat(:,2,:));
        P3=squeeze(dat(:,3,:));
        P4=squeeze(dat(:,4,:));
        for i=1:avg_size:L-avg_size
            handl=figure;
            subplot(1,4,1);topoplot(rescale(mean(P1(i:i+avg_size,:)),1,-1),chann,'electrodes','labels');
            subplot(1,4,2);topoplot(rescale(mean(P2(i:i+avg_size,:)),1,-1),chann,'electrodes','labels');
            subplot(1,4,3);topoplot(rescale(mean(P3(i:i+avg_size,:)),1,-1),chann,'electrodes','labels');
            subplot(1,4,4);topoplot(rescale(mean(P4(i:i+avg_size,:)),1,-1),chann,'electrodes','labels');
            title(classname,'FontSize',16);
            plotname=sprintf('Features_BinPow/spatial_patt/%s_%s_%d.fig',FeatFiles(filenum,1:end-4),classname,count);
            saveas(handl,plotname);
            count=count+1;
            close(handl);
        end
    end
end

%%
%% --Load bcilab mat files
cd ../bcilab_matfiles
Direc=dir('s*.mat');
for i=1:length(Direc)
FeatFiles(i,:)=Direc(i).name;%get all file names
end
cd ../
%%
for filenum=1:size(FeatFiles,1)
     name=sprintf('Features_BinPow/%s',FeatFiles(filenum,:));
     EEG=load(name);
     count=1;
     for nevent=1:40
       handl=figure;
       [spectra,freqs]=spectopo(EEG.data(:,EEG.event(nevent).latency:8064+EEG.event(nevent).latency),0,128,...
           'freq',[4,8,13,20,40],'chanlocs',chann,'title',EEG.event(nevent).type,'winsize',1024,...
           'overlap',512,'rmdc','on');
       plotname=sprintf('Spectopo_plots/%s_%s_%d.fig',FeatFiles(filenum,1:end-4),EEG.event(nevent).type,count);
       saveas(handl,plotname);
       count=count+1;
       close(handl);
     end
end