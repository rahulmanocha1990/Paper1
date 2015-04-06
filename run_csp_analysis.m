%% === load training data and train CSP classifier ===
clc
clear all;
cd ../data_for_csp
Direc=dir('s*.mat');
for i=1:length(Direc)
MatFiles(i,:)=Direc(i).name;%get all file names
end

%%
Fs=128;
flt = @(f)(f>7&f<30).*(1-cos((f-(7+30)/2)/(7-30)*pi*4));
wnd=[0 8];
flt_len=8064;

%%
for filenum=1:size(MatFiles,1)
  name=sprintf('../data_matlab/%s',MatFiles(filenum,:));
  load(name);
  label(1,:)=mrk.arousal+1;
  label(2,:)=mrk.valence+1;
  label(3,:)=mrl.dominance+1;
  for class =1:3
      N1=sum(label(class,:)==1);
      N2=sum(label(class,:)==2);
      if(N1>N2)
         find(label(class,:)==2)
      elseif(N1<N2)
          
      else
          
      end
    RandIndices=randperm(length(mrk.pos));
    TrainSet=RandIndices(1:108);
    TestSet=RandIndices(109:120);
    [S,w,b] = train_csp(single(cnt), Fs, sparse(1,mrk.pos,(mrk.arousal+1)),wnd,flt,3,flt_len,TrainSet);
    y = test_csp(single(cnt(x,:)),S,w,b);
  end
end



% %% === run pseudo-online ===
% oldpos = 1;         % last data cursor
% t0 = tic;           % start time
% y = []; t = [];     % prediction and true label time series
% figure;             % make a new figure
% len = 3*nfo.fs;     % length of the display window
% speedup = 2;        % speedup over real time
% while 1
%     % determine data cursor (based on current time)
%     pos = 1+round(toc(t0)*nfo.fs*speedup);
%     % get the chunk of data since last query
%     newchunk = single(cnt(oldpos:pos,:));
%     % make a prediction (and also read out the current label)
%     y(oldpos:pos) = test_csp(newchunk,S,T,w,b);
%     t(oldpos:pos) = true_y(pos);
%     % plot the most recent window of data
%     if pos > len
%         plot(((pos-len):pos)/nfo.fs,[y((pos-len):pos); true_y((pos-len):pos)']);
%         line([pos-len,pos]/nfo.fs,[0 0],'Color','black','LineStyle','--');
%         axis([(pos-len)/nfo.fs pos/nfo.fs -2 2]);
%         xlabel('time (seconds)'); ylabel('class');
%         drawnow;
%     end
%     oldpos = pos;
% end
