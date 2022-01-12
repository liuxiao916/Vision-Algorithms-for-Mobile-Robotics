%Drawing a cube on the undistorted images
%Author: Xiao Liu
clear,clc;

%load_data
undistorted1 = imread('data\images_undistorted\img_0001.jpg');
undistorted1_gray = rgb2gray(undistorted1);
pose=load('data\poses.txt');
K = load('data\K.txt');

%get world coordinate
[X,Y]=meshgrid(0:0.04:0.32,0:0.04:0.2);
corners = [X(:) Y(:) zeros(size(X(:),1),1),ones(size(X(:),1),1)]';

%get pixel coordinate
T = get_Tmatrix(pose(1,:));
projected_points = projected(corners,T,K);

%plot
figure(1)
imshow(undistorted1_gray)
hold on
plot(projected_points(1,:),projected_points(2,:),'.','MarkerSize',20,'color',[1,0,0])
hold off

%cubic points
cubic_corners = [corners(:,8), corners(:,10), corners(:,20), corners(:,22), corners(:,8)+[0 0 -0.08 0]', corners(:,10)+[0 0 -0.08 0]', corners(:,20)+[0 0 -0.08 0]', corners(:,22)+[0 0 -0.08 0]'];
cubic_projected = projected(cubic_corners,T,K);
draw_cubic(undistorted1_gray,cubic_projected)

function k_skew = skew(k)
    k_skew=[[0,-k(3),k(2)];[k(3),0,-k(1)];[-k(2),k(1),0]];
end

function R = rodrigues(omega)
    theta = norm(omega);
    k = omega/norm(omega);
    R = eye(3)+sin(theta)*skew(k)+(1-cos(theta))*skew(k)*skew(k);
end

function T = get_Tmatrix(pose)
    T = zeros(3:4);
    T(1:3,1:3)=rodrigues(pose(1:3));
    T(1:3,4)=pose(4:6);
end

function projected_points =  projected(points,T,K)
    projected_points = K*T*points;
    projected_points = projected_points./projected_points(3,:);
end

function draw_cubic(img,points)
    figure()
    imshow(img)
    hold on
    plot([points(1,1) points(1,2)],[points(2,1) points(2,2)],'LineWidth',2,'color',[1,0,0])
    plot([points(1,1) points(1,3)],[points(2,1) points(2,3)],'LineWidth',2,'color',[1,0,0])
    plot([points(1,2) points(1,4)],[points(2,2) points(2,4)],'LineWidth',2,'color',[1,0,0])
    plot([points(1,3) points(1,4)],[points(2,3) points(2,4)],'LineWidth',2,'color',[1,0,0])

    plot([points(1,5) points(1,6)],[points(2,5) points(2,6)],'LineWidth',2,'color',[1,0,0])
    plot([points(1,5) points(1,7)],[points(2,5) points(2,7)],'LineWidth',2,'color',[1,0,0])
    plot([points(1,6) points(1,8)],[points(2,6) points(2,8)],'LineWidth',2,'color',[1,0,0])
    plot([points(1,7) points(1,8)],[points(2,7) points(2,8)],'LineWidth',2,'color',[1,0,0])

    plot([points(1,1) points(1,5)],[points(2,1) points(2,5)],'LineWidth',2,'color',[1,0,0])
    plot([points(1,2) points(1,6)],[points(2,2) points(2,6)],'LineWidth',2,'color',[1,0,0])
    plot([points(1,3) points(1,7)],[points(2,3) points(2,7)],'LineWidth',2,'color',[1,0,0])
    plot([points(1,4) points(1,8)],[points(2,4) points(2,8)],'LineWidth',2,'color',[1,0,0])
    hold off
end
