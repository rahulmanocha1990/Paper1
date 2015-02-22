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




