%% Make graph
close all;
Acost = [0 2 1 0; 2 0 2 0; 1 2 0 4; 0 0 4 0];
Acap = [0 40 20 0; 40 0 10 0; 20 10 0 40; 0 0 40 0];
node_names = {'A','B','C', 'D'};
Gcost = graph(Acost,node_names);
Gcap = graph(Acap,node_names);

figure(1)
plot(Gcost,'EdgeLabel', Gcost.Edges.Weight);

figure(2)
plot(Gcap,'EdgeLabel', Gcap.Edges.Weight);