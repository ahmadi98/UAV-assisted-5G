
d=zeros(1,9)

for n=10:10:90  %could be any number of nodes
  % number of points that you want
 center = [2 ,2]; % center coordinates of the circle [x0,y0] 
 radius = 2; % radius of the circle
 angle = 2*pi*rand(n,1);

 rng(1)
 r = radius*sqrt(rand(n,1));

 
 x = center(1)+r.*cos(angle) ;
 y = center(2)+r.*sin(angle);
x(1)=2;
y(1)=2;
v=[x,y]
 opts = statset('Display','final');
        [cidx, ctrs,dis] = kmeans(v, 4, 'Distance','city', ... 
                              'Replicates',5, 'Options',opts);

 
figure(1)
        plot(v(cidx==1,1),v(cidx==1,2),'r.', ...
             v(cidx==4,1),v(cidx==4,2),'y.', ...
            v(cidx==3,1),v(cidx==3,2),'g.', ...
            v(cidx==2,1),v(cidx==2,2),'b.', ctrs(:,1),ctrs(:,2),'kx');
legend('first cluster group','second cluster group ','third cluster group ','fourth cluster group ','centroid')
  figure(2)        
[IDX,C,SUMD,K]=best_kmeans(v)
d(1,n)=K
end
figure(3)
bar(d)
xlabel('Number of Nodes Used');
ylabel('Number of Centroids Required')

    
  
  
  
  
