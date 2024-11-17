clear all 
clc
 load('COIL20_Obj.mat');	
 nClass = length(unique(gnd));
 dataset='COIL20_Obj';      
 fea=double(fea);
 
 %Sort samples by labels
 [labels,index]=sort(gnd,'ascend');
 gnd=labels;
 fea=fea(index,:);
 fea=double(fea);
 
 %Euclidean length normalization
 fea = NormalizeFea(fea); 

 LabelsRatio=0.1;
 K=nClass; %full-size dataset as input data  
 meanAC=[];
 meanMI=[];
 stdAC=[];
 stdMI=[];
 % The value of parameter p and alpha in the experiments
       % PIE  UMIST COIL20  COIL100  Optdigists MNIST
 %p      3    3      2        2         5        5
 %alpha  1000 100    100     1000       100     100s
  p=3;
  alpha=20;
  TempAC=[];
  TempMI=[];
  for h=1%:10
     %Select the data points of K classes as the input of the algorithm
     [X,Smpgnd,count]=CreatSampleDatasets(fea,K,gnd,nClass,LabelsRatio);
     % X:selected data points belong to K Classes
     % Smpgnd: the lables of selected data points
     %  count: the number of selected data points
     Options.maxIter=50;
     Options.k =p;% p: Nearest neighbor parameter
     Options.alpha=alpha;
     Options.gndSmpNum=count;
     Options.Smpgnd=Smpgnd;
     Options.KClass=K;
     Options.nClass=nClass;
     
     
     options = [];
      options.Metric = 'Euclidean';
      options.NeighborMode = 'KNN';
     options.k =p;
     options.WeightMode = 'Binary';%'HeatKernel';
     options.t =1;%mean(s(:));
     W = constructW(X, options);
     
     [~,V]=GOCNMF(X',W,Options);
     [~, label] = max(V');
     newL=bestMap(Smpgnd,label);
     AC=Accuracy(newL,Smpgnd);
     MIhat = MutualInfo(Smpgnd,label);  
     TempAC(h)=AC;% accuracy.acc;
     TempMI(h)=MIhat;% accuracy.nmi;
 end
    meanAC=mean(TempAC);
    meanMI=mean(TempMI);
    stdAC=std(TempAC);
    stdMI=std(TempMI);

 
 
    
 