%%
clear
x0 = [0;0;0;0;0];
Tspan = [0 5] ;
[t_save state_save] = ode45(@(t,xx) twowheel_dynamic(t,xx,[1,-1],[0.5,0.2,1,1]), Tspan, x0);
figure
plot(state_save(:,1),state_save(:,2))

%%
clf
x = 1; y = 1; th = 0; L1 = 0.5; L2 = 1;
figure
Lh1 = line([x-L1*sin(th),x+L1*sin(th)],[y-L1*cos(th),y+L1*cos(th)]);
Lh2 = line([x,x+L2*cos(th)],[y,y+L2*sin(th)]);
%%
nFrames = size(t_save,1);
F(nFrames) = struct('cdata',[],'colormap',[]);
disp('Creating and recording frames...')
for i = 1:nFrames
    x = state_save(i,1);
    y = state_save(i,2);
    th = state_save(i,3);
    % Move the line to new location/orientation
    set(Lh1,'xdata',[x-L1*sin(th),x+L1*sin(th)],...
        'ydata', [y+L1*cos(th),y-L1*cos(th)]);
    set(Lh2,'xdata',[x,x+L2*cos(th)],...
        'ydata', [y,y+L2*sin(th)]);
    % Make sure the axis stays fixed (and square)
    axis([-5 5 -5 5]); axis square
    % Flush the graphics buffer to ensure the line is moved on screen
    drawnow
    % Capture frame
    F(i) = getframe;
end
disp('Playing movie...')
Fps = 20;
nPlay = 3;
movie(F,nPlay,Fps)

%%
function dx_new = twowheel_dynamic(t,xx,f,con)
x = xx(1);
y = xx(2);
th = xx(3);
qq = xx(4);
dth = xx(5);
L1 = con(1);
L3 = con(2);
j1 = con(3);
m1 = con(4);
f1 = f(1);
f2 = f(2);
dx_new = [qq*cos(th);
          qq*sin(th);
          dth;
          (L3*m1*dth^2 + f1 + f2)/m1;
          -(L1*(f1 - f2))/j1];
end
