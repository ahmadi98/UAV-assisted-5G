theta = 0; %initial angle 
d=zeros(100,18)% to get cost of the 2opt for 100 which is the monte carlo iterations and 18 which is the number of time the angle is shifted
dist=zeros(100,1)%to get cost of the 2opt for 100 which is the monte carlo iterations at each iteration of kmean clustering 
j=0

  for mc= 1:100
j=j+1
n=50% n was tested to be 5 20 50 90 number of nodes
  % number of points that you want
 center = [2 ,2]; % center coordinates of the circle [x0,y0] 
 radius = 2; % radius of the circle
 angle = 2*pi*rand(n,1);

 rng(j)%fixing the point for the whole experiment in each generation
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
 
%running 2opt on the kmean clustering

X = v(cidx==1, :);
            s = size(X,1);
            [p,d11] = tspsearch(X,s);
            figure(2)
    tspplot(p,X,1)
          legend('UAV route','cluster points '); 
               X = v(cidx==2, :);
            s = size(X,1);
            [p,d22] = tspsearch(X,s);
            
           figure(3)
           
    tspplot(p,X,1)
    legend('UAV route','cluster points '); 
               X = v(cidx==3, :);
            s = size(X,1);
            [p,d33] = tspsearch(X,s);
            figure(4)
    tspplot(p,X,1)
           legend('UAV route','cluster points '); 
               X = v(cidx==4, :);
            s = size(X,1);
            [p,d44] = tspsearch(X,s);
            figure(5)
   tspplot(p,X,1)
           legend('UAV route','cluster points '); 
    dist(mc,1)=d11+d22+d33+d44



 for i=1:18

% choose a point which will be the center of rotation
x_center = 2;
y_center = 2;

 
% create a matrix which will be used later in calculations
center = repmat([x_center; y_center], 1, length(x));
% define a 60 degree counter-clockwise rotation matrix
theta = theta+pi/18;       % pi/3 radians = 60 degrees
R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
% do the rotation...
s = v - center';     % shift points in the plane so that the center of rotation is at the origin
so = s*R;           % apply the rotation about the origin
vo = so + center';   % shift again so the origin goes back to the desired center of rotation
% this can be done in one line as:
% vo = R*(v - center) + center
% pick out the vectors of rotated x- and y-data
x_rotated = vo(:,1);
y_rotated = vo(:,2);
% make a plot
lx=[2,2];
ly=[0,4];


 
figure(6)
plot( x_rotated, y_rotated, 'r*', x_center, y_center, 'bo',lx,ly, 'r-', ly,lx, 'r-');
legend('cluster points','Base station ','axis separating the UAVs','location','sw');
axis equal

 
%running 2opt on shifting the axis algorithm
a=vo(:,1);
b=vo(:,2);
    X = vo(a<=x_center & b<=y_center,:);
    s = size(X,1);
    [p,d1] = tspsearch(X,s)
    figure(7)
    tspplot(p,X,1)
    legend('UAV route','cluster points ')

   

     
    X =  vo(a<=x_center & b>=y_center,:);
    s = size(X,1);
    [p,d2] = tspsearch(X,s)
    figure(8)
    tspplot(p,X,1)
   legend('UAV route','cluster points ')

   

   

     
    X = vo(a>=x_center & b<=y_center,:);
    s = size(X,1);
    [p,d3] = tspsearch(X,s)
    figure(9)
    tspplot(p,X,1)
   

   legend('UAV route','cluster points ')

   

     
    X = vo(a>=x_center & b>=y_center,:);
    s = size(X,1);
    [p,d4] = tspsearch(X,s)
    figure(10)
    tspplot(p,X,1)
    legend('UAV route','cluster points ')
    opts = statset('Display','final');
    d(mc,i)=d1+d2+d3+d4

 end 
 end
 



M=mean(d)
M1=mean(dist)
table = array2table(d);
table.Properties.VariableNames = {'i1','i2','i3','i4','i5','i6','i7','i8','i9','i10','i11','i12','i13','i14','i15','i16','i17','i18'}
table



mydata=M;
figure(11)
hold on
for i = 1:length(mydata)
    h=bar(i,mydata(i));
    if mydata(i) == min(mydata)
        set(h,'FaceColor','g');
    else
        set(h,'FaceColor','r');
    end
  title('The Angle with the Most Optimal Route for (5 nodes)')
  xlabel('UAV Starting Angle at Zero with 5 Degree Increase each Iteration');
  ylabel('Mean Net_Distance in Kilometers')
    set(gca,'xtick',1:25,'xticklabel',{'angle=5','angle=10','angle=15','angle=20','angle=25','angle=30','angle=35','angle=40','angle=45','angle=50','angle=55','angle=60','angle=65','angle=70','angle=75','angle=80','angle=85','angle=90'})
    xtickangle(45)  
    
    
    
    
end

hold off

%%%%%%%%%%%%%%%%%
M2=[min(M) min(M1)]




[maxBar,maxIndex] = max(M2);
[minBar,minIndex] = min(M2);
figure(12)
bar(M2)
text(maxIndex,maxBar+2,'Max')
text(minIndex,minBar+2,'Min')
set(gca,'XTickLabel',{'rotating the axis','k-mean clustering'})
xtickangle(45) 
xlabel('Comparison Between K-means and Rotating the Axis Algorithm');
ylabel('Mean Net_Distance in kilometers')
text(1:length(M2),M2,num2str(M2'),'vert','bottom','horiz','center'); 
title('The Algorithm with the Optimal Route for(5 nodes)')
box off
%%%%%%%%%%%%%%%%



