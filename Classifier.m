clc;
close all;
clear all;


m1=[-1;0];
c1=[4 3;3 4];
m2=[1;0];
c2=[4 3;3 4];
n=200;

r1=mvnrnd(m1,c1,n);
r2=mvnrnd(m2,c2,n);
r=[r1;r2];

xx=-7:0.1:7;
[x y]=meshgrid(xx,xx);
%z = repmat(m,200,1) + randn(200,2)*chol(c);

figure
grid on;
plot(r1(:,1),r1(:,2),'b+');
hold on;
plot(r2(:,1),r2(:,2),'r*');
hold on;

%a=zeros(n,2);
obj=gmdistribution.fit(r,2);
obj1=gmdistribution(m1',c1);
obj2=gmdistribution(m2',c2);
med=zeros(1,2);
ged=zeros(1,2);
map=zeros(1,2);
knn=zeros(1,2);
knn_class=0;
l=1;

for x1=-7:0.1:7
    for y1=-7:0.1:7
        
		if ((pdist2([x1 y1],m1','euclidean'))-(pdist2([x1 y1],m2','euclidean')))==0 
            med=cat(1,med,[x1 y1]);
        end
    
        if (mahal(obj1,[x1 y1])-mahal(obj2,[x1 y1]))==0
            ged=cat(1,ged,[x1 y1]);
        end
            
        if (((([x1;y1]- m1).')*c1.^(-1)*([x1;y1]- m1))-((([x1;y1]-m2).')*c2.^(-1)*([x1;y1]-m2)))==log(c2./c1)
            map=cat(1,map,[x1 y1]);
        end
    end
end

for i=2:1:size(med)-1
    line([med(i,1) med(i+1,1)],[med(i,2),med(i+1,2)],'Color','r','LineWidth',2);
    hold on;
end

for i=2:1:size(ged)-1
    line([ged(i,1) ged(i+1,1)],[ged(i,2),ged(i+1,2)],'Color','m','LineWidth',2);
    hold on;
end

for i=2:1:size(map)-1
    line([map(i,1) map(i+1,1)],[map(i,2),map(i+1,2)],'Color','y','LineWidth',2);
    hold on;
end

classes=zeros(size(x));
N=size(r,1);
t = [repmat(0,n,1);repmat(1,n,1)];
tv = unique(t);

for i = 1:length(x(:))
    this = [x(i) y(i)];
    dists = sum((r - repmat(this,N,1)).^2,2);
    [d I] = sort(dists,'ascend');
    [a,b] = hist(t(I(1:1)));
    pos = find(a==max(a));
    if length(pos)>1
        order = randperm(length(pos));
        pos = pos(order(1));
    end
    classes(i) = b(pos);
end
   
contour(x,y,classes,[0.5 0.5],'k','LineWidth',2)
    
plot_gaussian_ellipsoid(m1,c1);
plot_gaussian_ellipsoid(m2,c2);

    