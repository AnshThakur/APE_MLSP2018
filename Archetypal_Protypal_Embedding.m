clc;
clear;

%% generate random data in triangle spread

x = [2 5]; % //triangle base
y = [0 0.5]; % //triangle height
N = 1000; %// number of points
points = rand(N,2); %// sample uniformly in unit square
ind = points(:,2)>points(:,1); %// points to be unfolded
points(ind,:) = [2-points(ind,2) points(ind,1)]; %// unfold them
points(:,1) = x(1) + (x(2)-x(1))/2*points(:,1); %// stretch x as needed
points(:,2) = y(1) + (y(2)-y(1))*points(:,2); %// stretch y as needed
%plot(points(:,1),points(:,2),'.')
%scatter(points(:,1),points(:,2),20,'b.');


%% archetypal analysis parameters
param.p=15;
param.robust=false;
param.epsilon=10^-3;  % width for Huber loss
param.computeXtX=true;
param.stepsFISTA=0;
param.stepsAS=10;
param.numThreads=-1;

%% model extremal behaviour using archetypes
[D A B] = mexArchetypalAnalysis(points',param);


%% model average behaviour using Gaussian mixture models

gmfit = fitgmdist(points,3,'CovType','diagonal');
means=gmfit.mu;

%% visualization 
scatter(points(:,1),points(:,2),20,'b.');
hold on; 
% ploting archetypes. Should lie on hull
D_1=D';
hold on;scatter(D_1(:,1),D_1(:,2),60,'ko','filled')

% plotting means of GMM
hold on;scatter(means(:,1),means(:,2),100,'rd','filled')
legend('data points','Archetypes','means')

%% final dictionary D_f can be used to obtain APE
D_f=[D means'];

% generate data
x = [2 5]; % //triangle base
y = [0 0.5]; % //triangle height
N = 10; %// number of points
points = rand(N,2); %// sample uniformly in unit square
ind = points(:,2)>points(:,1); %// points to be unfolded
points(ind,:) = [2-points(ind,2) points(ind,1)]; %// unfold them
points(:,1) = x(1) + (x(2)-x(1))/2*points(:,1); %// stretch x as needed
points(:,2) = y(1) + (y(2)-y(1))*points(:,2); %// stretch y as needed
test=points';
%% simplex decomposition
APE=mexDecompSimplex(test,D_f,param);
APE=full(APE);
APE=APE';
%% ploting one DCR
figure; plot(APE(1,:)); legend('Archetypal Prototypal Embedding');







